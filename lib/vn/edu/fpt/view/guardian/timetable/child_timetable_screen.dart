import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class ChildTimetableScreen extends StatefulWidget {
  const ChildTimetableScreen({super.key});

  @override
  State<ChildTimetableScreen> createState() => _ChildTimetableScreenState();
}

class _ChildTimetableScreenState extends State<ChildTimetableScreen> {
  int selectedDayIndex = 0;
  final List<String> days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6'];
  final List<String> dayShort = ['T2', 'T3', 'T4', 'T5', 'T6'];

  @override
  Widget build(BuildContext context) {
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('hoc_sinh').doc(childId).get(),
      builder: (context, studentSnapshot) {
        if (!studentSnapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        
        final studentData = studentSnapshot.data!.data() as Map<String, dynamic>;
        final lopId = studentData['lopId'];
        final tkbId = 'tkb_${lopId}_HK1_2024';

        return GuardianLayout(
          currentIndex: 1,
          title: 'Thời khóa biểu',
          childId: childId,
          body: Column(
            children: [
              // Day Selector
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final isSelected = selectedDayIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedDayIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryContainer : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected ? [BoxShadow(color: AppColors.primaryContainer.withOpacity(0.3), blurRadius: 4)] : null,
                        ),
                        child: Text(
                          dayShort[index],
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('thoi_khoa_bieu')
                      .doc(tkbId)
                      .collection('tiet_hoc')
                      .where('thuSo', isEqualTo: selectedDayIndex + 2)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final periods = snapshot.data!.docs;

                    if (periods.isEmpty) {
                      return const Center(child: Text('Chưa có lịch học cho ngày này'));
                    }

                    final sortedDocs = periods.toList()..sort((a, b) => (a['tietSo'] as String).compareTo(b['tietSo'] as String));

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: sortedDocs.length,
                      itemBuilder: (context, index) {
                        final data = sortedDocs[index].data() as Map<String, dynamic>;
                        return _buildTimetableCard(data);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildTimetableCard(Map<String, dynamic> data) {
    final color = Color(int.parse((data['mauSac'] ?? '#405e92').replaceFirst('#', '0xFF')));
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tiết ${data['tietSo']}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 4),
                Text(data['gioVao'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(data['gioRa'], style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
            const VerticalDivider(width: 32, thickness: 1, indent: 4, endIndent: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data['monHoc'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.surfaceAccent, borderRadius: BorderRadius.circular(8)),
                        child: Text(data['phong'] ?? 'P.101', style: const TextStyle(fontSize: 11, color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text('GV: ${data['tenGiaoVien']}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
