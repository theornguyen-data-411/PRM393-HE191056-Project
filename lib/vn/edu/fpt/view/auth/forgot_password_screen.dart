import 'package:flutter/material.dart';
import '../../component/app_button.dart';
import '../../component/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendRequest() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập email')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi link đặt lại mật khẩu đến email của bạn'), backgroundColor: Color(0xFF28A745)),
        );
        Navigator.pop(context);
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
      backgroundColor: const Color(0xFFF3F4F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF191C1D)), onPressed: () => Navigator.pop(context)),
        title: const Text('Quên mật khẩu', style: TextStyle(color: Color(0xFF191C1D), fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 160, height: 160,
                decoration: const BoxDecoration(color: Color(0xFFFFF3E8), shape: BoxShape.circle),
                child: const Icon(Icons.lock_reset, size: 80, color: Color(0xFFFF6B00)),
              ),
              const SizedBox(height: 32),
              const Text('Đặt lại mật khẩu', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF001B3F))),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text('Nhập email để nhận link đặt lại mật khẩu', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
              ),
              const SizedBox(height: 40),
              AppTextField(
                controller: _emailController,
                hintText: 'email@fpt.edu.vn',
                prefixIcon: Icons.mail,
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Gửi yêu cầu',
                isLoading: _isLoading,
                onPressed: _handleSendRequest,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Quay lại đăng nhập', style: TextStyle(color: Color(0xFFFF6B00), fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
