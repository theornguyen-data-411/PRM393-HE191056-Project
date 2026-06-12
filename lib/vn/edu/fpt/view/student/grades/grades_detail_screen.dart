import 'package:flutter/material.dart';
import '../../../model/grade_model.dart';
import '../../../service/grade_service.dart';
import '../../../component/bottom_nav_bar.dart';

class GradesDetailScreen extends StatefulWidget {
  const GradesDetailScreen({super.key});

  @override
  State<GradesDetailScreen> createState() => _GradesDetailScreenState();
}

class _GradesDetailScreenState extends State<GradesDetailScreen> {
  final GradeService _gradeService = GradeService();
  GradeModel? _grade;
  bool _isLoading = true;
  String _studentId = 'hs_001';
  String _semester = 'HK1';
  String _subject = 'Toán';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _studentId = args?['userId'] as String? ?? 'hs_001';
      _subject = args?['subject'] as String? ?? 'Toán';
      _semester = args?['semester'] as String? ?? 'HK1';
      _loadGrade();
    });
  }

  Future<void> _loadGrade() async {
    try {
      final data = await _gradeService.getGradeBySubject(_studentId, _semester, _subject);
      setState(() {
        _grade = data;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_grade == null) return Scaffold(appBar: AppBar(), body: const Center(child: Text('Không tìm thấy dữ liệu')));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B00),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/student-grades', arguments: {'userId': _studentId}),
        ),
        title: Text('Chi tiết - Môn ${_grade!.monHoc}', style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildGradeBreakdownCard(),
            const SizedBox(height: 16),
            _buildFormulaCard(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2, onTap: (i){}),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF6B00), Color(0xFFCC5500)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: const Color(0xFFFF6B00).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_grade!.monHoc, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const Text('GV: Nguyễn Thị Bình', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)), child: Text(_grade!.xepLoaiHocLuc, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              const Text('ĐTB', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(_grade!.diemTrungBinh.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.format_list_bulleted, color: Color(0xFFFF6B00), size: 18), SizedBox(width: 8), Text('Bảng điểm chi tiết', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF6B00)))]),
          const SizedBox(height: 16),
          _buildGradeRow('Điểm miệng', '(HS 1)', _grade!.diemMieng, const Color(0xFFFFF3E8), const Color(0xFFFF6B00)),
          const Divider(),
          _buildGradeRow('Điểm 15 phút', '(HS 1)', _grade!.diem15Phut, const Color(0xFFD0E4FF), const Color(0xFF0062A1)),
          const Divider(),
          _buildGradeRow('Điểm 1 tiết', '(HS 2)', _grade!.diem1Tiet, const Color(0xFFE8F5E9), const Color(0xFF28A745)),
          const Divider(),
          _buildGradeRow('Điểm giữa kỳ', '(HS 2)', [_grade!.diemGiuaKy], const Color(0xFFF3E5F5), const Color(0xFF8E24AA)),
          const Divider(),
          _buildGradeRow('Điểm cuối kỳ', '(HS 3)', [_grade!.diemCuoiKy], const Color(0xFFFFEBEE), const Color(0xFFDC3545)),
          const SizedBox(height: 16),
          const Divider(thickness: 2, color: Color(0xFFFF6B00)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Điểm trung bình môn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF6B00))),
              Text(_grade!.diemTrungBinh.toStringAsFixed(1), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFFFF6B00))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeRow(String label, String hs, List<double> scores, Color bg, Color text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(text: TextSpan(children: [TextSpan(text: label, style: const TextStyle(color: Colors.grey, fontSize: 14)), const TextSpan(text: ' '), TextSpan(text: hs, style: const TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic))])),
          Wrap(
            spacing: 8,
            children: scores.map((s) => Container(width: 36, height: 36, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)), child: Center(child: Text(s.toStringAsFixed(s % 1 == 0 ? 0 : 1), style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 13))))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F5), borderRadius: BorderRadius.circular(12)),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.push_pin, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Công thức tính', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('(Σ ĐMiệng×1 + Σ Đ15p×1 + Σ Đ1tiết×2 + ĐGK×2 + ĐCK×3) ÷ Tổng hệ số', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
