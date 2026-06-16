import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/guardian_bottom_nav_bar.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/child_banner.dart';

class GuardianLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final String title;
  final bool showChildBanner;
  final String childId;

  const GuardianLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.title,
    this.showChildBanner = true,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    const guardianId = 'ph_001'; // Demo

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryContainer),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Nếu là màn hình root của BottomNav, nhấn back sẽ quay về chọn con
              Navigator.pushReplacementNamed(context, '/select-child');
            }
          },
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('phu_huynh').doc(guardianId).snapshots(),
          builder: (context, snapshot) {
            String name = '...';
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              name = data?['hoTen'] ?? 'Phụ huynh';
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Xin chào,', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryContainer),
                ),
              ],
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              radius: 18,
              child: const Text('PH', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(showChildBanner ? 56 : 0),
          child: showChildBanner
              ? StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('hoc_sinh').doc(childId).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final childData = snapshot.data!.data() as Map<String, dynamic>?;
                    if (childData == null) return const SizedBox.shrink();
                    return ChildBanner(
                      childName: childData['hoTen'],
                      className: 'Lớp ${childData['tenLop']}',
                      onSwitchChild: () => Navigator.pushNamed(context, '/select-child'),
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: body,
      bottomNavigationBar: GuardianBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
          String route = '/';
          switch (index) {
            case 0: route = '/guardian-dashboard'; break;
            case 1: route = '/guardian-grades'; break;
            case 2: route = '/guardian-dormitory'; break;
            case 3: route = '/guardian-chat'; break;
            case 4: route = '/guardian-profile'; break;
          }
          Navigator.pushReplacementNamed(context, route, arguments: childId);
        },
      ),
    );
  }
}
