import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/dormitory_model.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/attendance_model.dart';
import 'package:myfschoolse1915/vn/edu/fpt/service/dormitory_service.dart';
import 'package:myfschoolse1915/vn/edu/fpt/service/attendance_service.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/bottom_nav_bar.dart';

class DormitoryScreen extends StatefulWidget {
  const DormitoryScreen({super.key});

  @override
  State<DormitoryScreen> createState() => _DormitoryScreenState();
}

class _DormitoryScreenState extends State<DormitoryScreen> {
  final DormitoryService _dormService = DormitoryService();
  final AttendanceService _attService = AttendanceService();
  
  DormitoryModel? _dormInfo;
  AttendanceModel? _todayAttendance;
  List<AttendanceModel> _recentAttendance = [];
  bool _isLoading = true;
  String _studentId = 'hs_001';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final info = await _dormService.getDormitoryInfo(_studentId);
      final today = await _attService.getTodayKtxAttendance(_studentId);
      final recent = await _attService.getAttendanceByMonth(_studentId, DateTime.now().month, DateTime.now().year);
      
      setState(() {
        _dormInfo = info;
        _todayAttendance = today;
        _recentAttendance = recent.where((a) => a.loai == 'ktx').take(7).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onNavTap(int index) {
    final routes = {
      0: '/student-dashboard',
      1: '/student-timetable',
      2: '/student-grades',
      3: '/student-news',
      4: '/student-profile',
    };
    if (routes.containsKey(index)) {
      Navigator.pushReplacementNamed(context, routes[index]!, arguments: {'userId': _studentId});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B00),
        title: const Text('Quản lý Ký túc xá', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': _studentId}),
        ),
        actions: [IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRoomInfoCard(),
            const SizedBox(height: 16),
            _buildTodayAttendanceCard(),
            const SizedBox(height: 16),
            _buildRoommatesCard(),
            const SizedBox(height: 16),
            _buildAttendanceHistoryCard(),
            const SizedBox(height: 16),
            _buildContactCard(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0, onTap: _onNavTap),
    );
  }

  Widget _buildRoomInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF0F766E)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.home, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_dormInfo?.tenPhong ?? 'N/A', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Tầng ${_dormInfo?.tang} • Dãy ${_dormInfo?.day} • Khu ${_dormInfo?.khu}', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
                child: const Text('🏠 Nội trú', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              ),
              Text('Năm học ${_dormInfo?.namHoc ?? ''}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayAttendanceCard() {
    bool isPresent = _todayAttendance?.trangThai == 'co_mat';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.2))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Điểm danh tối', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(_formatDate(DateTime.now()), style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const Divider(height: 24),
          Column(
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(color: (isPresent ? Colors.green : Colors.grey).withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(isPresent ? Icons.check_circle : Icons.help_outline, color: isPresent ? Colors.green : Colors.grey, size: 40),
              ),
              const SizedBox(height: 12),
              Text(isPresent ? 'Có mặt' : 'Chưa điểm danh', style: TextStyle(color: isPresent ? Colors.green : Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
              if (isPresent) Text('Điểm danh lúc ${_todayAttendance?.gioVao}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoommatesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bạn cùng phòng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (_dormInfo?.roommates.length ?? 0) + 1,
              itemBuilder: (context, index) {
                if (index == (_dormInfo?.roommates.length ?? 0)) {
                   return _buildAddRoommateButton();
                }
                final mate = _dormInfo!.roommates[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: (mate.anhDaiDien.trim().isNotEmpty)
                            ? NetworkImage(mate.anhDaiDien)
                            : null,
                        child: (mate.anhDaiDien.trim().isEmpty)
                            ? const Icon(Icons.person, size: 20)
                            : null,
                      ),
                      const SizedBox(height: 4),
                      Text(mate.hoTen.split(' ').last, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddRoommateButton() {
    return Column(
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: Colors.grey.shade100, border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid), shape: BoxShape.circle),
          child: const Icon(Icons.add, color: Colors.grey, size: 20),
        ),
        const SizedBox(height: 4),
        const Text('', style: TextStyle(fontSize: 13)), // Spacer
      ],
    );
  }

  Widget _buildAttendanceHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.2))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lịch sử điểm danh tối', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextButton(onPressed: () {}, child: const Text('Xem tất cả', style: TextStyle(color: Color(0xFFFF6B00), fontSize: 13))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _recentAttendance.map((a) => _buildHistoryItem(a)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(AttendanceModel att) {
    bool isPresent = att.trangThai == 'co_mat';
    return Column(
      children: [
        Text(att.thu, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: (isPresent ? Colors.green : Colors.red).withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(isPresent ? Icons.check_circle : Icons.cancel, color: isPresent ? Colors.green : Colors.red, size: 20),
        ),
        const SizedBox(height: 8),
        Text(att.ngay.day.toString(), style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Liên hệ quản lý KTX', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          _buildContactItem(Icons.call, 'Số điện thoại', _dormInfo?.quanLySdt ?? 'N/A'),
          const SizedBox(height: 12),
          _buildContactItem(Icons.person, 'Quản lý', _dormInfo?.quanLyTen ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F5), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFFF6B00).withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFFFF6B00), size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
