import 'package:flutter/material.dart';

class PeriodCard extends StatelessWidget {
  final int tietSo;
  final String monHoc;
  final String teacher;
  final String phong;
  final String gioVao;
  final String gioRa;
  final String colorHex;

  const PeriodCard({
    super.key,
    required this.tietSo,
    required this.monHoc,
    required this.teacher,
    required this.phong,
    required this.gioVao,
    required this.gioRa,
    required this.colorHex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))),
              width: 4,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiết $tietSo: $monHoc',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'GV: $teacher • Phòng $phong',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$gioVao - $gioRa',
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
