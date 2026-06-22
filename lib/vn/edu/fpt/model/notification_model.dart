import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String thongBaoId;
  final String tieuDe;
  final String noiDung;
  final DateTime ngayTao;
  final String loai; // hoc_vu | khen_thuong | su_kien | y_te | tai_chinh
  final bool isGhim;
  final bool isRead;

  NotificationModel({
    required this.thongBaoId,
    required this.tieuDe,
    required this.noiDung,
    required this.ngayTao,
    required this.loai,
    this.isGhim = false,
    this.isRead = false,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      thongBaoId: data['thongBaoId'] ?? '',
      tieuDe: data['tieuDe'] ?? '',
      noiDung: data['noiDung'] ?? '',
      ngayTao: (data['taoLuc'] as Timestamp?)?.toDate() ?? (data['ngayTao'] as Timestamp?)?.toDate() ?? DateTime.now(),
      loai: data['loai'] ?? 'hoc_vu',
      isGhim: data['ghim'] ?? data['isGhim'] ?? false,
      isRead: data['daDoc'] ?? data['isRead'] ?? false,
    );
  }

  String get loaiText {
    switch (loai) {
      case 'hoc_vu': return 'Học vụ';
      case 'khen_thuong': return 'Khen thưởng';
      case 'su_kien': return 'Sự kiện';
      case 'y_te': return 'Y tế';
      case 'tai_chinh': return 'Tài chính';
      default: return 'Thông báo';
    }
  }
}
