import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class ChildAttendanceScreen extends StatelessWidget {
  const ChildAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return GuardianLayout(
      currentIndex: 1,
      title: 'Điểm danh',
      childId: childId,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('diem_danh')
            .where('hocSinhId', isEqualTo: childId)
            .where('loai', isEqualTo: 'hoc')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final records = snapshot.data!.docs.map((d) => d.data() as Map<String, dynamic>).toList();
          
          final absentCount = records.where((r) => r['trangThai'].toString().contains('vang')).length;
          final lateCount = records.where((r) => r['trangThai'] == 'muon').length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Bento
                const Text('TỔNG QUAN KỲ HỌC', style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildBentoCard('Tổng vắng', '$absentCount', 'buổi', Icons.event_busy, AppColors.errorContainer, AppColors.error)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildBentoCard('Đi muộn', '$lateCount', 'buổi', Icons.schedule, AppColors.surfaceAccent, AppColors.primaryContainer)),
                  ],
                ),
                const SizedBox(height: 24),

                const Text('Chi tiết điểm danh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final data = records[index];
                    return _buildAttendanceItem(data);
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBentoCard(String title, String value, String unit, IconData icon, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor.withOpacity(0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: bgColor.withOpacity(0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: textColor, size: 20), const SizedBox(width: 4), Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textMuted))]),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)), const SizedBox(width: 4), Text(unit, style: const TextStyle(fontSize: 12, color: AppColors.textMuted))],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(Map<String, dynamic> data) {
    final status = data['trangThai'];
    Color statusColor;
    String statusText;
    switch (status) {
      case 'co_mat': statusColor = AppColors.success; statusText = 'Đúng giờ'; break;
      case 'muon': statusColor = Colors.orange; statusText = 'Muộn'; break;
      case 'vang_co_phep': statusColor = AppColors.error; statusText = 'Vắng phép'; break;
      default: statusColor = AppColors.error; statusText = 'Vắng';
    }

    final date = (data['ngay'] as Timestamp).toDate();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.surfaceVariant)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(data['thu']?.substring(0, 2) ?? 'T2', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted)), Text('${date.day}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['loai'] == 'ktx' ? 'Điểm danh KTX' : 'Học tập • Tiết 1', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(data['gioVao']?.isNotEmpty == true ? '${data['gioVao']} - Checkin' : 'Không có giờ vào', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: statusColor.withOpacity(0.2))),
            child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
