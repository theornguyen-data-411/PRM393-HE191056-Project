import 'package:flutter/material.dart';
import 'dashboard.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    // Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDBE1FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.school, size: 36, color: Color(0xFF004AC6)),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Who are you?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select your role to continue',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF434655),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Role Cards
                    _buildRoleCard(
                      id: 'student',
                      title: 'Student',
                      description: 'Access your classes and grades',
                      icon: Icons.school_outlined,
                      color: const Color(0xFF004AC6),
                      bgColor: const Color(0xFFDBE1FF),
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      id: 'teacher',
                      title: 'Teacher',
                      description: 'Manage your classes and students',
                      icon: Icons.co_present_outlined,
                      color: const Color(0xFF585F6C),
                      bgColor: const Color(0xFFDCE2F3),
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      id: 'guardian',
                      title: 'Guardian',
                      description: "Track your child's progress",
                      icon: Icons.family_restroom_outlined,
                      color: const Color(0xFF0051B1),
                      bgColor: const Color(0xFFD8E2FF),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedRole == null
                      ? null
                      : () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const DashboardScreen()),
                            (route) => false,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF2563EB).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String id,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    bool isSelected = selectedRole == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF434655),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isSelected ? color : const Color(0xFF737686),
            ),
          ],
        ),
      ),
    );
  }
}
