import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class GuardianDashboardScreen extends StatelessWidget {
  const GuardianDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return GuardianLayout(
      currentIndex: 0,
      title: 'Trang chủ',
      childId: childId,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('hoc_sinh').doc(childId).snapshots(),
        builder: (context, studentSnapshot) {
          if (!studentSnapshot.hasData) return const Center(child: CircularProgressIndicator());
          final studentData = studentSnapshot.data!.data() as Map<String, dynamic>? ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 28, backgroundColor: AppColors.surfaceAccent, child: Icon(Icons.person, color: AppColors.primaryContainer)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lớp ${studentData['tenLop'] ?? '...'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Năm học ${studentData['namHoc'] ?? '...'}', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                            Text('MSHV: ${studentData['maHocSinh'] ?? '...'}', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.surfaceAccent, borderRadius: BorderRadius.circular(12)),
                        child: const Text('Học sinh', style: TextStyle(color: AppColors.primaryContainer, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Today's Schedule
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, color: AppColors.primaryContainer, size: 18),
                              const SizedBox(width: 8),
                              Text('Hôm nay - ${_formatDayOfWeek()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/guardian-timetable', arguments: childId),
                            child: const Text('Xem TKB', style: TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('thoi_khoa_bieu')
                            .doc('tkb_${studentData['lopId']}_HK1_2024')
                            .collection('tiet_hoc')
                            .where('thuSo', isEqualTo: DateTime.now().weekday + 1 > 7 ? 2 : DateTime.now().weekday + 1)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          final docs = snapshot.data!.docs;
                          if (docs.isEmpty) return const Text('Không có lịch học hôm nay');
                          
                          // Sort periods by tietSo
                          final periods = docs.toList();
                          periods.sort((a, b) => (a.data() as Map)['tietSo'].toString().compareTo((b.data() as Map)['tietSo'].toString()));

                          return Column(
                            children: periods.map((p) {
                              final data = p.data() as Map<String, dynamic>;
                              return _ScheduleItem(
                                time: '${data['gioVao']} - ${data['gioRa']}',
                                tietSo: data['tietSo']?.toString() ?? '',
                                subject: data['monHoc'],
                                teacher: data['tenGiaoVien'] ?? data['giaoVien'] ?? '',
                                room: data['phong'],
                                color: Color(int.parse((data['mauSac'] ?? '#ff6b00').replaceFirst('#', '0xFF'))),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Stats Row
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('tong_ket_hk').doc('tk_${childId}_HK1_2024').snapshots(),
                  builder: (context, snapshot) {
                    final summary = snapshot.hasData ? (snapshot.data!.data() as Map<String, dynamic>?) : null;
                    return Row(
                      children: [
                        _buildStatBox('Điểm danh', '0%', 'Tháng này', AppColors.success),
                        const SizedBox(width: 8),
                        _buildStatBox('ĐTB HK1', '${summary?['dtbCaHocKy'] ?? '8.3'}', summary?['xepLoaiHocLuc'] ?? 'Giỏi', AppColors.primaryContainer),
                        const SizedBox(width: 8),
                        _buildStatBox('Bài tập', '2', 'Chưa nộp', AppColors.error),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),

                const Text('Truy cập nhanh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A3C6E))),
                const SizedBox(height: 12),

                // Quick Access Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.1,
                  children: [
                    _buildQuickAccessItem(context, Icons.calendar_today, 'Thời khóa biểu', '/guardian-timetable', childId),
                    _buildQuickAccessItem(context, Icons.bar_chart, 'Bảng điểm', '/guardian-grades', childId),
                    _buildQuickAccessItem(context, Icons.checklist, 'Điểm danh', '/guardian-attendance', childId),
                    _buildQuickAccessItem(context, Icons.domain, 'Ký túc xá', '/guardian-dormitory', childId),
                    _buildQuickAccessItem(context, Icons.assignment, 'Bài tập', '/guardian-homework', childId),
                    _buildQuickAccessItem(context, Icons.payments, 'Học phí', '/guardian-tuition', childId),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDayOfWeek() {
    final weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
    return weekdays[DateTime.now().weekday - 1];
  }

  Widget _buildStatBox(String title, String value, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(BuildContext context, IconData icon, String label, String route, String childId) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route, arguments: childId),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryContainer, size: 24),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String tietSo;
  final String subject;
  final String teacher;
  final String room;
  final Color color;
  const _ScheduleItem({required this.time, required this.tietSo, required this.subject, required this.teacher, required this.room, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(width: 3, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tiết $tietSo: $subject', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('GV: ${teacher.isNotEmpty ? teacher.split(' ').last : '...'} • Phòng $room', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)),
            child: Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
