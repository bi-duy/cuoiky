import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ToeicExamApp());
}

// ==============================================================================
// 1. CẤU HÌNH THEME & API
// ==============================================================================
class AppTheme {
  static const Color primary = Color(0xFF1E3A8A); // Deep Navy
  static const Color primaryLight = Color(0xFF2563EB); // Royal Blue
  static const Color accent = Color(0xFF0D9488); // Teal
  static const Color bg = Color(0xFFF8FAFC); // Clean Slate
  static const Color cardBg = Colors.white;
  static const Color textMain = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color border = Color(0xFFE2E8F0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: primaryLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),
    );
  }
}

String getApiBaseUrl() {
  if (kIsWeb) return 'http://localhost:5247';
  try {
    if (Platform.isAndroid) return 'http://10.0.2.2:5247';
  } catch (_) {}
  return 'http://localhost:5247';
}

// ==============================================================================
// 2. DATA MODELS
// ==============================================================================
class UserSession {
  final String maSV;
  final String hoTen;
  final String email;
  final String lop;
  final String nhom;
  final String vaiTro;
  final String deThiPhanCong;

  UserSession({
    required this.maSV,
    required this.hoTen,
    required this.email,
    required this.lop,
    required this.nhom,
    required this.vaiTro,
    required this.deThiPhanCong,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      maSV: json['maSV'] ?? '',
      hoTen: json['hoTen'] ?? '',
      email: json['email'] ?? '',
      lop: json['lop'] ?? '',
      nhom: json['nhom'] ?? 'Nhóm 7',
      vaiTro: json['vaiTro'] ?? 'Student',
      deThiPhanCong: json['deThiPhanCong'] ?? 'Reading v09',
    );
  }

  static UserSession defaultUser() {
    return UserSession(
      maSV: '2380600355',
      hoTen: 'Nguyễn Nhật Duy',
      email: 'nhatduy355@gmail.com',
      lop: '23DTHC7',
      nhom: 'Nhóm 7',
      vaiTro: 'Student',
      deThiPhanCong: 'Reading v09',
    );
  }
}

class DeThiItem {
  final int deThiId;
  final String maDe;
  final String tenDe;
  final int thoiGianPhut;
  final int tongSoCau;
  final String trangThai;

  DeThiItem({
    required this.deThiId,
    required this.maDe,
    required this.tenDe,
    required this.thoiGianPhut,
    required this.tongSoCau,
    required this.trangThai,
  });

  factory DeThiItem.fromJson(Map<String, dynamic> json) {
    return DeThiItem(
      deThiId: json['deThiId'] ?? 0,
      maDe: json['maDe'] ?? '',
      tenDe: json['tenDe'] ?? '',
      thoiGianPhut: json['thoiGianPhut'] ?? 75,
      tongSoCau: json['tongSoCau'] ?? 100,
      trangThai: json['trangThai'] ?? 'Hoạt động',
    );
  }
}

class DoanVan {
  final int doanVanId;
  final int partNumber;
  final String tieuDe;
  final String noiDungDoc;
  final String loaiNoiDung;
  final String? hinhAnhUrl;

  DoanVan({
    required this.doanVanId,
    required this.partNumber,
    required this.tieuDe,
    required this.noiDungDoc,
    required this.loaiNoiDung,
    this.hinhAnhUrl,
  });

  factory DoanVan.fromJson(Map<String, dynamic> json) {
    return DoanVan(
      doanVanId: json['doanVanId'] ?? 0,
      partNumber: json['partNumber'] ?? 0,
      tieuDe: json['tieuDe'] ?? '',
      noiDungDoc: json['noiDungDoc'] ?? '',
      loaiNoiDung: json['loaiNoiDung'] ?? '',
      hinhAnhUrl: json['hinhAnhUrl'],
    );
  }
}

class DapAn {
  final int dapAnId;
  final int cauHoiId;
  final String kyTu;
  final String noiDungDapAn;

  DapAn({
    required this.dapAnId,
    required this.cauHoiId,
    required this.kyTu,
    required this.noiDungDapAn,
  });

  factory DapAn.fromJson(Map<String, dynamic> json) {
    return DapAn(
      dapAnId: json['dapAnId'] ?? 0,
      cauHoiId: json['cauHoiId'] ?? 0,
      kyTu: json['kyTu'] ?? '',
      noiDungDapAn: json['noiDungDapAn'] ?? '',
    );
  }
}

class CauHoi {
  final int cauHoiId;
  final int partNumber;
  final int? doanVanId;
  final int soThuTuCau;
  final String noiDungCauHoi;
  final List<DapAn> dapAn;

  CauHoi({
    required this.cauHoiId,
    required this.partNumber,
    this.doanVanId,
    required this.soThuTuCau,
    required this.noiDungCauHoi,
    required this.dapAn,
  });

  factory CauHoi.fromJson(Map<String, dynamic> json) {
    var daList = (json['dapAn'] as List<dynamic>?)
            ?.map((e) => DapAn.fromJson(e))
            .toList() ??
        [];
    return CauHoi(
      cauHoiId: json['cauHoiId'] ?? 0,
      partNumber: json['partNumber'] ?? 5,
      doanVanId: json['doanVanId'],
      soThuTuCau: json['soThuTuCau'] ?? 0,
      noiDungCauHoi: json['noiDungCauHoi'] ?? '',
      dapAn: daList,
    );
  }
}

