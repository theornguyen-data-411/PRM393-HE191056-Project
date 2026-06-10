import 'package:flutter/material.dart';

class GuardianNewsScreen extends StatelessWidget {
  const GuardianNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Tin tức nhà trường'),
      ),
    );
  }
}