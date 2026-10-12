-- ==============================================================================
-- DATABASE: [de tanh] TRÊN LAPTOP-MAALSNS1
-- ĐỀ TÀI: PHÂN TÍCH VÀ XÂY DỰNG ỨNG DỤNG THI TOEIC READING
-- SINH VIÊN: NGUYỄN NHẬT DUY - 2380600355 - LỚP: 23DTHC7 (NHÓM 7)
-- MÃ ĐỀ: READING V09 (ETS TEST 09 - FULL DỮ LIỆU ĐỀ THI)
-- ==============================================================================

USE [de tanh];
GO

-- Xóa bảng cũ theo thứ tự ràng buộc khóa ngoại
IF OBJECT_ID('dbo.ChiTietBaiThi', 'U') IS NOT NULL DROP TABLE dbo.ChiTietBaiThi;
IF OBJECT_ID('dbo.BaiThi', 'U') IS NOT NULL DROP TABLE dbo.BaiThi;
IF OBJECT_ID('dbo.DapAn', 'U') IS NOT NULL DROP TABLE dbo.DapAn;
IF OBJECT_ID('dbo.CauHoi', 'U') IS NOT NULL DROP TABLE dbo.CauHoi;
IF OBJECT_ID('dbo.DoanVan', 'U') IS NOT NULL DROP TABLE dbo.DoanVan;
IF OBJECT_ID('dbo.PhanThi', 'U') IS NOT NULL DROP TABLE dbo.PhanThi;
IF OBJECT_ID('dbo.DeThi', 'U') IS NOT NULL DROP TABLE dbo.DeThi;
IF OBJECT_ID('dbo.NguoiDung', 'U') IS NOT NULL DROP TABLE dbo.NguoiDung;
GO

-- 1. Bảng NguoiDung
CREATE TABLE dbo.NguoiDung (
    MaSV VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Lop NVARCHAR(50),
    Nhom NVARCHAR(20),
    MatKhauHash NVARCHAR(256) DEFAULT '123456',
    VaiTro NVARCHAR(20) DEFAULT 'Student',
    NgayTao DATETIME DEFAULT GETDATE()
);
GO

-- 2. Bảng DeThi
CREATE TABLE dbo.DeThi (
    DeThiId INT IDENTITY(1,1) PRIMARY KEY,
    MaDe VARCHAR(50) NOT NULL UNIQUE,
    TenDe NVARCHAR(255) NOT NULL,
    ThoiGianPhut INT NOT NULL DEFAULT 75,
    TongSoCau INT NOT NULL DEFAULT 100,
    TrangThai NVARCHAR(30) DEFAULT N'Hoạt động',
    NgayTao DATETIME DEFAULT GETDATE(),
    NguoiTao VARCHAR(20)
);
GO

-- 3. Bảng PhanThi
CREATE TABLE dbo.PhanThi (
    PhanThiId INT IDENTITY(1,1) PRIMARY KEY,
    DeThiId INT NOT NULL FOREIGN KEY REFERENCES dbo.DeThi(DeThiId) ON DELETE CASCADE,
    PartNumber INT NOT NULL,
    TenPart NVARCHAR(100) NOT NULL,
    HuongDan NVARCHAR(MAX),
    CauBatDau INT NOT NULL,
    CauKetThuc INT NOT NULL
);
GO

-- 4. Bảng DoanVan (Part 6 & Part 7)
CREATE TABLE dbo.DoanVan (
    DoanVanId INT IDENTITY(1,1) PRIMARY KEY,
    PhanThiId INT NOT NULL FOREIGN KEY REFERENCES dbo.PhanThi(PhanThiId) ON DELETE CASCADE,
    TieuDe NVARCHAR(255),
    NoiDungDoc NVARCHAR(MAX) NOT NULL,
    LoaiNoiDung NVARCHAR(50),
    HinhAnhUrl NVARCHAR(500),
    ThuTu INT DEFAULT 1
);
GO

-- 5. Bảng CauHoi
CREATE TABLE dbo.CauHoi (
    CauHoiId INT IDENTITY(1,1) PRIMARY KEY,
    PhanThiId INT NOT NULL FOREIGN KEY REFERENCES dbo.PhanThi(PhanThiId),
    DoanVanId INT NULL FOREIGN KEY REFERENCES dbo.DoanVan(DoanVanId) ON DELETE CASCADE,
    SoThuTuCau INT NOT NULL,
    NoiDungCauHoi NVARCHAR(MAX) NOT NULL,
    DapAnDung CHAR(1) NOT NULL,
    GiaiThich NVARCHAR(MAX) NULL,
    DiemSo FLOAT DEFAULT 5.0
);
GO

