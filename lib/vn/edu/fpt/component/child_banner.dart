import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';

class ChildBanner extends StatelessWidget {
  final String childName;
  final String className;
  final String? imageUrl;
  final VoidCallback onSwitchChild;

  const ChildBanner({
    super.key,
    required this.childName,
    required this.className,
    this.imageUrl,
    required this.onSwitchChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceAccent,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                ? NetworkImage(imageUrl!)
                : null,
            backgroundColor: AppColors.primaryContainer,
            child: imageUrl == null || imageUrl!.isEmpty
                ? Text(
                    childName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$childName • $className',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textMain,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onSwitchChild,
            icon: const Text(
              'Đổi con',
              style: TextStyle(
                color: AppColors.primaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            label: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primaryContainer,
              size: 16,
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
