import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/student_model.dart';
import '../../../model/timetable_model.dart';
import '../../../component/info_card.dart';
import '../../../component/period_card.dart';
import '../../../component/bottom_nav_bar.dart';
import '../../../component/empty_state_widget.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  String? _currentUserId;
  StudentModel? _student;
  List<PeriodModel> _todaySchedule = [];
  int _attendancePercent = 0;
  double _avgGrade = 0.0;
  int _pendingHomework = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _currentUserId = args?['userId'] as String? ?? 'hs_001';
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      final studentDoc = await FirebaseFirestore.instance.collection('hoc_sinh').doc(_currentUserId).get();
      if (studentDoc.exists) _student = StudentModel.fromFirestore(studentDoc);
      await _loadTodaySchedule();
      await _loadAttendanceStats();
      await _loadGrades();
      await _loadHomeworkCount();
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  Future<void> _loadTodaySchedule() async {
    if (_student == null) return;
    final tkbQuery = await FirebaseFirestore.instance.collection('thoi_khoa_bieu').where('lopId', isEqualTo: _student!.lopId).limit(1).get();
    if (tkbQuery.docs.isEmpty) {
      setState(() => _todaySchedule = []);
      return;
    }
    final tkbDoc = tkbQuery.docs.first;
    final periodsSnapshot = await tkbDoc.reference.collection('tiet_hoc').where('thuSo', isEqualTo: DateTime.now().weekday + 1 > 7 ? 2 : DateTime.now().weekday + 1).get();
    final docs = periodsSnapshot.docs;
    setState(() {
      _todaySchedule = docs.map((doc) => PeriodModel.fromFirestore(doc)).toList();
      _todaySchedule.sort((a, b) => a.tietSo.compareTo(b.tietSo));
    });
  }

  Future<void> _loadAttendanceStats() async {
    if (_currentUserId == null) return;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final attendanceSnapshot = await FirebaseFirestore.instance.collection('diem_danh').where('hocSinhId', isEqualTo: _currentUserId)
        .where('ngay', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth)).get();
    int total = attendanceSnapshot.docs.length;
    int present = attendanceSnapshot.docs.where((d) => d.data()['trangThai'] == 'co_mat').length;
    setState(() => _attendancePercent = total > 0 ? ((present / total) * 100).round() : 0);
  }

  Future<void> _loadGrades() async {
    if (_currentUserId == null) return;
    final gradesSnapshot = await FirebaseFirestore.instance.collection('bang_diem').where('hocSinhId', isEqualTo: _currentUserId).where('hocKy', isEqualTo: 'HK1').get();
    if (gradesSnapshot.docs.isNotEmpty) {
      double total = 0;
      for (var doc in gradesSnapshot.docs) {
        total += (doc.data()['diemTrungBinh'] as num? ?? 0.0).toDouble();
      }
      setState(() => _avgGrade = total / gradesSnapshot.docs.length);
    }
  }

  Future<void> _loadHomeworkCount() async {
    if (_student == null) return;
    final homeworkSnapshot = await FirebaseFirestore.instance.collection('bai_tap').where('lopId', isEqualTo: _student!.lopId).where('trangThai', isEqualTo: 'chua_nop').get();
    setState(() => _pendingHomework = homeworkSnapshot.docs.length);
  }

  void _onNavTap(int index) {
    if (index == 0) return;
    final routes = {
      1: '/student-timetable',
      2: '/student-grades',
      3: '/student-news',
      4: '/student-profile',
    };
    if (routes.containsKey(index)) {
      Navigator.pushReplacementNamed(context, routes[index]!, arguments: {'userId': _currentUserId});
    }
  }

  String _formatDate() {
    final now = DateTime.now();
    final weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
    return '${weekdays[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            height: 120, padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            decoration: const BoxDecoration(color: Color(0xFFFF6B00), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () {}),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Xin chào,', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(_student?.hoTen ?? 'Học sinh', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
                Container(
                  width: 40, height: 40, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: Center(child: Text(_student?.initials ?? 'HS', style: const TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.bold))),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  StudentInfoCard(
                    studentName: _student?.hoTen,
                    className: _student?.tenLop,
                    studentId: _student?.maHocSinh,
                    academicYear: _student?.namHoc,
                    avatarUrl: _student?.anhDaiDien,
                  ),
                  const SizedBox(height: 16),
                  _buildScheduleCard(),
                  const SizedBox(height: 16),
                  _buildStatsGrid(),
                  const SizedBox(height: 16),
                  _buildQuickAccess(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0, onTap: _onNavTap),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE1E3E4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('📅 Hôm nay - ${_formatDate()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            TextButton(onPressed: () {}, child: const Text('Xem TKB', style: TextStyle(color: Color(0xFFFF6B00), fontSize: 12))),
          ]),
          const SizedBox(height: 8),
          if (_todaySchedule.isEmpty)
            const EmptyStateWidget(message: 'Hôm nay bạn không có tiết học')
          else
            ..._todaySchedule.map((p) => PeriodCard(tietSo: p.tietSo, monHoc: p.monHoc, teacher: p.shortTeacher, phong: p.phong, gioVao: p.gioVao, gioRa: p.gioRa, colorHex: p.mauSac)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.2,
      children: [
        _buildStatItem('Điểm danh', '$_attendancePercent%', 'Tháng này', const Color(0xFF28A745)),
        _buildStatItem('ĐTB HK1', _avgGrade.toStringAsFixed(1), 'Giỏi', const Color(0xFFFF6B00)),
        _buildStatItem('Bài tập', '$_pendingHomework', 'Chưa nộp', const Color(0xFFDC3545)),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, String sub, Color color) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE1E3E4))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(sub, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ]),
    );
  }

  Widget _buildQuickAccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Truy cập nhanh', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A3C6E))),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildActionItem(Icons.calendar_today, 'Thời khóa\nbiểu', const Color(0xFFFF6B00), () => _onNavTap(1)),
            _buildActionItem(Icons.analytics, 'Bảng\nđiểm', const Color(0xFF059EFF), () => _onNavTap(2)),
            _buildActionItem(Icons.check_circle, 'Điểm\ndanh', const Color(0xFF28A745), () => Navigator.pushNamed(context, '/student-attendance', arguments: {'userId': _currentUserId})),
            _buildActionItem(Icons.assignment, 'Bài\ntập', Colors.purple, () => Navigator.pushNamed(context, '/student-homework', arguments: {'userId': _currentUserId})),
            _buildActionItem(Icons.apartment, 'Ký túc\nxá', Colors.teal, () => Navigator.pushNamed(context, '/student-dormitory', arguments: {'userId': _currentUserId})),
            _buildActionItem(Icons.notifications, 'Thông\nbáo', Colors.red, () => _onNavTap(3)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E3E4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
