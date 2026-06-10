import 'package:flutter/material.dart';

class ChildTimetableScreen extends StatelessWidget {
  const ChildTimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thời khóa biểu'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Thời khóa biểu của con'),
      ),
    );
  }
}