import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';

class GuardianNewsScreen extends StatefulWidget {
  const GuardianNewsScreen({super.key});

  @override
  State<GuardianNewsScreen> createState() => _GuardianNewsScreenState();
}

class _GuardianNewsScreenState extends State<GuardianNewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';

    return GuardianLayout(
      currentIndex: 3,
      title: 'Thông báo',
      childId: childId,
      showChildBanner: false,
      body: Column(
        children: [
          // Custom Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                const Text('Thông báo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.notifications, color: Colors.white)),
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryContainer,
              labelColor: AppColors.primaryContainer,
              unselectedLabelColor: AppColors.textMuted,
              tabs: const [
                Tab(text: 'Thông báo'),
                Tab(text: 'Tin tức'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationList(childId),
                _buildNewsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(String childId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('thong_bao_push').where('userId', isEqualTo: 'ph_001').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final items = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final data = items[index].data() as Map<String, dynamic>;
            return _buildNotificationItem(data);
          },
        );
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: AppColors.primaryContainer, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.surfaceAccent, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant)),
                child: Text(data['loai'] ?? 'Học tập', style: const TextStyle(color: AppColors.primaryContainer, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const Text('2 giờ trước', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 8),
          Text(data['tieuDe'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(data['noiDung'], style: const TextStyle(fontSize: 13, color: AppColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tin_tuc').orderBy('ngayDang', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final items = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final data = items[index].data() as Map<String, dynamic>;
            return _buildNewsItem(data);
          },
        );
      },
    );
  }

  Widget _buildNewsItem(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
            child: Text(data['danhMuc'] ?? 'Tin tức', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
          ),
          const SizedBox(height: 8),
          Text(data['tieuDe'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(data['noiDung'], style: const TextStyle(fontSize: 13, color: AppColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
