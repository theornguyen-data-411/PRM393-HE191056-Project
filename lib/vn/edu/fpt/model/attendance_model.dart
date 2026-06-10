import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String diemDanhId;
  final String hocSinhId;
  final String lopId;
  final DateTime ngay;
  final String ngayString;
  final String thang;
  final String thu;
  final String trangThai; // co_mat | vang_co_phep | vang_khong_phep
  final String gioVao;
  final String ghiChu;
  final String loai; // hoc | ktx

  AttendanceModel({
    required this.diemDanhId,
    required this.hocSinhId,
    required this.lopId,
    required this.ngay,
    required this.ngayString,
    required this.thang,
    this.thu = '',
    required this.trangThai,
    this.gioVao = '',
    this.ghiChu = '',
    required this.loai,
  });

  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AttendanceModel(
      diemDanhId: data['diemDanhId'] ?? '',
      hocSinhId: data['hocSinhId'] ?? '',
      lopId: data['lopId'] ?? '',
      ngay: (data['ngay'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ngayString: data['ngayString'] ?? '',
      thang: data['thang'] ?? '',
      thu: data['thu'] ?? '',
      trangThai: data['trangThai'] ?? '',
      gioVao: data['gioVao'] ?? '',
      ghiChu: data['ghiChu'] ?? '',
      loai: data['loai'] ?? 'hoc',
    );
  }

  bool get isCoMat => trangThai == 'co_mat';
  bool get isVangCoPhep => trangThai == 'vang_co_phep';
  bool get isVangKhongPhep => trangThai == 'vang_khong_phep';
  bool get isKtx => loai == 'ktx';

  String get trangThaiText {
    switch (trangThai) {
      case 'co_mat':
        return 'Có mặt';
      case 'vang_co_phep':
        return 'Vắng có phép';
      case 'vang_khong_phep':
        return 'Vắng không phép';
      default:
        return trangThai;
    }
  }
}