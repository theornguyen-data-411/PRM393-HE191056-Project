import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/homework_model.dart';

class HomeworkService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<HomeworkModel>> getHomeworkByClass(String classId) async {
    final snapshot = await _db.collection('bai_tap')
        .where('lopId', isEqualTo: classId)
        .orderBy('hanNop', descending: false)
        .get();
        
    return snapshot.docs.map((doc) => HomeworkModel.fromFirestore(doc)).toList();
  }
}
