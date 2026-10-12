# KIẾN TRÚC PHÂN TẦNG ASP.NET BOILERPLATE (ABP) - ĐỀ TÀI TOEIC READING

> **Dự án:** Ứng dụng thi TOEIC Reading (HUTECH)  
> **Sinh viên:** Nguyễn Nhật Duy - MSSV: 2380600355 - Lớp: 23DTHC7 (Nhóm 7)  
> **Hệ thống CSDL:** Microsoft SQL Server - Database: `de tanh`  
> **Kiến trúc:** ASP.NET Boilerplate (ABP Framework) - 6 Dự án phân tầng chuẩn DDD  

---

## 1. TỔNG QUAN 6 DỰ ÁN TRONG SOLUTION (SLN)

Theo đúng mô hình chuẩn của ABP Framework (Domain-Driven Design - DDD):

```
Acme.ToeicExamApp (Solution)
│
├── 📁 src
│   ├── 📦 Acme.ToeicExamApp.Core                 (Tầng Miền / Domain - Thực thể, Enums, Quản lý nghiệp vụ)
│   ├── 📦 Acme.ToeicExamApp.Application          (Tầng Ứng dụng - AppServices, DTOs, Mapping)
│   ├── 📦 Acme.ToeicExamApp.EntityFrameworkCore  (Tầng Truy cập Dữ liệu - DbContext, Migrations, Repositories)
│   └── 🌐 Acme.ToeicExamApp.Web                  (Tầng Trình diễn - Controllers, Views, API endpoints, Auth)
│
└── 📁 test
    ├── 🧪 Acme.ToeicExamApp.Tests                (Kiểm thử Đơn vị & Tích hợp Application layer)
    └── 🧪 Acme.ToeicExamApp.Web.Tests            (Kiểm thử Tích hợp Web & Giao diện MVC)
```

---

## 2. CHI TIẾT TRIỂN KHAI TỪNG TẦNG CHO BÀI THI TOEIC READING

### 2.1. Tầng Cốt lõi (Core Project: `Acme.ToeicExamApp.Core`)
Chứa các thực thể miền (Entities) kế thừa từ `Entity<int>` hoặc `Entity<string>` và `IHasCreationTime`:

```csharp
// 1. Thực thể Đề thi
[Table("DeThi")]
public class DeThi : Entity, IHasCreationTime
{
    [Required]
    [StringLength(50)]
    public string MaDe { get; set; } // Ví dụ: "Reading v09"

    [Required]
    [StringLength(255)]
    public string TenDe { get; set; } // "ETS TOEIC READING TEST 09"

    public int ThoiGianPhut { get; set; } = 75;
    public int TongSoCau { get; set; } = 100;
    public string TrangThai { get; set; } = "Hoạt động";
    public DateTime CreationTime { get; set; } = Clock.Now;

    public virtual ICollection<PhanThi> PhanThis { get; set; }
}

// 2. Thực thể Câu hỏi (101 - 200)
[Table("CauHoi")]
public class CauHoi : Entity
{
    public int PhanThiId { get; set; }
    public int? DoanVanId { get; set; }
    public int SoThuTuCau { get; set; } // 101 -> 200
    
    [Required]
    public string NoiDungCauHoi { get; set; }

    [Required]
    [StringLength(1)]
    public string DapAnDung { get; set; } // "A", "B", "C", "D"

    public string GiaiThich { get; set; }

    public virtual ICollection<DapAn> DapAns { get; set; }
}
```

### 2.2. Tầng Entity Framework Core (`Acme.ToeicExamApp.EntityFrameworkCore`)
Khai báo `DbSet` trong `ToeicExamAppDbContext` và cấu hình kết nối tới database `de tanh`:

