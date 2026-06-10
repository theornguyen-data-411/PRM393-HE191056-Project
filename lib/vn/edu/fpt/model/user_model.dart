import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String hoTen;
  final String vaiTro; // hoc_sinh | phu_huynh
  final String anhDaiDien;
  final String soDienThoai;
  final bool isActive;
  final DateTime taoLuc;
  final DateTime dangNhapLanCuoi;
  final String fcmToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.hoTen,
    required this.vaiTro,
    this.anhDaiDien = '',
    this.soDienThoai = '',
    this.isActive = true,
    DateTime? taoLuc,
    DateTime? dangNhapLanCuoi,
    this.fcmToken = '',
  })  : taoLuc = taoLuc ?? DateTime.now(),
        dangNhapLanCuoi = dangNhapLanCuoi ?? DateTime.now();

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      hoTen: data['hoTen'] ?? '',
      vaiTro: data['vaiTro'] ?? '',
      anhDaiDien: data['anhDaiDien'] ?? '',
      soDienThoai: data['soDienThoai'] ?? '',
      isActive: data['isActive'] ?? true,
      taoLuc: (data['taoLuc'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dangNhapLanCuoi: (data['dangNhapLanCuoi'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fcmToken: data['fcmToken'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'hoTen': hoTen,
      'vaiTro': vaiTro,
      'anhDaiDien': anhDaiDien,
      'soDienThoai': soDienThoai,
      'isActive': isActive,
      'taoLuc': Timestamp.fromDate(taoLuc),
      'dangNhapLanCuoi': Timestamp.fromDate(dangNhapLanCuoi),
      'fcmToken': fcmToken,
    };
  }

  bool get isHocSinh => vaiTro == 'hoc_sinh';
  bool get isPhuHuynh => vaiTro == 'phu_huynh';
}
