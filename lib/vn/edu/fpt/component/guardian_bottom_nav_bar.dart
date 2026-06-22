import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';

class GuardianBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GuardianBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(0, Icons.home, 'Trang chủ'),
              _buildItem(1, Icons.school, 'Học tập'),
              _buildItem(2, Icons.domain, 'KTX'),
              _buildItem(3, Icons.chat_bubble, 'Liên lạc'),
              _buildItem(4, Icons.person, 'Hồ sơ'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index, IconData icon, String label) {
    final bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primaryContainer : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? AppColors.primaryContainer : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
