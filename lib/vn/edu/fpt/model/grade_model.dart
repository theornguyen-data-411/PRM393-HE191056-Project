import 'package:cloud_firestore/cloud_firestore.dart';

class GradeModel {
  final String bangDiemId;
  final String hocSinhId;
  final String lopId;
  final String monHoc;
  final String hocKy;
  final String namHoc;
  final List<double> diemMieng;
  final List<double> diem15Phut;
  final List<double> diem1Tiet;
  final double diemGiuaKy;
  final double diemCuoiKy;
  final double diemTrungBinh;
  final String xepLoai;
  final String mauSac;
  final DateTime capNhatLuc;

  GradeModel({
    required this.bangDiemId,
    required this.hocSinhId,
    required this.lopId,
    required this.monHoc,
    required this.hocKy,
    required this.namHoc,
    this.diemMieng = const [],
    this.diem15Phut = const [],
    this.diem1Tiet = const [],
    this.diemGiuaKy = 0.0,
    this.diemCuoiKy = 0.0,
    this.diemTrungBinh = 0.0,
    this.xepLoai = '',
    this.mauSac = '#FF6B00',
    DateTime? capNhatLuc,
  }) : capNhatLuc = capNhatLuc ?? DateTime.now();

  factory GradeModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GradeModel(
      bangDiemId: data['bangDiemId'] ?? '',
      hocSinhId: data['hocSinhId'] ?? '',
      lopId: data['lopId'] ?? '',
      monHoc: data['monHoc'] ?? '',
      hocKy: data['hocKy'] ?? '',
      namHoc: data['namHoc'] ?? '',
      diemMieng: List<double>.from(data['diemMieng'] ?? []),
      diem15Phut: List<double>.from(data['diem15Phut'] ?? []),
      diem1Tiet: List<double>.from(data['diem1Tiet'] ?? []),
      diemGiuaKy: (data['diemGiuaKy'] ?? 0.0).toDouble(),
      diemCuoiKy: (data['diemCuoiKy'] ?? 0.0).toDouble(),
      diemTrungBinh: (data['diemTrungBinh'] ?? 0.0).toDouble(),
      xepLoai: data['xepLoai'] ?? '',
      mauSac: data['mauSac'] ?? '#FF6B00',
      capNhatLuc: (data['capNhatLuc'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  double get diemTB {
    return diemTrungBinh;
  }

  String get xepLoaiHocLuc {
    double dtb = diemTrungBinh;
    if (dtb >= 8.5) return 'Giỏi';
    if (dtb >= 7.0) return 'Khá';
    if (dtb >= 5.5) return 'Trung bình';
    if (dtb >= 4.0) return 'Yếu';
    return 'Kém';
  }
}
