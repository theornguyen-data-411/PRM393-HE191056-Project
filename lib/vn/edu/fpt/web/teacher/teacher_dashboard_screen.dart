import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/web/shared/web_dashboard_layout.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WebDashboardLayout(
      title: 'Tổng quan giáo viên',
      currentIndex: 0,
      menuItems: [
        WebSidebarItem(icon: Icons.dashboard, label: 'Tổng quan', onTap: () {}),
        WebSidebarItem(icon: Icons.school, label: 'Lớp học', onTap: () {}),
        WebSidebarItem(icon: Icons.fact_check, label: 'Điểm danh', onTap: () {}),
        WebSidebarItem(icon: Icons.edit_document, label: 'Nhập điểm', onTap: () {}),
        WebSidebarItem(icon: Icons.calendar_month, label: 'Thời khóa biểu', onTap: () {}),
        WebSidebarItem(icon: Icons.person, label: 'Hồ sơ', onTap: () {}),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                _buildStatCard('Lớp phụ trách', '3', Icons.class_, Colors.indigo),
                const SizedBox(width: 16),
                _buildStatCard('Học sinh', '126', Icons.group, Colors.blue),
                const SizedBox(width: 16),
                _buildStatCard('Tiết dạy hôm nay', '4', Icons.schedule, AppColors.primaryContainer),
                const SizedBox(width: 16),
                _buildStatCard('Chưa nhập điểm', '2', Icons.assignment_late, Colors.red),
              ],
            ),
            const SizedBox(height: 24),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Schedule (2/3)
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Lịch trình hôm nay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildScheduleItem('Tiết 1', '07:30', 'Đại số & Giải tích', 'Toán 11A1', 'P.101', AppColors.primaryContainer),
                        _buildScheduleItem('Tiết 2', '08:20', 'Hình học', 'Toán 11A2', 'P.102', Colors.indigo, isCurrent: true),
                        _buildScheduleItem('Tiết 4', '10:10', 'Vật lý Đại cương', 'Vật lý 11B1', 'P.301', Colors.green),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                
                // Tasks (1/3)
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Việc cần làm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildTaskItem('Điểm danh lớp 11A2', 'Quá hạn 1 giờ', true),
                        _buildTaskItem('Nhập điểm 15p lớp 11A1', 'Hạn: Hôm nay, 17:00', false),
                        _buildTaskItem('Trả lời tin nhắn PHHS (3)', 'Sổ liên lạc điện tử', false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String period, String time, String title, String className, String room, Color color, {bool isCurrent = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.surfaceAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCurrent ? AppColors.primaryContainer.withOpacity(0.2) : const Color(0xFFF3F4F5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(period, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                Text(time, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isCurrent ? AppColors.primaryContainer : Colors.indigo)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(className, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: const Text('ĐANG DIỄN RA', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE1E3E4))),
            child: Row(
              children: [
                const Icon(Icons.meeting_room, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(room, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String sub, bool isAlert) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: false, onChanged: (v) {}, activeColor: AppColors.primaryContainer),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    if (isAlert) const Icon(Icons.warning, size: 12, color: Colors.red),
                    if (isAlert) const SizedBox(width: 4),
                    Text(sub, style: TextStyle(fontSize: 11, color: isAlert ? Colors.red : Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
