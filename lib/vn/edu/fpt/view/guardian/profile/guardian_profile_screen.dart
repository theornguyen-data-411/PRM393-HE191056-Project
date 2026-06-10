import 'package:flutter/material.dart';

class GuardianProfileScreen extends StatelessWidget {
  const GuardianProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Hồ sơ phụ huynh'),
      ),
    );
  }
}