-- 6. Bảng DapAn
CREATE TABLE dbo.DapAn (
    DapAnId INT IDENTITY(1,1) PRIMARY KEY,
    CauHoiId INT NOT NULL FOREIGN KEY REFERENCES dbo.CauHoi(CauHoiId) ON DELETE CASCADE,
    KyTu CHAR(1) NOT NULL,
    NoiDungDapAn NVARCHAR(MAX) NOT NULL
);
GO

-- 7. Bảng BaiThi
CREATE TABLE dbo.BaiThi (
    BaiThiId INT IDENTITY(1,1) PRIMARY KEY,
    MaSV VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES dbo.NguoiDung(MaSV),
    DeThiId INT NOT NULL FOREIGN KEY REFERENCES dbo.DeThi(DeThiId),
    ThoiGianBatDau DATETIME NOT NULL,
    ThoiGianNop DATETIME NULL,
    SoCauDung INT DEFAULT 0,
    SoCauSai INT DEFAULT 0,
    SoCauBoQua INT DEFAULT 0,
    DiemThang495 INT DEFAULT 0,
    TrangThai NVARCHAR(30) DEFAULT N'Đang thi'
);
GO

-- 8. Bảng ChiTietBaiThi
CREATE TABLE dbo.ChiTietBaiThi (
    ChiTietId INT IDENTITY(1,1) PRIMARY KEY,
    BaiThiId INT NOT NULL FOREIGN KEY REFERENCES dbo.BaiThi(BaiThiId) ON DELETE CASCADE,
    CauHoiId INT NOT NULL FOREIGN KEY REFERENCES dbo.CauHoi(CauHoiId),
    DapAnChon CHAR(1) NULL,
    LaDung BIT DEFAULT 0,
    ThoiDiemChon DATETIME DEFAULT GETDATE()
);
GO

-- ==============================================================================
-- DỮ LIỆU ĐỀ THI READING V09 (ETS TEST 09)
-- ==============================================================================

INSERT INTO dbo.NguoiDung (MaSV, HoTen, Email, Lop, Nhom, VaiTro) VALUES 
('2380600355', N'Nguyễn Nhật Duy', 'nhatduy355@gmail.com', N'23DTHC7', N'Nhóm 7', 'Student'),
('GV001', N'Giảng viên HUTECH', 'giangvien@hutech.edu.vn', N'Khoa CNTT', N'Khoa', 'Teacher');

INSERT INTO dbo.DeThi (MaDe, TenDe, ThoiGianPhut, TongSoCau, TrangThai, NguoiTao) VALUES
('Reading v09', N'ETS TOEIC READING TEST 09', 75, 100, N'Hoạt động', 'GV001');

DECLARE @DeId INT = SCOPE_IDENTITY();

-- Tạo 3 phần thi
INSERT INTO dbo.PhanThi (DeThiId, PartNumber, TenPart, HuongDan, CauBatDau, CauKetThuc) VALUES
(@DeId, 5, N'Part 5: Incomplete Sentences', N'Chọn phương án đúng nhất (A, B, C hoặc D) để hoàn thành câu.', 101, 130),
(@DeId, 6, N'Part 6: Text Completion', N'Đọc các đoạn văn và chọn từ/câu thích hợp nhất điền vào 4 chỗ trống.', 131, 146),
(@DeId, 7, N'Part 7: Reading Comprehension', N'Đọc các bài đọc và trả lời câu hỏi đọc hiểu tương ứng.', 147, 200);

DECLARE @Part5Id INT = (SELECT PhanThiId FROM dbo.PhanThi WHERE DeThiId = @DeId AND PartNumber = 5);
DECLARE @Part6Id INT = (SELECT PhanThiId FROM dbo.PhanThi WHERE DeThiId = @DeId AND PartNumber = 6);
DECLARE @Part7Id INT = (SELECT PhanThiId FROM dbo.PhanThi WHERE DeThiId = @DeId AND PartNumber = 7);

-- Helper procedure để thêm nhanh câu hỏi Part 5
-- Câu 101 -> 130
DECLARE @qId INT;

