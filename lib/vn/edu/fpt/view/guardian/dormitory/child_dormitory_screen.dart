import 'package:flutter/material.dart';

class ChildDormitoryScreen extends StatelessWidget {
  const ChildDormitoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ký túc xá'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Thông tin ký túc xá'),
      ),
    );
  }
}