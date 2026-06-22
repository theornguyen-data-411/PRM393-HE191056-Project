import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class ChildDormitoryScreen extends StatelessWidget {
  const ChildDormitoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return GuardianLayout(
      currentIndex: 2,
      title: 'Ký túc xá',
      childId: childId,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ky_tuc_xa')
            .doc('ktx_$childId')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) return const Center(child: Text('Học sinh không ở nội trú'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check-in Status Card
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('diem_danh')
                      .where('hocSinhId', isEqualTo: childId)
                      .where('loai', isEqualTo: 'ktx')
                      .where('ngayString', isEqualTo: '2025-06-02') // Mock check
                      .snapshots(),
                  builder: (context, ddSnapshot) {
                    final isChecked = ddSnapshot.hasData && ddSnapshot.data!.docs.isNotEmpty;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: (isChecked ? AppColors.success : Colors.orange).withOpacity(0.1), shape: BoxShape.circle),
                            child: Icon(isChecked ? Icons.check_circle : Icons.pending, color: isChecked ? AppColors.success : Colors.orange, size: 40),
                          ),
                          const SizedBox(height: 16),
                          Text(isChecked ? 'Đã điểm danh tối' : 'Chưa điểm danh tối', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          if (isChecked) Text('Lúc ${(ddSnapshot.data!.docs.first.data() as Map)['gioVao']}', style: const TextStyle(color: AppColors.textMuted)),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Room Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primaryContainer, AppColors.primary]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phòng ${data['soPhong']}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Tầng ${data['tang']} • Dãy ${data['day']} • ${data['khu']}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)), child: const Text('Nội trú', style: TextStyle(color: Colors.white, fontSize: 11))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Leave History
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('xin_phep_ktx').where('hocSinhId', isEqualTo: childId).limit(1).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox.shrink();
                    final leave = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Xin phép về nhà', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${leave['tuNgayString']} - ${leave['denNgayString']}', style: const TextStyle(fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                child: Row(children: [Text(leave['trangThai'] == 'da_duyet' ? 'Đã duyệt' : 'Chờ', style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)), const Icon(Icons.check, color: AppColors.success, size: 12)]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Roommates
                const Text('Bạn cùng phòng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: (data['banPhong'] as List).length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final roommate = data['banPhong'][index];
                      return Column(
                        children: [
                          const CircleAvatar(radius: 26, backgroundColor: AppColors.surfaceVariant, child: Icon(Icons.person, color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          Text(roommate['hoTen'].split(' ').last, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Contact
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
                  child: Column(
                    children: [
                      _buildContactRow(Icons.call, 'Hotline KTX', data['sdtQuanLy'] ?? '024 3998 5678'),
                      const Divider(height: 24),
                      _buildContactRow(Icons.person, 'Quản lý', data['quanLyKtx'] ?? 'Nguyễn Văn X'),
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

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: AppColors.surface, child: Icon(icon, color: AppColors.primaryContainer, size: 20)),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
      ],
    );
  }
}
