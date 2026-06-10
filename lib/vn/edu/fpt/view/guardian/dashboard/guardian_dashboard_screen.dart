import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuardianDashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const GuardianDashboardScreen({super.key, this.arguments});

  @override
  State<GuardianDashboardScreen> createState() => _GuardianDashboardScreenState();
}

class _GuardianDashboardScreenState extends State<GuardianDashboardScreen> {
  String? _currentUserId;

  Map<String, dynamic>? _guardian;
  Map<String, dynamic>? _selectedChild;
  List<Map<String, dynamic>> _todaySchedule = [];
  Map<String, dynamic>? _attendanceStats;
  Map<String, dynamic>? _gradeStats;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _currentUserId = args?['userId'] as String?;
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (_currentUserId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Load guardian info from phu_huynh collection
      final guardianDoc = await FirebaseFirestore.instance
          .collection('phu_huynh')
          .doc(_currentUserId)
          .get();

      if (guardianDoc.exists) {
        _guardian = guardianDoc.data();
      }

      String? childId = widget.arguments?['childId'];
      childId ??= ModalRoute.of(context)?.settings.arguments is Map<String, dynamic>
          ? (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['childId'] as String?
          : null;

      if (childId == null) {
        // Use danhSachConId field (from seeder)
        final childrenIds = List<String>.from(_guardian?['danhSachConId'] ?? []);
        if (childrenIds.isNotEmpty) {
          childId = childrenIds.first;
        }
      }

      if (childId != null) {
        await _loadChildData(childId);
      }

      await _loadNotifications();

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

  Future<void> _loadChildData(String childId) async {
    final childDoc = await FirebaseFirestore.instance
        .collection('hoc_sinh')
        .doc(childId)
        .get();

    if (childDoc.exists) {
      final childData = childDoc.data()!;

      final classDoc = await FirebaseFirestore.instance
          .collection('lop_hoc')
          .doc(childData['lopId'])
          .get();

      final classData = classDoc.exists ? classDoc.data() : {};

      setState(() {
        _selectedChild = {
          ...childData,
          'id': childId,
          'lop': classData?['tenLop'] ?? 'Lớp',
          'truong': classData?['truong'] ?? 'Trường',
        };
      });

      await _loadTodaySchedule(childId);
      await _loadAttendanceStats(childId);
      await _loadGradeStats(childId);
    }
  }

  Future<void> _loadTodaySchedule(String childId) async {
    if (_selectedChild == null) return;

    final tkbRef = FirebaseFirestore.instance
        .collection('thoi_khoa_bieu')
        .doc('tkb_${_selectedChild!['lopId']}_2024_2025');

    final now = DateTime.now();
    final weekday = now.weekday + 1 > 7 ? 2 : now.weekday + 1;

    final periodsSnapshot = await tkbRef
        .collection('tiet_hoc')
        .where('thuSo', isEqualTo: weekday)
        .orderBy('thuSo')
        .get();

    setState(() {
      _todaySchedule = periodsSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    });
  }

  Future<void> _loadAttendanceStats(String childId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final attendanceSnapshot = await FirebaseFirestore.instance
        .collection('diem_danh')
        .where('hocSinhId', isEqualTo: childId)
        .where('loai', isEqualTo: 'hoc')
        .where('ngay', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('ngay', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    int total = attendanceSnapshot.docs.length;
    int present = 0;
    int absent = 0;
    int absentWithPermission = 0;
    int absentWithoutPermission = 0;

    for (var doc in attendanceSnapshot.docs) {
      final data = doc.data();
      final status = data['trangThai'] ?? '';
      if (status == 'co_mat') {
        present++;
      } else {
        absent++;
        if (status == 'vang_co_phep') {
          absentWithPermission++;
        } else if (status == 'vang_khong_phep') {
          absentWithoutPermission++;
        }
      }
    }

    setState(() {
      _attendanceStats = {
        'present': present,
        'absent': absent,
        'absentWithPermission': absentWithPermission,
        'absentWithoutPermission': absentWithoutPermission,
        'total': total,
        'percent': total > 0 ? ((present / total) * 100).round() : 0,
      };
    });
  }

  Future<void> _loadGradeStats(String childId) async {
    final gradesSnapshot = await FirebaseFirestore.instance
        .collection('bang_diem')
        .where('hocSinhId', isEqualTo: childId)
        .where('hocKy', isEqualTo: 'HK1')
        .get();

    double total = 0;
    int count = 0;

    for (var doc in gradesSnapshot.docs) {
      final data = doc.data();
      total += (data['diemTrungBinh'] ?? 0).toDouble();
      count++;
    }

    String rating = 'Trung bình';
    if (count > 0) {
      final avg = total / count;
      if (avg >= 8.5) rating = 'Tốt';
      else if (avg >= 7.0) rating = 'Khá';
      else if (avg >= 5.5) rating = 'Trung bình';
      else rating = 'Yếu';
    }

    setState(() {
      _gradeStats = {
        'average': count > 0 ? (total / count) : 0.0,
        'rating': rating,
        'count': count,
      };
    });
  }

  Future<void> _loadNotifications() async {
    if (_currentUserId == null) return;

    final notificationsSnapshot = await FirebaseFirestore.instance
        .collection('thong_bao_push')
        .where('userId', isEqualTo: _currentUserId)
        .orderBy('taoLuc', descending: true)
        .limit(5)
        .get();

    setState(() {
      _notifications = notificationsSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    });
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[parts.length - 2][0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'HS';
  }

  String _getParentInitials(String name) {
    final parts = name.split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.isNotEmpty
            ? name[0].toUpperCase()
            : 'PH';
  }

  String _formatDate() {
    final now = DateTime.now();
    final weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'];
    return '${weekdays[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';
  }

  String _formatTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} phút trước';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} giờ trước';
    } else if (diff.inDays == 1) {
      return 'Hôm qua, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header - Orange background
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 40,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B00),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40FF6B00),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Xin chào,',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _guardian?['hoTen'] ?? 'Phụ huynh',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                      _getParentInitials(_guardian?['hoTen'] ?? 'PH'),
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
                  // Student Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B00),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x40FF6B00),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _getInitials(_selectedChild?['hoTen'] ?? 'HS'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedChild?['hoTen'] ?? 'Học sinh',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF191C1D),
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Color(0xFF666666),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_selectedChild?['lop'] ?? 'Lớp'} • ${_selectedChild?['truong'] ?? 'Trường'}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF3E8),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color(0xFFFF6B00).withOpacity(0.2),
                                          ),
                                        ),
                                        child: const Text(
                                          'Học sinh',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFFFF6B00),
                                          ),
                                        ),
                                      ),
                                      if (_selectedChild?['noiTru'] == true)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF008080).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: const Color(0xFF008080).withOpacity(0.2),
                                            ),
                                          ),
                                          child: const Text(
                                            'Nội trú',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF008080),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFEDEEEF), height: 1),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${_attendanceStats?['percent'] ?? 0}%',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF28A745),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Chuyên cần',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 32,
                              color: const Color(0xFFEDEEEF),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    _gradeStats?['average']?.toStringAsFixed(1) ?? '0.0',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF6B00),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'ĐTB',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 32,
                              color: const Color(0xFFEDEEEF),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    _gradeStats?['rating'] ?? 'Trung bình',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF191C1D),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Hạnh kiểm',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Alert Card
                  if (_attendanceStats?['absent'] != null && _attendanceStats!['absent'] > 0)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning,
                            color: Color(0xFF93000A),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_selectedChild?['hoTen'] ?? 'Con'} vắng học ${_attendanceStats!['absent']} ngày tháng này',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF93000A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Chi tiết',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF93000A),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Today's Schedule Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '📅',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Hôm nay của con - ${_formatDate()}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF191C1D),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFEDEEEF), height: 1),
                        const SizedBox(height: 8),
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
                          ...(_todaySchedule.take(3).map((period) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.schedule,
                                      color: Color(0xFF666666),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Tiết ${period['tietSo']}: ${period['monHoc']} - Phòng ${period['phong'] ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF191C1D),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                        const SizedBox(height: 8),
                        const Text(
                          'Xem thời khóa biểu đầy đủ →',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFF6B00),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Quick Access Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                    children: [
                      _buildQuickAction(Icons.bar_chart, 'Bảng điểm', () {
                        Navigator.pushNamed(context, '/guardian-grades');
                      }),
                      _buildQuickAction(Icons.checklist, 'Điểm danh', () {
                        Navigator.pushNamed(context, '/guardian-attendance');
                      }),
                      _buildQuickAction(Icons.domain, 'Ký túc xá', () {
                        Navigator.pushNamed(context, '/guardian-dormitory');
                      }),
                      _buildQuickAction(Icons.assignment, 'Bài tập', () {
                        Navigator.pushNamed(context, '/guardian-homework');
                      }),
                      _buildQuickAction(Icons.payments, 'Học phí', () {
                        Navigator.pushNamed(context, '/guardian-tuition');
                      }),
                      _buildQuickAction(Icons.call, 'Liên lạc', () {
                        Navigator.pushNamed(context, '/guardian-contact');
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Latest Notifications
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thông báo mới nhất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFFF6B00),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...(_notifications.map((notification) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.campaign,
                                color: Color(0xFFFF6B00),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDEEEF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      notification['loai'] ?? 'Thông báo',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification['tieuDe'] ?? 'Không có tiêu đề',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF191C1D),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification['taoLuc'] != null
                                        ? _formatTimeAgo(notification['taoLuc'])
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 6,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Trang chủ', true, () {}),
                _buildNavItem(Icons.school, 'Học tập', false, () {
                  Navigator.pushNamed(context, '/guardian-grades');
                }),
                _buildNavItem(Icons.domain, 'Ký túc xá', false, () {
                  Navigator.pushNamed(context, '/guardian-dormitory');
                }),
                _buildNavItem(Icons.chat, 'Liên lạc', false, () {
                  Navigator.pushNamed(context, '/guardian-chat');
                }),
                _buildNavItem(Icons.person, 'Hồ sơ', false, () {
                  Navigator.pushNamed(context, '/guardian-profile');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3E8),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFFF6B00), size: 20),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFF3E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFFF6B00) : const Color(0xFF585F6C),
              size: 24,
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