-- 101
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 101, N'Every batch of sauce at Generita''s Bistro is processed meticulously by ------- expert chefs.', 'B', N'Trước cụm danh từ "expert chefs" ta cần tính từ sở hữu "their".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'they'), (@qId, 'B', N'their'), (@qId, 'C', N'them'), (@qId, 'D', N'themselves');

-- 102
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 102, N'Computerization of medical records ------- increases a physician''s ability to diagnose and treat patients.', 'B', N'Cần trạng từ "greatly" bổ nghĩa cho động từ "increases".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'great'), (@qId, 'B', N'greatly'), (@qId, 'C', N'greatness'), (@qId, 'D', N'greatest');

-- 103
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 103, N'At Rojelle''s Fine Dining, we use the freshest ------- available to make our salads.', 'C', N'"ingredients" mang nghĩa nguyên liệu làm món salad tươi ngon nhất.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'applications'), (@qId, 'B', N'subjects'), (@qId, 'C', N'ingredients'), (@qId, 'D', N'factors');

-- 104
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 104, N'Professor Benguigui will present his paper ------- the natural history conference tomorrow.', 'B', N'Giới từ "at" đi với địa điểm sự kiện/hội nghị "the natural history conference".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'by'), (@qId, 'B', N'at'), (@qId, 'C', N'of'), (@qId, 'D', N'on');

-- 105
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 105, N'The chefs are still waiting for a ------- date for the new convection oven that was ordered two weeks ago.', 'D', N'Cụm danh từ ghép "shipping date" mang nghĩa ngày giao hàng.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'shipper'), (@qId, 'B', N'ships'), (@qId, 'C', N'shipments'), (@qId, 'D', N'shipping');

-- 106
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 106, N'Mr. Kang works ------- with our internal team members as well as various regional sales representatives.', 'C', N'Cụm từ "work closely with" mang nghĩa hợp tác chặt chẽ với ai.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'mildly'), (@qId, 'B', N'nearly'), (@qId, 'C', N'closely'), (@qId, 'D', N'narrowly');

-- 107
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 107, N'Fashion designer Hye-Ja Pak knows ------- to update her line in response to changing tastes.', 'B', N'Cấu trúc "know when to V": biết khi nào cần cập nhật dòng sản phẩm.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'and'), (@qId, 'B', N'when'), (@qId, 'C', N'need'), (@qId, 'D', N'for');

-- 108
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 108, N'The samba class was so well ------- that the Yulara Dance School decided to make the course a permanent offering.', 'A', N'Cụm tính từ ghép "well attended" mang nghĩa có đông người tham dự.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'attended'), (@qId, 'B', N'educated'), (@qId, 'C', N'gathered'), (@qId, 'D', N'protected');

-- 109
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 109, N'The factory will be situated away ------- the city''s residential area to reduce complaints about noise and emissions.', 'A', N'Cụm từ "away from" mang nghĩa cách xa khu dân cư.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'from'), (@qId, 'B', N'about'), (@qId, 'C', N'with'), (@qId, 'D', N'out');

-- 110
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 110, N'Ms. Kuramoto selected the most ------- mailing option available.', 'A', N'Cần tính từ "economical" bổ nghĩa cho cụm danh từ "mailing option".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'economical'), (@qId, 'B', N'economy'), (@qId, 'C', N'economize'), (@qId, 'D', N'economized');

-- 111
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 111, N'Companies without information technology specialists can ------- on Vyber Software Advisers for assistance with online services.', 'C', N'Sau trợ động từ "can" là động từ nguyên mẫu: "rely on" (dựa vào).');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'reliable'), (@qId, 'B', N'reliably'), (@qId, 'C', N'rely'), (@qId, 'D', N'relying');

-- 112
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 112, N'Next year, our team will have a new task, ------- is to review design portfolios.', 'B', N'Mệnh đề quan hệ không xác định dùng đại từ quan hệ "which" thay thế cho "a new task".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'although'), (@qId, 'B', N'which'), (@qId, 'C', N'after'), (@qId, 'D', N'because');

-- 113
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 113, N'Cook the meat for 30 minutes to ensure ------- readiness to be eaten.', 'C', N'Tính từ sở hữu "its" thay thế cho danh từ chỉ vật số ít "the meat".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'both'), (@qId, 'B', N'this'), (@qId, 'C', N'its'), (@qId, 'D', N'that');

