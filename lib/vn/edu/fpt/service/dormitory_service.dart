import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/dormitory_model.dart';

class DormitoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DormitoryModel?> getDormitoryInfo(String studentId) async {
    // In a real app, students might have a roomId field
    // For this example, we'll find the room where this student is a roommate
    // or just fetch by a mapping collection. 
    // Simplified: fetch by room ID associated with student.
    
    // For now, let's assume we find it by looking for a room that contains the studentId 
    // or we have a hardcoded link for demo purposes if the mapping doesn't exist.
    
    final snapshot = await _db.collection('ky_tuc_xa')
        .where('roommates_ids', arrayContains: studentId)
        .limit(1)
        .get();
        
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      final data = doc.data();
      final roommatesSnapshot = await doc.reference.collection('roommates').get();
      final roommates = roommatesSnapshot.docs.map((d) => RoommateModel.fromMap(d.data())).toList();
      
      final room = DormitoryModel.fromFirestore(doc);
      return DormitoryModel(
        phongId: room.phongId,
        tenPhong: room.tenPhong,
        tang: room.tang,
        day: room.day,
        khu: room.khu,
        namHoc: room.namHoc,
        roommates: roommates,
        quanLyTen: room.quanLyTen,
        quanLySdt: room.quanLySdt,
      );
    }
    return null;
  }
}
