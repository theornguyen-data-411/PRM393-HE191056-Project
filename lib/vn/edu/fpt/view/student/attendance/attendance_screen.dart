import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/attendance_model.dart';
import 'package:myfschoolse1915/vn/edu/fpt/service/attendance_service.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/bottom_nav_bar.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceService _attendanceService = AttendanceService();
  List<AttendanceModel> _attendances = [];
  bool _isLoading = true;
  String _studentId = 'hs_001';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    try {
      final list = await _attendanceService.getAttendanceByMonth(_studentId, _selectedDate.month, _selectedDate.year);
      setState(() {
        _attendances = list.where((a) => a.loai == 'hoc').toList();
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B00)),
          onPressed: () => Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': _studentId}),
        ),
        title: const Text('Điểm danh', style: TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.calendar_month, color: Color(0xFFFF6B00)), onPressed: () {})],
      ),
      body: Column(
        children: [
          _buildMonthSelector(),
          _buildSummaryCard(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chi tiết từng ngày', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(children: [Text('Tháng này', style: TextStyle(color: Colors.grey, fontSize: 14)), Icon(Icons.arrow_drop_down, color: Colors.grey)]),
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _attendances.isEmpty
                ? const Center(child: Text('Không có dữ liệu điểm danh'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _attendances.length,
                    itemBuilder: (context, index) => _buildAttendanceRow(_attendances[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2, onTap: _onNavTap),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
          Text('Tháng ${_selectedDate.month}, ${_selectedDate.year}', style: const TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.bold, fontSize: 16)),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    int present = _attendances.where((a) => a.trangThai == 'co_mat').length;
    int absentUnexcused = _attendances.where((a) => a.trangThai == 'vang_khong_phep').length;
    int absentExcused = _attendances.where((a) => a.trangThai == 'vang_co_phep').length;
    double rate = _attendances.isEmpty ? 0 : (present / _attendances.length) * 100;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
      child: Column(
        children: [
          Row(
            children: [
              _buildSummaryItem('Có mặt', present.toString(), const Color(0xFFDCFCE7), const Color(0xFF16A34A), Icons.check_circle),
              const SizedBox(width: 8),
              _buildSummaryItem('Vắng KP', absentUnexcused.toString(), const Color(0xFFFEE2E2), const Color(0xFFDC2626), Icons.cancel),
              const SizedBox(width: 8),
              _buildSummaryItem('Vắng phép', absentExcused.toString(), const Color(0xFFFEF9C3), const Color(0xFFCA8A04), Icons.horizontal_rule),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tỷ lệ chuyên cần', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text('${rate.toStringAsFixed(1)}%', style: const TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: rate / 100, backgroundColor: Colors.grey.shade200, color: const Color(0xFFFF6B00), minHeight: 8, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color bg, Color text, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Icon(icon, color: text, size: 20),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 22)),
            Text(label, style: TextStyle(color: text, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRow(AttendanceModel att) {
    Color bg;
    Color text;
    if (att.trangThai == 'co_mat') {
      bg = const Color(0xFFDCFCE7);
      text = const Color(0xFF16A34A);
    } else if (att.trangThai == 'vang_khong_phep') {
      bg = const Color(0xFFFEE2E2);
      text = const Color(0xFFDC2626);
    } else {
      bg = const Color(0xFFFEF9C3);
      text = const Color(0xFFCA8A04);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: att.trangThai != 'co_mat' ? Border(left: BorderSide(color: text, width: 4)) : null),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0xFFF3F4F5), borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(att.thu, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                Text(att.ngay.day.toString().padLeft(2, '0'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Lịch học chính', style: TextStyle(fontWeight: FontWeight.w500)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)), child: Text(att.trangThaiText, style: TextStyle(color: text, fontSize: 10, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(att.ghiChu.isNotEmpty ? att.ghiChu : 'Tiết học trong ngày', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
