import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSeeder {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seedAll() async {
    print('🚀 Bắt đầu tạo database...');
    await _createUsers();
    await _createStudents();
    await _createGuardians();
    await _createClasses();
    await _createTimeTable();
    await _createAttendance();
    await _createGrades();
    await _createHomework();
    await _createDormitory();
    await _createNews();
    await _createNotifications();
    await _createTuitionFees();
    await _createContacts();
    await _createMessages();
    print('✅ Tạo database hoàn tất!');
  }

  // ══════════════════════════════════════════
  // COLLECTION: users
  // ══════════════════════════════════════════
  static Future<void> _createUsers() async {
    final users = [
      // Học sinh
      {
        'uid': 'hs_001',
        'email': 'an.nv@fpt.edu.vn',
        'hoTen': 'Nguyễn Văn An',
        'vaiTro': 'hoc_sinh', // hoc_sinh | phu_huynh
        'anhDaiDien': '',
        'soDienThoai': '0901234567',
        'isActive': true,
        'taoLuc': Timestamp.now(),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      // Phụ huynh
      {
        'uid': 'ph_001',
        'email': 'lan.nt@gmail.com',
        'hoTen': 'Nguyễn Thị Lan',
        'vaiTro': 'phu_huynh',
        'anhDaiDien': '',
        'soDienThoai': '0909998888',
        'isActive': true,
        'taoLuc': Timestamp.now(),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
      {
        'uid': 'hs_002',
        'email': 'bao.nt@fpt.edu.vn',
        'hoTen': 'Nguyễn Thị Bảo',
        'vaiTro': 'hoc_sinh',
        'anhDaiDien': '',
        'soDienThoai': '0901234568',
        'isActive': true,
        'taoLuc': Timestamp.now(),
        'dangNhapLanCuoi': Timestamp.now(),
        'fcmToken': '',
      },
    ];

    for (final u in users) {
      await _db.collection('users')
          .doc(u['uid'] as String)
          .set(u);
    }
    print('✅ users');
  }

  // ══════════════════════════════════════════
  // COLLECTION: hoc_sinh
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
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'khoiLop': '11',
        'truong': 'THPT FPT Đà Nẵng',
        'namHoc': '2024-2025',
        'diaChi': '123 Nguyễn Văn Linh, Đà Nẵng',
        'nhomMau': 'B+',
        'ngayNhapHoc': Timestamp.fromDate(DateTime(2022, 9, 5)),
        'phuHuynhId': 'ph_001',
        'isNoiTru': true,
        'isActive': true,
        'anhDaiDien': '',
      },
      {
        'hocSinhId': 'hs_002',
        'userId': 'hs_002',
        'hoTen': 'Nguyễn Thị Bảo',
        'maHocSinh': 'HS002',
        'ngaySinh': Timestamp.fromDate(DateTime(2010, 7, 22)),
        'gioiTinh': 'Nữ',
        'lopId': 'lop_8B',
        'tenLop': '8B',
        'khoiLop': '8',
        'truong': 'THCS FPT Đà Nẵng',
        'namHoc': '2024-2025',
        'diaChi': '123 Nguyễn Văn Linh, Đà Nẵng',
        'nhomMau': 'A+',
        'ngayNhapHoc': Timestamp.fromDate(DateTime(2023, 9, 5)),
        'phuHuynhId': 'ph_001',
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
    print('✅ hoc_sinh');
  }

  // ══════════════════════════════════════════
  // COLLECTION: phu_huynh
  // ══════════════════════════════════════════
  static Future<void> _createGuardians() async {
    await _db.collection('phu_huynh').doc('ph_001').set({
      'phuHuynhId': 'ph_001',
      'userId': 'ph_001',
      'hoTen': 'Nguyễn Thị Lan',
      'quanHe': 'Mẹ',
      'danhSachConId': ['hs_001', 'hs_002'],
      'ngheNghiep': 'Giáo viên',
      'soDienThoai': '0909998888',
      'soDienThoaiPhu': '0909998889',
      'email': 'lan.nt@gmail.com',
      'diaChi': '123 Nguyễn Văn Linh, Đà Nẵng',
      'isActive': true,
    });
    print('✅ phu_huynh');
  }

  // ══════════════════════════════════════════
  // COLLECTION: lop_hoc
  // ══════════════════════════════════════════
  static Future<void> _createClasses() async {
    final classes = [
      {
        'lopId': 'lop_11A1',
        'tenLop': '11A1',
        'khoiLop': '11',
        'giaoVienChuNhiem': 'Nguyễn Thị Bình',
        'giaoVienChuNhiemId': 'gv_001',
        'truong': 'THPT FPT Đà Nẵng',
        'namHoc': '2024-2025',
        'siSo': 42,
        'phong': 'P.101',
        'danhSachHocSinhId': ['hs_001'],
      },
      {
        'lopId': 'lop_8B',
        'tenLop': '8B',
        'khoiLop': '8',
        'giaoVienChuNhiem': 'Trần Văn Dũng',
        'giaoVienChuNhiemId': 'gv_002',
        'truong': 'THCS FPT Đà Nẵng',
        'namHoc': '2024-2025',
        'siSo': 38,
        'phong': 'P.205',
        'danhSachHocSinhId': ['hs_002'],
      },
    ];

    for (final c in classes) {
      await _db.collection('lop_hoc')
          .doc(c['lopId'] as String)
          .set(c);
    }
    print('✅ lop_hoc');
  }

  // ══════════════════════════════════════════
  // COLLECTION: thoi_khoa_bieu
  // ══════════════════════════════════════════
  static Future<void> _createTimeTable() async {
    // TKB cho lớp 11A1
    final tkbRef = _db
        .collection('thoi_khoa_bieu')
        .doc('tkb_11A1_2024_2025');

    await tkbRef.set({
      'tkbId': 'tkb_11A1_2024_2025',
      'lopId': 'lop_11A1',
      'tenLop': '11A1',
      'namHoc': '2024-2025',
      'hocKy': '1',
      'capNhatLuc': Timestamp.now(),
    });

    // Subcollection: tiet_hoc
    final periods = [
      // Thứ 2
      {
        'tietId': 't2_1',
        'thu': 'Thứ 2',
        'thuSo': 2,
        'tietSo': '1-2',
        'monHoc': 'Toán',
        'giaoVien': 'Nguyễn Thị Bình',
        'giaoVienId': 'gv_001',
        'phong': 'P.101',
        'gioVao': '07:00',
        'gioRa': '08:30',
        'mauSac': '#FF6B00',
      },
      {
        'tietId': 't2_2',
        'thu': 'Thứ 2',
        'thuSo': 2,
        'tietSo': '3-4',
        'monHoc': 'Văn',
        'giaoVien': 'Trần Văn C',
        'giaoVienId': 'gv_003',
        'phong': 'P.202',
        'gioVao': '08:45',
        'gioRa': '10:15',
        'mauSac': '#1A3C6E',
      },
      {
        'tietId': 't2_3',
        'thu': 'Thứ 2',
        'thuSo': 2,
        'tietSo': '5',
        'monHoc': 'Tiếng Anh',
        'giaoVien': 'Lê Thị D',
        'giaoVienId': 'gv_004',
        'phong': 'P.103',
        'gioVao': '10:30',
        'gioRa': '11:15',
        'mauSac': '#16A34A',
      },
      // Thứ 3
      {
        'tietId': 't3_1',
        'thu': 'Thứ 3',
        'thuSo': 3,
        'tietSo': '1-2',
        'monHoc': 'Vật lý',
        'giaoVien': 'Phạm Văn E',
        'giaoVienId': 'gv_005',
        'phong': 'P.301',
        'gioVao': '07:00',
        'gioRa': '08:30',
        'mauSac': '#7C3AED',
      },
      {
        'tietId': 't3_2',
        'thu': 'Thứ 3',
        'thuSo': 3,
        'tietSo': '3-4',
        'monHoc': 'Hóa học',
        'giaoVien': 'Ngô Thị F',
        'giaoVienId': 'gv_006',
        'phong': 'P.302',
        'gioVao': '08:45',
        'gioRa': '10:15',
        'mauSac': '#EA580C',
      },
      // Thứ 4
      {
        'tietId': 't4_1',
        'thu': 'Thứ 4',
        'thuSo': 4,
        'tietSo': '1-2',
        'monHoc': 'Toán',
        'giaoVien': 'Nguyễn Thị Bình',
        'giaoVienId': 'gv_001',
        'phong': 'P.101',
        'gioVao': '07:00',
        'gioRa': '08:30',
        'mauSac': '#FF6B00',
      },
      {
        'tietId': 't4_2',
        'thu': 'Thứ 4',
        'thuSo': 4,
        'tietSo': '3-4',
        'monHoc': 'Sinh học',
        'giaoVien': 'Đinh Văn G',
        'giaoVienId': 'gv_007',
        'phong': 'P.201',
        'gioVao': '08:45',
        'gioRa': '10:15',
        'mauSac': '#0D9488',
      },
      // Thứ 5
      {
        'tietId': 't5_1',
        'thu': 'Thứ 5',
        'thuSo': 5,
        'tietSo': '1-2',
        'monHoc': 'Tiếng Anh',
        'giaoVien': 'Lê Thị D',
        'giaoVienId': 'gv_004',
        'phong': 'P.103',
        'gioVao': '07:00',
        'gioRa': '08:30',
        'mauSac': '#16A34A',
      },
      {
        'tietId': 't5_2',
        'thu': 'Thứ 5',
        'thuSo': 5,
        'tietSo': '3-4',
        'monHoc': 'Văn',
        'giaoVien': 'Trần Văn C',
        'giaoVienId': 'gv_003',
        'phong': 'P.202',
        'gioVao': '08:45',
        'gioRa': '10:15',
        'mauSac': '#1A3C6E',
      },
      // Thứ 6
      {
        'tietId': 't6_1',
        'thu': 'Thứ 6',
        'thuSo': 6,
        'tietSo': '1-2',
        'monHoc': 'Vật lý',
        'giaoVien': 'Phạm Văn E',
        'giaoVienId': 'gv_005',
        'phong': 'P.301',
        'gioVao': '07:00',
        'gioRa': '08:30',
        'mauSac': '#7C3AED',
      },
      {
        'tietId': 't6_2',
        'thu': 'Thứ 6',
        'thuSo': 6,
        'tietSo': '3',
        'monHoc': 'GDQP',
        'giaoVien': 'Lý Văn H',
        'giaoVienId': 'gv_008',
        'phong': 'Sân trường',
        'gioVao': '08:45',
        'gioRa': '09:30',
        'mauSac': '#6B7280',
      },
    ];

    for (final p in periods) {
      await tkbRef
          .collection('tiet_hoc')
          .doc(p['tietId'] as String)
          .set(p);
    }
    print('✅ thoi_khoa_bieu');
  }

  // ══════════════════════════════════════════
  // COLLECTION: diem_danh
  // ══════════════════════════════════════════
  static Future<void> _createAttendance() async {
    final dates = [
      {'ngay': '2025-06-03', 'thu': 'Thứ 2', 'trangThai': 'co_mat', 'gioVao': '06:55'},
      {'ngay': '2025-06-04', 'thu': 'Thứ 3', 'trangThai': 'co_mat', 'gioVao': '07:00'},
      {'ngay': '2025-06-05', 'thu': 'Thứ 4', 'trangThai': 'vang_co_phep', 'gioVao': ''},
      {'ngay': '2025-06-06', 'thu': 'Thứ 5', 'trangThai': 'co_mat', 'gioVao': '07:02'},
      {'ngay': '2025-06-09', 'thu': 'Thứ 2', 'trangThai': 'co_mat', 'gioVao': '06:58'},
      {'ngay': '2025-06-10', 'thu': 'Thứ 3', 'trangThai': 'vang_khong_phep', 'gioVao': ''},
      {'ngay': '2025-06-11', 'thu': 'Thứ 4', 'trangThai': 'co_mat', 'gioVao': '07:00'},
    ];

    for (final d in dates) {
      final id = 'dd_hs001_${d['ngay']}';
      await _db.collection('diem_danh').doc(id).set({
        'diemDanhId': id,
        'hocSinhId': 'hs_001',
        'lopId': 'lop_11A1',
        'ngay': Timestamp.fromDate(
            DateTime.parse(d['ngay'] as String)),
        'ngayString': d['ngay'],
        'thang': 'Tháng 6/2025',
        'thu': d['thu'],
        // co_mat | vang_co_phep | vang_khong_phep
        'trangThai': d['trangThai'],
        'gioVao': d['gioVao'],
        'ghiChu': d['trangThai'] == 'vang_co_phep'
            ? 'Nghỉ ốm có đơn xin phép'
            : '',
        'loai': 'hoc', // hoc | ktx (điểm danh tối KTX)
      });
    }

    // Điểm danh KTX buổi tối
    final ktxDates = [
      {'ngay': '2025-06-03', 'trangThai': 'co_mat', 'gio': '21:25'},
      {'ngay': '2025-06-04', 'trangThai': 'co_mat', 'gio': '21:30'},
      {'ngay': '2025-06-05', 'trangThai': 'vang_co_phep', 'gio': ''},
      {'ngay': '2025-06-06', 'trangThai': 'co_mat', 'gio': '21:28'},
      {'ngay': '2025-06-09', 'trangThai': 'co_mat', 'gio': '21:20'},
      {'ngay': '2025-06-10', 'trangThai': 'vang_khong_phep', 'gio': ''},
      {'ngay': '2025-06-11', 'trangThai': 'co_mat', 'gio': '21:30'},
    ];

    for (final d in ktxDates) {
      final id = 'ktx_hs001_${d['ngay']}';
      await _db.collection('diem_danh').doc(id).set({
        'diemDanhId': id,
        'hocSinhId': 'hs_001',
        'lopId': 'lop_11A1',
        'ngay': Timestamp.fromDate(
            DateTime.parse(d['ngay'] as String)),
        'ngayString': d['ngay'],
        'thang': 'Tháng 6/2025',
        'thu': '',
        'trangThai': d['trangThai'],
        'gioVao': d['gio'],
        'ghiChu': '',
        'loai': 'ktx',
      });
    }
    print('✅ diem_danh');
  }

  // ══════════════════════════════════════════
  // COLLECTION: bang_diem
  // ══════════════════════════════════════════
  static Future<void> _createGrades() async {
    final monHocs = [
      {
        'mon': 'Toán',
        'diemMieng': [8.0, 9.0, 7.0],
        'diem15p': [8.5, 9.0, 7.5, 8.0],
        'diem1Tiet': [8.0, 8.5],
        'diemGiuaKy': 8.5,
        'diemCuoiKy': 8.0,
        'dtb': 8.5,
        'xepLoai': 'Giỏi',
        'mauSac': '#FF6B00',
      },
      {
        'mon': 'Văn',
        'diemMieng': [7.0, 8.0, 7.5],
        'diem15p': [7.5, 8.0, 7.0],
        'diem1Tiet': [7.5, 8.0],
        'diemGiuaKy': 7.5,
        'diemCuoiKy': 8.0,
        'dtb': 7.8,
        'xepLoai': 'Khá',
        'mauSac': '#1A3C6E',
      },
      {
        'mon': 'Tiếng Anh',
        'diemMieng': [9.0, 9.5, 8.5],
        'diem15p': [9.0, 9.5, 8.0, 9.0],
        'diem1Tiet': [9.0, 9.5],
        'diemGiuaKy': 9.0,
        'diemCuoiKy': 9.0,
        'dtb': 9.0,
        'xepLoai': 'Giỏi',
        'mauSac': '#16A34A',
      },
      {
        'mon': 'Vật lý',
        'diemMieng': [8.0, 8.5, 7.5],
        'diem15p': [8.0, 8.5, 7.0],
        'diem1Tiet': [8.0, 8.5],
        'diemGiuaKy': 8.0,
        'diemCuoiKy': 8.5,
        'dtb': 8.2,
        'xepLoai': 'Giỏi',
        'mauSac': '#7C3AED',
      },
      {
        'mon': 'Hóa học',
        'diemMieng': [7.0, 7.5, 8.0],
        'diem15p': [7.5, 7.0, 8.0],
        'diem1Tiet': [7.5, 7.5],
        'diemGiuaKy': 7.5,
        'diemCuoiKy': 7.5,
        'dtb': 7.5,
        'xepLoai': 'Khá',
        'mauSac': '#EA580C',
      },
      {
        'mon': 'Sinh học',
        'diemMieng': [8.5, 9.0, 8.0],
        'diem15p': [8.5, 9.0, 8.5],
        'diem1Tiet': [9.0, 8.5],
        'diemGiuaKy': 8.5,
        'diemCuoiKy': 9.0,
        'dtb': 8.8,
        'xepLoai': 'Giỏi',
        'mauSac': '#0D9488',
      },
    ];

    for (int i = 0; i < monHocs.length; i++) {
      final m = monHocs[i];
      final id = 'bd_hs001_hk1_${i + 1}';
      await _db.collection('bang_diem').doc(id).set({
        'bangDiemId': id,
        'hocSinhId': 'hs_001',
        'lopId': 'lop_11A1',
        'monHoc': m['mon'],
        'hocKy': 'HK1',
        'namHoc': '2024-2025',
        // Hệ số 1
        'diemMieng': m['diemMieng'],
        // Hệ số 1
        'diem15Phut': m['diem15p'],
        // Hệ số 2
        'diem1Tiet': m['diem1Tiet'],
        // Hệ số 2
        'diemGiuaKy': m['diemGiuaKy'],
        // Hệ số 3
        'diemCuoiKy': m['diemCuoiKy'],
        'diemTrungBinh': m['dtb'],
        'xepLoai': m['xepLoai'],
        'mauSac': m['mauSac'],
        'capNhatLuc': Timestamp.now(),
      });
    }

    // Tổng kết học kỳ
    await _db.collection('tong_ket_hk')
        .doc('tk_hs001_hk1_2024')
        .set({
      'tongKetId': 'tk_hs001_hk1_2024',
      'hocSinhId': 'hs_001',
      'hocKy': 'HK1',
      'namHoc': '2024-2025',
      'dtbCaHocKy': 8.2,
      'xepLoaiHocLuc': 'Giỏi',
      'xepLoaiHanhKiem': 'Tốt',
      'thuHangLop': 5,
      'siSoLop': 42,
      'capNhatLuc': Timestamp.now(),
    });

    print('✅ bang_diem');
  }

  // ══════════════════════════════════════════
  // COLLECTION: bai_tap
  // ══════════════════════════════════════════
  static Future<void> _createHomework() async {
    final homeworks = [
      {
        'baiTapId': 'bt_001',
        'tieuDe': 'Làm bài tập chương 3: Phương trình bậc 2',
        'moTa': 'Hoàn thành bài tập từ trang 45-48 SGK Toán 11',
        'monHoc': 'Toán',
        'lopId': 'lop_11A1',
        'giaoVienId': 'gv_001',
        'giaoVien': 'Nguyễn Thị Bình',
        'hanNop': Timestamp.fromDate(DateTime(2025, 6, 5)),
        'hanNopString': '05/06/2025',
        'fileDinhKem': [],
        'trangThai': 'chua_nop', // chua_nop | da_nop | qua_han
        'mauSac': '#FF6B00',
        'taoLuc': Timestamp.now(),
      },
      {
        'baiTapId': 'bt_002',
        'tieuDe': 'Soạn bài: Chí Phèo - Nam Cao',
        'moTa': 'Đọc và soạn bài Chí Phèo, trả lời câu hỏi SGK',
        'monHoc': 'Văn',
        'lopId': 'lop_11A1',
        'giaoVienId': 'gv_003',
        'giaoVien': 'Trần Văn C',
        'hanNop': Timestamp.fromDate(DateTime(2025, 6, 3)),
        'hanNopString': '03/06/2025',
        'fileDinhKem': [],
        'trangThai': 'da_nop',
        'mauSac': '#1A3C6E',
        'taoLuc': Timestamp.now(),
      },
      {
        'baiTapId': 'bt_003',
        'tieuDe': 'Unit 10 - Grammar & Vocabulary',
        'moTa': 'Làm bài tập Unit 10 trong workbook trang 65-67',
        'monHoc': 'Tiếng Anh',
        'lopId': 'lop_11A1',
        'giaoVienId': 'gv_004',
        'giaoVien': 'Lê Thị D',
        'hanNop': Timestamp.fromDate(DateTime(2025, 5, 28)),
        'hanNopString': '28/05/2025',
        'fileDinhKem': [],
        'trangThai': 'qua_han',
        'mauSac': '#16A34A',
        'taoLuc': Timestamp.now(),
      },
      {
        'baiTapId': 'bt_004',
        'tieuDe': 'Bài tập Vật lý: Dao động điều hòa',
        'moTa': 'Giải các bài tập từ 1 đến 10 trang 52 SGK',
        'monHoc': 'Vật lý',
        'lopId': 'lop_11A1',
        'giaoVienId': 'gv_005',
        'giaoVien': 'Phạm Văn E',
        'hanNop': Timestamp.fromDate(DateTime(2025, 6, 8)),
        'hanNopString': '08/06/2025',
        'fileDinhKem': [],
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
    print('✅ bai_tap');
  }

  // ══════════════════════════════════════════
  // COLLECTION: ky_tuc_xa
  // ══════════════════════════════════════════
  static Future<void> _createDormitory() async {
    // Thông tin phòng
    await _db.collection('ky_tuc_xa')
        .doc('ktx_hs001')
        .set({
      'ktxId': 'ktx_hs001',
      'hocSinhId': 'hs_001',
      'soPhong': '203',
      'tang': '2',
      'day': 'A',
      'khu': 'Khu Nam',
      'namHoc': '2024-2025',
      'banPhong': [
        {
          'hocSinhId': 'hs_003',
          'hoTen': 'Trần Minh',
          'lop': '11A2',
          'anhDaiDien': '',
        },
        {
          'hocSinhId': 'hs_004',
          'hoTen': 'Lê Hùng',
          'lop': '11B1',
          'anhDaiDien': '',
        },
        {
          'hocSinhId': 'hs_005',
          'hoTen': 'Phạm Tuấn',
          'lop': '11A1',
          'anhDaiDien': '',
        },
      ],
      'quanLyKtx': 'Nguyễn Văn X',
      'sdtQuanLy': '0243998567',
      'isActive': true,
    });

    // Lịch xin phép về nhà
    await _db.collection('xin_phep_ktx')
        .doc('xp_001')
        .set({
      'xinPhepId': 'xp_001',
      'hocSinhId': 'hs_001',
      'tuNgay': Timestamp.fromDate(DateTime(2025, 6, 7)),
      'denNgay': Timestamp.fromDate(DateTime(2025, 6, 9)),
      'tuNgayString': '07/06/2025',
      'denNgayString': '09/06/2025',
      'lyDo': 'Về nhà cuối tuần',
      // cho_duyet | da_duyet | tu_choi
      'trangThai': 'da_duyet',
      'taoLuc': Timestamp.now(),
    });

    print('✅ ky_tuc_xa');
  }

  // ══════════════════════════════════════════
  // COLLECTION: tin_tuc
  // ══════════════════════════════════════════
  static Future<void> _createNews() async {
    final news = [
      {
        'tinTucId': 'tt_001',
        'tieuDe': 'Lịch thi học kỳ 1 năm học 2024-2025',
        'noiDung': 'Nhà trường thông báo lịch thi chính thức học kỳ 1 năm học 2024-2025. Kỳ thi bắt đầu từ ngày 15/12/2024.',
        'danhMuc': 'thong_bao', // thong_bao | su_kien | tin_tuc
        'doiTuong': ['hoc_sinh', 'phu_huynh'],
        'danhSachLopId': [], // rỗng = tất cả
        'ghim': true,
        'anhThumbnail': '',
        'nguoiDang': 'Ban Giám Hiệu',
        'trangThai': 'da_dang', // cho_duyet | da_dang
        'luotXem': 342,
        'ngayDang': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'taoLuc': Timestamp.now(),
      },
      {
        'tinTucId': 'tt_002',
        'tieuDe': 'Kết quả xét khen thưởng học kỳ 1',
        'noiDung': 'Nhà trường công bố danh sách học sinh được khen thưởng học kỳ 1 năm học 2024-2025.',
        'danhMuc': 'thong_bao',
        'doiTuong': ['hoc_sinh', 'phu_huynh'],
        'danhSachLopId': [],
        'ghim': false,
        'anhThumbnail': '',
        'nguoiDang': 'Phòng Học vụ',
        'trangThai': 'da_dang',
        'luotXem': 215,
        'ngayDang': Timestamp.fromDate(DateTime(2025, 5, 28)),
        'taoLuc': Timestamp.now(),
      },
      {
        'tinTucId': 'tt_003',
        'tieuDe': 'FPT Schools tổ chức ngày hội STEM 2025',
        'noiDung': 'Ngày hội STEM 2025 sẽ được tổ chức vào ngày 20/06/2025 tại sân trường với nhiều hoạt động thú vị.',
        'danhMuc': 'su_kien',
        'doiTuong': ['hoc_sinh', 'phu_huynh'],
        'danhSachLopId': [],
        'ghim': false,
        'anhThumbnail': '',
        'nguoiDang': 'Ban Tổ chức',
        'trangThai': 'da_dang',
        'luotXem': 189,
        'ngayDang': Timestamp.fromDate(DateTime(2025, 6, 3)),
        'taoLuc': Timestamp.now(),
      },
      {
        'tinTucId': 'tt_004',
        'tieuDe': 'Thông báo nghỉ lễ 30/4 và 1/5',
        'noiDung': 'Nhà trường thông báo lịch nghỉ lễ 30/4 và 1/5/2025.',
        'danhMuc': 'thong_bao',
        'doiTuong': ['hoc_sinh', 'phu_huynh'],
        'danhSachLopId': [],
        'ghim': false,
        'anhThumbnail': '',
        'nguoiDang': 'Ban Giám Hiệu',
        'trangThai': 'da_dang',
        'luotXem': 420,
        'ngayDang': Timestamp.fromDate(DateTime(2025, 4, 25)),
        'taoLuc': Timestamp.now(),
      },
      {
        'tinTucId': 'tt_005',
        'tieuDe': 'Họp phụ huynh cuối học kỳ 1',
        'noiDung': 'Nhà trường kính mời phụ huynh tham dự buổi họp tổng kết học kỳ 1 vào ngày 20/12/2024.',
        'danhMuc': 'thong_bao',
        'doiTuong': ['phu_huynh'],
        'danhSachLopId': [],
        'ghim': false,
        'anhThumbnail': '',
        'nguoiDang': 'Phòng Học vụ',
        'trangThai': 'da_dang',
        'luotXem': 298,
        'ngayDang': Timestamp.fromDate(DateTime(2024, 12, 10)),
        'taoLuc': Timestamp.now(),
      },
    ];

    for (final t in news) {
      await _db.collection('tin_tuc')
          .doc(t['tinTucId'] as String)
          .set(t);
    }
    print('✅ tin_tuc');
  }

  // ══════════════════════════════════════════
  // COLLECTION: thong_bao_push
  // ══════════════════════════════════════════
  static Future<void> _createNotifications() async {
    final notifs = [
      {
        'thongBaoId': 'tb_001',
        'userId': 'hs_001',
        'tieuDe': 'Lịch thi học kỳ 1',
        'noiDung': 'Lịch thi chính thức HK1 đã được công bố',
        'loai': 'thong_bao', // thong_bao | diem_danh | bang_diem | bai_tap | hoc_phi
        'thamChieuId': 'tt_001',
        'thamChieuCollection': 'tin_tuc',
        'daDoc': false,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 1)),
      },
      {
        'thongBaoId': 'tb_002',
        'userId': 'hs_001',
        'tieuDe': 'Bài tập Tiếng Anh quá hạn',
        'noiDung': 'Bạn có bài tập Unit 10 đã quá hạn nộp',
        'loai': 'bai_tap',
        'thamChieuId': 'bt_003',
        'thamChieuCollection': 'bai_tap',
        'daDoc': false,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 5, 29)),
      },
      {
        'thongBaoId': 'tb_003',
        'userId': 'ph_001',
        'tieuDe': 'An vắng học hôm nay',
        'noiDung': 'Nguyễn Văn An vắng không phép tiết 1-2 ngày 10/06',
        'loai': 'diem_danh',
        'thamChieuId': 'dd_hs001_2025-06-10',
        'thamChieuCollection': 'diem_danh',
        'daDoc': false,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 6, 10)),
      },
      {
        'thongBaoId': 'tb_004',
        'userId': 'ph_001',
        'tieuDe': 'Nhắc đóng học phí',
        'noiDung': 'Phí ký túc xá tháng 1/2025 sắp đến hạn',
        'loai': 'hoc_phi',
        'thamChieuId': 'hp_002',
        'thamChieuCollection': 'hoc_phi',
        'daDoc': true,
        'taoLuc': Timestamp.fromDate(DateTime(2025, 1, 3)),
      },
    ];

    for (final t in notifs) {
      await _db.collection('thong_bao_push')
          .doc(t['thongBaoId'] as String)
          .set(t);
    }
    print('✅ thong_bao_push');
  }

  // ══════════════════════════════════════════
  // COLLECTION: hoc_phi
  // ══════════════════════════════════════════
  static Future<void> _createTuitionFees() async {
    final fees = [
      // Học phí HK2 - đã đóng
      {
        'hocPhiId': 'hp_001',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
        'lopId': 'lop_11A1',
        'loai': 'hoc_phi', // hoc_phi | ktx | xe_bus
        'tenKhoan': 'Học phí HK2 2024-2025',
        'soTien': 6000000,
        'donViTien': 'VND',
        'hocKy': 'HK2',
        'thang': '',
        'namHoc': '2024-2025',
        'hanDong': Timestamp.fromDate(DateTime(2025, 1, 15)),
        'hanDongString': '15/01/2025',
        'ngayDong': Timestamp.fromDate(DateTime(2025, 1, 10)),
        // da_dong | chua_dong | qua_han
        'trangThai': 'da_dong',
        'phuongThucThanhToan': 'chuyen_khoan',
        'maBienLai': 'BL2025001',
        'ghiChu': '',
        'taoLuc': Timestamp.now(),
      },
      // KTX tháng 1 - chưa đóng
      {
        'hocPhiId': 'hp_002',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
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
        'phuongThucThanhToan': '',
        'maBienLai': '',
        'ghiChu': '',
        'taoLuc': Timestamp.now(),
      },
      // Xe bus tháng 1 - quá hạn
      {
        'hocPhiId': 'hp_003',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
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
        'phuongThucThanhToan': '',
        'maBienLai': '',
        'ghiChu': '',
        'taoLuc': Timestamp.now(),
      },
      // Lịch sử - KTX T12 đã đóng
      {
        'hocPhiId': 'hp_004',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
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
        'phuongThucThanhToan': 'tien_mat',
        'maBienLai': 'BL2024120',
        'ghiChu': '',
        'taoLuc': Timestamp.now(),
      },
      // Lịch sử - Xe bus T12 đã đóng
      {
        'hocPhiId': 'hp_005',
        'hocSinhId': 'hs_001',
        'tenHocSinh': 'Nguyễn Văn An',
        'lopId': 'lop_11A1',
        'loai': 'xe_bus',
        'tenKhoan': 'Phí xe buýt T12/2024',
        'soTien': 1000000,
        'donViTien': 'VND',
        'hocKy': '',
        'thang': 'T12/2024',
        'namHoc': '2024-2025',
        'hanDong': Timestamp.fromDate(DateTime(2024, 12, 5)),
        'hanDongString': '05/12/2024',
        'ngayDong': Timestamp.fromDate(DateTime(2024, 12, 3)),
        'trangThai': 'da_dong',
        'phuongThucThanhToan': 'chuyen_khoan',
        'maBienLai': 'BL2024121',
        'ghiChu': '',
        'taoLuc': Timestamp.now(),
      },
    ];

    for (final f in fees) {
      await _db.collection('hoc_phi')
          .doc(f['hocPhiId'] as String)
          .set(f);
    }
    print('✅ hoc_phi');
  }

  // ══════════════════════════════════════════
  // COLLECTION: lien_lac
  // ══════════════════════════════════════════
  static Future<void> _createContacts() async {
    final contacts = [
      {
        'lienLacId': 'll_001',
        'hoTen': 'Nguyễn Thị Bình',
        'chucVu': 'Giáo viên chủ nhiệm',
        'monHoc': 'Toán',
        'lopPhuTrach': ['11A1'],
        'soDienThoai': '0901112222',
        'email': 'binh.nt@fpt.edu.vn',
        'nhom': 'gvcn', // gvcn | gvbm | bgh | phong_ban
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
        'userId': 'gv_001',
      },
      {
        'lienLacId': 'll_002',
        'hoTen': 'PGS.TS Lê Văn Minh',
        'chucVu': 'Hiệu trưởng',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998560',
        'email': 'hieuttruong@fpt.edu.vn',
        'nhom': 'bgh',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
        'userId': 'bgd_001',
      },
      {
        'lienLacId': 'll_003',
        'hoTen': 'TS Phạm Thị Thu',
        'chucVu': 'Hiệu phó Học vụ',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998561',
        'email': 'hocvu@fpt.edu.vn',
        'nhom': 'bgh',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
        'userId': 'bgd_002',
      },
      {
        'lienLacId': 'll_004',
        'hoTen': 'Phòng Học vụ',
        'chucVu': 'Phòng ban',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998578',
        'email': 'hocvu@fpt.edu.vn',
        'nhom': 'phong_ban',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
        'userId': '',
      },
      {
        'lienLacId': 'll_005',
        'hoTen': 'Phòng Y tế',
        'chucVu': 'Phòng ban',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998579',
        'email': 'yte@fpt.edu.vn',
        'nhom': 'phong_ban',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
        'userId': '',
      },
      {
        'lienLacId': 'll_006',
        'hoTen': 'Quản lý Ký túc xá',
        'chucVu': 'Phòng ban',
        'monHoc': '',
        'lopPhuTrach': [],
        'soDienThoai': '0243998580',
        'email': 'ktx@fpt.edu.vn',
        'nhom': 'phong_ban',
        'truong': 'THPT FPT Đà Nẵng',
        'anhDaiDien': '',
        'userId': '',
      },
    ];

    for (final c in contacts) {
      await _db.collection('lien_lac')
          .doc(c['lienLacId'] as String)
          .set(c);
    }
    print('✅ lien_lac');
  }

  // ══════════════════════════════════════════
  // COLLECTION: tin_nhan (Realtime-style trong Firestore)
  // ══════════════════════════════════════════
  static Future<void> _createMessages() async {
    // Tạo cuộc hội thoại
    final chatId = 'chat_ph001_gv001';
    await _db.collection('cuoc_tro_chuyen').doc(chatId).set({
      'chatId': chatId,
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
      'thoiGianTinCuoi': Timestamp.now(),
      'nguoiGuiCuoi': 'ph_001',
      'soTinChuaDoc': {
        'ph_001': 0,
        'gv_001': 1,
      },
      'taoLuc': Timestamp.now(),
    });

    // Tin nhắn trong cuộc trò chuyện
    final messages = [
      {
        'tinNhanId': 'tn_001',
        'chatId': chatId,
        'nguoiGuiId': 'gv_001',
        'tenNguoiGui': 'Nguyễn Thị Bình',
        'vaiTro': 'giao_vien',
        'noiDung': 'Chào anh/chị, An hôm nay có vắng tiết 1-2 Toán. Anh/chị có biết lý do không ạ?',
        'loai': 'van_ban', // van_ban | hinh_anh | file
        'daDoc': true,
        'docLuc': Timestamp.now(),
        'taoLuc': Timestamp.fromDate(
            DateTime(2025, 6, 10, 8, 30)),
      },
      {
        'tinNhanId': 'tn_002',
        'chatId': chatId,
        'nguoiGuiId': 'ph_001',
        'tenNguoiGui': 'Nguyễn Thị Lan',
        'vaiTro': 'phu_huynh',
        'noiDung': 'Dạ cô, An bị sốt ạ. Gia đình xin phép cho An nghỉ hôm nay. Con sẽ đi học lại vào ngày mai ạ.',
        'loai': 'van_ban',
        'daDoc': false,
        'docLuc': null,
        'taoLuc': Timestamp.fromDate(
            DateTime(2025, 6, 10, 8, 45)),
      },
      {
        'tinNhanId': 'tn_003',
        'chatId': chatId,
        'nguoiGuiId': 'gv_001',
        'tenNguoiGui': 'Nguyễn Thị Bình',
        'vaiTro': 'giao_vien',
        'noiDung': 'Dạ cô hiểu rồi ạ. Anh/chị nhớ làm đơn xin phép gửi lên phòng học vụ nhé. Chúc An mau khỏe!',
        'loai': 'van_ban',
        'daDoc': false,
        'docLuc': null,
        'taoLuc': Timestamp.fromDate(
            DateTime(2025, 6, 10, 9, 0)),
      },
    ];

    for (final m in messages) {
      await _db
          .collection('cuoc_tro_chuyen')
          .doc(chatId)
          .collection('tin_nhan')
          .doc(m['tinNhanId'] as String)
          .set(m);
    }
    print('✅ tin_nhan');
  }
}