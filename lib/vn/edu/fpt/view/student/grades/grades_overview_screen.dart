import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/grade_model.dart';
import 'package:myfschoolse1915/vn/edu/fpt/service/grade_service.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/bottom_nav_bar.dart';

class GradesOverviewScreen extends StatefulWidget {
  const GradesOverviewScreen({super.key});

  @override
  State<GradesOverviewScreen> createState() => _GradesOverviewScreenState();
}

class _GradesOverviewScreenState extends State<GradesOverviewScreen> {
  final GradeService _gradeService = GradeService();
  List<GradeModel> _grades = [];
  String _currentSemester = 'HK1';
  bool _isLoading = true;
  String _studentId = 'hs_001';

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    try {
      final list = await _gradeService.getGrades(_studentId, _currentSemester);
      setState(() {
        _grades = list;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onNavTap(int index) {
    if (index == 2) return;
    final routes = {
      0: '/student-dashboard',
      1: '/student-timetable',
      3: '/student-news',
      4: '/student-profile',
    };
    if (routes.containsKey(index)) {
      Navigator.pushReplacementNamed(context, routes[index]!, arguments: {'userId': _studentId});
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAvg = _grades.isEmpty ? 0 : _grades.map((g) => g.diemTrungBinh).reduce((a, b) => a + b) / _grades.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B00)),
          onPressed: () => Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': _studentId}),
        ),
        title: const Text('Bảng điểm', style: TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFFFF6B00)), onPressed: () {})],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSemesterSelector(),
                const SizedBox(height: 16),
                _buildSummaryCard(totalAvg),
                const SizedBox(height: 24),
                const Text('Chi tiết từng môn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ..._grades.map((g) => _buildSubjectCard(g)),
              ],
            ),
          ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2, onTap: _onNavTap),
    );
  }

  Widget _buildSemesterSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFF6B00).withOpacity(0.2))),
      child: Row(
        children: [
          _buildSemesterBtn('HK1', _currentSemester == 'HK1'),
          _buildSemesterBtn('HK2', _currentSemester == 'HK2'),
        ],
      ),
    );
  }

  Widget _buildSemesterBtn(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            setState(() {
              _currentSemester = label;
              _isLoading = true;
            });
            _loadGrades();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: isSelected ? const Color(0xFFFF6B00) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double avg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF6B00), Color(0xFFA04100)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: const Color(0xFFFF6B00).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          Text('Kết quả Học kỳ 1', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
          const SizedBox(height: 4),
          Text(avg.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
          Text('ĐIỂM TRUNG BÌNH', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat('Xếp loại', 'Giỏi'),
                _buildSummaryStat('Hạnh kiểm', 'Tốt'),
                _buildSummaryStat('Thứ hạng', '5/42'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  Widget _buildSubjectCard(GradeModel grade) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(
        context,
        '/student-grades-detail',
        arguments: {'userId': _studentId, 'subject': grade.monHoc, 'semester': _currentSemester},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: _getSubjectColor(grade.monHoc).withOpacity(0.1), shape: BoxShape.circle),
              child: Center(
                child: Text(
                  grade.monHoc.isNotEmpty ? grade.monHoc[0] : '?',
                  style: TextStyle(color: _getSubjectColor(grade.monHoc), fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(grade.monHoc, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('ĐTB: ${grade.diemTrungBinh.toStringAsFixed(1)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          grade.xepLoaiHocLuc,
                          style: const TextStyle(color: Color(0xFF16A34A), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 8,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: grade.diemTrungBinh / 10, backgroundColor: const Color(0xFFF3F4F5), color: const Color(0xFFFF6B00)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'toán': return Colors.blue;
      case 'văn': return Colors.green;
      case 'tiếng anh': return Colors.red;
      case 'vật lý': return Colors.purple;
      case 'hóa học': return Colors.orange;
      default: return Colors.grey;
    }
  }
}
