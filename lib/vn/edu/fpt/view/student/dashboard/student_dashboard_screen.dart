import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/student_model.dart';
import '../../../model/attendance_model.dart';
import '../../../model/grade_model.dart';
import '../../../model/timetable_model.dart';

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
      // Load student info
      final studentDoc = await FirebaseFirestore.instance
          .collection('hoc_sinh')
          .doc(_currentUserId)
          .get();

      if (studentDoc.exists) {
        _student = StudentModel.fromFirestore(studentDoc);
      }

      // Load today's schedule
      await _loadTodaySchedule();

      // Load attendance stats
      await _loadAttendanceStats();

      // Load average grade
      await _loadGrades();

      // Load pending homework count
      await _loadHomeworkCount();

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Future<void> _loadTodaySchedule() async {
    if (_student == null) return;

    final tkbRef = FirebaseFirestore.instance
        .collection('thoi_khoa_bieu')
        .doc('tkb_${_student!.lopId}_2024_2025');

    final periodsSnapshot = await tkbRef
        .collection('tiet_hoc')
        .where('thuSo', isEqualTo: _getWeekday(DateTime.now().weekday))
        .orderBy('thuSo')
        .get();

    setState(() {
      _todaySchedule = periodsSnapshot.docs
          .map((doc) => PeriodModel.fromFirestore(doc))
          .toList();
    });
  }

  int _getWeekday(int weekday) {
    // Convert Flutter weekday (1=Mon) to Vietnamese format (2=Mon)
    return weekday + 1 > 7 ? 2 : weekday + 1;
  }

  Future<void> _loadAttendanceStats() async {
    if (_student == null) return;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final attendanceSnapshot = await FirebaseFirestore.instance
        .collection('diem_danh')
        .where('hocSinhId', isEqualTo: _currentUserId)
        .where('loai', isEqualTo: 'hoc')
        .where('ngay', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('ngay', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    int total = attendanceSnapshot.docs.length;
    int present = 0;

    for (var doc in attendanceSnapshot.docs) {
      AttendanceModel att = AttendanceModel.fromFirestore(doc);
      if (att.isCoMat) present++;
    }

    setState(() {
      _attendancePercent = total > 0 ? ((present / total) * 100).round() : 0;
    });
  }

  Future<void> _loadGrades() async {
    if (_student == null) return;

    final gradesSnapshot = await FirebaseFirestore.instance
        .collection('bang_diem')
        .where('hocSinhId', isEqualTo: _currentUserId)
        .where('hocKy', isEqualTo: 'HK1')
        .get();

    if (gradesSnapshot.docs.isNotEmpty) {
      double total = 0;
      for (var doc in gradesSnapshot.docs) {
        GradeModel grade = GradeModel.fromFirestore(doc);
        total += grade.diemTrungBinh;
      }
      setState(() {
        _avgGrade = total / gradesSnapshot.docs.length;
      });
    }
  }

  Future<void> _loadHomeworkCount() async {
    if (_student == null) return;

    final homeworkSnapshot = await FirebaseFirestore.instance
        .collection('bai_tap')
        .where('lopId', isEqualTo: _student!.lopId)
        .where('trangThai', isEqualTo: 'chua_nop')
        .get();

    setState(() {
      _pendingHomework = homeworkSnapshot.docs.length;
    });
  }

  String _getGradeLabel() {
    if (_avgGrade >= 8.5) return 'Giỏi';
    if (_avgGrade >= 7.0) return 'Khá';
    if (_avgGrade >= 5.5) return 'Trung bình';
    return 'Yếu';
  }

  String _formatDate() {
    final now = DateTime.now();
    final weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
    return '${weekdays[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B00),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Xin chào,',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _student?.hoTen ?? 'Học sinh',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        _student?.initials ?? 'HS',
                        style: const TextStyle(
                          color: Color(0xFFFF6B00),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFFE1E3E4)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F5),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(Icons.person, color: Color(0xFF666666)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _student?.tenLop ?? 'Lớp',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF3E8),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFFF6B00).withOpacity(0.2)),
                                      ),
                                      child: const Text(
                                        'Học sinh',
                                        style: TextStyle(
                                          color: Color(0xFFFF6B00),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Năm học ${_student?.namHoc ?? '2024-2025'}',
                                  style: const TextStyle(
                                    color: Color(0xFF5A4136),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'MSHV: ${_student?.maHocSinh ?? 'HS001'}',
                                  style: const TextStyle(
                                    color: Color(0xFF5A4136),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Today's Schedule
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFFE1E3E4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text('', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hôm nay - ${_formatDate()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/student-timetable'),
                                child: const Text(
                                  'Xem TKB',
                                  style: TextStyle(
                                    color: Color(0xFFFF6B00),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_todaySchedule.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Không có tiết học hôm nay',
                                  style: TextStyle(color: Color(0xFF666666)),
                                ),
                              ),
                            )
                          else
                            ...(_todaySchedule.take(3).map((period) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color(int.parse(period.mauSac.replaceFirst('#', '0xFF'))),
                                    width: 4,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tiết ${period.tietSo}: ${period.monHoc}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'GV: ${period.shortTeacher} • Phòng ${period.phong}',
                                        style: const TextStyle(
                                          color: Color(0xFF5A4136),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDEEEF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${period.gioVao} - ${period.gioRa}',
                                      style: const TextStyle(
                                        color: Color(0xFF5A4136),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Điểm danh',
                            '$_attendancePercent%',
                            'Tháng này',
                            const Color(0xFF28A745),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'ĐTB HK1',
                            _avgGrade.toStringAsFixed(1),
                            'Xếp loại ${_getGradeLabel()}',
                            const Color(0xFFFF6B00),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Bài tập',
                            '$_pendingHomework',
                            'Chưa nộp',
                            const Color(0xFFDC3545),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Quick Access
                    const Text(
                      'Truy cập nhanh',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF405E92),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _buildQuickAction(
                          Icons.calendar_today,
                          'Thời khóa\nbiểu',
                          const Color(0xFFFF6B00),
                          () => Navigator.pushNamed(context, '/student-timetable'),
                        ),
                        _buildQuickAction(
                          Icons.analytics,
                          'Bảng\nđiểm',
                          const Color(0xFF059EFF),
                          () => Navigator.pushNamed(context, '/student-grades'),
                        ),
                        _buildQuickAction(
                          Icons.check_circle,
                          'Điểm\ndanh',
                          const Color(0xFF28A745),
                          () => Navigator.pushNamed(context, '/student-attendance'),
                        ),
                        _buildQuickAction(
                          Icons.assignment,
                          'Bài\ntập',
                          const Color(0xFF7C3AED),
                          () => Navigator.pushNamed(context, '/student-homework'),
                        ),
                        _buildQuickAction(
                          Icons.apartment,
                          'Ký túc\nxá',
                          const Color(0xFF059669),
                          () => Navigator.pushNamed(context, '/student-dormitory'),
                        ),
                        _buildQuickAction(
                          Icons.notifications,
                          'Thông\nbáo',
                          const Color(0xFFDC3545),
                          () => Navigator.pushNamed(context, '/notifications'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -4),
            ),
          ],
          border: const Border(
            top: BorderSide(color: Color(0xFFE1E3E4)),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Trang chủ', true, () {}),
                _buildNavItem(Icons.calendar_today, 'TKB', false, () => Navigator.pushNamed(context, '/student-timetable')),
                _buildNavItem(Icons.grade, 'Điểm', false, () => Navigator.pushNamed(context, '/student-grades')),
                _buildNavItemWithBadge(Icons.notifications, 'Thông báo', false, () => Navigator.pushNamed(context, '/notifications')),
                _buildNavItem(Icons.person, 'Hồ sơ', false, () => Navigator.pushNamed(context, '/student-profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFE1E3E4)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: const Color(0xFFE1E3E4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF191C1D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFFF6B00) : const Color(0xFF585F6C),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFFF6B00) : const Color(0xFF585F6C),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  color: isActive ? const Color(0xFFFF6B00) : const Color(0xFF585F6C),
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC3545),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFFF6B00) : const Color(0xFF585F6C),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}