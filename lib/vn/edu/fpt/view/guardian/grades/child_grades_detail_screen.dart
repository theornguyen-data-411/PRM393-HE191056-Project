import 'package:flutter/material.dart';

class ChildGradesDetailScreen extends StatelessWidget {
  const ChildGradesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết điểm'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Chi tiết điểm'),
      ),
    );
  }
}