-- 114
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 114, N'Amoxitron''s research team will hire ------- interns to assist with laboratory duties.', 'B', N'Lượng từ "several" đi với danh từ đếm được số nhiều "interns".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'given'), (@qId, 'B', N'several'), (@qId, 'C', N'whole'), (@qId, 'D', N'natural');

-- 115
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 115, N'------- the new acai juice blend has proved so popular, we should move quickly to increase our production volume.', 'C', N'Liên từ chỉ nguyên nhân "Since" (Bởi vì).');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'If'), (@qId, 'B', N'Whether'), (@qId, 'C', N'Since'), (@qId, 'D', N'Unless');

-- 116
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 116, N'New emissions standards have forced Rider Auto to modify the process of engine -------.', 'A', N'Sau giới từ "of" là cụm danh từ ghép "engine construction".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'construction'), (@qId, 'B', N'constructed'), (@qId, 'C', N'constructive'), (@qId, 'D', N'construct');

-- 117
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 117, N'Maki Kayano''s book offers techniques for ------- business tasks with speed and precision.', 'A', N'Sau giới từ "for" là V-ing: "executing business tasks" (thực hiện công việc).');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'executing'), (@qId, 'B', N'equipping'), (@qId, 'C', N'returning'), (@qId, 'D', N'involving');

-- 118
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 118, N'To control costs, updated credit card readers will be installed in branch stores -------.', 'B', N'Trạng từ "gradually" (dần dần, từng bước) đứng cuối bổ nghĩa cho động từ "be installed".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'gradual'), (@qId, 'B', N'gradually'), (@qId, 'C', N'more gradual'), (@qId, 'D', N'most gradual');

-- 119
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 119, N'In this quarter, the Montel Beverage Company is expecting sales ------- £160,000 and £180,000.', 'D', N'Cấu trúc "between A and B" (ở giữa A và B).');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'without'), (@qId, 'B', N'among'), (@qId, 'C', N'throughout'), (@qId, 'D', N'between');

-- 120
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 120, N'Because Mount Akoyola is so challenging for climbers, ------- have reached its peak.', 'D', N'Đại từ "few" mang nghĩa hầu như không có ai đạt đến đỉnh núi.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'any'), (@qId, 'B', N'either'), (@qId, 'C', N'other'), (@qId, 'D', N'few');

-- 121
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 121, N'King Street Bridge will be closed in the month of September ------- repair work.', 'A', N'Cụm giới từ "because of" đi với danh từ "repair work".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'because of'), (@qId, 'B', N'so that'), (@qId, 'C', N'as if'), (@qId, 'D', N'rather than');

-- 122
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 122, N'Ms. Taniguchi''s supervisor commended her for negotiating ------- with Furuyama Corporation.', 'D', N'Cần trạng từ "effectively" bổ nghĩa cho danh động từ "negotiating".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'effective'), (@qId, 'B', N'effecting'), (@qId, 'C', N'effected'), (@qId, 'D', N'effectively');

-- 123
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 123, N'Staff members may reserve the conference room ------- they need it.', 'D', N'Liên từ "anytime" mang nghĩa bất cứ lúc nào họ cần.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'somewhere'), (@qId, 'B', N'whatever'), (@qId, 'C', N'everything'), (@qId, 'D', N'anytime');

-- 124
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 124, N'The public relations director must have a high level of ------- in English and Spanish.', 'A', N'Danh từ "proficiency" mang nghĩa sự thành thạo ngoại ngữ.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'proficiency'), (@qId, 'B', N'advancement'), (@qId, 'C', N'routine'), (@qId, 'D', N'strength');

-- 125
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 125, N'Patterson Products ------- seeks innovative ways of meeting changing consumer demand.', 'C', N'Trạng từ "continually" mang nghĩa liên tục tìm kiếm đổi mới.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'dually'), (@qId, 'B', N'favorably'), (@qId, 'C', N'continually'), (@qId, 'D', N'generically');

-- 126
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 126, N'Mr. Volante is working at home tomorrow so he ------- the technical report without any distractions.', 'A', N'Mệnh đề mục đích "so he can finish".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'can finish'), (@qId, 'B', N'would finish'), (@qId, 'C', N'finished'), (@qId, 'D', N'has been finishing');

