import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/web/shared/web_dashboard_layout.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';

class AdminAccountManagementScreen extends StatefulWidget {
  const AdminAccountManagementScreen({super.key});

  @override
  State<AdminAccountManagementScreen> createState() => _AdminAccountManagementScreenState();
}

class _AdminAccountManagementScreenState extends State<AdminAccountManagementScreen> {
  String _selectedRole = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    return WebDashboardLayout(
      title: 'Quản lý tài khoản',
      currentIndex: 1, // Let's say index 1 is for Accounts/Users
      menuItems: [
        WebSidebarItem(icon: Icons.dashboard, label: 'Overview', onTap: () => Navigator.pushReplacementNamed(context, '/admin-dashboard')),
        WebSidebarItem(icon: Icons.account_balance_wallet, label: 'Tài khoản', onTap: () {}),
        WebSidebarItem(icon: Icons.school, label: 'Classes', onTap: () {}),
        WebSidebarItem(icon: Icons.analytics, label: 'Reports', onTap: () {}),
      ],
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header & Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Danh sách người dùng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo tài khoản'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Filters
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  _buildDropdown('Vai trò', ['Tất cả', 'admin', 'giao_vien', 'hoc_sinh', 'phu_huynh']),
                  const SizedBox(width: 16),
                  _buildDropdown('Trạng thái', ['Tất cả', 'Hoạt động', 'Chờ kích hoạt']),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm tên/email...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FA),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _selectedRole == 'Tất cả' 
                      ? FirebaseFirestore.instance.collection('users').snapshots()
                      : FirebaseFirestore.instance.collection('users').where('vaiTro', isEqualTo: _selectedRole).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final users = snapshot.data!.docs;
                    
                    return SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
                        columns: const [
                          DataColumn(label: Text('TÊN')),
                          DataColumn(label: Text('EMAIL')),
                          DataColumn(label: Text('VAI TRÒ')),
                          DataColumn(label: Text('SĐT')),
                          DataColumn(label: Text('TRẠNG THÁI')),
                          DataColumn(label: Text('THAO TÁC')),
                        ],
                        rows: users.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return DataRow(cells: [
                            DataCell(Text(data['hoTen'] ?? '...', style: const TextStyle(fontWeight: FontWeight.w500))),
                            DataCell(Text(data['email'] ?? '...')),
                            DataCell(_buildRoleBadge(data['vaiTro'])),
                            DataCell(Text(data['soDienThoai'] ?? '...')),
                            DataCell(_buildStatusBadge(data['isActive'] ?? true)),
                            DataCell(Row(
                              children: [
                                IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue)),
                                IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red)),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: label == 'Vai trò' ? _selectedRole : 'Tất cả',
          items: options.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: (v) {
            if (label == 'Vai trò') setState(() => _selectedRole = v!);
          },
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String? role) {
    Color color = Colors.grey;
    String text = role ?? 'User';
    switch (role) {
      case 'admin': color = Colors.red; text = 'Admin'; break;
      case 'giao_vien': color = Colors.orange; text = 'Giáo viên'; break;
      case 'hoc_sinh': color = Colors.blue; text = 'Học sinh'; break;
      case 'phu_huynh': color = Colors.green; text = 'Phụ huynh'; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: isActive ? Colors.green : Colors.grey, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(isActive ? 'Hoạt động' : 'Khóa', style: TextStyle(color: isActive ? Colors.green : Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
