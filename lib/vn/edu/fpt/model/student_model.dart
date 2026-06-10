import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String hocSinhId;
  final String userId;
  final String hoTen;
  final String maHocSinh;
  final DateTime ngaySinh;
  final String gioiTinh;
  final String lopId;
  final String tenLop;
  final String khoiLop;
  final String truong;
  final String namHoc;
  final String diaChi;
  final String nhomMau;
  final DateTime ngayNhapHoc;
  final String phuHuynhId;
  final bool isNoiTru;
  final bool isActive;
  final String anhDaiDien;

  StudentModel({
    required this.hocSinhId,
    required this.userId,
    required this.hoTen,
    required this.maHocSinh,
    required this.ngaySinh,
    required this.gioiTinh,
    required this.lopId,
    required this.tenLop,
    required this.khoiLop,
    required this.truong,
    required this.namHoc,
    this.diaChi = '',
    this.nhomMau = '',
    required this.ngayNhapHoc,
    required this.phuHuynhId,
    this.isNoiTru = false,
    this.isActive = true,
    this.anhDaiDien = '',
  });

  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      hocSinhId: data['hocSinhId'] ?? '',
      userId: data['userId'] ?? '',
      hoTen: data['hoTen'] ?? '',
      maHocSinh: data['maHocSinh'] ?? '',
      ngaySinh: (data['ngaySinh'] as Timestamp?)?.toDate() ?? DateTime.now(),
      gioiTinh: data['gioiTinh'] ?? '',
      lopId: data['lopId'] ?? '',
      tenLop: data['tenLop'] ?? '',
      khoiLop: data['khoiLop'] ?? '',
      truong: data['truong'] ?? '',
      namHoc: data['namHoc'] ?? '',
      diaChi: data['diaChi'] ?? '',
      nhomMau: data['nhomMau'] ?? '',
      ngayNhapHoc: (data['ngayNhapHoc'] as Timestamp?)?.toDate() ?? DateTime.now(),
      phuHuynhId: data['phuHuynhId'] ?? '',
      isNoiTru: data['isNoiTru'] ?? false,
      isActive: data['isActive'] ?? true,
      anhDaiDien: data['anhDaiDien'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'hocSinhId': hocSinhId,
      'userId': userId,
      'hoTen': hoTen,
      'maHocSinh': maHocSinh,
      'ngaySinh': Timestamp.fromDate(ngaySinh),
      'gioiTinh': gioiTinh,
      'lopId': lopId,
      'tenLop': tenLop,
      'khoiLop': khoiLop,
      'truong': truong,
      'namHoc': namHoc,
      'diaChi': diaChi,
      'nhomMau': nhomMau,
      'ngayNhapHoc': Timestamp.fromDate(ngayNhapHoc),
      'phuHuynhId': phuHuynhId,
      'isNoiTru': isNoiTru,
      'isActive': isActive,
      'anhDaiDien': anhDaiDien,
    };
  }

  String get initials {
    List<String> parts = hoTen.split(' ');
    if (parts.length >= 2) {
      return '${parts[parts.length - 2][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return hoTen.isNotEmpty ? hoTen[0].toUpperCase() : '';
  }
}
