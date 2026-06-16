import 'package:cloud_firestore/cloud_firestore.dart';

class TimetableModel {
  final String tkzId;
  final String lopId;
  final String tenLop;
  final String namHoc;
  final String hocKy;
  final DateTime capNhatLuc;

  TimetableModel({
    required this.tkzId,
    required this.lopId,
    required this.tenLop,
    required this.namHoc,
    this.hocKy = '1',
    DateTime? capNhatLuc,
  }) : capNhatLuc = capNhatLuc ?? DateTime.now();

  factory TimetableModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TimetableModel(
      tkzId: data['tkbId'] ?? data['tkzId'] ?? '',
      lopId: data['lopId'] ?? '',
      tenLop: data['tenLop'] ?? '',
      namHoc: data['namHoc'] ?? '',
      hocKy: data['hocKy']?.toString() ?? '1',
      capNhatLuc: (data['capNhatLuc'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class PeriodModel {
  final String tietId;
  final String thu;
  final int thuSo;
  final String tietSo;
  final String monHoc;
  final String giaoVien;
  final String giaoVienId;
  final String phong;
  final String gioVao;
  final String gioRa;
  final String mauSac;

  PeriodModel({
    required this.tietId,
    required this.thu,
    required this.thuSo,
    required this.tietSo,
    required this.monHoc,
    this.giaoVien = '',
    this.giaoVienId = '',
    this.phong = '',
    this.gioVao = '',
    this.gioRa = '',
    this.mauSac = '#FF6B00',
  });

  factory PeriodModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PeriodModel(
      tietId: data['tietId'] ?? '',
      thu: data['thu'] ?? '',
      thuSo: data['thuSo'] ?? 0,
      tietSo: data['tietSo']?.toString() ?? '',
      monHoc: data['monHoc'] ?? '',
      giaoVien: data['tenGiaoVien'] ?? data['giaoVien'] ?? '',
      giaoVienId: data['giaoVienId'] ?? '',
      phong: data['phong'] ?? '',
      gioVao: data['gioVao'] ?? '',
      gioRa: data['gioRa'] ?? '',
      mauSac: data['mauSac'] ?? '#FF6B00',
    );
  }

  String get shortTeacher {
    if (giaoVien.isEmpty) return '';
    List<String> parts = giaoVien.split(' ');
    if (parts.length >= 2) {
      return '${parts[parts.length - 2]} ${parts[parts.length - 1][0]}';
    }
    return giaoVien;
  }
}
