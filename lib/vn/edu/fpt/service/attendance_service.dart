import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/attendance_model.dart';

class AttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<AttendanceModel>> getAttendanceByMonth(String studentId, int month, int year) async {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0);
    
    final snapshot = await _db.collection('diem_danh')
        .where('hocSinhId', isEqualTo: studentId)
        .where('ngay', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('ngay', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .orderBy('ngay', descending: true)
        .get();
        
    return snapshot.docs.map((doc) => AttendanceModel.fromFirestore(doc)).toList();
  }

  Future<AttendanceModel?> getTodayKtxAttendance(String studentId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    final snapshot = await _db.collection('diem_danh')
        .where('hocSinhId', isEqualTo: studentId)
        .where('loai', isEqualTo: 'ktx')
        .where('ngay', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .limit(1)
        .get();
        
    if (snapshot.docs.isNotEmpty) {
      return AttendanceModel.fromFirestore(snapshot.docs.first);
    }
    return null;
  }
}