```csharp
public class ToeicExamAppDbContext : AbpDbContext
{
    public DbSet<DeThi> DeThis { get; set; }
    public DbSet<PhanThi> PhanThis { get; set; }
    public DbSet<DoanVan> DoanVans { get; set; }
    public DbSet<CauHoi> CauHois { get; set; }
    public DbSet<DapAn> DapAns { get; set; }
    public DbSet<BaiThi> BaiThis { get; set; }
    public DbSet<ChiTietBaiThi> ChiTietBaiThis { get; set; }
    public DbSet<SinhVien> SinhViens { get; set; }
    public DbSet<NguoiDung> NguoiDungs { get; set; }

    public ToeicExamAppDbContext(DbContextOptions<ToeicExamAppDbContext> options) 
        : base(options)
    {
    }
}
```

Chuỗi kết nối trong `appsettings.json`:
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=LAPTOP-MAALSNS1;Database=de tanh;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

### 2.3. Tầng Ứng dụng (`Acme.ToeicExamApp.Application`)
Định nghĩa Interface và triển khai Application Service chấm điểm & quản lý đề thi:

```csharp
public interface IDeThiAppService : IApplicationService
{
    Task<ListResultDto<DeThiDto>> GetAllDeThi();
    Task<DeThiFullDto> GetDeThiLamBai(int deThiId);
    Task<KetQuaThiDto> NopBaiThi(NopBaiInput input);
}

public class DeThiAppService : ToeicExamAppAppServiceBase, IDeThiAppService
{
    private readonly IRepository<DeThi> _deThiRepository;
    private readonly IRepository<CauHoi> _cauHoiRepository;
    private readonly IRepository<BaiThi> _baiThiRepository;

    public DeThiAppService(
        IRepository<DeThi> deThiRepository,
        IRepository<CauHoi> cauHoiRepository,
        IRepository<BaiThi> baiThiRepository)
    {
        _deThiRepository = deThiRepository;
        _cauHoiRepository = cauHoiRepository;
        _baiThiRepository = baiThiRepository;
    }

    // Nghiệp vụ chấm điểm tự động và quy đổi điểm TOEIC Reading thang 495
    public async Task<KetQuaThiDto> NopBaiThi(NopBaiInput input)
    {
        // 1. Lấy danh sách câu hỏi và đáp án đúng từ Repository
        // 2. So khớp câu trả lời của thí sinh
        // 3. Tính số câu Đúng, Sai, Bỏ qua
        // 4. Lưu kết quả vào BaiThi & ChiTietBaiThi trong DB [de tanh]
        // 5. Trả về DTO kết quả kèm giải thích
    }
}
```

### 2.4. Tầng Web / Trình diễn (`Acme.ToeicExamApp.Web`)
Cung cấp:
- **Admin MVC Controller:** Giảng viên Upload file Word (.docx) đề thi, kiểm tra bộ thẻ `[TEST]`, `[PART]`, `[Q]`, `[ANS]` và xem trước đề thi (Preview).
- **RESTful API Controller / Minimal API:** Cung cấp API xác thực đăng nhập (`/api/auth/login`) và API thi cho Ứng dụng Mobile Flutter.

---

## 3. TÍCH HỢP GIAO DIỆN NGƯỜI HỌC (MOBILE & WEB FLUTTER)

1. **Màn hình Đăng nhập (Login):**
   - Xác thực tài khoản thí sinh qua MSSV (Nguyễn Nhật Duy - `2380600355`).
   - Hỗ trợ tính năng Quick-Pick chọn nhanh tài khoản trong database `de tanh`.
2. **Màn hình Làm bài:**
   - Đếm ngược 75 phút thời gian thực, có cảnh báo khi sắp hết giờ và tự động thu bài.
   - Chuyển Part 5, 6, 7 mượt mà.
   - Khung đọc bài Part 6 & Part 7 độc lập phía trên, câu hỏi ở dưới, không phải cuộn trang.
   - Bảng lưới ma trận 100 câu hỏi (Palette) kiểm tra trạng thái.
3. **Màn hình Kết quả đồ họa:**
   - Vòng tròn điểm số TOEIC Reading /495.
   - Thanh tiến trình tỷ lệ đồ họa Đúng / Sai / Bỏ qua.
   - Đánh giá cấp độ chuẩn ETS.
   - Bảng giải thích chi tiết từng câu.
