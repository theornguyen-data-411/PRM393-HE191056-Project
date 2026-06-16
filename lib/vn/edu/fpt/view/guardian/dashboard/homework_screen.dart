import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class GuardianHomeworkScreen extends StatelessWidget {
  const GuardianHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('hoc_sinh').doc(childId).get(),
      builder: (context, studentSnapshot) {
        if (!studentSnapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        
        final studentData = studentSnapshot.data!.data() as Map<String, dynamic>;
        final lopId = studentData['lopId'];

        return GuardianLayout(
          currentIndex: 1,
          title: 'Bài tập',
          childId: childId,
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('bai_tap')
                .where('lopId', isEqualTo: lopId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Đã có lỗi xảy ra'));
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              
              final items = snapshot.data!.docs;
              if (items.isEmpty) return const Center(child: Text('Chưa có bài tập nào cho lớp này'));

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final data = items[index].data() as Map<String, dynamic>;
                  return _buildHomeworkItem(data);
                },
              );
            },
          ),
        );
      }
    );
  }

  Widget _buildHomeworkItem(Map<String, dynamic> data) {
    final status = data['trangThai'];
    Color statusColor;
    String statusText;
    switch (status) {
      case 'da_nop':
        statusColor = AppColors.success;
        statusText = 'Đã nộp';
        break;
      case 'qua_han':
        statusColor = AppColors.error;
        statusText = 'Quá hạn';
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Chưa nộp';
    }

    final color = Color(int.parse((data['mauSac'] ?? '#ff6b00').replaceFirst('#', '0xFF')));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(data['monHoc'], style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(data['tieuDe'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(data['moTa'], style: const TextStyle(fontSize: 13, color: AppColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text('Hạn: ${data['hanNopString']}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
              Text('GV: ${data['tenGiaoVien']}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontStyle: FontStyle.italic)),
            ],
          ),
        ],
      ),
    );
  }
}
