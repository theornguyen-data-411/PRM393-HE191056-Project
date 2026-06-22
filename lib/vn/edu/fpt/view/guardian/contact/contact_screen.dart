import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return GuardianLayout(
      currentIndex: 3,
      title: 'Liên lạc',
      childId: childId,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('lien_lac').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final contacts = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

          final gvcn = contacts.firstWhere((c) => c['nhom'] == 'gvcn', orElse: () => {});
          final bgh = contacts.where((c) => c['nhom'] == 'bgh').toList();
          final phongBan = contacts.where((c) => c['nhom'] == 'phong_ban').toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GVCN Card
                if (gvcn.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.school, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Giáo viên chủ nhiệm', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(gvcn['hoTen'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text('Lớp 11A1', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.call, size: 18),
                                label: const Text('Gọi điện'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.chat, size: 18),
                                label: const Text('Nhắn tin'),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.surfaceVariant)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.surfaceVariant)),
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionHeader('Ban Giám Hiệu'),
                const SizedBox(height: 8),
                Column(children: bgh.map((c) => _buildContactItem(c)).toList()),

                const SizedBox(height: 24),
                _buildSectionHeader('Phòng ban'),
                const SizedBox(height: 8),
                Column(children: phongBan.map((c) => _buildDeptItem(c)).toList()),

                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surfaceVariant.withOpacity(0.5),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildContactItem(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: AppColors.primaryContainer, child: Text(data['hoTen'][0], style: const TextStyle(color: Colors.white))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['hoTen'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(data['chucVu'], style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: AppColors.primaryContainer, size: 20)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat, color: AppColors.primaryContainer, size: 20)),
        ],
      ),
    );
  }

  Widget _buildDeptItem(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.tertiary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.menu_book, color: AppColors.tertiary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['hoTen'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(data['soDienThoai'], style: const TextStyle(fontSize: 12, color: AppColors.primaryContainer, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: AppColors.primaryContainer, size: 20)),
        ],
      ),
    );
  }
}
