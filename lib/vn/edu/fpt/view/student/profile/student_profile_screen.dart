import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/student_model.dart';
import '../../../component/bottom_nav_bar.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  String? _currentUserId;
  StudentModel? _student;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _currentUserId = args?['userId'] as String? ?? 'hs_001';
      _loadStudentData();
    });
  }

  Future<void> _loadStudentData() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('hoc_sinh').doc(_currentUserId).get();
      if (doc.exists) {
        setState(() {
          _student = StudentModel.fromFirestore(doc);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onNavTap(int index) {
    if (index == 4) return;
    final routes = {
      0: '/student-dashboard',
      1: '/student-timetable',
      2: '/student-grades',
      3: '/student-news',
    };
    if (routes.containsKey(index)) {
      Navigator.pushReplacementNamed(context, routes[index]!, arguments: {'userId': _currentUserId});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 30),
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B00),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': _currentUserId}),
                    ),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
                  ],
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: _student?.anhDaiDien.isNotEmpty == true
                      ? NetworkImage(_student!.anhDaiDien)
                      : null,
                  child: _student?.anhDaiDien.isEmpty == true
                      ? Text(_student?.initials ?? 'HS',
                          style: const TextStyle(fontSize: 32, color: Color(0xFFFF6B00), fontWeight: FontWeight.bold))
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  _student?.hoTen ?? 'Học sinh',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Lớp ${_student?.tenLop} • MSHS: ${_student?.maHocSinh}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'THPT FPT Đà Nẵng',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 16),
                  _buildAccountCard(),
                  const SizedBox(height: 24),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông tin học sinh',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF6B00))),
          const SizedBox(height: 16),
          _buildInfoItem(Icons.cake, 'Ngày sinh', _formatDate(_student?.ngaySinh)),
          _buildInfoItem(Icons.home, 'Địa chỉ', _student?.diaChi ?? 'Chưa cập nhật'),
          _buildInfoItem(Icons.call, 'SĐT', '090 123 4567'), // Assume fixed for now or add to model
          _buildInfoItem(Icons.calendar_today, 'Ngày nhập học', _formatDate(_student?.ngayNhapHoc)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF6B00), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tài khoản',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildActionItem(Icons.notifications, 'Cài đặt thông báo', trailing: Switch(value: true, onChanged: (v) {}, activeColor: const Color(0xFFFF6B00))),
          _buildActionItem(Icons.lock, 'Đổi mật khẩu', trailing: const Icon(Icons.chevron_right, color: Colors.grey)),
          _buildActionItem(Icons.language, 'Ngôn ngữ: Tiếng Việt', trailing: const Icon(Icons.chevron_right, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, {Widget? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFFFF6B00)),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: trailing,
      onTap: () {},
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout),
        label: const Text('Đăng xuất'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFFF6B00),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          side: const BorderSide(color: Color(0xFFF0F0F0)),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
