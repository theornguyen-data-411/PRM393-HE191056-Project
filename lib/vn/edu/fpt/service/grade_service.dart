import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/grade_model.dart';

class GradeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<GradeModel>> getGrades(String studentId, String semester) async {
    final snapshot = await _db.collection('bang_diem')
        .where('hocSinhId', isEqualTo: studentId)
        .where('hocKy', isEqualTo: semester)
        .get();
        
    return snapshot.docs.map((doc) => GradeModel.fromFirestore(doc)).toList();
  }

  Future<GradeModel?> getGradeBySubject(String studentId, String semester, String subject) async {
    final snapshot = await _db.collection('bang_diem')
        .where('hocSinhId', isEqualTo: studentId)
        .where('hocKy', isEqualTo: semester)
        .where('monHoc', isEqualTo: subject)
        .limit(1)
        .get();
        
    if (snapshot.docs.isNotEmpty) {
      return GradeModel.fromFirestore(snapshot.docs.first);
    }
    return null;
  }
}
