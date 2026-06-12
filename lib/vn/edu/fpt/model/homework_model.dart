import 'package:cloud_firestore/cloud_firestore.dart';

class HomeworkModel {
  final String baiTapId;
  final String lopId;
  final String monHoc;
  final String giaoVien;
  final String tieuDe;
  final String moTa;
  final DateTime hanNop;
  final String trangThai; // chua_nop | da_nop | qua_han
  final String icon;

  HomeworkModel({
    required this.baiTapId,
    required this.lopId,
    required this.monHoc,
    required this.giaoVien,
    required this.tieuDe,
    required this.moTa,
    required this.hanNop,
    required this.trangThai,
    required this.icon,
  });

  factory HomeworkModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return HomeworkModel(
      baiTapId: data['baiTapId'] ?? '',
      lopId: data['lopId'] ?? '',
      monHoc: data['monHoc'] ?? '',
      giaoVien: data['giaoVien'] ?? '',
      tieuDe: data['tieuDe'] ?? '',
      moTa: data['moTa'] ?? '',
      hanNop: (data['hanNop'] as Timestamp?)?.toDate() ?? DateTime.now(),
      trangThai: data['trangThai'] ?? 'chua_nop',
      icon: data['icon'] ?? 'assignment',
    );
  }

  String get remainingDaysText {
    final now = DateTime.now();
    if (hanNop.isBefore(now)) return 'Quá hạn';
    final diff = hanNop.difference(now).inDays;
    if (diff == 0) return 'Hết hạn hôm nay';
    return 'Còn $diff ngày';
  }
}
