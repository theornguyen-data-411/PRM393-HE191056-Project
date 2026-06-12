import 'package:flutter/material.dart';
import '../../../model/homework_model.dart';
import '../../../service/homework_service.dart';
import '../../../component/bottom_nav_bar.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  final HomeworkService _homeworkService = HomeworkService();
  List<HomeworkModel> _allHomework = [];
  List<HomeworkModel> _filteredHomework = [];
  String _currentFilter = 'Tất cả';
  bool _isLoading = true;
  String _lopId = 'lop_11a1';

  @override
  void initState() {
    super.initState();
    _loadHomework();
  }

  Future<void> _loadHomework() async {
    try {
      final list = await _homeworkService.getHomeworkByClass(_lopId);
      setState(() {
        _allHomework = list;
        _filteredHomework = list;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filter(String filter) {
    setState(() {
      _currentFilter = filter;
      if (filter == 'Tất cả') {
        _filteredHomework = _allHomework;
      } else if (filter == 'Chưa nộp') {
        _filteredHomework = _allHomework.where((h) => h.trangThai == 'chua_nop').toList();
      } else if (filter == 'Đã nộp') {
        _filteredHomework = _allHomework.where((h) => h.trangThai == 'da_nop').toList();
      } else if (filter == 'Quá hạn') {
        _filteredHomework = _allHomework.where((h) => h.trangThai == 'qua_han').toList();
      }
    });
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
      Navigator.pushReplacementNamed(context, routes[index]!, arguments: {'userId': 'hs_001'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B00),
        title: const Text('Bài tập về nhà', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': 'hs_001'}),
        ),
        actions: [IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {})],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _filteredHomework.isEmpty
                ? const Center(child: Text('Không có bài tập nào'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredHomework.length,
                    itemBuilder: (context, index) => _buildHomeworkCard(_filteredHomework[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0, onTap: _onNavTap),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Tất cả', 'Chưa nộp', 'Đã nộp', 'Quá hạn'];
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 12)),
              selected: isSelected,
              onSelected: (_) => _filter(filter),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFFFF6B00),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300)),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeworkCard(HomeworkModel homework) {
    Color borderColor;
    Color iconBgColor;
    Color textColor;
    
    switch (homework.trangThai) {
      case 'da_nop':
        borderColor = Colors.green;
        iconBgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        break;
      case 'qua_han':
        borderColor = Colors.red;
        iconBgColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        break;
      default:
        borderColor = const Color(0xFFFF6B00);
        iconBgColor = const Color(0xFFFF6B00).withValues(alpha: 0.1);
        textColor = const Color(0xFFFF6B00);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: borderColor, width: 6)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
                  child: Icon(_getIcon(homework.icon), color: textColor, size: 18),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(homework.monHoc, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('GV: ${homework.giaoVien}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(homework.tieuDe, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(homework.moTa, style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('Hạn nộp: ${_formatDate(homework.hanNop)}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(homework.trangThai == 'da_nop' ? Icons.check_circle : homework.trangThai == 'qua_han' ? Icons.cancel : Icons.warning, color: textColor, size: 12),
                      const SizedBox(width: 4),
                      Text(homework.trangThai == 'da_nop' ? 'Đã nộp' : homework.trangThai == 'qua_han' ? 'Quá hạn' : homework.remainingDaysText,
                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'functions': return Icons.functions;
      case 'menu_book': return Icons.menu_book;
      case 'public': return Icons.public;
      case 'science': return Icons.science;
      default: return Icons.assignment;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
