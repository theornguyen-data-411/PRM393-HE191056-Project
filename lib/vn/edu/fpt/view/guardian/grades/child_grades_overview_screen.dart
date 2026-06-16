import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class ChildGradesOverviewScreen extends StatelessWidget {
  const ChildGradesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return GuardianLayout(
      currentIndex: 1,
      title: 'Bảng điểm',
      childId: childId,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Gradient Card
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('tong_ket_hk').doc('tk_${childId}_HK1_2024').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryContainer, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      const Text('Kết quả HK1 của An', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('${data['dtbCaHocKy'] ?? '8.2'}', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildScoreItem('98%', 'Chuyên cần'),
                            _buildVerticalDivider(),
                            _buildScoreItem('${data['dtbCaHocKy'] ?? '8.2'}', 'ĐTB'),
                            _buildVerticalDivider(),
                            _buildScoreItem('${data['xepLoaiHanhKiem'] ?? 'Tốt'}', 'Hạnh kiểm'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Comparison Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bar_chart, color: AppColors.textMuted, size: 16),
                  SizedBox(width: 8),
                  Text('ĐTB lớp 11A1: 7.8', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  Spacer(),
                  Icon(Icons.trending_up, color: AppColors.success, size: 16),
                  SizedBox(width: 4),
                  Text('Con bạn đang học tốt hơn trung bình lớp', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Chi tiết điểm môn học', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Subject List
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bang_diem')
                  .where('hocSinhId', isEqualTo: childId)
                  .where('hocKy', isEqualTo: 'HK1')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final grades = snapshot.data!.docs;

                if (grades.isEmpty) return const Center(child: Text('Chưa có dữ liệu điểm'));

                return Column(
                  children: grades.map((doc) {
                    final grade = doc.data() as Map<String, dynamic>;
                    return _buildSubjectRow(
                      context,
                      grade['monHoc'],
                      grade['tenGiaoVien'],
                      grade['diemTrungBinh'].toDouble(),
                      grade['mauSac'] ?? '#405e92',
                      childId,
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String value, String label) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 32, color: Colors.white30);
  }

  Widget _buildSubjectRow(BuildContext context, String subject, String teacher, double score, String hexColor, String childId) {
    final color = Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/guardian-grades-detail', arguments: {'childId': childId, 'subject': subject}),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceVariant),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
          ),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(Icons.calculate, color: color)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('GV: $teacher', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$score', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Row(
                    children: [
                      Icon(Icons.arrow_upward, color: AppColors.success, size: 12),
                      SizedBox(width: 4),
                      Text('+0.2', style: TextStyle(color: AppColors.success, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