class DeThiFull {
  final int deThiId;
  final String maDe;
  final String tenDe;
  final int thoiGianPhut;
  final int tongSoCau;
  final List<DoanVan> doanVan;
  final List<CauHoi> cauHoi;

  DeThiFull({
    required this.deThiId,
    required this.maDe,
    required this.tenDe,
    required this.thoiGianPhut,
    required this.tongSoCau,
    required this.doanVan,
    required this.cauHoi,
  });

  factory DeThiFull.fromJson(Map<String, dynamic> json) {
    var dvList = (json['doanVan'] as List<dynamic>?)
            ?.map((e) => DoanVan.fromJson(e))
            .toList() ??
        [];
    var chList = (json['cauHoi'] as List<dynamic>?)
            ?.map((e) => CauHoi.fromJson(e))
            .toList() ??
        [];
    return DeThiFull(
      deThiId: json['deThiId'] ?? 0,
      maDe: json['maDe'] ?? '',
      tenDe: json['tenDe'] ?? '',
      thoiGianPhut: json['thoiGianPhut'] ?? 75,
      tongSoCau: json['tongSoCau'] ?? 100,
      doanVan: dvList,
      cauHoi: chList,
    );
  }
}

class KetQuaChiTiet {
  final int cauHoiId;
  final int soThuTuCau;
  final String dapAnChon;
  final String dapAnDung;
  final bool laDung;
  final String giaiThich;

  KetQuaChiTiet({
    required this.cauHoiId,
    required this.soThuTuCau,
    required this.dapAnChon,
    required this.dapAnDung,
    required this.laDung,
    required this.giaiThich,
  });

  factory KetQuaChiTiet.fromJson(Map<String, dynamic> json) {
    return KetQuaChiTiet(
      cauHoiId: json['cauHoiId'] ?? 0,
      soThuTuCau: json['soThuTuCau'] ?? 0,
      dapAnChon: json['dapAnChon'] ?? '',
      dapAnDung: json['dapAnDung'] ?? '',
      laDung: json['laDung'] ?? false,
      giaiThich: json['giaiThich'] ?? '',
    );
  }
}

class KetQuaThi {
  final int baiThiId;
  final String maSV;
  final int soCauDung;
  final int soCauSai;
  final int soCauBoQua;
  final int tongSoCau;
  final int diemReading;
  final int thoiGianLamGiay;
  final List<KetQuaChiTiet> chiTiet;

  KetQuaThi({
    required this.baiThiId,
    required this.maSV,
    required this.soCauDung,
    required this.soCauSai,
    required this.soCauBoQua,
    required this.tongSoCau,
    required this.diemReading,
    required this.thoiGianLamGiay,
    required this.chiTiet,
  });

  factory KetQuaThi.fromJson(Map<String, dynamic> json) {
    var ctList = (json['chiTiet'] as List<dynamic>?)
            ?.map((e) => KetQuaChiTiet.fromJson(e))
            .toList() ??
        [];
    return KetQuaThi(
      baiThiId: json['baiThiId'] ?? 0,
      maSV: json['maSV'] ?? '',
      soCauDung: json['soCauDung'] ?? 0,
      soCauSai: json['soCauSai'] ?? 0,
      soCauBoQua: json['soCauBoQua'] ?? 0,
      tongSoCau: json['tongSoCau'] ?? 0,
      diemReading: json['diemReading'] ?? 5,
      thoiGianLamGiay: json['thoiGianLamGiay'] ?? 0,
      chiTiet: ctList,
    );
  }
}

// ==============================================================================
// 3. MAIN APP
// ==============================================================================
class ToeicExamApp extends StatelessWidget {
  const ToeicExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ Thống Thi TOEIC Reading',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}

// ==============================================================================
// 4. MÀN HÌNH ĐĂNG NHẬP TÀI KHOẢN (LOGIN SCREEN)
// ==============================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _maSVController = TextEditingController(text: '2380600355');
  final _matKhauController = TextEditingController(text: '123456');
  bool _obscurePassword = true;
  bool _isLoading = false;

