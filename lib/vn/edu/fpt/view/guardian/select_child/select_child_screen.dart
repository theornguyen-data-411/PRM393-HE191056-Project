import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfschoolse1915/vn/edu/fpt/core/app_colors.dart';

class SelectChildScreen extends StatefulWidget {
  const SelectChildScreen({super.key});

  @override
  State<SelectChildScreen> createState() => _SelectChildScreenState();
}

class _SelectChildScreenState extends State<SelectChildScreen> {
  String? selectedChildId;

  @override
  Widget build(BuildContext context) {
    // Giả sử lấy phuHuynhId từ Auth. Ở đây fix cứng ph_001 để demo theo database_seeder
    const guardianId = 'ph_001';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chọn học sinh',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('phu_huynh')
            .doc(guardianId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Đã có lỗi xảy ra'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) return const Center(child: Text('Không tìm thấy dữ liệu phụ huynh'));

          final children = (data['danhSachCon'] as List? ?? []);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceVariant),
                  ),
                  child: Text(
                    'Bạn có ${children.length} con đang học tại FPT Schools',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: children.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final child = children[index] as Map<String, dynamic>;
                    final childId = child['hocSinhId'];
                    final isSelected = selectedChildId == childId;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedChildId = childId;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryContainer : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: isSelected ? AppColors.primaryContainer : AppColors.secondary,
                              child: Text(
                                child['hoTen'].split(' ').last.substring(0, 1),
                                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    child['hoTen'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  Text(
                                    'Lớp ${child['tenLop']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Text(
                                    'THPT FPT Đà Nẵng',
                                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.tertiary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppColors.tertiary.withOpacity(0.2)),
                                        ),
                                        child: const Text(
                                          'Nội trú',
                                          style: TextStyle(color: AppColors.tertiary, fontSize: 11),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceVariant,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          childId,
                                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryContainer : AppColors.surfaceVariant,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryContainer,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: selectedChildId != null
                          ? () {
                              // Chuyển sang Dashboard với con đã chọn
                              Navigator.pushNamed(
                                context,
                                '/guardian-dashboard',
                                arguments: selectedChildId,
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        shadowColor: AppColors.primaryContainer.withOpacity(0.25),
                      ),
                      child: const Text(
                        'Xem thông tin',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bạn muốn thêm tài khoản con?',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Liên hệ nhà trường',
                        style: TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
