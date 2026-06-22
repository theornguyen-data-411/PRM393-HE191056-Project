import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/notification_model.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/news_model.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<NotificationModel>> getNotifications({String userId = 'hs_001'}) async {
    try {
      // Simplified query to avoid complex index requirements
      final snapshot = await _db.collection('thong_bao_push')
          .where('userId', isEqualTo: userId)
          .get();
          
      final list = snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
      // Sort in memory to avoid "Query requires an index" error
      list.sort((a, b) => b.ngayTao.compareTo(a.ngayTao));
      return list;
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<List<NewsModel>> getNews() async {
    try {
      final snapshot = await _db.collection('tin_tuc').get();
          
      final list = snapshot.docs.map((doc) => NewsModel.fromFirestore(doc)).toList();
      // Sort in memory: Pinned first, then by date
      list.sort((a, b) {
        if (a.isNoiBat != b.isNoiBat) {
          return a.isNoiBat ? -1 : 1;
        }
        return b.ngayDang.compareTo(a.ngayDang);
      });
      return list;
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }
}
