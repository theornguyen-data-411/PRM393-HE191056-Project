import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String _selectedRole = 'phu_huynh';
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
        // Học sinh: đăng nhập bằng email + mật khẩu
        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
            );
          }
          return;
        }

        final usersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: _emailController.text.trim())
            .limit(1)
            .get();

        if (usersSnapshot.docs.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email không tồn tại')),
            );
          }
          return;
        }

        final userDoc = usersSnapshot.docs.first;
        final userData = userDoc.data();
        final userId = userDoc.id;

        final userRole = userData['vaiTro'] ?? '';
        if (userRole != _selectedRole) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vai trò không khớp với tài khoản')),
            );
          }
          return;
        }

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': userId});
        }
      } else {
        // Phụ huynh: đăng nhập bằng số điện thoại
        if (_phoneController.text.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng nhập số điện thoại')),
            );
          }
          return;
        }

        final usersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('soDienThoai', isEqualTo: _phoneController.text.trim())
            .limit(1)
            .get();

        if (usersSnapshot.docs.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Số điện thoại không tồn tại')),
            );
          }
          return;
        }

        final userDoc = usersSnapshot.docs.first;
        final userId = userDoc.id;

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/select-child', arguments: {'userId': userId});
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top 40% - Branding
            Expanded(
              flex: 40,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFF3E8), Color(0xFFFFF3E8)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B00).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://fpt.com.vn/Content/images/logo.png',
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFFF6B00),
                              child: const Icon(
                                Icons.school,
                                size: 48,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'MyFPTSchools',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A3C6E),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom 60% - Login Form
            Expanded(
              flex: 60,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Chào mừng trở lại!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A3C6E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Đăng nhập để tiếp tục',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Role Selection
                      const Text(
                        'Bạn là:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A3C6E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = 'hoc_sinh'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'hoc_sinh'
                                      ? const Color(0xFFFFF3E8)
                                      : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedRole == 'hoc_sinh'
                                        ? const Color(0xFFFF6B00)
                                        : const Color(0xFFE5E7EB),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.school,
                                      color: _selectedRole == 'hoc_sinh'
                                          ? const Color(0xFFFF6B00)
                                          : const Color(0xFF666666),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Học sinh',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: _selectedRole == 'hoc_sinh'
                                            ? Colors.black
                                            : const Color(0xFF666666),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = 'phu_huynh'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'phu_huynh'
                                      ? const Color(0xFFFFF3E8)
                                      : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedRole == 'phu_huynh'
                                        ? const Color(0xFFFF6B00)
                                        : const Color(0xFFE5E7EB),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.family_restroom,
                                      color: _selectedRole == 'phu_huynh'
                                          ? const Color(0xFFFF6B00)
                                          : const Color(0xFF666666),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Phụ huynh',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: _selectedRole == 'phu_huynh'
                                            ? Colors.black
                                            : const Color(0xFF666666),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Input fields based on role
                      if (_selectedRole == 'hoc_sinh') ...[
                        // Email Input (Học sinh)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email, color: Color(0xFF666666)),
                              hintText: 'Nhập email',
                              hintStyle: TextStyle(color: Color(0xFF666666)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password Input (Học sinh)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF666666)),
                              hintText: 'Nhập mật khẩu',
                              hintStyle: const TextStyle(color: Color(0xFF666666)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                  color: const Color(0xFF666666),
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Forgot Password (Học sinh)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                color: Color(0xFFFF6B00),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        // Phone Input (Phụ huynh)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.call, color: Color(0xFF666666)),
                              hintText: 'Nhập số điện thoại',
                              hintStyle: TextStyle(color: Color(0xFF666666)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B00),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            shadowColor: const Color(0xFFFF6B00).withOpacity(0.4),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Footer
                      const Center(
                        child: Text(
                          'Phiên bản 1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
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
}