-- 127
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 127, N'All of the billing procedures remain the same, ------- new payment codes need to be inserted into the invoice documents.', 'D', N'Liên từ "except that" (ngoại trừ việc là).');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'in order that'), (@qId, 'B', N'during'), (@qId, 'C', N'across from'), (@qId, 'D', N'except that');

-- 128
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 128, N'The lightweight design of the new sedan is ------- because it can cause the vehicle to slide on icy roads.', 'C', N'Tính từ "questionable" (đáng nghi ngờ, còn tranh cãi).');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'possible'), (@qId, 'B', N'mechanical'), (@qId, 'C', N'questionable'), (@qId, 'D', N'multiple');

-- 129
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 129, N'When the bank president retired, the common ------- was that the vice president would take over.', 'B', N'Danh từ "assumption" (suy đoán, nhận định chung).');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'assume'), (@qId, 'B', N'assumption'), (@qId, 'C', N'assuming'), (@qId, 'D', N'assumable');

-- 130
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part5Id, NULL, 130, N'West Bengali Airlines ------- fees for oversized items that are still within weight limitations.', 'D', N'Động từ "waives" (miễn lệ phí).');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'invites'), (@qId, 'B', N'cooperates'), (@qId, 'C', N'transports'), (@qId, 'D', N'waives');

-- ==============================================================================
-- PART 6: ĐOẠN VĂN EMAIL & CÂU HỎI 131 - 134
-- ==============================================================================
DECLARE @dvId INT;

INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
VALUES (@Part6Id, N'Questions 131-134 refer to the following e-mail.',
N'To: pmendoza@factmail.co
From: recruiting@analystsassoc.org
Date: May 2
Subject: Joining ASA

Dear Mr. Mendoza,
Thank you for expressing your interest in our organization during the recent ------- [131]. It was a pleasure meeting you at the ASA booth during the Weber Information Systems Convention. As you may recall from our conversation, we discussed how ASA membership ------- [132] your career through networking opportunities as well as the industry insights offered in our monthly newsletter. The normal fee for members is just $120 a year; however, we are currently offering a new-member discount. ------- [133].
If you are still interested in joining, please reply to ------- [134] with your mailing address. I will then forward you an application packet.

Sincerely,
Ashlee Loren, President
Association of Systems Analysts', N'Email', NULL, 1);
SET @dvId = SCOPE_IDENTITY();

-- 131
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part6Id, @dvId, 131, N'Chọn đáp án thích hợp điền vào vị trí [131]', 'C', N'"during the recent conference" phù hợp với ngữ cảnh hội nghị Weber Convention.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'election'), (@qId, 'B', N'broadcast'), (@qId, 'C', N'conference'), (@qId, 'D', N'performance');

-- 132
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part6Id, @dvId, 132, N'Chọn đáp án thích hợp điền vào vị trí [132]', 'A', N'"can benefit your career" - có thể mang lại lợi ích cho sự nghiệp của bạn.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'can benefit'), (@qId, 'B', N'is benefiting'), (@qId, 'C', N'has benefited'), (@qId, 'D', N'will have benefited');

-- 133
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part6Id, @dvId, 133, N'Chọn đáp án thích hợp điền vào vị trí [133]', 'D', N'Câu tiếp nối ý giảm giá thành viên: "This month you can join for just half the usual rate."');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES 
(@qId, 'A', N'Discounts on rental cars are included in the annual membership.'),
(@qId, 'B', N'Our jobs board is quite comprehensive.'),
(@qId, 'C', N'We are the first organization of our kind.'),
(@qId, 'D', N'This month you can join for just half the usual rate.');

-- 134
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part6Id, @dvId, 134, N'Chọn đáp án thích hợp điền vào vị trí [134]', 'B', N'"please reply to me" - người gửi email xưng là "I will forward...".');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES (@qId, 'A', N'it'), (@qId, 'B', N'me'), (@qId, 'C', N'them'), (@qId, 'D', N'anyone');

