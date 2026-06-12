import 'package:cloud_firestore/cloud_firestore.dart';

class DormitoryModel {
  final String phongId;
  final String tenPhong;
  final String tang;
  final String day;
  final String khu;
  final String namHoc;
  final List<RoommateModel> roommates;
  final String quanLyTen;
  final String quanLySdt;

  DormitoryModel({
    required this.phongId,
    required this.tenPhong,
    required this.tang,
    required this.day,
    required this.khu,
    required this.namHoc,
    this.roommates = const [],
    required this.quanLyTen,
    required this.quanLySdt,
  });

  factory DormitoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DormitoryModel(
      phongId: data['phongId'] ?? '',
      tenPhong: data['tenPhong'] ?? '',
      tang: data['tang'] ?? '',
      day: data['day'] ?? '',
      khu: data['khu'] ?? '',
      namHoc: data['namHoc'] ?? '',
      quanLyTen: data['quanLyTen'] ?? '',
      quanLySdt: data['quanLySdt'] ?? '',
    );
  }
}

class RoommateModel {
  final String hoTen;
  final String anhDaiDien;

  RoommateModel({required this.hoTen, required this.anhDaiDien});

  factory RoommateModel.fromMap(Map<String, dynamic> map) {
    return RoommateModel(
      hoTen: map['hoTen'] ?? '',
      anhDaiDien: map['anhDaiDien'] ?? '',
    );
  }
}
