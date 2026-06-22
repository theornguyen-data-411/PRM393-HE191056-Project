import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class ChildGradesDetailScreen extends StatelessWidget {
  const ChildGradesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    final String childId = args['childId'] ?? 'hs_001';
    final String subject = args['subject'] ?? 'Toán';

    return GuardianLayout(
      currentIndex: 1,
      title: 'Chi tiết môn học',
      childId: childId,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bang_diem')
            .doc('bd_${childId}_HK1_${subject.replaceAll(' ', '_')}')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) return const Center(child: Text('Không tìm thấy dữ liệu điểm'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject Header Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(subject, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.white70, size: 16),
                                  const SizedBox(width: 4),
                                  Text('GV: ${data['tenGiaoVien']}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              data['xepLoai'] ?? 'Giỏi',
                              style: const TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Trung bình môn', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text('${data['diemTrungBinh']}', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Icon(Icons.trending_up, color: AppColors.success, size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Detailed Score Table
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.surfaceVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bảng điểm chi tiết', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildDetailRow('Miệng (HS 1)', (data['diemMieng'] as List? ?? [])),
                      _buildDetailRow('15 phút (HS 1)', (data['diem15Phut'] as List? ?? [])),
                      _buildDetailRow('1 tiết (HS 2)', (data['diem1Tiet'] as List? ?? []), isHS2: true),
                      _buildSummaryRow('Giữa kỳ (HS 2)', data['diemGiuaKy']?.toDouble() ?? 0.0, isHS2: true),
                      _buildSummaryRow('Cuối kỳ (HS 3)', data['diemCuoiKy']?.toDouble() ?? 0.0, isFinal: true),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Trung bình môn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('${data['diemTrungBinh']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primaryContainer)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, List scores, {bool isHS2 = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: scores.map((s) => Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isHS2 ? AppColors.surfaceAccent : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isHS2 ? AppColors.outlineVariant : AppColors.surfaceVariant),
              ),
              child: Text('$s', style: TextStyle(fontWeight: FontWeight.w600, color: isHS2 ? AppColors.primaryContainer : AppColors.textMain)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double score, {bool isHS2 = false, bool isFinal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isFinal ? AppColors.textMain : AppColors.textMuted, fontWeight: isFinal ? FontWeight.bold : FontWeight.normal)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isFinal ? AppColors.primaryContainer : (isHS2 ? AppColors.surfaceAccent : AppColors.surface),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$score',
              style: TextStyle(fontWeight: FontWeight.bold, color: isFinal ? Colors.white : (isHS2 ? AppColors.primaryContainer : AppColors.textMain)),
            ),
          ),
        ],
      ),
    );
  }
}