  List<Map<String, dynamic>> _quickAccounts = [
    {'maSV': '2380600355', 'hoTen': 'Nguyễn Nhật Duy', 'lop': '23DTHC7', 'vaiTro': 'Student', 'deThi': 'Reading v09'},
    {'maSV': '2280600579', 'hoTen': 'Huỳnh Nguyễn Thành Đạt', 'lop': '22DTHG4', 'vaiTro': 'Student', 'deThi': 'Reading v03'},
    {'maSV': '2380600232', 'hoTen': 'Ngô Ngọc Chiến', 'lop': '23DTHC7', 'vaiTro': 'Student', 'deThi': 'Reading v04'},
    {'maSV': '2380600645', 'hoTen': 'Hoàng Khắc Trung Hiếu', 'lop': '23DTHC7', 'vaiTro': 'Student', 'deThi': 'Reading v08'},
    {'maSV': 'GV001', 'hoTen': 'Giảng viên HUTECH', 'lop': 'Khoa CNTT', 'vaiTro': 'Teacher', 'deThi': 'Quản trị'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchQuickAccounts();
  }

  Future<void> _fetchQuickAccounts() async {
    try {
      final res = await http.get(Uri.parse('${getApiBaseUrl()}/api/auth/quick-students')).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(res.bodyBytes));
        setState(() {
          _quickAccounts = data.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      }
    } catch (_) {}
  }

  Future<void> _handleLogin() async {
    final maSV = _maSVController.text.trim();
    final matKhau = _matKhauController.text.trim();

    if (maSV.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập Mã Sinh Viên!'), backgroundColor: AppTheme.danger),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final res = await http.post(
        Uri.parse('${getApiBaseUrl()}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'maSV': maSV, 'matKhau': matKhau}),
      ).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final data = json.decode(utf8.decode(res.bodyBytes));
        final user = UserSession.fromJson(data['user']);
        _goToHome(user);
        return;
      }
    } catch (_) {}

    // Fallback login
    final matched = _quickAccounts.firstWhere(
      (a) => a['maSV'] == maSV,
      orElse: () => {'maSV': maSV, 'hoTen': 'Thí sinh TOEIC', 'lop': '23DTHC7', 'vaiTro': 'Student', 'deThi': 'Reading v09'},
    );

    final user = UserSession(
      maSV: matched['maSV'],
      hoTen: matched['hoTen'],
      email: '${matched['maSV']}@gmail.com',
      lop: matched['lop'] ?? '23DTHC7',
      nhom: 'Nhóm 7',
      vaiTro: matched['vaiTro'] ?? 'Student',
      deThiPhanCong: 'Reading v09',
    );

    _goToHome(user);
  }

