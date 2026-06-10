import 'package:flutter/material.dart';

class ChildGradesOverviewScreen extends StatelessWidget {
  const ChildGradesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng điểm'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Bảng điểm của con'),
      ),
    );
  }
}
