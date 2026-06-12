import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String tinTucId;
  final String tieuDe;
  final String noiDung;
  final String anhBia;
  final DateTime ngayDang;
  final String chuyenMuc; // su_kien | hoc_thuat | hoat_dong
  final bool isNoiBat;

  NewsModel({
    required this.tinTucId,
    required this.tieuDe,
    required this.noiDung,
    required this.anhBia,
    required this.ngayDang,
    required this.chuyenMuc,
    this.isNoiBat = false,
  });

  factory NewsModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NewsModel(
      tinTucId: data['tinTucId'] ?? '',
      tieuDe: data['tieuDe'] ?? '',
      noiDung: data['noiDung'] ?? '',
      anhBia: data['anhBia'] ?? '',
      ngayDang: (data['ngayDang'] as Timestamp?)?.toDate() ?? DateTime.now(),
      chuyenMuc: data['chuyenMuc'] ?? 'su_kien',
      isNoiBat: data['isNoiBat'] ?? false,
    );
  }

  String get chuyenMucText {
    switch (chuyenMuc) {
      case 'su_kien': return 'Sự kiện';
      case 'hoc_thuat': return 'Học thuật';
      case 'hoat_dong': return 'Hoạt động';
      default: return 'Tin tức';
    }
  }
}
