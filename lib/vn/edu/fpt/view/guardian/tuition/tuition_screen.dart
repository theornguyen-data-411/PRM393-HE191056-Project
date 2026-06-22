import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/guardian/guardian_layout.dart';
import 'package:intl/intl.dart';

class TuitionScreen extends StatelessWidget {
  const TuitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String childId = ModalRoute.of(context)!.settings.arguments as String? ?? 'hs_001';
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return GuardianLayout(
      currentIndex: 1, // Likely in Academics or separate, let's keep 1 for now or adjust based on UX
      title: 'Học phí',
      childId: childId,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('hoc_phi')
            .where('hocSinhId', isEqualTo: childId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final fees = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

          final unpaidFees = fees.where((f) => f['trangThai'] != 'da_dong').toList();
          final paidFees = fees.where((f) => f['trangThai'] == 'da_dong').toList();
          final totalDue = unpaidFees.fold(0, (sum, f) => sum + (f['soTien'] as int));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Card (Gradient)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Học kỳ 2 - Năm học 2024-2025', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
                      const Text('Tổng cần đóng', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(currencyFormatter.format(totalDue), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      const Divider(color: Colors.white24, height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMiniSummary('Học phí', '6.000k ₫'),
                          _buildMiniSummary('Ký túc xá', '1.500k ₫'),
                          _buildMiniSummary('Xe buýt', '1.000k ₫'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Urgent Action Card
                if (unpaidFees.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(left: BorderSide(color: AppColors.error, width: 4)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning, color: AppColors.error, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Cần đóng ngay', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text('${unpaidFees.length} khoản phí đã đến hạn hoặc quá hạn', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(currencyFormatter.format(totalDue), style: const TextStyle(color: AppColors.error, fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: AppColors.outlineVariant)),
                            elevation: 0,
                          ),
                          child: const Text('Xem hướng dẫn đóng phí', style: TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                const Text('Trạng thái thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Column(
                  children: fees.map((f) => _buildPaymentRow(f, currencyFormatter)).toList(),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Lịch sử thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: const Text('Xem tất cả', style: TextStyle(color: AppColors.primaryContainer))),
                  ],
                ),
                Column(
                  children: paidFees.map((f) => _buildHistoryRow(f, currencyFormatter)).toList(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniSummary(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPaymentRow(Map<String, dynamic> data, NumberFormat formatter) {
    final bool isPaid = data['trangThai'] == 'da_dong';
    final bool isOverdue = data['trangThai'] == 'qua_han';

    IconData icon;
    Color iconColor;
    switch (data['loai']) {
      case 'hoc_phi': icon = Icons.school; iconColor = AppColors.primaryContainer; break;
      case 'ktx': icon = Icons.bed; iconColor = AppColors.tertiary; break;
      case 'xe_bus': icon = Icons.directions_bus; iconColor = AppColors.secondary; break;
      default: icon = Icons.receipt_long; iconColor = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.surfaceVariant))),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: iconColor.withOpacity(0.1), child: Icon(icon, color: iconColor)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['tenKhoan'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Hạn đóng: ${data['hanDongString']}', style: TextStyle(fontSize: 12, color: isOverdue ? AppColors.error : AppColors.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isPaid ? AppColors.success.withOpacity(0.1) : (isOverdue ? AppColors.error.withOpacity(0.1) : AppColors.surfaceAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPaid ? 'Đã đóng' : (isOverdue ? 'Quá hạn' : 'Chưa đóng'),
                  style: TextStyle(color: isPaid ? AppColors.success : (isOverdue ? AppColors.error : AppColors.primaryContainer), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              if (!isPaid) const SizedBox(height: 4),
              if (!isPaid) Text(formatter.format(data['soTien']), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(Map<String, dynamic> data, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.surfaceVariant))),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: AppColors.surface, radius: 16, child: Icon(Icons.receipt_long, color: AppColors.textMuted, size: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['tenKhoan'], style: const TextStyle(fontSize: 14)),
                Text(data['hanDongString'], style: const TextStyle(fontSize: 11, color: AppColors.textMuted)), // Should use ngayDong
              ],
            ),
          ),
          Text('+ ${formatter.format(data['soTien'])}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
        ],
      ),
    );
  }
}
