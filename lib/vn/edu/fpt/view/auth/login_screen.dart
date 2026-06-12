import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../component/app_button.dart';
import '../../component/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedRole = 'hoc_sinh';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      if (_selectedRole == 'hoc_sinh') {
        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')));
          return;
        }
        final usersSnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: _emailController.text.trim()).limit(1).get();
        if (usersSnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email không tồn tại')));
          return;
        }
        final userDoc = usersSnapshot.docs.first;
        if (mounted) Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': userDoc.id});
      } else {
        if (_phoneController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập số điện thoại')));
          return;
        }
        final usersSnapshot = await FirebaseFirestore.instance.collection('users').where('soDienThoai', isEqualTo: _phoneController.text.trim()).limit(1).get();
        if (usersSnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Số điện thoại không tồn tại')));
          return;
        }
        final userDoc = usersSnapshot.docs.first;
        if (mounted) Navigator.pushReplacementNamed(context, '/select-child', arguments: {'userId': userDoc.id});
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Branding
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFF3E8), Colors.white],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://fpt.com.vn/Content/images/logo.png',
                  height: 100,
                  errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 80, color: Color(0xFFFF6B00)),
                ),
                const SizedBox(height: 16),
                const Text('MyFPTSchools', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A3C6E))),
              ],
            ),
          ),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Chào mừng trở lại!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A3C6E))),
                  const Text('Đăng nhập để tiếp tục', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),
                  const Text('Bạn là:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A3C6E))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildRoleToggle('hoc_sinh', 'Học sinh', Icons.school),
                      const SizedBox(width: 12),
                      _buildRoleToggle('phu_huynh', 'Phụ huynh', Icons.family_restroom),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_selectedRole == 'hoc_sinh') ...[
                    AppTextField(
                      controller: _emailController,
                      hintText: 'email@fpt.edu.vn',
                      prefixIcon: Icons.mail,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      hintText: 'Mật khẩu',
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ] else ...[
                    AppTextField(
                      controller: _phoneController,
                      hintText: 'Số điện thoại',
                      prefixIcon: Icons.call,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                      child: const Text('Quên mật khẩu?', style: TextStyle(color: Color(0xFFFF6B00))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Đăng nhập',
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleToggle(String role, String label, IconData icon) {
    bool isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF3E8) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFFFF6B00) : const Color(0xFFE5E7EB), width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? const Color(0xFFFF6B00) : Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