  void _goToHome(UserSession user) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ExamListScreen(user: user)),
    );
  }

  void _quickPick(Map<String, dynamic> acc) {
    setState(() {
      _maSVController.text = acc['maSV'];
      _matKhauController.text = '123456';
    });
    _handleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), AppTheme.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Logo & Tiêu đề
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.school_rounded, color: AppTheme.primary, size: 45),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TOEIC READING MASTER',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Hệ Thống Thi Trắc Nghiệm ETS Chuẩn Quốc Tế',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 28),

                  // Khung Đăng nhập
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Đăng Nhập Thí Sinh',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Nhập mã số sinh viên để bắt đầu thi',
                          style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                        ),
                        const SizedBox(height: 20),

                        // Input Mã SV
                        TextField(
                          controller: _maSVController,
                          decoration: InputDecoration(
                            labelText: 'Mã số sinh viên (MSSV)',
                            prefixIcon: const Icon(Icons.badge_outlined, color: AppTheme.primaryLight),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input Mật khẩu
                        TextField(
                          controller: _matKhauController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primaryLight),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nút Đăng nhập
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                : const Text('ĐĂNG NHẬP VÀO PHÒNG THI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tính năng chọn nhanh tài khoản
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.touch_app_rounded, color: Colors.amber, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Đăng nhập nhanh 1-chạm (Danh sách sinh viên trong lớp):',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _quickAccounts.map((acc) {
                            final isMe = acc['maSV'] == '2380600355';
                            return ActionChip(
                              backgroundColor: isMe ? Colors.amber : Colors.white.withValues(alpha: 0.2),
                              side: BorderSide.none,
                              avatar: CircleAvatar(
                                radius: 10,
                                backgroundColor: isMe ? Colors.black : Colors.white70,
                                child: Text(
                                  acc['hoTen'] != null && acc['hoTen'].isNotEmpty ? acc['hoTen'][0] : 'S',
                                  style: TextStyle(fontSize: 10, color: isMe ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                              label: Text(
                                '${acc['hoTen']} (${acc['maSV']})',
                                style: TextStyle(
                                  color: isMe ? Colors.black : Colors.white,
                                  fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () => _quickPick(acc),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==============================================================================
// 5. MÀN HÌNH 2: DANH SÁCH ĐỀ THI (HOME)
// ==============================================================================
class ExamListScreen extends StatefulWidget {
  final UserSession user;
  const ExamListScreen({super.key, required this.user});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  List<DeThiItem> _deThiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeThiList();
  }

  Future<void> _fetchDeThiList() async {
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('${getApiBaseUrl()}/api/toeic/dethi');
      final response = await http.get(url).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _deThiList = data.map((e) => DeThiItem.fromJson(e)).toList();
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}

    setState(() {
      _deThiList = [
        DeThiItem(
          deThiId: 1,
          maDe: 'Reading v09',
          tenDe: 'ETS TOEIC READING TEST 09',
          thoiGianPhut: 75,
          tongSoCau: 100,
          trangThai: 'Hoạt động',
        )
      ];
      _isLoading = false;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOEIC READING MASTER', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Lịch sử bài thi',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExamHistoryScreen(user: widget.user)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Đăng xuất',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeaderCard(),
            const SizedBox(height: 20),
            _buildAssignedExamBanner(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách đề thi có sẵn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Tải lại'),
                  onPressed: _fetchDeThiList,
                )
              ],
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
            else
              ..._deThiList.map((item) => _buildExamCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.15),
            child: const Icon(Icons.person, color: AppTheme.primary, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.hoTen,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                ),
                const SizedBox(height: 4),
                Text(
                  'MSSV: ${widget.user.maSV} • Lớp: ${widget.user.lop} (${widget.user.nhom})',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Đang online',
              style: TextStyle(color: AppTheme.success, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAssignedExamBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                child: const Text('ĐỀ PHÂN CÔNG RIÊNG', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w900)),
              ),
              const Spacer(),
              const Icon(Icons.timer, color: Colors.white70, size: 18),
              const SizedBox(width: 4),
              const Text('75 Phút', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Reading v09 - ETS TEST 09', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          const Text(
            'Gồm Part 5 (Câu 101-130), Part 6 (Câu 131-146) & Part 7 (Câu 147-200). Đầy đủ bài đọc, đồng hồ đếm ngược tự động và chấm điểm chuẩn.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 22),
            label: const Text('VÀO PHÒNG THI NGAY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExamDetailInstructionScreen(deThiId: 1, user: widget.user)),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildExamCard(DeThiItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.assignment, color: AppTheme.primaryLight, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.tenDe, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Mã: ${item.maDe}', style: const TextStyle(fontSize: 13, color: AppTheme.primaryLight, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 10),
                      Text('• ${item.thoiGianPhut} phút', style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                      const SizedBox(width: 10),
                      Text('• ${item.tongSoCau} câu', style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              child: const Text('Vào thi', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExamDetailInstructionScreen(deThiId: item.deThiId, user: widget.user)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================================================================
// 6. MÀN HÌNH HƯỚNG DẪN THI
// ==============================================================================
class ExamDetailInstructionScreen extends StatelessWidget {
  final int deThiId;
  final UserSession user;
  const ExamDetailInstructionScreen({super.key, required this.deThiId, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quy Chế Phòng Thi TOEIC')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ĐỀ THI TOEIC READING TEST 09 (Reading v09)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                  const SizedBox(height: 8),
                  Text('Thí sinh: ${user.hoTen} (${user.maSV})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text('Thời gian làm bài: 75 Phút (Đếm ngược tự động)', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textMain)),
                  const Text('Thang điểm: 495 điểm Reading theo quy chuẩn ETS', style: TextStyle(color: AppTheme.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Cấu trúc các phần trong bài thi:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPartRuleItem('Part 5 (Câu 101 - 130):', 'Câu hỏi điền từ vào chỗ trống độc lập. Chọn phương án đúng nhất A, B, C, D.', Icons.format_list_numbered),
            _buildPartRuleItem('Part 6 (Câu 131 - 146):', 'Bài đọc điền từ vào đoạn văn (Email, Thông báo). Mỗi bài gồm 4 chỗ trống.', Icons.article_outlined),
            _buildPartRuleItem('Part 7 (Câu 147 - 200):', 'Đọc hiểu văn bản đơn, kép & ba (Hóa đơn, tin nhắn, quảng cáo, báo chí).', Icons.menu_book_outlined),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.warning.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Lưu ý: Hệ thống tự động thu bài và khóa quyền chọn đáp án khi đồng hồ về 00:00!',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFB45309)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.alarm_on, size: 24),
                label: const Text('BẮT ĐẦU TÍNH GIỜ LÀM BÀI (75 PHÚT)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ExamTakingScreen(deThiId: deThiId, user: user)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartRuleItem(String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryLight, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: AppTheme.textMain, height: 1.4),
                children: [
                  TextSpan(text: '$title ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: desc, style: const TextStyle(color: AppTheme.textMuted)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==============================================================================
// 7. MÀN HÌNH LÀM BÀI THI CHÍNH
// ==============================================================================
class ExamTakingScreen extends StatefulWidget {
  final int deThiId;
  final UserSession user;
  const ExamTakingScreen({super.key, required this.deThiId, required this.user});

  @override
  State<ExamTakingScreen> createState() => _ExamTakingScreenState();
}

class _ExamTakingScreenState extends State<ExamTakingScreen> with SingleTickerProviderStateMixin {
  DeThiFull? _deThi;
  bool _isLoading = true;

  final Map<int, String> _userAnswers = {};
  final Set<int> _flaggedQuestions = {};

  int _currentIndex = 0;
  late int _remainingSeconds;
  Timer? _countdownTimer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 75 * 60;
    _loadExamData();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _elapsedSeconds++;
        } else {
          _countdownTimer?.cancel();
          _onTimeExpired();
        }
      });
    });
  }

  void _onTimeExpired() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('HẾT GIỜ LÀM BÀI!'),
        content: const Text('Đã hết 75 phút quy định. Hệ thống đang tự động nộp bài và tính điểm.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _submitExam(isAuto: true);
            },
            child: const Text('Xem Kết Quả'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadExamData() async {
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('${getApiBaseUrl()}/api/toeic/dethi/${widget.deThiId}/lam-bai');
      final res = await http.get(url).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final decoded = json.decode(utf8.decode(res.bodyBytes));
        setState(() {
          _deThi = DeThiFull.fromJson(decoded);
          _isLoading = false;
        });
        _startTimer();
        return;
      }
    } catch (_) {}

    _deThi = _createFallbackExamData();
    setState(() => _isLoading = false);
    _startTimer();
  }

  String _formatTimer(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _selectAnswer(int cauHoiId, String kyTu) {
    setState(() {
      if (_userAnswers[cauHoiId] == kyTu) {
        _userAnswers.remove(cauHoiId);
      } else {
        _userAnswers[cauHoiId] = kyTu;
      }
    });

    _autoSaveProgress();
  }

  void _toggleFlag(int cauHoiId) {
    setState(() {
      if (_flaggedQuestions.contains(cauHoiId)) {
        _flaggedQuestions.remove(cauHoiId);
      } else {
        _flaggedQuestions.add(cauHoiId);
      }
    });
  }

  void _autoSaveProgress() {
    try {
      final url = Uri.parse('${getApiBaseUrl()}/api/toeic/baithi/luu-tam');
      http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'maSV': widget.user.maSV,
          'deThiId': widget.deThiId,
          'cauTraLoi': _userAnswers.entries.map((e) => {'cauHoiId': e.key, 'dapAnChon': e.value}).toList(),
        }),
      );
    } catch (_) {}
  }

  void _confirmSubmit() {
    final total = _deThi?.cauHoi.length ?? 0;
    final answered = _userAnswers.length;
    final unanswered = total - answered;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận Nộp Bài Thi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thời gian còn lại: ${_formatTimer(_remainingSeconds)}'),
            const SizedBox(height: 8),
            Text('Số câu đã làm: $answered / $total'),
            if (unanswered > 0)
              Text(
                'Cảnh báo: Bạn còn $unanswered câu CHƯA LÀM!',
                style: const TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 12),
            const Text('Bạn có chắc chắn muốn nộp bài và xem kết quả ngay không?'),
          ],
        ),
        actions: [
          TextButton(child: const Text('Làm tiếp'), onPressed: () => Navigator.pop(ctx)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger, foregroundColor: Colors.white),
            child: const Text('Xác nhận Nộp'),
            onPressed: () {
              Navigator.pop(ctx);
              _submitExam(isAuto: false);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submitExam({bool isAuto = false}) async {
    _countdownTimer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Đang chấm điểm tự động từ Database de tanh...', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final url = Uri.parse('${getApiBaseUrl()}/api/toeic/baithi/nop-bai');
      final body = json.encode({
        'maSV': widget.user.maSV,
        'deThiId': widget.deThiId,
        'thoiGianLamGiay': _elapsedSeconds,
        'cauTraLoi': _userAnswers.entries.map((e) => {'cauHoiId': e.key, 'dapAnChon': e.value}).toList(),
      });

      final res = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body).timeout(const Duration(seconds: 6));

      if (res.statusCode == 200) {
        final decoded = json.decode(utf8.decode(res.bodyBytes));
        final ketQua = KetQuaThi.fromJson(decoded);

        if (!mounted) return;
        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ExamResultScreen(ketQua: ketQua, deThi: _deThi!, user: widget.user)),
        );
        return;
      }
    } catch (_) {}

    if (!mounted) return;
    Navigator.pop(context);

    final offlineResult = _calculateOfflineResult();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ExamResultScreen(ketQua: offlineResult, deThi: _deThi!, user: widget.user)),
    );
  }

  KetQuaThi _calculateOfflineResult() {
    int dung = 0;
    int sai = 0;
    int boQua = 0;
    List<KetQuaChiTiet> ct = [];

    final list = _deThi?.cauHoi ?? [];
    for (var q in list) {
      final userAns = _userAnswers[q.cauHoiId] ?? '';
      final correct = _getOfflineCorrectAnswer(q.soThuTuCau);
      final isCorrect = userAns.isNotEmpty && userAns.toUpperCase() == correct;

      if (userAns.isEmpty) {
        boQua++;
      } else if (isCorrect) {
        dung++;
      } else {
        sai++;
      }

      ct.add(KetQuaChiTiet(
        cauHoiId: q.cauHoiId,
        soThuTuCau: q.soThuTuCau,
        dapAnChon: userAns,
        dapAnDung: correct,
        laDung: isCorrect,
        giaiThich: 'Đáp án chuẩn ETS Test 09: $correct.',
      ));
    }

    int score = (dung / (list.isEmpty ? 1 : list.length) * 495).round();
    score = ((score ~/ 5) * 5).clamp(5, 495);

    return KetQuaThi(
      baiThiId: 999,
      maSV: widget.user.maSV,
      soCauDung: dung,
      soCauSai: sai,
      soCauBoQua: boQua,
      tongSoCau: list.length,
      diemReading: score,
      thoiGianLamGiay: _elapsedSeconds,
      chiTiet: ct,
    );
  }

  String _getOfflineCorrectAnswer(int soThuTu) {
    const ansKey = {
      101: 'B', 102: 'B', 103: 'C', 104: 'B', 105: 'D',
      106: 'C', 107: 'B', 108: 'A', 109: 'A', 110: 'A',
      111: 'C', 112: 'B', 113: 'C', 114: 'B', 115: 'C',
      116: 'A', 117: 'A', 118: 'B', 119: 'D', 120: 'D',
      121: 'A', 122: 'D', 123: 'D', 124: 'A', 125: 'C',
      126: 'A', 127: 'D', 128: 'C', 129: 'B', 130: 'D',
      131: 'C', 132: 'A', 133: 'D', 134: 'B',
      147: 'B', 148: 'D', 149: 'D', 150: 'B', 151: 'A'
    };
    return ansKey[soThuTu] ?? 'A';
  }

  void _openQuestionPalette() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildQuestionPaletteSheet(),
    );
  }

  Widget _buildQuestionPaletteSheet() {
    final list = _deThi?.cauHoi ?? [];
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Bảng Lưới Câu Hỏi (Palette)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegend(AppTheme.primaryLight, 'Đã làm (${_userAnswers.length})'),
              _buildLegend(Colors.grey.shade300, 'Chưa làm (${list.length - _userAnswers.length})'),
              _buildLegend(AppTheme.warning, 'Đánh dấu (${_flaggedQuestions.length})'),
            ],
          ),
          const Divider(height: 24),
          Expanded(
            child: GridView.builder(
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (ctx, idx) {
                final q = list[idx];
                final isAnswered = _userAnswers.containsKey(q.cauHoiId);
                final isFlagged = _flaggedQuestions.contains(q.cauHoiId);
                final isCurrent = idx == _currentIndex;

                Color bg = Colors.grey.shade100;
                Color textColor = AppTheme.textMain;
                if (isAnswered) {
                  bg = AppTheme.primaryLight;
                  textColor = Colors.white;
                }
                if (isFlagged) {
                  bg = AppTheme.warning;
                  textColor = Colors.white;
                }

                return InkWell(
                  onTap: () {
                    setState(() => _currentIndex = idx);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCurrent ? AppTheme.primary : AppTheme.border,
                        width: isCurrent ? 2.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${q.soThuTuCau}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Đang tải câu hỏi TOEIC Reading từ SQL de tanh...'),
            ],
          ),
        ),
      );
    }

    final questions = _deThi?.cauHoi ?? [];
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lỗi tải đề')),
        body: const Center(child: Text('Không tìm thấy câu hỏi trong đề thi.')),
      );
    }

    final currentQuestion = questions[_currentIndex];
    final bool isLowTime = _remainingSeconds <= 300;

    DoanVan? passage;
    if (currentQuestion.doanVanId != null) {
      try {
        passage = _deThi?.doanVan.firstWhere((dv) => dv.doanVanId == currentQuestion.doanVanId);
      } catch (_) {}
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isLowTime ? AppTheme.danger : Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isLowTime ? Colors.yellow : Colors.white30, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer, size: 16, color: isLowTime ? Colors.yellow : Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimer(_remainingSeconds),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isLowTime ? Colors.yellow : Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Câu ${currentQuestion.soThuTuCau}/${questions.last.soThuTuCau}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            tooltip: 'Bảng câu hỏi',
            onPressed: _openQuestionPalette,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.danger,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _confirmSubmit,
              child: const Text('NỘP BÀI', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _userAnswers.length / questions.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.success),
            minHeight: 4,
          ),
          _buildPartSelector(currentQuestion.partNumber),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (passage != null) _buildPassageCard(passage),
                  _buildQuestionCard(currentQuestion),
                  const SizedBox(height: 16),
                  ...currentQuestion.dapAn.map(
                    (da) => _buildChoiceCard(currentQuestion.cauHoiId, da.kyTu, da.noiDungDapAn),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomNavBar(questions.length),
        ],
      ),
    );
  }

  Widget _buildPartSelector(int currentPart) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _buildPartChip(5, 'Part 5 (101-130)', currentPart == 5),
          const SizedBox(width: 8),
          _buildPartChip(6, 'Part 6 (131-146)', currentPart == 6),
          const SizedBox(width: 8),
          _buildPartChip(7, 'Part 7 (147-200)', currentPart == 7),
        ],
      ),
    );
  }

  Widget _buildPartChip(int partNum, String title, bool isActive) {
    return Expanded(
      child: InkWell(
        onTap: () {
          final target = _deThi?.cauHoi.indexWhere((q) => q.partNumber == partNum) ?? -1;
          if (target != -1) {
            setState(() => _currentIndex = target);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.white : AppTheme.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildPassageCard(DoanVan passage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  passage.tieuDe.isNotEmpty ? passage.tieuDe : 'Bài đọc (${passage.loaiNoiDung})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Text(passage.loaiNoiDung, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              )
            ],
          ),
          const Divider(height: 20),
          Text(passage.noiDungDoc, style: const TextStyle(fontSize: 14.5, height: 1.6, color: AppTheme.textMain)),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(CauHoi q) {
    final isFlagged = _flaggedQuestions.contains(q.cauHoiId);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'CÂU ${q.soThuTuCau}',
                  style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _toggleFlag(q.cauHoiId),
                child: Row(
                  children: [
                    Icon(isFlagged ? Icons.flag : Icons.flag_outlined, color: isFlagged ? AppTheme.warning : AppTheme.textMuted, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      isFlagged ? 'Đã đánh dấu' : 'Đánh dấu',
                      style: TextStyle(fontSize: 12, color: isFlagged ? AppTheme.warning : AppTheme.textMuted, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            q.noiDungCauHoi,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textMain, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCard(int cauHoiId, String kyTu, String content) {
    final isSelected = _userAnswers[cauHoiId] == kyTu;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => _selectAnswer(cauHoiId, kyTu),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? AppTheme.primaryLight : AppTheme.border, width: isSelected ? 2 : 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryLight : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  kyTu,
                  style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppTheme.textMain),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: AppTheme.textMain,
                  ),
                ),
              ),
              if (isSelected) const Icon(Icons.check_circle, color: AppTheme.primaryLight, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(int totalQuestions) {
    final canPrev = _currentIndex > 0;
    final canNext = _currentIndex < totalQuestions - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: AppTheme.textMain,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            icon: const Icon(Icons.arrow_back_ios, size: 14),
            label: const Text('Câu trước'),
            onPressed: canPrev ? () => setState(() => _currentIndex--) : null,
          ),
          Text('${_currentIndex + 1} / $totalQuestions', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 1,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            label: const Text('Câu sau'),
            icon: const Icon(Icons.arrow_forward_ios, size: 14),
            onPressed: canNext ? () => setState(() => _currentIndex++) : null,
          ),
        ],
      ),
    );
  }

  DeThiFull _createFallbackExamData() {
    return DeThiFull(
      deThiId: 1,
      maDe: 'Reading v09',
      tenDe: 'ETS TOEIC READING TEST 09',
      thoiGianPhut: 75,
      tongSoCau: 100,
      doanVan: [
        DoanVan(
          doanVanId: 1,
          partNumber: 6,
          tieuDe: 'Questions 131-134 refer to the following e-mail.',
          loaiNoiDung: 'Email',
          noiDungDoc: 'To: pmendoza@factmail.co\nFrom: recruiting@analystsassoc.org\nDate: May 2\nSubject: Joining ASA\n\nDear Mr. Mendoza,\nThank you for expressing your interest in our organization during the recent ------- [131]. It was a pleasure meeting you at the ASA booth during the Weber Information Systems Convention. As you may recall from our conversation, we discussed how ASA membership ------- [132] your career through networking opportunities as well as the industry insights offered in our monthly newsletter. The normal fee for members is just \$120 a year; however, we are currently offering a new-member discount. ------- [133].\nIf you are still interested in joining, please reply to ------- [134] with your mailing address. I will then forward you an application packet.\n\nSincerely,\nAshlee Loren, President\nAssociation of Systems Analysts',
        ),
      ],
      cauHoi: [
        CauHoi(
          cauHoiId: 1,
          partNumber: 5,
          soThuTuCau: 101,
          noiDungCauHoi: 'Every batch of sauce at Generita\'s Bistro is processed meticulously by ------- expert chefs.',
          dapAn: [
            DapAn(dapAnId: 1, cauHoiId: 1, kyTu: 'A', noiDungDapAn: 'they'),
            DapAn(dapAnId: 2, cauHoiId: 1, kyTu: 'B', noiDungDapAn: 'their'),
            DapAn(dapAnId: 3, cauHoiId: 1, kyTu: 'C', noiDungDapAn: 'them'),
            DapAn(dapAnId: 4, cauHoiId: 1, kyTu: 'D', noiDungDapAn: 'themselves'),
          ],
        ),
        CauHoi(
          cauHoiId: 2,
          partNumber: 5,
          soThuTuCau: 102,
          noiDungCauHoi: 'Computerization of medical records ------- increases a physician\'s ability to diagnose and treat patients.',
          dapAn: [
            DapAn(dapAnId: 5, cauHoiId: 2, kyTu: 'A', noiDungDapAn: 'great'),
            DapAn(dapAnId: 6, cauHoiId: 2, kyTu: 'B', noiDungDapAn: 'greatly'),
            DapAn(dapAnId: 7, cauHoiId: 2, kyTu: 'C', noiDungDapAn: 'greatness'),
            DapAn(dapAnId: 8, cauHoiId: 2, kyTu: 'D', noiDungDapAn: 'greatest'),
          ],
        ),
        CauHoi(
          cauHoiId: 3,
          partNumber: 5,
          soThuTuCau: 103,
          noiDungCauHoi: 'At Rojelle\'s Fine Dining, we use the freshest ------- available to make our salads.',
          dapAn: [
            DapAn(dapAnId: 9, cauHoiId: 3, kyTu: 'A', noiDungDapAn: 'applications'),
            DapAn(dapAnId: 10, cauHoiId: 3, kyTu: 'B', noiDungDapAn: 'subjects'),
            DapAn(dapAnId: 11, cauHoiId: 3, kyTu: 'C', noiDungDapAn: 'ingredients'),
            DapAn(dapAnId: 12, cauHoiId: 3, kyTu: 'D', noiDungDapAn: 'factors'),
          ],
        ),
      ],
    );
  }
}

// ==============================================================================
// 8. MÀN HÌNH KẾT QUẢ THI & BIỂU ĐỒ PHÂN TÍCH (RESULT & ANALYTICS)
// ==============================================================================
class ExamResultScreen extends StatelessWidget {
  final KetQuaThi ketQua;
  final DeThiFull deThi;
  final UserSession user;

  const ExamResultScreen({super.key, required this.ketQua, required this.deThi, required this.user});

  String _getToeicLevel(int score) {
    if (score >= 400) return 'Xuất sắc (Trình độ C1 / Senior Proficiency)';
    if (score >= 300) return 'Tốt (Trình độ B2 / Working Proficiency)';
    if (score >= 200) return 'Khá (Trình độ B1 / Intermediate)';
    return 'Cơ bản (Trình độ A2 / Elementary)';
  }

  @override
  Widget build(BuildContext context) {
    final m = (ketQua.thoiGianLamGiay ~/ 60).toString();
    final s = (ketQua.thoiGianLamGiay % 60).toString().padLeft(2, '0');

    final double rateDung = ketQua.tongSoCau > 0 ? (ketQua.soCauDung / ketQua.tongSoCau) : 0;
    final double rateSai = ketQua.tongSoCau > 0 ? (ketQua.soCauSai / ketQua.tongSoCau) : 0;
    final double rateBoQua = ketQua.tongSoCau > 0 ? (ketQua.soCauBoQua / ketQua.tongSoCau) : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('KẾT QUẢ BÀI THI TOEIC READING'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            tooltip: 'Trang chủ',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => ExamListScreen(user: user)),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Banner
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF1E40AF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  Text('THÍ SINH: ${user.hoTen.toUpperCase()} (${user.maSV})', style: const TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 0.8)),
                  const SizedBox(height: 6),
                  Text(
                    '${ketQua.diemReading} / 495',
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getToeicLevel(ketQua.diemReading),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Thời gian làm bài: $m phút $s giây • Lưu tại database: de tanh', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Biểu đồ đồ họa phân bố kết quả (Graphic Progress Bar)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Biểu đồ Tỷ lệ Làm Bài', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 16,
                      child: Row(
                        children: [
                          if (rateDung > 0)
                            Expanded(flex: (rateDung * 100).round(), child: Container(color: AppTheme.success)),
                          if (rateSai > 0)
                            Expanded(flex: (rateSai * 100).round(), child: Container(color: AppTheme.danger)),
                          if (rateBoQua > 0)
                            Expanded(flex: (rateBoQua * 100).round(), child: Container(color: Colors.grey.shade400)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniDot(AppTheme.success, 'Đúng: ${ketQua.soCauDung} (${(rateDung * 100).toStringAsFixed(1)}%)'),
                      _buildMiniDot(AppTheme.danger, 'Sai: ${ketQua.soCauSai} (${(rateSai * 100).toStringAsFixed(1)}%)'),
                      _buildMiniDot(Colors.grey.shade600, 'Bỏ qua: ${ketQua.soCauBoQua} (${(rateBoQua * 100).toStringAsFixed(1)}%)'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3 Card Thống kê
            Row(
              children: [
                _buildStatCard('Số câu đúng', '${ketQua.soCauDung}', AppTheme.success, Icons.check_circle),
                const SizedBox(width: 10),
                _buildStatCard('Số câu sai', '${ketQua.soCauSai}', AppTheme.danger, Icons.cancel),
                const SizedBox(width: 10),
                _buildStatCard('Bỏ qua', '${ketQua.soCauBoQua}', Colors.grey, Icons.help_outline),
              ],
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.history),
                    label: const Text('Lịch Sử Thi', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => ExamHistoryScreen(user: user)));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Thi Lại Đề Này', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => ExamTakingScreen(deThiId: deThi.deThiId, user: user)),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Lời giải thích chi tiết
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Chi tiết từng câu & Lời giải thích ngữ pháp:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            ...ketQua.chiTiet.map((ct) => _buildReviewCard(ct)),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDot(Color color, String text) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(KetQuaChiTiet ct) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ct.laDung ? AppTheme.success.withValues(alpha: 0.5) : AppTheme.danger.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ct.laDung ? AppTheme.success.withValues(alpha: 0.12) : AppTheme.danger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'CÂU ${ct.soThuTuCau}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: ct.laDung ? AppTheme.success : AppTheme.danger, fontSize: 12),
                ),
              ),
              const Spacer(),
              Icon(ct.laDung ? Icons.check_circle : Icons.cancel, color: ct.laDung ? AppTheme.success : AppTheme.danger, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Bạn chọn: ${ct.dapAnChon.isEmpty ? "Bỏ qua" : ct.dapAnChon}', style: TextStyle(fontWeight: FontWeight.bold, color: ct.laDung ? AppTheme.success : AppTheme.danger)),
              const SizedBox(width: 16),
              Text('Đáp án đúng: ${ct.dapAnDung}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
            ],
          ),
          if (ct.giaiThich.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
              child: Text('Giải thích: ${ct.giaiThich}', style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4)),
            ),
          ],
        ],
      ),
    );
  }
}

