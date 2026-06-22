import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const guardianId = 'ph_001'; // Demo ID
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return GuardianLayout(
      currentIndex: 3,
      title: 'Tin nhắn',
      childId: childId,
      showChildBanner: false,
      body: Column(
        children: [
          // Custom App Bar for Chat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                const Text('Tin nhắn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit_square, color: AppColors.primaryContainer)),
              ],
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm cuộc trò chuyện',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.surfaceVariant)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.surfaceVariant)),
              ),
            ),
          ),

          // Chat List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cuoc_tro_chuyen')
                  .where('thanhVien', arrayContains: guardianId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final chats = snapshot.data!.docs;

                if (chats.isEmpty) return const Center(child: Text('Chưa có cuộc trò chuyện nào'));

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: chats.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final data = chats[index].data() as Map<String, dynamic>;
                    return _buildChatItem(context, data, guardianId, childId);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, Map<String, dynamic> data, String myId, String childId) {
    final otherId = (data['thanhVien'] as List).firstWhere((id) => id != myId);
    final otherName = data['tenThanhVien'][otherId];
    final otherRole = data['vaiTroThanhVien'][otherId];
    final unreadCount = data['soTinChuaDoc'][myId] ?? 0;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/guardian-chat-detail', arguments: {'chatId': data['chatId'], 'childId': childId, 'otherName': otherName}),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.surfaceVariant,
                  child: Text(otherName[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.success, border: Border.all(color: Colors.white, width: 2), shape: BoxShape.circle)),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$otherName (${otherRole == 'giao_vien' ? 'GVCN' : 'Admin'})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const Text('2 giờ', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['tinNhanCuoi'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: unreadCount > 0 ? AppColors.textMain : AppColors.textMuted, fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal),
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(10)),
                          child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
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
