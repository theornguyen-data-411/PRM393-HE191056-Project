import 'package:flutter/material.dart';

class ChildAttendanceScreen extends StatelessWidget {
  const ChildAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điểm danh'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Điểm danh của con'),
      ),
    );
  }
}