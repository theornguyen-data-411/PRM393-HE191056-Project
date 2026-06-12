import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notification_model.dart';
import '../model/news_model.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<NotificationModel>> getNotifications() async {
    final snapshot = await _db.collection('thong_bao')
        .orderBy('isGhim', descending: true)
        .orderBy('ngayTao', descending: true)
        .get();
        
    return snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
  }

  Future<List<NewsModel>> getNews() async {
    final snapshot = await _db.collection('tin_tuc')
        .orderBy('isNoiBat', descending: true)
        .orderBy('ngayDang', descending: true)
        .get();
        
    return snapshot.docs.map((doc) => NewsModel.fromFirestore(doc)).toList();
  }
}
