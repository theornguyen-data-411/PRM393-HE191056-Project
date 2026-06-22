import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';

class WebDashboardLayout extends StatelessWidget {
  final Widget body;
  final String title;
  final List<WebSidebarItem> menuItems;
  final int currentIndex;

  const WebDashboardLayout({
    super.key,
    required this.body,
    required this.title,
    required this.menuItems,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 240,
            color: const Color(0xFF1A3C6E),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            'F',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MyFPTSchools',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Admin Portal',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      final isSelected = index == currentIndex;
                      return ListTile(
                        onTap: item.onTap,
                        leading: Icon(
                          item.icon,
                          color: isSelected ? Colors.white : Colors.white70,
                          size: 20,
                        ),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        tileColor: isSelected ? AppColors.primaryContainer : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.white10),
                ListTile(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                  leading: const Icon(Icons.logout, color: Colors.white70, size: 20),
                  title: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                // TopBar
                Container(
                  height: 64,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C6E),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Năm học: 2024-2025',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFE1E3E4),
                        child: Icon(Icons.person, color: Colors.grey, size: 20),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WebSidebarItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  WebSidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
