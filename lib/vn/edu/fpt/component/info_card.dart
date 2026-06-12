import 'package:flutter/material.dart';

class StudentInfoCard extends StatelessWidget {
  final String? studentName;
  final String? className;
  final String? studentId;
  final String? academicYear;
  final String? avatarUrl;

  const StudentInfoCard({
    super.key,
    this.studentName,
    this.className,
    this.studentId,
    this.academicYear,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E3E4)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(avatarUrl ?? 'https://via.placeholder.com/150'),
            backgroundColor: const Color(0xFFF3F4F5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lớp ${className ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFF6B00).withOpacity(0.2)),
                      ),
                      child: const Text(
                        'Học sinh',
                        style: TextStyle(
                          color: Color(0xFFFF6B00),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Năm học ${academicYear ?? ''}',
                  style: const TextStyle(color: Color(0xFF5A4136), fontSize: 13),
                ),
                Text(
                  'MSHV: ${studentId ?? ''}',
                  style: const TextStyle(color: Color(0xFF5A4136), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
