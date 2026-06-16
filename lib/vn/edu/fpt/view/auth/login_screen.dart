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
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập số điện thoại')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('soDienThoai', isEqualTo: phone)
          .limit(1)
          .get();

      if (usersSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Số điện thoại không tồn tại trên hệ thống')));
        return;
      }

      final userData = usersSnapshot.docs.first.data();
      final role = userData['vaiTro'];
      final userId = usersSnapshot.docs.first.id;

      if (mounted) {
        if (role == 'phu_huynh') {
          Navigator.pushReplacementNamed(context, '/select-child', arguments: userId);
        } else if (role == 'hoc_sinh') {
          Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': userId});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tài khoản không có quyền truy cập ứng dụng di động')));
        }
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
                  'https://fpt.edu.vn/Content/images/assets/Logo-FE.png',
                  height: 100,
                  errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 80, color: Color(0xFFFF6B00)),
                ),
                const SizedBox(height: 16),
                const Text('MyFPTSchools', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A3C6E))),
                const Text('Hệ thống quản lý học sinh thông minh', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                  const Text('Đăng nhập', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A3C6E))),
                  const Text('Vui lòng nhập số điện thoại để tiếp tục', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _phoneController,
                    hintText: 'Số điện thoại',
                    prefixIcon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    text: 'Tiếp tục',
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
}