// ==============================================================================
// 9. MÀN HÌNH LỊCH SỬ THI CỦA THÍ SINH (EXAM HISTORY)
// ==============================================================================
class ExamHistoryScreen extends StatefulWidget {
  final UserSession user;
  const ExamHistoryScreen({super.key, required this.user});

  @override
  State<ExamHistoryScreen> createState() => _ExamHistoryScreenState();
}

class _ExamHistoryScreenState extends State<ExamHistoryScreen> {
  List<dynamic> _historyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('${getApiBaseUrl()}/api/toeic/baithi/lich-su/${widget.user.maSV}');
      final res = await http.get(url).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(res.bodyBytes));
        setState(() {
          _historyList = data;
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}

    setState(() {
      _historyList = [
        {
          'baiThiId': 1,
          'maDe': 'Reading v09',
          'tenDe': 'ETS TOEIC READING TEST 09',
          'thoiGianNop': '2026-10-12 09:24:28',
          'soCauDung': 35,
          'soCauSai': 4,
          'soCauBoQua': 0,
          'diemReading': 445,
        }
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch Sử Làm Bài Thi')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyList.isEmpty
              ? const Center(child: Text('Chưa có lịch sử làm bài thi nào.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _historyList.length,
                  itemBuilder: (ctx, idx) {
                    final item = _historyList[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item['tenDe']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(
                                  '${item['diemReading']} / 495',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryLight),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('Ngày nộp: ${item['thoiGianNop']}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            const Divider(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Đúng: ${item['soCauDung']}', style: const TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold)),
                                Text('Sai: ${item['soCauSai']}', style: const TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold)),
                                Text('Bỏ qua: ${item['soCauBoQua']}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
