import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSeeder {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seedAll() async {
    print('🚀 Bắt đầu tạo database...');
    
    // Thứ tự quan trọng - phải đúng thứ tự này
    await _createUsers();          // 1. Tạo users trước
    await _createAdmins();         // 2. Admin
    await _createTeachers();       // 3. Giáo viên
    await _createClasses();        // 4. Lớp học
    await _createStudents();       // 5. Học sinh
    await _createGuardians();      // 6. Phụ huynh
    await _createAssignments();    // 7. Phân công GV
    await _createTimetable();      // 8. Thời khóa biểu
    await _createAttendance();     // 9. Điểm danh
    await _createGrades();         // 10. Bảng điểm
    await _createHomework();       // 11. Bài tập
    await _createDormitory();      // 12. Ký túc xá
    await _createNews();           // 13. Tin tức
    await _createNotifications();  // 14. Thông báo
    await _createTuitionFees();    // 15. Học phí
    await _createContacts();       // 16. Liên lạc
    await _createMessages();       // 17. Tin nhắn
    
    print('✅ Tạo database hoàn tất!');
  }

  // ══════════════════════════════════════════
  // 1. USERS — tất cả 4 roles
  // ══════════════════════════════════════════
  static Future<void> _createUsers() async {
    final users = [
      // ── ADMIN ──
      {
        'uid': 'admin_001',
        'email': 'admin@fpt.edu.vn',
        'hoTen': 'Nguyễn Quản Trị',
        'vaiTro': 'admin',
        'anhDaiDien': '',
        'soDienThoai': '0243998500',
        'matKhau': '123456',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2020, 1, 1)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },

      // ── GIÁO VIÊN ──
      {
        'uid': 'gv_001',
        'email': 'binh.nt@fpt.edu.vn',
        'hoTen': 'Nguyễn Thị Bình',
        'vaiTro': 'giao_vien',
        'anhDaiDien': '',
        'soDienThoai': '0901112222',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2016, 3, 1)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'gv_002',
        'email': 'dung.tv@fpt.edu.vn',
        'hoTen': 'Trần Văn Dũng',
        'vaiTro': 'giao_vien',
        'anhDaiDien': '',
        'soDienThoai': '0901112223',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2019, 9, 1)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'gv_003',
        'email': 'd.lt@fpt.edu.vn',
        'hoTen': 'Lê Thị D',
        'vaiTro': 'giao_vien',
        'anhDaiDien': '',
        'soDienThoai': '0901112224',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2018, 9, 1)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'gv_004',
        'email': 'e.pv@fpt.edu.vn',
        'hoTen': 'Phạm Văn E',
        'vaiTro': 'giao_vien',
        'anhDaiDien': '',
        'soDienThoai': '0901112225',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2017, 9, 1)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'gv_005',
        'email': 'f.nt@fpt.edu.vn',
        'hoTen': 'Ngô Thị F',
        'vaiTro': 'giao_vien',
        'anhDaiDien': '',
        'soDienThoai': '0901112226',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2020, 9, 1)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },

      // ── HỌC SINH ──
      {
        'uid': 'hs_001',
        'email': 'an.nv@fpt.edu.vn',
        'hoTen': 'Nguyễn Văn An',
        'vaiTro': 'hoc_sinh',
        'anhDaiDien': '',
        'soDienThoai': '0901234567',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2022, 9, 5)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'hs_002',
        'email': 'b.tt@fpt.edu.vn',
        'hoTen': 'Trần Thị B',
        'vaiTro': 'hoc_sinh',
        'anhDaiDien': '',
        'soDienThoai': '0901234568',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2022, 9, 5)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'hs_003',
        'email': 'c.lv@fpt.edu.vn',
        'hoTen': 'Lê Văn C',
        'vaiTro': 'hoc_sinh',
        'anhDaiDien': '',
        'soDienThoai': '0901234569',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2022, 9, 5)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'hs_004',
        'email': 'd.pt@fpt.edu.vn',
        'hoTen': 'Phạm Thị D',
        'vaiTro': 'hoc_sinh',
        'anhDaiDien': '',
        'soDienThoai': '0901234570',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2022, 9, 5)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'hs_005',
        'email': 'bao.nt@fpt.edu.vn',
        'hoTen': 'Nguyễn Thị Bảo',
        'vaiTro': 'hoc_sinh',
        'anhDaiDien': '',
        'soDienThoai': '0901234571',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2023, 9, 5)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },

      // ── PHỤ HUYNH ──
      {
        'uid': 'ph_001',
        'email': 'lan.nt@gmail.com',
        'hoTen': 'Nguyễn Thị Lan',
        'vaiTro': 'phu_huynh',
        'anhDaiDien': '',
        'soDienThoai': '0909998888',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2022, 9, 1)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'ph_002',
        'email': 'hung.tv@gmail.com',
        'hoTen': 'Trần Văn Hùng',
        'vaiTro': 'phu_huynh',
        'anhDaiDien': '',
        'soDienThoai': '0909997777',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2022, 9, 1)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'ph_003',
        'email': 'mai.lv@gmail.com',
        'hoTen': 'Lê Văn Mai',
        'vaiTro': 'phu_huynh',
        'anhDaiDien': '',
        'soDienThoai': '0909996666',
        'isActive': true,
        'taoLuc': Timestamp.fromDate(DateTime(2022, 9, 1)),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
    ];

    for (final u in users) {
      await _db.collection('users')
          .doc(u['uid'] as String)
          .set(u);
    }
    print('✅ users (${users.length} accounts)');
  }

  // ══════════════════════════════════════════
  // 2. ADMIN
  // ══════════════════════════════════════════
  static Future<void> _createAdmins() async {
    await _db.collection('admin')
        .doc('admin_001')
        .set({
      'adminId': 'admin_001',
      'userId': 'admin_001',
      'hoTen': 'Nguyễn Quản Trị',
      'maAdmin': 'AD001',
      'email': 'admin@fpt.edu.vn',
      'chucVu': 'Quản trị viên hệ thống',
      'truong': 'THPT FPT Đà Nẵng',
      'quyenHan': [
        'quan_ly_lop',
        'quan_ly_giao_vien',
        'quan_ly_hoc_sinh',
        'phan_cong_giao_vien',
        'xep_hoc_sinh',
        'xem_bao_cao',
        'quan_ly_tai_khoan',
        'quan_ly_hoc_phi',
      ],
      'isActive': true,
      'taoLuc': Timestamp.fromDate(DateTime(2020, 1, 1)),
    });
    print('✅ admin');
  }

  // ══════════════════════════════════════════
  // 3. GIÁO VIÊN
  // ══════════════════════════════════════════
  static Future<void> _createTeachers() async {
    final teachers = [
      {
        'giaoVienId': 'gv_001',
        'userId': 'gv_001',
        'hoTen': 'Nguyễn Thị Bình',
        'maGiaoVien': 'GV001',
        'email': 'binh.nt@fpt.edu.vn',
        'soDienThoai': '0901112222',
        'gioiTinh': 'Nữ',
        'ngaySinh': Timestamp.fromDate(DateTime(1985, 5, 20)),
        'monHocChinh': 'Toán',
        'danhSachMonDay': ['Toán'],
        // Khớp với phan_cong
        'danhSachPhanCong': [
          {
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
            'monHoc': 'Toán',
            'isGVCN': true,
          },
          {
            'lopId': 'lop_11A2',
            'tenLop': '11A2',
            'monHoc': 'Toán',
            'isGVCN': false,
          },
        ],
        'khoaHoc': 'Khoa học tự nhiên',
        'bangCap': 'Thạc sĩ Toán học',
        'namKinhNghiem': 8,
        'ngayVaoLam': Timestamp.fromDate(
            DateTime(2016, 3, 1)),
        'phongLamViec': 'P.201',
        'anhDaiDien': '',
        'isActive': true,
      },
      {
        'giaoVienId': 'gv_002',
        'userId': 'gv_002',
        'hoTen': 'Trần Văn Dũng',
        'maGiaoVien': 'GV002',
        'email': 'dung.tv@fpt.edu.vn',
        'soDienThoai': '0901112223',
        'gioiTinh': 'Nam',
        'ngaySinh': Timestamp.fromDate(DateTime(1988, 8, 15)),
        'monHocChinh': 'Ngữ văn',
        'danhSachMonDay': ['Ngữ văn'],
        'danhSachPhanCong': [
          {
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
            'monHoc': 'Văn',
            'isGVCN': false,
          },
          {
            'lopId': 'lop_11A2',
            'tenLop': '11A2',
            'monHoc': 'Văn',
            'isGVCN': true,
          },
        ],
        'khoaHoc': 'Khoa học xã hội',
        'bangCap': 'Cử nhân Ngữ văn',
        'namKinhNghiem': 5,
        'ngayVaoLam': Timestamp.fromDate(
            DateTime(2019, 9, 1)),
        'phongLamViec': 'P.202',
        'anhDaiDien': '',
        'isActive': true,
      },
      {
        'giaoVienId': 'gv_003',
        'userId': 'gv_003',
        'hoTen': 'Lê Thị D',
        'maGiaoVien': 'GV003',
        'email': 'd.lt@fpt.edu.vn',
        'soDienThoai': '0901112224',
        'gioiTinh': 'Nữ',
        'ngaySinh': Timestamp.fromDate(DateTime(1990, 3, 10)),
        'monHocChinh': 'Tiếng Anh',
        'danhSachMonDay': ['Tiếng Anh'],
        'danhSachPhanCong': [
          {
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
            'monHoc': 'Tiếng Anh',
            'isGVCN': false,
          },
        ],
        'khoaHoc': 'Ngoại ngữ',
        'bangCap': 'Thạc sĩ Tiếng Anh',
        'namKinhNghiem': 6,
        'ngayVaoLam': Timestamp.fromDate(
            DateTime(2018, 9, 1)),
        'phongLamViec': 'P.203',
        'anhDaiDien': '',
        'isActive': true,
      },
      {
        'giaoVienId': 'gv_004',
        'userId': 'gv_004',
        'hoTen': 'Phạm Văn E',
        'maGiaoVien': 'GV004',
        'email': 'e.pv@fpt.edu.vn',
        'soDienThoai': '0901112225',
        'gioiTinh': 'Nam',
        'ngaySinh': Timestamp.fromDate(DateTime(1987, 11, 25)),
        'monHocChinh': 'Vật lý',
        'danhSachMonDay': ['Vật lý'],
        'danhSachPhanCong': [
          {
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
            'monHoc': 'Vật lý',
            'isGVCN': false,
          },
        ],
        'khoaHoc': 'Khoa học tự nhiên',
        'bangCap': 'Thạc sĩ Vật lý',
        'namKinhNghiem': 7,
        'ngayVaoLam': Timestamp.fromDate(
            DateTime(2017, 9, 1)),
        'phongLamViec': 'P.301',
        'anhDaiDien': '',
        'isActive': true,
      },
      {
        'giaoVienId': 'gv_005',
        'userId': 'gv_005',
        'hoTen': 'Ngô Thị F',
        'maGiaoVien': 'GV005',
        'email': 'f.nt@fpt.edu.vn',
        'soDienThoai': '0901112226',
        'gioiTinh': 'Nữ',
        'ngaySinh': Timestamp.fromDate(DateTime(1992, 7, 8)),
        'monHocChinh': 'Hóa học',
        'danhSachMonDay': ['Hóa học'],
        'danhSachPhanCong': [
          {
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
            'monHoc': 'Hóa học',
            'isGVCN': false,
          },
        ],
        'khoaHoc': 'Khoa học tự nhiên',
        'bangCap': 'Cử nhân Hóa học',
        'namKinhNghiem': 4,
        'ngayVaoLam': Timestamp.fromDate(
            DateTime(2020, 9, 1)),
        'phongLamViec': 'P.302',
        'anhDaiDien': '',
        'isActive': true,
      },
    ];

    for (final t in teachers) {
      await _db.collection('giao_vien')
          .doc(t['giaoVienId'] as String)
          .set(t);
    }
    print('✅ giao_vien (${teachers.length} GV)');
  }

  // ══════════════════════════════════════════
  // 4. LỚP HỌC
  // khớp với giao_vien.danhSachPhanCong
  // ══════════════════════════════════════════
  static Future<void> _createClasses() async {
    final classes = [
      {
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'khoiLop': '11',
        'truong': 'THPT FPT Đà Nẵng',
        'namHoc': '2024-2025',
        // Khớp với gv_001
        'giaoVienChuNhiemId': 'gv_001',
        'giaoVienChuNhiem': 'Nguyễn Thị Bình',
        'siSoHienTai': 4,
        'siSoToiDa': 45,
        'phongHoc': 'P.101',
        // Khớp với hoc_sinh
        'danhSachHocSinhId': [
          'hs_001', 'hs_002', 'hs_003', 'hs_004'
        ],
        // Khớp với giao_vien
        'danhSachGiaoVien': [
          {'giaoVienId': 'gv_001', 'monHoc': 'Toán', 'isGVCN': true},
          {'giaoVienId': 'gv_002', 'monHoc': 'Văn', 'isGVCN': false},
          {'giaoVienId': 'gv_003', 'monHoc': 'Tiếng Anh', 'isGVCN': false},
          {'giaoVienId': 'gv_004', 'monHoc': 'Vật lý', 'isGVCN': false},
          {'giaoVienId': 'gv_005', 'monHoc': 'Hóa học', 'isGVCN': false},
        ],
        'isActive': true,
      },
      {
        'lopId': 'lop_11A2',
        'tenLop': '11A2',
        'khoiLop': '11',
        'truong': 'THPT FPT Đà Nẵng',
        'namHoc': '2024-2025',
        // Khớp với gv_002
        'giaoVienChuNhiemId': 'gv_002',
        'giaoVienChuNhiem': 'Trần Văn Dũng',
        'siSoHienTai': 1,
        'siSoToiDa': 45,
        'phongHoc': 'P.102',
        // Khớp với hoc_sinh
        'danhSachHocSinhId': ['hs_005'],
        'danhSachGiaoVien': [
          {'giaoVienId': 'gv_001', 'monHoc': 'Toán', 'isGVCN': false},
          {'giaoVienId': 'gv_002', 'monHoc': 'Văn', 'isGVCN': true},
        ],
        'isActive': true,
      },
    ];

    for (final c in classes) {
      await _db.collection('lop_hoc')
          .doc(c['lopId'] as String)
          .set(c);
    }
    print('✅ lop_hoc (${classes.length} lớp)');
  }

  // ══════════════════════════════════════════
  // 5. HỌC SINH
  // lopId khớp với lop_hoc
  // phuHuynhId khớp với phu_huynh
  // ══════════════════════════════════════════
  static Future<void> _createStudents() async {
    final students = [
      {
        'hocSinhId': 'hs_001',
        'userId': 'hs_001',
        'hoTen': 'Nguyễn Văn An',
        'maHocSinh': 'HS001',
        'ngaySinh': Timestamp.fromDate(DateTime(2008, 3, 15)),
        'gioiTinh': 'Nam',
        // Khớp với lop_hoc
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'khoiLop': '11',
        'truong': 'THPT FPT Đà Nẵng',
        'namHoc': '2024-2025',
        'diaChi': '123 Nguyễn Văn Linh, Đà Nẵng',
        'nhomMau': 'B+',
        'ngayNhapHoc': Timestamp.fromDate(DateTime(2022, 9, 5)),
        // Khớp với phu_huynh
        'phuHuynhId': 'ph_001',
        'tenPhuHuynh': 'Nguyễn Thị Lan',
        'sdtPhuHuynh': '0909998888',
        'isNoiTru': true,
        'isActive': true,
        'anhDaiDien': '',
      },
      {
        'hocSinhId': 'hs_002',
        'userId': 'hs_002',
        'hoTen': 'Trần Thị B',
        'maHocSinh': 'HS002',
        'ngaySinh': Timestamp.fromDate(DateTime(2008, 6, 20)),
        'gioiTinh': 'Nữ',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'khoiLop': '11',
        'truong': 'THPT FPT Đà Nẵng',
        'namHoc': '2024-2025',
        'diaChi': '456 Lê Duẩn, Đà Nẵng',
        'nhomMau': 'A+',
        'ngayNhapHoc': Timestamp.fromDate(DateTime(2022, 9, 5)),
        'phuHuynhId': 'ph_002',
        'tenPhuHuynh': 'Trần Văn Hùng',
        'sdtPhuHuynh': '0909997777',
        'isNoiTru': false,
        'isActive': true,
        'anhDaiDien': '',
      },
      {
        'hocSinhId': 'hs_003',
        'userId': 'hs_003',
        'hoTen': 'Lê Văn C',
        'maHocSinh': 'HS003',
        'ngaySinh': Timestamp.fromDate(DateTime(2008, 11, 5)),
        'gioiTinh': 'Nam',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'khoiLop': '11',
        'truong': 'THPT FPT Đà Nẵng',
        'namHoc': '2024-2025',
        'diaChi': '789 Trần Phú, Đà Nẵng',
        'nhomMau': 'O+',
        'ngayNhapHoc': Timestamp.fromDate(DateTime(2022, 9, 5)),
        'phuHuynhId': 'ph_003',
        'tenPhuHuynh': 'Lê Văn Mai',
        'sdtPhuHuynh': '0909996666',
        'isNoiTru': true,
        'isActive': true,
        'anhDaiDien': '',
      },
      {
        'hocSinhId': 'hs_004',
        'userId': 'hs_004',
        'hoTen': 'Phạm Thị D',
        'maHocSinh': 'HS004',
        'ngaySinh': Timestamp.fromDate(DateTime(2008, 1, 12)),
        'gioiTinh': 'Nữ',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'khoiLop': '11',
        'truong': 'THPT FPT Đà Nẵng',
        'namHoc': '2024-2025',
        'diaChi': '321 Hùng Vương, Đà Nẵng',
        'nhomMau': 'AB+',
        'ngayNhapHoc': Timestamp.fromDate(DateTime(2022, 9, 5)),
        'phuHuynhId': 'ph_001',
        'tenPhuHuynh': 'Nguyễn Thị Lan',
        'sdtPhuHuynh': '0909998888',
        'isNoiTru': false,
        'isActive': true,
        'anhDaiDien': '',
      },
      {
        'hocSinhId': 'hs_005',
        'userId': 'hs_005',
        'hoTen': 'Nguyễn Thị Bảo',
        'maHocSinh': 'HS005',
        'ngaySinh': Timestamp.fromDate(DateTime(2010, 7, 22)),
        'gioiTinh': 'Nữ',
        // Khớp với lop_11A2
        'lopId': 'lop_11A2',
        'tenLop': '11A2',
        'khoiLop': '11',
        'truong': 'THPT FPT Đà Nẵng',
        'namHoc': '2024-2025',
        'diaChi': '123 Nguyễn Văn Linh, Đà Nẵng',
        'nhomMau': 'A+',
        'ngayNhapHoc': Timestamp.fromDate(DateTime(2023, 9, 5)),
        // Con thứ 2 của ph_001
        'phuHuynhId': 'ph_001',
        'tenPhuHuynh': 'Nguyễn Thị Lan',
        'sdtPhuHuynh': '0909998888',
        'isNoiTru': false,
        'isActive': true,
        'anhDaiDien': '',
      },
    ];

    for (final s in students) {
      await _db.collection('hoc_sinh')
          .doc(s['hocSinhId'] as String)
          .set(s);
    }
    print('✅ hoc_sinh (${students.length} HS)');
  }

  // ══════════════════════════════════════════
  // 6. PHỤ HUYNH
  // danhSachConId khớp với hoc_sinh
  // ══════════════════════════════════════════
  static Future<void> _createGuardians() async {
    final guardians = [
      {
        'phuHuynhId': 'ph_001',
        'userId': 'ph_001',
        'hoTen': 'Nguyễn Thị Lan',
        'quanHe': 'Mẹ',
        // Có 2 con: hs_001 (11A1) và hs_005 (11A2)
        'danhSachConId': ['hs_001', 'hs_005'],
        'danhSachCon': [
          {
            'hocSinhId': 'hs_001',
            'hoTen': 'Nguyễn Văn An',
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
          },
          {
            'hocSinhId': 'hs_005',
            'hoTen': 'Nguyễn Thị Bảo',
            'lopId': 'lop_11A2',
            'tenLop': '11A2',
          },
        ],
        'ngheNghiep': 'Giáo viên',
        'soDienThoai': '0909998888',
        'soDienThoaiPhu': '0909998889',
        'email': 'lan.nt@gmail.com',
        'diaChi': '123 Nguyễn Văn Linh, Đà Nẵng',
        'isActive': true,
      },
      {
        'phuHuynhId': 'ph_002',
        'userId': 'ph_002',
        'hoTen': 'Trần Văn Hùng',
        'quanHe': 'Bố',
        'danhSachConId': ['hs_002'],
        'danhSachCon': [
          {
            'hocSinhId': 'hs_002',
            'hoTen': 'Trần Thị B',
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
          },
        ],
        'ngheNghiep': 'Kỹ sư',
        'soDienThoai': '0909997777',
        'soDienThoaiPhu': '',
        'email': 'hung.tv@gmail.com',
        'diaChi': '456 Lê Duẩn, Đà Nẵng',
        'isActive': true,
      },
      {
        'phuHuynhId': 'ph_003',
        'userId': 'ph_003',
        'hoTen': 'Lê Văn Mai',
        'quanHe': 'Bố',
        'danhSachConId': ['hs_003'],
        'danhSachCon': [
          {
            'hocSinhId': 'hs_003',
            'hoTen': 'Lê Văn C',
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
          },
        ],
        'ngheNghiep': 'Bác sĩ',
        'soDienThoai': '0909996666',
        'soDienThoaiPhu': '',
        'email': 'mai.lv@gmail.com',
        'diaChi': '789 Trần Phú, Đà Nẵng',
        'isActive': true,
      },
    ];

    for (final p in guardians) {
      await _db.collection('phu_huynh')
          .doc(p['phuHuynhId'] as String)
          .set(p);
    }
    print('✅ phu_huynh (${guardians.length} PH)');
  }

  // ══════════════════════════════════════════
  // 7. PHÂN CÔNG
  // giaoVienId khớp giao_vien
  // lopId khớp lop_hoc
  // ══════════════════════════════════════════
  static Future<void> _createAssignments() async {
    final assignments = [
      {
        'phanCongId': 'pc_001',
        'giaoVienId': 'gv_001',
        'tenGiaoVien': 'Nguyễn Thị Bình',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'monHoc': 'Toán',
        'isGVCN': true,
        'namHoc': '2024-2025',
        'hocKy': 'HK1',
        'assignedBy': 'admin_001',
        'assignedAt': Timestamp.fromDate(DateTime(2024, 9, 1)),
        'isActive': true,
      },
      {
        'phanCongId': 'pc_002',
        'giaoVienId': 'gv_001',
        'tenGiaoVien': 'Nguyễn Thị Bình',
        'lopId': 'lop_11A2',
        'tenLop': '11A2',
        'monHoc': 'Toán',
        'isGVCN': false,
        'namHoc': '2024-2025',
        'hocKy': 'HK1',
        'assignedBy': 'admin_001',
        'assignedAt': Timestamp.fromDate(DateTime(2024, 9, 1)),
        'isActive': true,
      },
      {
        'phanCongId': 'pc_003',
        'giaoVienId': 'gv_002',
        'tenGiaoVien': 'Trần Văn Dũng',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'monHoc': 'Văn',
        'isGVCN': false,
        'namHoc': '2024-2025',
        'hocKy': 'HK1',
        'assignedBy': 'admin_001',
        'assignedAt': Timestamp.fromDate(DateTime(2024, 9, 1)),
        'isActive': true,
      },
      {
        'phanCongId': 'pc_004',
        'giaoVienId': 'gv_002',
        'tenGiaoVien': 'Trần Văn Dũng',
        'lopId': 'lop_11A2',
        'tenLop': '11A2',
        'monHoc': 'Văn',
        'isGVCN': true,
        'namHoc': '2024-2025',
        'hocKy': 'HK1',
        'assignedBy': 'admin_001',
        'assignedAt': Timestamp.fromDate(DateTime(2024, 9, 1)),
        'isActive': true,
      },
      {
        'phanCongId': 'pc_005',
        'giaoVienId': 'gv_003',
        'tenGiaoVien': 'Lê Thị D',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'monHoc': 'Tiếng Anh',
        'isGVCN': false,
        'namHoc': '2024-2025',
        'hocKy': 'HK1',
        'assignedBy': 'admin_001',
        'assignedAt': Timestamp.fromDate(DateTime(2024, 9, 1)),
        'isActive': true,
      },
      {
        'phanCongId': 'pc_006',
        'giaoVienId': 'gv_004',
        'tenGiaoVien': 'Phạm Văn E',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'monHoc': 'Vật lý',
        'isGVCN': false,
        'namHoc': '2024-2025',
        'hocKy': 'HK1',
        'assignedBy': 'admin_001',
        'assignedAt': Timestamp.fromDate(DateTime(2024, 9, 1)),
        'isActive': true,
      },
      {
        'phanCongId': 'pc_007',
        'giaoVienId': 'gv_005',
        'tenGiaoVien': 'Ngô Thị F',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'monHoc': 'Hóa học',
        'isGVCN': false,
        'namHoc': '2024-2025',
        'hocKy': 'HK1',
        'assignedBy': 'admin_001',
        'assignedAt': Timestamp.fromDate(DateTime(2024, 9, 1)),
        'isActive': true,
      },
    ];

    for (final a in assignments) {
      await _db.collection('phan_cong')
          .doc(a['phanCongId'] as String)
          .set(a);
    }
    print('✅ phan_cong (${assignments.length} PC)');
  }

  // ══════════════════════════════════════════
  // 8. THỜI KHÓA BIỂU
  // giaoVienId khớp giao_vien
  // lopId khớp lop_hoc
  // ══════════════════════════════════════════
  static Future<void> _createTimetable() async {
    final tkbRef = _db.collection('thoi_khoa_bieu')
        .doc('tkb_lop_11A1_HK1_2024');

    await tkbRef.set({
      'tkbId': 'tkb_lop_11A1_HK1_2024',
      'lopId': 'lop_11A1',
      'tenLop': '11A1',
      'namHoc': '2024-2025',
      'hocKy': 'HK1',
      'capNhatBoi': 'admin_001',
      'capNhatLuc': Timestamp.now(),
    });

    final periods = [
      // ── THỨ 2 ──
      {
        'tietId': 't2_toan',
        'thu': 'Thứ 2', 'thuSo': 2,
        'tietSo': '1-2',
        'monHoc': 'Toán',
        // Khớp gv_001
        'giaoVienId': 'gv_001',
        'tenGiaoVien': 'Nguyễn Thị Bình',
        'phong': 'P.101',
        'gioVao': '07:00', 'gioRa': '08:30',
        'mauSac': '#FF6B00',
      },
      {
        'tietId': 't2_van',
        'thu': 'Thứ 2', 'thuSo': 2,
        'tietSo': '3-4',
        'monHoc': 'Văn',
        // Khớp gv_002
        'giaoVienId': 'gv_002',
        'tenGiaoVien': 'Trần Văn Dũng',
        'phong': 'P.202',
        'gioVao': '08:45', 'gioRa': '10:15',
        'mauSac': '#1A3C6E',
      },
      {
        'tietId': 't2_anh',
        'thu': 'Thứ 2', 'thuSo': 2,
        'tietSo': '5',
        'monHoc': 'Tiếng Anh',
        // Khớp gv_003
        'giaoVienId': 'gv_003',
        'tenGiaoVien': 'Lê Thị D',
        'phong': 'P.203',
        'gioVao': '10:30', 'gioRa': '11:15',
        'mauSac': '#16A34A',
      },
      // ── THỨ 3 ──
      {
        'tietId': 't3_ly',
        'thu': 'Thứ 3', 'thuSo': 3,
        'tietSo': '1-2',
        'monHoc': 'Vật lý',
        // Khớp gv_004
        'giaoVienId': 'gv_004',
        'tenGiaoVien': 'Phạm Văn E',
        'phong': 'P.301',
        'gioVao': '07:00', 'gioRa': '08:30',
        'mauSac': '#7C3AED',
      },
      {
        'tietId': 't3_hoa',
        'thu': 'Thứ 3', 'thuSo': 3,
        'tietSo': '3-4',
        'monHoc': 'Hóa học',
        // Khớp gv_005
        'giaoVienId': 'gv_005',
        'tenGiaoVien': 'Ngô Thị F',
        'phong': 'P.302',
        'gioVao': '08:45', 'gioRa': '10:15',
        'mauSac': '#EA580C',
      },
      {
        'tietId': 't3_van',
        'thu': 'Thứ 3', 'thuSo': 3,
        'tietSo': '5',
        'monHoc': 'Văn',
        'giaoVienId': 'gv_002',
        'tenGiaoVien': 'Trần Văn Dũng',
        'phong': 'P.202',
        'gioVao': '10:30', 'gioRa': '11:15',
        'mauSac': '#1A3C6E',
      },
      // ── THỨ 4 ──
      {
        'tietId': 't4_toan',
        'thu': 'Thứ 4', 'thuSo': 4,
        'tietSo': '1-2',
        'monHoc': 'Toán',
        'giaoVienId': 'gv_001',
        'tenGiaoVien': 'Nguyễn Thị Bình',
        'phong': 'P.101',
        'gioVao': '07:00', 'gioRa': '08:30',
        'mauSac': '#FF6B00',
      },
      {
        'tietId': 't4_anh',
        'thu': 'Thứ 4', 'thuSo': 4,
        'tietSo': '3-4',
        'monHoc': 'Tiếng Anh',
        'giaoVienId': 'gv_003',
        'tenGiaoVien': 'Lê Thị D',
        'phong': 'P.203',
        'gioVao': '08:45', 'gioRa': '10:15',
        'mauSac': '#16A34A',
      },
      {
        'tietId': 't4_ly',
        'thu': 'Thứ 4', 'thuSo': 4,
        'tietSo': '5',
        'monHoc': 'Vật lý',
        'giaoVienId': 'gv_004',
        'tenGiaoVien': 'Phạm Văn E',
        'phong': 'P.301',
        'gioVao': '10:30', 'gioRa': '11:15',
        'mauSac': '#7C3AED',
      },
      // ── THỨ 5 ──
      {
        'tietId': 't5_hoa',
        'thu': 'Thứ 5', 'thuSo': 5,
        'tietSo': '1-2',
        'monHoc': 'Hóa học',
        'giaoVienId': 'gv_005',
        'tenGiaoVien': 'Ngô Thị F',
        'phong': 'P.302',
        'gioVao': '07:00', 'gioRa': '08:30',
        'mauSac': '#EA580C',
      },
      {
        'tietId': 't5_toan',
        'thu': 'Thứ 5', 'thuSo': 5,
        'tietSo': '3-4',
        'monHoc': 'Toán',
        'giaoVienId': 'gv_001',
        'tenGiaoVien': 'Nguyễn Thị Bình',
        'phong': 'P.101',
        'gioVao': '08:45', 'gioRa': '10:15',
        'mauSac': '#FF6B00',
      },
      // ── THỨ 6 ──
      {
        'tietId': 't6_van',
        'thu': 'Thứ 6', 'thuSo': 6,
        'tietSo': '1-2',
        'monHoc': 'Văn',
        'giaoVienId': 'gv_002',
        'tenGiaoVien': 'Trần Văn Dũng',
        'phong': 'P.202',
        'gioVao': '07:00', 'gioRa': '08:30',
        'mauSac': '#1A3C6E',
      },
      {
        'tietId': 't6_anh',
        'thu': 'Thứ 6', 'thuSo': 6,
        'tietSo': '3-4',
        'monHoc': 'Tiếng Anh',
        'giaoVienId': 'gv_003',
        'tenGiaoVien': 'Lê Thị D',
        'phong': 'P.203',
        'gioVao': '08:45', 'gioRa': '10:15',
        'mauSac': '#16A34A',
      },
    ];

    for (final p in periods) {
      await tkbRef.collection('tiet_hoc')
          .doc(p['tietId'] as String)
          .set(p);
    }
    print('✅ thoi_khoa_bieu (${periods.length} tiết)');
  }

  // ══════════════════════════════════════════
  // 9. ĐIỂM DANH
  // hocSinhId khớp hoc_sinh
  // lopId khớp lop_hoc
  // giaoVienId khớp giao_vien (người chấm)
  // ══════════════════════════════════════════
  static Future<void> _createAttendance() async {
    // Điểm danh học cho 4 HS lớp 11A1
    final records = [
      // hs_001 - An: chuyên cần tốt, 1 vắng phép
      {'hs': 'hs_001', 'ngay': '2025-06-02', 'tt': 'co_mat', 'gio': '06:55'},
      {'hs': 'hs_001', 'ngay': '2025-06-03', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_001', 'ngay': '2025-06-04', 'tt': 'co_mat', 'gio': '06:58'},
      {'hs': 'hs_001', 'ngay': '2025-06-05', 'tt': 'vang_co_phep', 'gio': ''},
      {'hs': 'hs_001', 'ngay': '2025-06-06', 'tt': 'co_mat', 'gio': '07:02'},
      {'hs': 'hs_001', 'ngay': '2025-06-09', 'tt': 'co_mat', 'gio': '06:55'},
      {'hs': 'hs_001', 'ngay': '2025-06-10', 'tt': 'vang_khong_phep', 'gio': ''},
      {'hs': 'hs_001', 'ngay': '2025-06-11', 'tt': 'co_mat', 'gio': '07:00'},
      // hs_002 - B: hay đến muộn
      {'hs': 'hs_002', 'ngay': '2025-06-02', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_002', 'ngay': '2025-06-03', 'tt': 'muon', 'gio': '07:15'},
      {'hs': 'hs_002', 'ngay': '2025-06-04', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_002', 'ngay': '2025-06-05', 'tt': 'co_mat', 'gio': '06:58'},
      {'hs': 'hs_002', 'ngay': '2025-06-06', 'tt': 'muon', 'gio': '07:20'},
      {'hs': 'hs_002', 'ngay': '2025-06-09', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_002', 'ngay': '2025-06-10', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_002', 'ngay': '2025-06-11', 'tt': 'muon', 'gio': '07:25'},
      // hs_003 - C: vắng nhiều nhất
      {'hs': 'hs_003', 'ngay': '2025-06-02', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_003', 'ngay': '2025-06-03', 'tt': 'vang_khong_phep', 'gio': ''},
      {'hs': 'hs_003', 'ngay': '2025-06-04', 'tt': 'vang_khong_phep', 'gio': ''},
      {'hs': 'hs_003', 'ngay': '2025-06-05', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_003', 'ngay': '2025-06-06', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_003', 'ngay': '2025-06-09', 'tt': 'vang_co_phep', 'gio': ''},
      {'hs': 'hs_003', 'ngay': '2025-06-10', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_003', 'ngay': '2025-06-11', 'tt': 'co_mat', 'gio': '07:00'},
      // hs_004 - D: chuyên cần tốt
      {'hs': 'hs_004', 'ngay': '2025-06-02', 'tt': 'co_mat', 'gio': '06:50'},
      {'hs': 'hs_004', 'ngay': '2025-06-03', 'tt': 'co_mat', 'gio': '06:52'},
      {'hs': 'hs_004', 'ngay': '2025-06-04', 'tt': 'co_mat', 'gio': '06:55'},
      {'hs': 'hs_004', 'ngay': '2025-06-05', 'tt': 'co_mat', 'gio': '06:58'},
      {'hs': 'hs_004', 'ngay': '2025-06-06', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_004', 'ngay': '2025-06-09', 'tt': 'co_mat', 'gio': '06:55'},
      {'hs': 'hs_004', 'ngay': '2025-06-10', 'tt': 'co_mat', 'gio': '07:00'},
      {'hs': 'hs_004', 'ngay': '2025-06-11', 'tt': 'co_mat', 'gio': '06:58'},
    ];

    // Map ngày → thứ
    final thuMap = {
      '2025-06-02': 'Thứ 2',
      '2025-06-03': 'Thứ 3',
      '2025-06-04': 'Thứ 4',
      '2025-06-05': 'Thứ 5',
      '2025-06-06': 'Thứ 6',
      '2025-06-09': 'Thứ 2',
      '2025-06-10': 'Thứ 3',
      '2025-06-11': 'Thứ 4',
    };

    for (final r in records) {
      final id = 'dd_${r['hs']}_${r['ngay']}';
      await _db.collection('diem_danh').doc(id).set({
        'diemDanhId': id,
        'hocSinhId': r['hs'],
        'lopId': 'lop_11A1',
        // Người chấm = GVCN = gv_001
        'giaoVienId': 'gv_001',
        'tenGiaoVien': 'Nguyễn Thị Bình',
        'ngay': Timestamp.fromDate(
            DateTime.parse(r['ngay'] as String)),
        'ngayString': r['ngay'],
        'thang': 'Tháng 6/2025',
        'thu': thuMap[r['ngay']],
        'trangThai': r['tt'],
        // co_mat | vang_co_phep | vang_khong_phep | muon
        'gioVao': r['gio'],
        'ghiChu': r['tt'] == 'vang_co_phep'
            ? 'Có đơn xin phép'
            : r['tt'] == 'muon'
                ? 'Đến muộn'
                : '',
        'loai': 'hoc',
      });
    }

    // Điểm danh KTX cho hs_001 và hs_003 (nội trú)
    final ktxRecords = [
      {'hs': 'hs_001', 'ngay': '2025-06-02', 'tt': 'co_mat', 'gio': '21:25'},
      {'hs': 'hs_001', 'ngay': '2025-06-03', 'tt': 'co_mat', 'gio': '21:30'},
      {'hs': 'hs_001', 'ngay': '2025-06-04', 'tt': 'co_mat', 'gio': '21:28'},
      {'hs': 'hs_001', 'ngay': '2025-06-05', 'tt': 'vang_co_phep', 'gio': ''},
      {'hs': 'hs_001', 'ngay': '2025-06-06', 'tt': 'co_mat', 'gio': '21:20'},
      {'hs': 'hs_001', 'ngay': '2025-06-09', 'tt': 'co_mat', 'gio': '21:30'},
      {'hs': 'hs_001', 'ngay': '2025-06-10', 'tt': 'vang_khong_phep', 'gio': ''},
      {'hs': 'hs_001', 'ngay': '2025-06-11', 'tt': 'co_mat', 'gio': '21:25'},
      {'hs': 'hs_003', 'ngay': '2025-06-02', 'tt': 'co_mat', 'gio': '21:30'},
      {'hs': 'hs_003', 'ngay': '2025-06-03', 'tt': 'vang_khong_phep', 'gio': ''},
      {'hs': 'hs_003', 'ngay': '2025-06-04', 'tt': 'vang_khong_phep', 'gio': ''},
      {'hs': 'hs_003', 'ngay': '2025-06-05', 'tt': 'co_mat', 'gio': '21:28'},
      {'hs': 'hs_003', 'ngay': '2025-06-06', 'tt': 'co_mat', 'gio': '21:30'},
      {'hs': 'hs_003', 'ngay': '2025-06-09', 'tt': 'co_mat', 'gio': '21:25'},
      {'hs': 'hs_003', 'ngay': '2025-06-10', 'tt': 'co_mat', 'gio': '21:30'},
      {'hs': 'hs_003', 'ngay': '2025-06-11', 'tt': 'co_mat', 'gio': '21:28'},
    ];

    for (final r in ktxRecords) {
      final id = 'ktx_${r['hs']}_${r['ngay']}';
      await _db.collection('diem_danh').doc(id).set({
        'diemDanhId': id,
        'hocSinhId': r['hs'],
        'lopId': 'lop_11A1',
        'giaoVienId': '',
        'tenGiaoVien': 'Quản lý KTX',
        'ngay': Timestamp.fromDate(
            DateTime.parse(r['ngay'] as String)),
        'ngayString': r['ngay'],
        'thang': 'Tháng 6/2025',
        'thu': thuMap[r['ngay']],
        'trangThai': r['tt'],
        'gioVao': r['gio'],
        'ghiChu': '',
        'loai': 'ktx',
      });
    }
    print('✅ diem_danh (${records.length + ktxRecords.length} records)');
  }

  // ══════════════════════════════════════════
  // 10. BẢNG ĐIỂM
  // hocSinhId khớp hoc_sinh
  // giaoVienId khớp giao_vien (người nhập)
  // lopId khớp lop_hoc
  // ══════════════════════════════════════════
  static Future<void> _createGrades() async {
    // Định nghĩa điểm cho 4 HS, 5 môn, HK1
    final gradeData = [
      // hs_001 - An: học giỏi
      {
        'hs': 'hs_001', 'mon': 'Toán',
        'gvId': 'gv_001', 'tenGv': 'Nguyễn Thị Bình',
        'mieng': [8.0, 9.0, 7.0],
        '15p': [8.5, 9.0, 7.5, 8.0],
        '1tiet': [8.0, 8.5],
        'gk': 8.5, 'ck': 8.0, 'dtb': 8.3,
        'xepLoai': 'Giỏi', 'mau': '#FF6B00',
      },
      {
        'hs': 'hs_001', 'mon': 'Văn',
        'gvId': 'gv_002', 'tenGv': 'Trần Văn Dũng',
        'mieng': [7.0, 8.0, 7.5],
        '15p': [7.5, 8.0, 7.0],
        '1tiet': [7.5, 8.0],
        'gk': 7.5, 'ck': 8.0, 'dtb': 7.8,
        'xepLoai': 'Khá', 'mau': '#1A3C6E',
      },
      {
        'hs': 'hs_001', 'mon': 'Tiếng Anh',
        'gvId': 'gv_003', 'tenGv': 'Lê Thị D',
        'mieng': [9.0, 9.5, 8.5],
        '15p': [9.0, 9.5, 8.0, 9.0],
        '1tiet': [9.0, 9.5],
        'gk': 9.0, 'ck': 9.0, 'dtb': 9.1,
        'xepLoai': 'Giỏi', 'mau': '#16A34A',
      },
      {
        'hs': 'hs_001', 'mon': 'Vật lý',
        'gvId': 'gv_004', 'tenGv': 'Phạm Văn E',
        'mieng': [8.0, 8.5, 7.5],
        '15p': [8.0, 8.5, 7.0],
        '1tiet': [8.0, 8.5],
        'gk': 8.0, 'ck': 8.5, 'dtb': 8.2,
        'xepLoai': 'Giỏi', 'mau': '#7C3AED',
      },
      {
        'hs': 'hs_001', 'mon': 'Hóa học',
        'gvId': 'gv_005', 'tenGv': 'Ngô Thị F',
        'mieng': [7.0, 7.5, 8.0],
        '15p': [7.5, 7.0, 8.0],
        '1tiet': [7.5, 7.5],
        'gk': 7.5, 'ck': 7.5, 'dtb': 7.6,
        'xepLoai': 'Khá', 'mau': '#EA580C',
      },
      // hs_002 - B: học khá
      {
        'hs': 'hs_002', 'mon': 'Toán',
        'gvId': 'gv_001', 'tenGv': 'Nguyễn Thị Bình',
        'mieng': [7.0, 7.5, 6.5],
        '15p': [7.0, 7.5, 6.5, 7.0],
        '1tiet': [7.0, 7.5],
        'gk': 7.0, 'ck': 7.5, 'dtb': 7.2,
        'xepLoai': 'Khá', 'mau': '#FF6B00',
      },
      {
        'hs': 'hs_002', 'mon': 'Văn',
        'gvId': 'gv_002', 'tenGv': 'Trần Văn Dũng',
        'mieng': [8.0, 8.5, 7.5],
        '15p': [8.0, 8.5, 7.5],
        '1tiet': [8.0, 8.5],
        'gk': 8.0, 'ck': 8.5, 'dtb': 8.2,
        'xepLoai': 'Giỏi', 'mau': '#1A3C6E',
      },
      {
        'hs': 'hs_002', 'mon': 'Tiếng Anh',
        'gvId': 'gv_003', 'tenGv': 'Lê Thị D',
        'mieng': [7.5, 8.0, 7.0],
        '15p': [7.5, 8.0, 7.0],
        '1tiet': [7.5, 8.0],
        'gk': 7.5, 'ck': 7.5, 'dtb': 7.7,
        'xepLoai': 'Khá', 'mau': '#16A34A',
      },
      {
        'hs': 'hs_002', 'mon': 'Vật lý',
        'gvId': 'gv_004', 'tenGv': 'Phạm Văn E',
        'mieng': [6.5, 7.0, 6.0],
        '15p': [6.5, 7.0, 6.0],
        '1tiet': [6.5, 7.0],
        'gk': 6.5, 'ck': 7.0, 'dtb': 6.8,
        'xepLoai': 'Khá', 'mau': '#7C3AED',
      },
      {
        'hs': 'hs_002', 'mon': 'Hóa học',
        'gvId': 'gv_005', 'tenGv': 'Ngô Thị F',
        'mieng': [7.0, 7.5, 7.0],
        '15p': [7.0, 7.5, 7.0],
        '1tiet': [7.0, 7.5],
        'gk': 7.0, 'ck': 7.5, 'dtb': 7.2,
        'xepLoai': 'Khá', 'mau': '#EA580C',
      },
      // hs_003 - C: học trung bình
      {
        'hs': 'hs_003', 'mon': 'Toán',
        'gvId': 'gv_001', 'tenGv': 'Nguyễn Thị Bình',
        'mieng': [5.5, 6.0, 5.0],
        '15p': [5.5, 6.0, 5.0, 5.5],
        '1tiet': [5.5, 6.0],
        'gk': 5.5, 'ck': 6.0, 'dtb': 5.8,
        'xepLoai': 'Trung bình', 'mau': '#FF6B00',
      },
      {
        'hs': 'hs_003', 'mon': 'Văn',
        'gvId': 'gv_002', 'tenGv': 'Trần Văn Dũng',
        'mieng': [6.5, 7.0, 6.0],
        '15p': [6.5, 7.0, 6.0],
        '1tiet': [6.5, 7.0],
        'gk': 6.5, 'ck': 6.5, 'dtb': 6.6,
        'xepLoai': 'Khá', 'mau': '#1A3C6E',
      },
      {
        'hs': 'hs_003', 'mon': 'Tiếng Anh',
        'gvId': 'gv_003', 'tenGv': 'Lê Thị D',
        'mieng': [5.0, 5.5, 5.0],
        '15p': [5.0, 5.5, 5.0],
        '1tiet': [5.0, 5.5],
        'gk': 5.0, 'ck': 5.5, 'dtb': 5.2,
        'xepLoai': 'Trung bình', 'mau': '#16A34A',
      },
      {
        'hs': 'hs_003', 'mon': 'Vật lý',
        'gvId': 'gv_004', 'tenGv': 'Phạm Văn E',
        'mieng': [6.0, 6.5, 5.5],
        '15p': [6.0, 6.5, 5.5],
        '1tiet': [6.0, 6.5],
        'gk': 6.0, 'ck': 6.5, 'dtb': 6.2,
        'xepLoai': 'Khá', 'mau': '#7C3AED',
      },
      {
        'hs': 'hs_003', 'mon': 'Hóa học',
        'gvId': 'gv_005', 'tenGv': 'Ngô Thị F',
        'mieng': [5.5, 6.0, 5.0],
        '15p': [5.5, 6.0, 5.0],
        '1tiet': [5.5, 6.0],
        'gk': 5.5, 'ck': 6.0, 'dtb': 5.8,
        'xepLoai': 'Trung bình', 'mau': '#EA580C',
      },
      // hs_004 - D: học giỏi
      {
        'hs': 'hs_004', 'mon': 'Toán',
        'gvId': 'gv_001', 'tenGv': 'Nguyễn Thị Bình',
        'mieng': [9.0, 9.5, 8.5],
        '15p': [9.0, 9.5, 8.5, 9.0],
        '1tiet': [9.0, 9.5],
        'gk': 9.0, 'ck': 9.5, 'dtb': 9.2,
        'xepLoai': 'Giỏi', 'mau': '#FF6B00',
      },
      {
        'hs': 'hs_004', 'mon': 'Văn',
        'gvId': 'gv_002', 'tenGv': 'Trần Văn Dũng',
        'mieng': [8.5, 9.0, 8.0],
        '15p': [8.5, 9.0, 8.0],
        '1tiet': [8.5, 9.0],
        'gk': 8.5, 'ck': 9.0, 'dtb': 8.7,
        'xepLoai': 'Giỏi', 'mau': '#1A3C6E',
      },
      {
        'hs': 'hs_004', 'mon': 'Tiếng Anh',
        'gvId': 'gv_003', 'tenGv': 'Lê Thị D',
        'mieng': [8.0, 8.5, 7.5],
        '15p': [8.0, 8.5, 7.5],
        '1tiet': [8.0, 8.5],
        'gk': 8.0, 'ck': 8.5, 'dtb': 8.2,
        'xepLoai': 'Giỏi', 'mau': '#16A34A',
      },
      {
        'hs': 'hs_004', 'mon': 'Vật lý',
        'gvId': 'gv_004', 'tenGv': 'Phạm Văn E',
        'mieng': [9.5, 10.0, 9.0],
        '15p': [9.5, 10.0, 9.0],
        '1tiet': [9.5, 10.0],
        'gk': 9.5, 'ck': 10.0, 'dtb': 9.6,
        'xepLoai': 'Giỏi', 'mau': '#7C3AED',
      },
      {
        'hs': 'hs_004', 'mon': 'Hóa học',
        'gvId': 'gv_005', 'tenGv': 'Ngô Thị F',
        'mieng': [8.5, 9.0, 8.0],
        '15p': [8.5, 9.0, 8.0],
        '1tiet': [8.5, 9.0],
        'gk': 8.5, 'ck': 9.0, 'dtb': 8.7,
        'xepLoai': 'Giỏi', 'mau': '#EA580C',
      },
    ];

    int count = 0;
    for (final g in gradeData) {
      final id = 'bd_${g['hs']}_HK1_${g['mon']}'
          .replaceAll(' ', '_');
      await _db.collection('bang_diem').doc(id).set({
        'bangDiemId': id,
        'hocSinhId': g['hs'],
        'lopId': 'lop_11A1',
        'monHoc': g['mon'],
        'giaoVienId': g['gvId'],
        'tenGiaoVien': g['tenGv'],
        'hocKy': 'HK1',
        'namHoc': '2024-2025',
        'diemMieng': g['mieng'],
        'diem15Phut': g['15p'],
        'diem1Tiet': g['1tiet'],
        'diemGiuaKy': g['gk'],
        'diemCuoiKy': g['ck'],
        'diemTrungBinh': g['dtb'],
        'xepLoai': g['xepLoai'],
        'mauSac': g['mau'],
        'capNhatLuc': Timestamp.now(),
      });
      count++;
    }

    // Tổng kết HK1 cho 4 HS
    final summaries = [
      {
        'hs': 'hs_001',
        'dtb': 8.2, 'xepLoai': 'Giỏi',
        'hanhKiem': 'Tốt', 'hang': 3, 'siSo': 4,
      },
      {
        'hs': 'hs_002',
        'dtb': 7.4, 'xepLoai': 'Khá',
        'hanhKiem': 'Tốt', 'hang': 2, 'siSo': 4,
      },
      {
        'hs': 'hs_003',
        'dtb': 5.9, 'xepLoai': 'Trung bình',
        'hanhKiem': 'Khá', 'hang': 4, 'siSo': 4,
      },
      {
        'hs': 'hs_004',
        'dtb': 9.1, 'xepLoai': 'Giỏi',
        'hanhKiem': 'Tốt', 'hang': 1, 'siSo': 4,
      },
    ];

    for (final s in summaries) {
      await _db.collection('tong_ket_hk')
          .doc('tk_${s['hs']}_HK1_2024')
          .set({
        'tongKetId': 'tk_${s['hs']}_HK1_2024',
        'hocSinhId': s['hs'],
        'lopId': 'lop_11A1',
        'hocKy': 'HK1',
        'namHoc': '2024-2025',
        'dtbCaHocKy': s['dtb'],
        'xepLoaiHocLuc': s['xepLoai'],
        'xepLoaiHanhKiem': s['hanhKiem'],
        'thuHangLop': s['hang'],
        'siSoLop': s['siSo'],
        'capNhatLuc': Timestamp.now(),
      });
    }

    print('✅ bang_diem ($count records) + tong_ket_hk');
  }

  // ══════════════════════════════════════════
  // 11. BÀI TẬP
  // lopId khớp lop_hoc
  // giaoVienId khớp giao_vien
  // ══════════════════════════════════════════
  static Future<void> _createHomework() async {
    final homeworks = [
      {
        'baiTapId': 'bt_001',
        'tieuDe': 'Chương 3: Phương trình bậc 2',
        'moTa': 'Hoàn thành bài tập trang 45-48 SGK Toán 11',
        'monHoc': 'Toán',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        // Khớp gv_001
        'giaoVienId': 'gv_001',
        'tenGiaoVien': 'Nguyễn Thị Bình',
        'hanNop': Timestamp.fromDate(DateTime(2025, 6, 15)),
        'hanNopString': '15/06/2025',
        'trangThai': 'chua_nop',
        'mauSac': '#FF6B00',
        'taoLuc': Timestamp.now(),
      },
      {
        'baiTapId': 'bt_002',
        'tieuDe': 'Soạn bài: Chí Phèo - Nam Cao',
        'moTa': 'Đọc và soạn bài Chí Phèo, trả lời câu hỏi SGK trang 34',
        'monHoc': 'Văn',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        // Khớp gv_002
        'giaoVienId': 'gv_002',
        'tenGiaoVien': 'Trần Văn Dũng',
        'hanNop': Timestamp.fromDate(DateTime(2025, 6, 3)),
        'hanNopString': '03/06/2025',
        'trangThai': 'da_nop',
        'mauSac': '#1A3C6E',
        'taoLuc': Timestamp.now(),
      },
      {
        'baiTapId': 'bt_003',
        'tieuDe': 'Unit 10 - Grammar & Vocabulary',
        'moTa': 'Làm bài tập Unit 10 workbook trang 65-67',
        'monHoc': 'Tiếng Anh',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        // Khớp gv_003
        'giaoVienId': 'gv_003',
        'tenGiaoVien': 'Lê Thị D',
        'hanNop': Timestamp.fromDate(DateTime(2025, 5, 28)),
        'hanNopString': '28/05/2025',
        'trangThai': 'qua_han',
        'mauSac': '#16A34A',
        'taoLuc': Timestamp.now(),
      },
      {
        'baiTapId': 'bt_004',
        'tieuDe': 'Dao động điều hòa - Bài tập 1-10',
        'moTa': 'Giải các bài tập từ 1 đến 10 trang 52 SGK Vật lý',
        'monHoc': 'Vật lý',
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        // Khớp gv_004
        'giaoVienId': 'gv_004',
        'tenGiaoVien': 'Phạm Văn E',
        'hanNop': Timestamp.fromDate(DateTime(2025, 6, 18)),
        'hanNopString': '18/06/2025',
        'trangThai': 'chua_nop',
        'mauSac': '#7C3AED',
        'taoLuc': Timestamp.now(),
      },
    ];

    for (final b in homeworks) {
      await _db.collection('bai_tap')
          .doc(b['baiTapId'] as String)
          .set(b);
    }
    print('✅ bai_tap (${homeworks.length} bài)');
  }

  // ══════════════════════════════════════════
  // 12. KÝ TÚC XÁ
  // hocSinhId: chỉ hs isNoiTru=true
  // ══════════════════════════════════════════
  static Future<void> _createDormitory() async {
    // hs_001 và hs_003 là nội trú
    final dorms = [
      {
        'ktxId': 'ktx_hs_001',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
        'soPhong': '203',
        'tang': '2',
        'day': 'A',
        'khu': 'Khu Nam',
        'namHoc': '2024-2025',
        'banPhong': [
          {
            'hocSinhId': 'hs_003',
            'hoTen': 'Lê Văn C',
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
          },
          {
            'hocSinhId': 'hs_other_1',
            'hoTen': 'Trần Minh',
            'lopId': 'lop_11A2',
            'tenLop': '11A2',
          },
          {
            'hocSinhId': 'hs_other_2',
            'hoTen': 'Phạm Tuấn',
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
          },
        ],
        'quanLyKtx': 'Nguyễn Văn X',
        'sdtQuanLy': '0243998567',
        'isActive': true,
      },
      {
        'ktxId': 'ktx_hs003',
        'hocSinhId': 'hs_003',
        'tenHocSinh': 'Lê Văn C',
        'soPhong': '203',
        'tang': '2',
        'day': 'A',
        'khu': 'Khu Nam',
        'namHoc': '2024-2025',
        'banPhong': [
          {
            'hocSinhId': 'hs_001',
            'hoTen': 'Nguyễn Văn An',
            'lopId': 'lop_11A1',
            'tenLop': '11A1',
          },
          {
            'hocSinhId': 'hs_other_1',
            'hoTen': 'Trần Minh',
            'lopId': 'lop_11A2',
            'tenLop': '11A2',
          },
        ],
        'quanLyKtx': 'Nguyễn Văn X',
        'sdtQuanLy': '0243998567',
        'isActive': true,
      },
    ];

    for (final d in dorms) {
      await _db.collection('ky_tuc_xa')
          .doc(d['ktxId'] as String)
          .set(d);
    }

    // Đơn xin phép về nhà
    await _db.collection('xin_phep_ktx')
        .doc('xp_001')
        .set({
      'xinPhepId': 'xp_001',
      'hocSinhId': 'hs_001',
      'tenHocSinh': 'Nguyễn Văn An',
      'tuNgay': Timestamp.fromDate(DateTime(2025, 6, 7)),
      'denNgay': Timestamp.fromDate(DateTime(2025, 6, 9)),
      'tuNgayString': '07/06/2025',
      'denNgayString': '09/06/2025',
      'lyDo': 'Về nhà cuối tuần',
      'trangThai': 'da_duyet',
      'duyetBoi': 'Nguyễn Văn X',
      'taoLuc': Timestamp.now(),
    });

    print('✅ ky_tuc_xa');
  }

  // ══════════════════════════════════════════
  // 13. TIN TỨC
  // ══════════════════════════════════════════
  static Future<void> _createNews() async {
    final news = [
      {
        'tinTucId': 'tt_001',
        'tieuDe': 'Lịch thi học kỳ 1 năm học 2024-2025',
        'noiDung': 'Nhà trường thông báo lịch thi chính thức học kỳ 1. Kỳ thi bắt đầu từ ngày 15/12/2024.',
        'danhMuc': 'thong_bao',
        'doiTuong': ['hoc_sinh', 'phu_huynh', 'giao_vien'],
        'danhSachLopId': [],
        'ghim': true,
        'anhThumbnail': 'https://fpt.edu.vn/Content/images/assets/FE-da-dang-nganh-nghe.jpg',
        'nguoiDang': 'Ban Giám Hiệu',
        'nguoiDangId': 'admin_001',
        'trangThai': 'da_dang',
        'luotXem': 342,
        'ngayDang': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'taoLuc': Timestamp.now(),
      },
      {
        'tinTucId': 'tt_002',
        'tieuDe': 'Kết quả xét khen thưởng học kỳ 1',
        'noiDung': 'Nhà trường công bố danh sách học sinh được khen thưởng HK1 năm học 2024-2025.',
        'danhMuc': 'thong_bao',
        'doiTuong': ['hoc_sinh', 'phu_huynh'],
        'danhSachLopId': [],
        'ghim': false,
        'anhThumbnail': 'https://fschool.fpt.edu.vn/wp-content/uploads/1-38.jpg',
        'nguoiDang': 'Phòng Học vụ',
        'nguoiDangId': 'admin_001',
        'trangThai': 'da_dang',
        'luotXem': 215,
        'ngayDang': Timestamp.fromDate(DateTime(2025, 5, 28)),
        'taoLuc': Timestamp.now(),
      },
      {
        'tinTucId': 'tt_003',
        'tieuDe': 'FPT Schools tổ chức ngày hội STEM 2025',
        'noiDung': 'Ngày hội STEM 2025 sẽ được tổ chức ngày 20/06/2025 tại sân trường.',
        'danhMuc': 'su_kien',
        'doiTuong': ['hoc_sinh', 'phu_huynh', 'giao_vien'],
        'danhSachLopId': [],
        'ghim': false,
        'anhThumbnail': 'https://fschool.fpt.edu.vn/wp-content/uploads/STEM-1.jpg',
        'nguoiDang': 'Ban Tổ chức',
        'nguoiDangId': 'admin_001',
        'trangThai': 'da_dang',
        'luotXem': 189,
        'ngayDang': Timestamp.fromDate(DateTime(2025, 6, 3)),
        'taoLuc': Timestamp.now(),
      },
      {
        'tinTucId': 'tt_004',
        'tieuDe': 'Họp phụ huynh cuối học kỳ 1',
        'noiDung': 'Nhà trường kính mời phụ huynh tham dự buổi họp tổng kết HK1 ngày 20/12/2024.',
        'danhMuc': 'thong_bao',
        // Chỉ phụ huynh
        'doiTuong': ['phu_huynh'],
        'danhSachLopId': [],
        'ghim': false,
        'anhThumbnail': 'https://fschool.fpt.edu.vn/wp-content/uploads/z4027733470123_469850914d3393b4a2e5d7a6e1f0e4b8.jpg',
        'nguoiDang': 'Phòng Học vụ',
        'nguoiDangId': 'admin_001',
        'trangThai': 'da_dang',
        'luotXem': 298,
        'ngayDang': Timestamp.fromDate(DateTime(2024, 12, 10)),
        'taoLuc': Timestamp.now(),
      },
      {
        'tinTucId': 'tt_005',
        'tieuDe': 'Thông báo nộp kế hoạch giảng dạy HK2',
        'noiDung': 'Tất cả giáo viên nộp kế hoạch giảng dạy HK2 trước ngày 10/01/2025.',
        'danhMuc': 'thong_bao',
        // Chỉ giáo viên
        'doiTuong': ['giao_vien'],
        'danhSachLopId': [],
        'ghim': true,
        'anhThumbnail': 'https://fschool.fpt.edu.vn/wp-content/uploads/2-24.jpg',
        'nguoiDang': 'Ban Giám Hiệu',
        'nguoiDangId': 'admin_001',
        'trangThai': 'da_dang',
        'luotXem': 48,
        'ngayDang': Timestamp.fromDate(DateTime(2025, 1, 2)),
        'taoLuc': Timestamp.now(),
      },
    ];

    for (final t in news) {
      await _db.collection('tin_tuc')
          .doc(t['tinTucId'] as String)
          .set(t);
    }
    print('✅ tin_tuc (${news.length} tin)');
  }

  // ══════════════════════════════════════════
  // 14. THÔNG BÁO PUSH
  // userId khớp users
  // thamChieuId khớp collection tương ứng
  // ══════════════════════════════════════════
  static Future<void> _createNotifications() async {
    final notifs = [
      // Cho học sinh hs_001
      {
        'thongBaoId': 'tb_001',
        'userId': 'hs_001',
        'tieuDe': 'Lịch thi học kỳ 1',
        'noiDung': 'Lịch thi chính thức HK1 đã được công bố',
        'loai': 'thong_bao',
        'thamChieuId': 'tt_001',
        'thamChieuCollection': 'tin_tuc',
        'daDoc': false,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 1)),
      },
      {
        'thongBaoId': 'tb_002',
        'userId': 'hs_001',
        'tieuDe': 'Bài tập Tiếng Anh quá hạn',
        'noiDung': 'Bài tập Unit 10 đã quá hạn nộp',
        'loai': 'bai_tap',
        // Khớp bt_003
        'thamChieuId': 'bt_003',
        'thamChieuCollection': 'bai_tap',
        'daDoc': false,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 5, 29)),
      },
      // Cho phụ huynh ph_001
      {
        'thongBaoId': 'tb_003',
        'userId': 'ph_001',
        'tieuDe': 'An vắng học hôm nay',
        'noiDung': 'Nguyễn Văn An vắng không phép ngày 10/06',
        'loai': 'diem_danh',
        // Khớp diem_danh
        'thamChieuId': 'dd_hs_001_2025-06-10',
        'thamChieuCollection': 'diem_danh',
        'daDoc': false,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 10)),
      },
      {
        'thongBaoId': 'tb_004',
        'userId': 'ph_001',
        'tieuDe': 'Nhắc đóng phí KTX',
        'noiDung': 'Phí ký túc xá tháng 1/2025 sắp đến hạn',
        'loai': 'hoc_phi',
        // Khớp hoc_phi
        'thamChieuId': 'hp_002',
        'thamChieuCollection': 'hoc_phi',
        'daDoc': true,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 1, 3)),
      },
      // Cho giáo viên gv_001
      {
        'thongBaoId': 'tb_005',
        'userId': 'gv_001',
        'tieuDe': 'Nhắc chấm điểm danh',
        'noiDung': 'Lớp 11A2 chưa được chấm điểm danh hôm nay',
        'loai': 'diem_danh',
        'thamChieuId': '',
        'thamChieuCollection': 'diem_danh',
        'daDoc': false,
        'taoLuc': Timestamp.now(),
      },
      {
        'thongBaoId': 'tb_006',
        'userId': 'gv_001',
        'tieuDe': 'Thông báo nộp KHGD',
        'noiDung': 'Nhắc nhở: Nộp kế hoạch giảng dạy HK2 trước 10/01',
        'loai': 'thong_bao',
        'thamChieuId': 'tt_005',
        'thamChieuCollection': 'tin_tuc',
        'daDoc': false,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 1, 2)),
      },
      // Cho admin
      {
        'thongBaoId': 'tb_007',
        'userId': 'admin_001',
        'tieuDe': 'Tài khoản mới chờ duyệt',
        'noiDung': '3 tài khoản mới đăng ký cần được kích hoạt',
        'loai': 'tai_khoan',
        'thamChieuId': '',
        'thamChieuCollection': 'users',
        'daDoc': false,
        'taoLuc': Timestamp.now(),
      },
    ];

    for (final t in notifs) {
      await _db.collection('thong_bao_push')
          .doc(t['thongBaoId'] as String)
          .set(t);
    }
    print('✅ thong_bao_push (${notifs.length} thông báo)');
  }

  // ══════════════════════════════════════════
  // 15. HỌC PHÍ
  // hocSinhId: chỉ hs có phuHuynhId
  // ══════════════════════════════════════════
  static Future<void> _createTuitionFees() async {
    final fees = [
      // Học phí HK2 - hs_001 - đã đóng
      {
        'hocPhiId': 'hp_001',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
        'phuHuynhId': 'ph_001',
        'lopId': 'lop_11A1',
        'loai': 'hoc_phi',
        'tenKhoan': 'Học phí HK2 2024-2025',
        'soTien': 6000000,
        'donViTien': 'VND',
        'hocKy': 'HK2',
        'thang': '',
        'namHoc': '2024-2025',
        'hanDong': Timestamp.fromDate(DateTime(2025, 1, 15)),
        'hanDongString': '15/01/2025',
        'ngayDong': Timestamp.fromDate(DateTime(2025, 1, 10)),
        'trangThai': 'da_dong',
        'phuongThuc': 'chuyen_khoan',
        'maBienLai': 'BL2025001',
      },
      // Phí KTX T1 - hs_001 - chưa đóng
      {
        'hocPhiId': 'hp_002',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
        'phuHuynhId': 'ph_001',
        'lopId': 'lop_11A1',
        'loai': 'ktx',
        'tenKhoan': 'Phí ký túc xá T1/2025',
        'soTien': 1500000,
        'donViTien': 'VND',
        'hocKy': '',
        'thang': 'T1/2025',
        'namHoc': '2024-2025',
        'hanDong': Timestamp.fromDate(DateTime(2025, 1, 5)),
        'hanDongString': '05/01/2025',
        'ngayDong': null,
        'trangThai': 'chua_dong',
        'phuongThuc': '',
        'maBienLai': '',
      },
      // Phí xe bus T1 - hs_001 - quá hạn
      {
        'hocPhiId': 'hp_003',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
        'phuHuynhId': 'ph_001',
        'lopId': 'lop_11A1',
        'loai': 'xe_bus',
        'tenKhoan': 'Phí xe buýt T1/2025',
        'soTien': 1000000,
        'donViTien': 'VND',
        'hocKy': '',
        'thang': 'T1/2025',
        'namHoc': '2024-2025',
        'hanDong': Timestamp.fromDate(DateTime(2025, 1, 5)),
        'hanDongString': '05/01/2025',
        'ngayDong': null,
        'trangThai': 'qua_han',
        'phuongThuc': '',
        'maBienLai': '',
      },
      // Lịch sử - KTX T12 - hs_001 - đã đóng
      {
        'hocPhiId': 'hp_004',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
        'phuHuynhId': 'ph_001',
        'lopId': 'lop_11A1',
        'loai': 'ktx',
        'tenKhoan': 'Phí ký túc xá T12/2024',
        'soTien': 1500000,
        'donViTien': 'VND',
        'hocKy': '',
        'thang': 'T12/2024',
        'namHoc': '2024-2025',
        'hanDong': Timestamp.fromDate(DateTime(2024, 12, 5)),
        'hanDongString': '05/12/2024',
        'ngayDong': Timestamp.fromDate(DateTime(2024, 12, 3)),
        'trangThai': 'da_dong',
        'phuongThuc': 'tien_mat',
        'maBienLai': 'BL2024120',
      },
      // Học phí HK2 - hs_002 - đã đóng
      {
        'hocPhiId': 'hp_005',
        'hocSinhId': 'hs_002',
        'tenHocSinh': 'Trần Thị B',
        'phuHuynhId': 'ph_002',
        'lopId': 'lop_11A1',
        'loai': 'hoc_phi',
        'tenKhoan': 'Học phí HK2 2024-2025',
        'soTien': 6000000,
        'donViTien': 'VND',
        'hocKy': 'HK2',
        'thang': '',
        'namHoc': '2024-2025',
        'hanDong': Timestamp.fromDate(DateTime(2025, 1, 15)),
        'hanDongString': '15/01/2025',
        'ngayDong': Timestamp.fromDate(DateTime(2025, 1, 12)),
        'trangThai': 'da_dong',
        'phuongThuc': 'chuyen_khoan',
        'maBienLai': 'BL2025002',
      },
    ];

    for (final f in fees) {
      await _db.collection('hoc_phi')
          .doc(f['hocPhiId'] as String)
          .set(f);
    }
    print('✅ hoc_phi (${fees.length} khoản)');
  }

  // ══════════════════════════════════════════
  // 16. LIÊN LẠC
  // khớp với giao_vien và lop_hoc
  // ══════════════════════════════════════════
  static Future<void> _createContacts() async {
    final contacts = [
      {
        'lienLacId': 'll_001',
        // Khớp gv_001
        'userId': 'gv_001',
        'hoTen': 'Nguyễn Thị Bình',
        'chucVu': 'Giáo viên chủ nhiệm',
        'monHoc': 'Toán',
        // Khớp lop_11A1
        'lopPhuTrach': ['lop_11A1', 'lop_11A2'],
        'soDienThoai': '0901112222',
        'email': 'binh.nt@fpt.edu.vn',
        'nhom': 'gvcn',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
      },
      {
        'lienLacId': 'll_002',
        'userId': 'admin_001',
        'hoTen': 'PGS.TS Lê Văn Minh',
        'chucVu': 'Hiệu trưởng',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998560',
        'email': 'hieuttruong@fpt.edu.vn',
        'nhom': 'bgh',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
      },
      {
        'lienLacId': 'll_003',
        'userId': '',
        'hoTen': 'TS Phạm Thị Thu',
        'chucVu': 'Hiệu phó Học vụ',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998561',
        'email': 'hocvu@fpt.edu.vn',
        'nhom': 'bgh',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
      },
      {
        'lienLacId': 'll_004',
        'userId': '',
        'hoTen': 'Phòng Học vụ',
        'chucVu': 'Phòng ban',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998578',
        'email': 'hocvu@fpt.edu.vn',
        'nhom': 'phong_ban',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
      },
      {
        'lienLacId': 'll_005',
        'userId': '',
        'hoTen': 'Phòng Y tế',
        'chucVu': 'Phòng ban',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998579',
        'email': 'yte@fpt.edu.vn',
        'nhom': 'phong_ban',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
      },
      {
        'lienLacId': 'll_006',
        'userId': '',
        'hoTen': 'Quản lý Ký túc xá',
        'chucVu': 'Phòng ban',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998580',
        'email': 'ktx@fpt.edu.vn',
        'nhom': 'phong_ban',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
      },
    ];

    for (final c in contacts) {
      await _db.collection('lien_lac')
          .doc(c['lienLacId'] as String)
          .set(c);
    }
    print('✅ lien_lac (${contacts.length} liên lạc)');
  }

  // ══════════════════════════════════════════
  // 17. TIN NHẮN
  // participants khớp with users
  // ══════════════════════════════════════════
  static Future<void> _createMessages() async {
    // Chat giữa ph_001 và gv_001 (GVCN lớp An)
    const chatId1 = 'chat_ph001_gv001';
    await _db.collection('cuoc_tro_chuyen')
        .doc(chatId1)
        .set({
      'chatId': chatId1,
      // Khớp users
      'thanhVien': ['ph_001', 'gv_001'],
      'tenThanhVien': {
        'ph_001': 'Nguyễn Thị Lan',
        'gv_001': 'Nguyễn Thị Bình',
      },
      'vaiTroThanhVien': {
        'ph_001': 'phu_huynh',
        'gv_001': 'giao_vien',
      },
      'tinNhanCuoi': 'Dạ cô, An bị sốt ạ...',
      'thoiGianTinCuoi': Timestamp.fromDate(
          DateTime(2025, 6, 10, 8, 45)),
      'nguoiGuiCuoi': 'ph_001',
      'soTinChuaDoc': {'ph_001': 0, 'gv_001': 1},
      'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 10)),
    });

    final msgs1 = [
      {
        'tinNhanId': 'tn_001',
        'nguoiGuiId': 'gv_001',
        'tenNguoiGui': 'Nguyễn Thị Bình',
        'vaiTro': 'giao_vien',
        'noiDung': 'Chào anh/chị, An hôm nay vắng tiết 1-2 Toán. Anh/chị có biết lý do không ạ?',
        'loai': 'van_ban',
        'daDoc': true,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 10, 8, 30)),
      },
      {
        'tinNhanId': 'tn_002',
        'nguoiGuiId': 'ph_001',
        'tenNguoiGui': 'Nguyễn Thị Lan',
        'vaiTro': 'phu_huynh',
        'noiDung': 'Dạ cô, An bị sốt ạ. Gia đình xin phép cho An nghỉ hôm nay.',
        'loai': 'van_ban',
        'daDoc': false,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 10, 8, 45)),
      },
      {
        'tinNhanId': 'tn_003',
        'nguoiGuiId': 'gv_001',
        'tenNguoiGui': 'Nguyễn Thị Bình',
        'vaiTro': 'giao_vien',
        'noiDung': 'Dạ cô hiểu rồi. Anh/chị nhớ làm đơn xin phép gửi phòng học vụ nhé. Chúc An mau khỏe!',
        'loai': 'van_ban',
        'daDoc': false,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 10, 9, 0)),
      },
    ];

    for (final m in msgs1) {
      await _db.collection('cuoc_tro_chuyen')
          .doc(chatId1)
          .collection('tin_nhan')
          .doc(m['tinNhanId'] as String)
          .set(m);
    }

    // Chat giữa ph_002 và gv_002
    const chatId2 = 'chat_ph002_gv002';
    await _db.collection('cuoc_tro_chuyen')
        .doc(chatId2)
        .set({
      'chatId': chatId2,
      'thanhVien': ['ph_002', 'gv_002'],
      'tenThanhVien': {
        'ph_002': 'Trần Văn Hùng',
        'gv_002': 'Trần Văn Dũng',
      },
      'vaiTroThanhVien': {
        'ph_002': 'phu_huynh',
        'gv_002': 'giao_vien',
      },
      'tinNhanCuoi': 'Dạ vâng, cảm ơn thầy ạ',
      'thoiGianTinCuoi': Timestamp.fromDate(
          DateTime(2025, 6, 9, 15, 30)),
      'nguoiGuiCuoi': 'ph_002',
      'soTinChuaDoc': {'ph_002': 0, 'gv_002': 0},
      'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 9)),
    });

    final msgs2 = [
      {
        'tinNhanId': 'tn_004',
        'nguoiGuiId': 'gv_002',
        'tenNguoiGui': 'Trần Văn Dũng',
        'vaiTro': 'giao_vien',
        'noiDung': 'Chào anh Hùng, em B đang có tiến bộ rõ rệt trong môn Văn. Anh hãy khuyến khích em tiếp tục nhé!',
        'loai': 'van_ban',
        'daDoc': true,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 9, 15, 20)),
      },
      {
        'tinNhanId': 'tn_005',
        'nguoiGuiId': 'ph_002',
        'tenNguoiGui': 'Trần Văn Hùng',
        'vaiTro': 'phu_huynh',
        'noiDung': 'Dạ vâng, cảm ơn thầy ạ. Gia đình sẽ tiếp tục hỗ trợ con.',
        'loai': 'van_ban',
        'daDoc': true,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 9, 15, 30)),
      },
    ];

    for (final m in msgs2) {
      await _db.collection('cuoc_tro_chuyen')
          .doc(chatId2)
          .collection('tin_nhan')
          .doc(m['tinNhanId'] as String)
          .set(m);
    }

    print('✅ tin_nhan (${msgs1.length + msgs2.length} tin nhắn)');
  }
}
