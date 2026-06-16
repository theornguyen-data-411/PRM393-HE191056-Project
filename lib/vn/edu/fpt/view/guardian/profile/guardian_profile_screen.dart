import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class GuardianProfileScreen extends StatelessWidget {
  const GuardianProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const guardianId = 'ph_001'; // Demo ID
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return GuardianLayout(
      currentIndex: 4,
      title: 'Hồ sơ',
      childId: childId,
      showChildBanner: false,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('phu_huynh').doc(guardianId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) return const Center(child: Text('Không tìm thấy dữ liệu'));

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                // Header Profile
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 32),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text('PH', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryContainer)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['hoTen'],
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Lớp 11A1 • MSHS: HS001',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                      ),
                      Text(
                        'THPT FPT Đà Nẵng',
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Info Card
                      _buildProfileCard(
                        'Tài khoản',
                        [
                          _buildToggleRow(Icons.notifications, 'Cài đặt thông báo', true),
                          _buildActionRow(Icons.lock, 'Đổi mật khẩu'),
                          _buildActionRow(Icons.language, 'Ngôn ngữ: Tiếng Việt'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Logout Button
                      OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Đăng xuất'),
                              content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                                  },
                                  child: const Text('Đăng xuất', style: TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Đăng xuất'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleRow(IconData icon, String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryContainer, size: 20),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Switch(value: value, onChanged: (v) {}, activeColor: AppColors.primaryContainer),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryContainer, size: 20),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
