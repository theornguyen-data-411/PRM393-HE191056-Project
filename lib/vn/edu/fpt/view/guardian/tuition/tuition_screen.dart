import 'package:flutter/material.dart';

class TuitionScreen extends StatelessWidget {
  const TuitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Học phí'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Thông tin học phí'),
      ),
    );
  }
}
