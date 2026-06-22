import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    final String chatId = args['chatId'] ?? 'chat_ph001_gv001';
    final String otherName = args['otherName'] ?? 'Nguyễn Thị Bình';
    const myId = 'ph_001';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primaryContainer), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceVariant, child: Text(otherName[0])),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(otherName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const Text('GVCN lớp 11A1', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: AppColors.primaryContainer))],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cuoc_tro_chuyen')
                  .doc(chatId)
                  .collection('tin_nhan')
                  .orderBy('taoLuc', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final bool isMe = data['nguoiGuiId'] == myId;
                    return _buildMessageBubble(data, isMe);
                  },
                );
              },
            ),
          ),
          _buildInputBar(chatId, myId),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> data, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryContainer : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
          border: isMe ? null : Border.all(color: AppColors.surfaceVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(data['noiDung'], style: TextStyle(color: isMe ? Colors.white : AppColors.textMain, fontSize: 14)),
            const SizedBox(height: 4),
            Text('08:20', style: TextStyle(color: isMe ? Colors.white70 : AppColors.textMuted, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(String chatId, String myId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.surfaceVariant))),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file, color: AppColors.primaryContainer)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.surfaceVariant)),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(hintText: 'Nhắn tin...', border: InputBorder.none, isDense: true),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: IconButton(
                onPressed: () {
                  if (_messageController.text.trim().isEmpty) return;
                  // Gửi tin nhắn lên Firebase (Mock)
                  _messageController.clear();
                },
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
