import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/web/shared/web_dashboard_layout.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WebDashboardLayout(
      title: 'Tổng quan hệ thống',
      currentIndex: 0,
      menuItems: [
        WebSidebarItem(icon: Icons.dashboard, label: 'Overview', onTap: () {}),
        WebSidebarItem(icon: Icons.group, label: 'Students', onTap: () {}),
        WebSidebarItem(icon: Icons.school, label: 'Faculty', onTap: () {}),
        WebSidebarItem(icon: Icons.class_, label: 'Classes', onTap: () {}),
        WebSidebarItem(icon: Icons.analytics, label: 'Reports', onTap: () {}),
        WebSidebarItem(icon: Icons.settings, label: 'Settings', onTap: () {}),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chào mừng trở lại, xem nhanh các chỉ số quan trọng hôm nay.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            // Stats Grid
            Row(
              children: [
                _buildStatCard('Học sinh', '1,250', '+15 tháng này', Icons.group, Colors.blue),
                const SizedBox(width: 16),
                _buildStatCard('Giáo viên', '48', '+2 tháng này', Icons.school, Colors.green),
                const SizedBox(width: 16),
                _buildStatCard('Lớp học', '32', 'Đang hoạt động', Icons.class_, Colors.orange),
                const SizedBox(width: 16),
                _buildStatCard('Tài khoản', '1,298', '3 chờ duyệt', Icons.account_circle, Colors.indigo),
              ],
            ),
            const SizedBox(height: 24),
            
            // Main Content Area
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent Activity (65%)
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
                            const Text('Hoạt động gần đây', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildActivityTable(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                
                // Tasks & Quick Stats (35%)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildTasksCard(),
                      const SizedBox(height: 24),
                      _buildQuickStatsCard(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Icon(icon, color: color.withOpacity(0.5), size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(color: sub.contains('+') ? Colors.green : Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.5),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF3F4F5)))),
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('THỜI GIAN', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('NGƯỜI THỰC HIỆN', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('HÀNH ĐỘNG', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('TRẠNG THÁI', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))),
          ],
        ),
        _buildActivityRow('10:45, Hôm nay', 'Nguyễn Văn A', 'Thêm học sinh mới', 'Thành công', Colors.green),
        _buildActivityRow('09:12, Hôm nay', 'Lê Thị B', 'Cập nhật TKB', 'Thành công', Colors.green),
        _buildActivityRow('16:30, Hôm qua', 'Admin', 'Duyệt tài khoản', 'Lỗi đồng bộ', Colors.red),
        _buildActivityRow('14:20, Hôm qua', 'Trần Văn C', 'Phân công GV', 'Thành công', Colors.green),
      ],
    );
  }

  TableRow _buildActivityRow(String time, String user, String action, String status, Color statusColor) {
    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF3F4F5)))),
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(time, style: const TextStyle(fontSize: 13, color: Colors.grey))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(user, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(action, style: const TextStyle(fontSize: 13))),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }

  Widget _buildTasksCard() {
    return Container(
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
            children: [
              const Text('Cần xử lý', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: const Text('5', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTaskItem('Duyệt tài khoản mới', '3 GV, 2 Phụ huynh', Icons.person_add, AppColors.primaryContainer),
          _buildTaskItem('Giáo viên chưa có lớp', '2 GV bộ môn Thể dục', Icons.assignment_ind, Colors.indigo),
          _buildTaskItem('Học sinh chờ xếp lớp', '15 HS khối 10', Icons.groups, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String sub, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thống kê nhanh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildProgressStat('Tỷ lệ chuyên cần', 0.92, Colors.green),
          const SizedBox(height: 16),
          _buildProgressStat('ĐTB toàn trường', 0.81, AppColors.primaryContainer, label8: '8.1'),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, double value, Color color, {String? label8}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(label8 ?? '${(value * 100).toInt()}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
      ],
    );
  }
}
