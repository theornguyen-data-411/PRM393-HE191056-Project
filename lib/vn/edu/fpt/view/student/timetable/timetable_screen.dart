import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/student_model.dart';
import '../../../model/timetable_model.dart';
import '../../../component/bottom_nav_bar.dart';
import '../../../component/period_card.dart';
import '../../../component/empty_state_widget.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String? _currentUserId;
  StudentModel? _student;
  List<PeriodModel> _periods = [];
  int _selectedDay = DateTime.now().weekday; // Dart starts Mon at 1
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use the actual current day for selection
    int currentDay = DateTime.now().weekday;
    // Map 7 (Sun) to 8 (as used in selector logic)
    _selectedDay = (currentDay == 7) ? 8 : currentDay + 1;

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
      await _loadPeriods();
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPeriods() async {
    if (_student == null) return;
    final tkbQuery = await FirebaseFirestore.instance.collection('thoi_khoa_bieu').where('lopId', isEqualTo: _student!.lopId).limit(1).get();
    if (tkbQuery.docs.isEmpty) {
      setState(() => _periods = []);
      return;
    }
    final tkbDoc = tkbQuery.docs.first;
    final periodsSnapshot = await tkbDoc.reference.collection('tiet_hoc').where('thuSo', isEqualTo: _selectedDay).get();
    final docs = periodsSnapshot.docs;
    setState(() {
      _periods = docs.map((doc) => PeriodModel.fromFirestore(doc)).toList();
      _periods.sort((a, b) => a.tietSo.compareTo(b.tietSo));
    });
  }

  void _onNavTap(int index) {
    if (index == 1) return;
    final routes = {
      0: '/student-dashboard',
      2: '/student-grades',
      3: '/student-news',
      4: '/student-profile',
    };
    if (routes.containsKey(index)) {
      Navigator.pushReplacementNamed(context, routes[index]!, arguments: {'userId': _currentUserId});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF405E92)),
          onPressed: () => Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': _currentUserId}),
        ),
        title: const Text('Thời khóa biểu', style: TextStyle(color: Color(0xFF405E92), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications, color: Color(0xFF405E92)),
                Positioned(top: 0, right: 0, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white)))),
              ],
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          _buildDateContext(),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _periods.isEmpty
                ? const EmptyStateWidget(message: 'Hôm nay bạn không có tiết học')
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _periods.length,
                    itemBuilder: (context, index) {
                      final p = _periods[index];
                      return Column(
                        children: [
                          PeriodCard(tietSo: p.tietSo, monHoc: p.monHoc, teacher: p.shortTeacher, phong: p.phong, gioVao: p.gioVao, gioRa: p.gioRa, colorHex: p.mauSac),
                          if (index == 1) _buildBreakItem('Nghỉ giải lao 15 phút', Icons.local_cafe),
                          if (index == 4) _buildBreakItem('Nghỉ trưa', Icons.restaurant),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1, onTap: _onNavTap),
    );
  }

  Widget _buildDaySelector() {
    final days = [
      {'label': 'T2', 'val': 2},
      {'label': 'T3', 'val': 3},
      {'label': 'T4', 'val': 4},
      {'label': 'T5', 'val': 5},
      {'label': 'T6', 'val': 6},
      {'label': 'T7', 'val': 7},
      {'label': 'CN', 'val': 8},
    ];
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = _selectedDay == day['val'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDay = day['val'] as int;
                  _isLoading = true;
                });
                _loadPeriods();
              },
              child: Container(
                width: 56,
                decoration: BoxDecoration(color: isSelected ? const Color(0xFFFF6B00) : Colors.white, borderRadius: BorderRadius.circular(28), border: isSelected ? null : Border.all(color: Colors.grey.shade300)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(day['label'] as String, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    if (isSelected) const Text('03/06', style: TextStyle(color: Colors.white70, fontSize: 10)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateContext() {
    final now = DateTime.now();
    // Calculate the date based on selected day (2-8)
    // Find current Monday
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final displayDate = monday.add(Duration(days: _selectedDay - 2));
    final dateString = '${displayDate.day.toString().padLeft(2, '0')}/${displayDate.month.toString().padLeft(2, '0')}/${displayDate.year}';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFFFF3E8), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Color(0xFFFF6B00)),
              const SizedBox(width: 12),
              Text('Thứ $_selectedDay, ngày $dateString', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF405E92))),
            ],
          ),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFF6B00), borderRadius: BorderRadius.circular(20)), child: Text('${_periods.length} tiết', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildBreakItem(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