-- ==============================================================================
-- PART 7: BÀI ĐỌC HÓA ĐƠN & CÂU HỎI 147 - 148
-- ==============================================================================
INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
VALUES (@Part7Id, N'Questions 147-148 refer to the following invoice.',
N'INVOICE 3987 - Shawqi Office Services, Dubai, UAE
Report requested in English
18 October
Jenkins Press - P.O. Box 2291, Dubai, UAE

Service:
On 14 October, replaced bulb and repaired paper tray on copier per call received on 12 October. Replaced copy ink in two machines. Performed routine yearly maintenance on five copiers per existing service contract.

- Labor cost: AED 330.00
- Paper tray: AED 50.00
- Bulb: AED 30.00
- Copy ink: AED 220.00
Total: AED 630.00

Total amount must be received by 31 October.
Thank you for your business!', N'Invoice', NULL, 1);
SET @dvId = SCOPE_IDENTITY();

-- 147
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part7Id, @dvId, 147, N'What is indicated about Jenkins Press?', 'B', N'Văn bản ghi: "routine yearly maintenance on five copiers" => Máy photocopy được bảo dưỡng định kỳ hàng năm.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES 
(@qId, 'A', N'It has several offices around the world.'),
(@qId, 'B', N'Its copiers get checked every year.'),
(@qId, 'C', N'Its office equipment is outdated.'),
(@qId, 'D', N'It is a new customer of Shawqi Office Services.');

-- 148
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part7Id, @dvId, 148, N'When is payment due?', 'D', N'Dòng cuối ghi: "Total amount must be received by 31 October." => Hạn nộp là ngày 31 tháng 10.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES 
(@qId, 'A', N'October 12'),
(@qId, 'B', N'October 14'),
(@qId, 'C', N'October 18'),
(@qId, 'D', N'October 31');

-- PART 7: QUẢNG CÁO CĂN HỘ (149 - 151)
INSERT INTO dbo.DoanVan (PhanThiId, TieuDe, NoiDungDoc, LoaiNoiDung, HinhAnhUrl, ThuTu)
VALUES (@Part7Id, N'Questions 149-151 refer to the following advertisement.',
N'Harbour View Apartment — Porthmadog, Wales
This one-bedroom apartment is perfect for a holiday escape! Located in a quiet area, it boasts a patio with a lovely view of the harbour. Recently renovated, the unit includes an eat-in kitchen with stove, refrigerator, microwave, and coffeepot; bathroom with walk-in shower; and a living room with a large-screen TV. Other amenities of the property include:
• Short distance to restaurants and shops
• Five-minute walk to the beach
• Public gardens and historic sites within a 20-minute drive
• Heat and electricity included
• Towels and bed linens provided on-site
• Daily cleaning service available (extra fee)
• Wireless Internet access (extra fee)

Reserve this lovely gem now! Signing a contract by March 30 will reduce the rental cost by 10 percent. To sign a contract, contact Dylan Barrett at dbarrett@telarentals.co.uk.', N'Advertisement', NULL, 2);
SET @dvId = SCOPE_IDENTITY();

-- 149
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part7Id, @dvId, 149, N'Who would the advertisement most likely interest?', 'D', N'"perfect for a holiday escape" => Phù hợp cho khách nghỉ dưỡng ngắn ngày (Short-term vacationers).');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES 
(@qId, 'A', N'Business travelers'),
(@qId, 'B', N'Residents of Porthmadog'),
(@qId, 'C', N'Property investors'),
(@qId, 'D', N'Short-term vacationers');

-- 150
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part7Id, @dvId, 150, N'What is indicated about the rental fee?', 'B', N'Cleaning service và Wifi có ghi chú "(extra fee)" => Giá thuê không bao gồm tất cả các tính năng.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES 
(@qId, 'A', N'It includes tours of historic places.'),
(@qId, 'B', N'It does not cover all of the apartment''s features.'),
(@qId, 'C', N'It includes vouchers to use at local restaurants.'),
(@qId, 'D', N'It requires a minimum 30 percent deposit in advance.');

-- 151
INSERT INTO dbo.CauHoi (PhanThiId, DoanVanId, SoThuTuCau, NoiDungCauHoi, DapAnDung, GiaiThich)
VALUES (@Part7Id, @dvId, 151, N'Why should an individual contact Mr. Barrett by March 30?', 'A', N'"Signing a contract by March 30 will reduce the rental cost by 10 percent" => Để được giảm giá thuê.');
SET @qId = SCOPE_IDENTITY();
INSERT INTO dbo.DapAn VALUES 
(@qId, 'A', N'To get a discount on rent'),
(@qId, 'B', N'To schedule apartment renovations'),
(@qId, 'C', N'To rent the last available property'),
(@qId, 'D', N'To sell the property before the end of the season');

PRINT N'Cài đặt thành công dữ liệu TOEIC Reading v09 vào database [de tanh]!';
GO
