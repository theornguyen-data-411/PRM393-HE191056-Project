import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectChildScreen extends StatefulWidget {
  const SelectChildScreen({super.key});

  @override
  State<SelectChildScreen> createState() => _SelectChildScreenState();
}

class _SelectChildScreenState extends State<SelectChildScreen> {
  String? _currentUserId;
  List<Map<String, dynamic>> _children = [];
  String? _selectedChildId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('userId')) {
        _currentUserId = args['userId'] as String;
        _loadChildren();
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không tìm thấy thông tin người dùng')),
          );
        }
      }
    });
  }

  Future<void> _loadChildren() async {
    if (_currentUserId == null) return;

    try {
      // Load guardian's children from phu_huynh collection (NOT users collection)
      final guardianDoc = await FirebaseFirestore.instance
          .collection('phu_huynh')
          .doc(_currentUserId)
          .get();

      if (guardianDoc.exists) {
        final guardianData = guardianDoc.data()!;
        // Field is 'danhSachConId' not 'danhSachCon'
        final childrenIds = List<String>.from(guardianData['danhSachConId'] ?? []);

        if (childrenIds.isEmpty) {
          if (mounted) {
            setState(() => _isLoading = false);
          }
          return;
        }

        for (var childId in childrenIds) {
          final childDoc = await FirebaseFirestore.instance
              .collection('hoc_sinh')
              .doc(childId)
              .get();

          if (childDoc.exists) {
            final childData = childDoc.data()!;

            // Get class info from lop_hoc collection (NOT lop)
            final classDoc = await FirebaseFirestore.instance
                .collection('lop_hoc')
                .doc(childData['lopId'])
                .get();

            final classData = classDoc.exists ? classDoc.data() : {};

            setState(() {
              _children.add({
                'id': childId,
                'hoTen': childData['hoTen'] ?? 'Học sinh',
                'maHocSinh': childData['maHocSinh'] ?? childId,
                'lop': classData?['tenLop'] ?? 'Lớp',
                'truong': classData?['truong'] ?? 'Trường',
                'noiTru': childData['isNoiTru'] ?? false,
                'avatarUrl': childData['anhDaiDien'],
              });

              if (_selectedChildId == null && _children.isNotEmpty) {
                _selectedChildId = _children.first['id'];
              }
            });
          }
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[parts.length - 2][0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'HS';
  }

  void _handleContinue() {
    if (_selectedChildId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn học sinh')),
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/guardian-dashboard',
      arguments: {
        'childId': _selectedChildId,
        'userId': _currentUserId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B00),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chọn học sinh',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE1E3E4)),
                  ),
                  child: Text(
                    'Bạn có ${_children.length} con đang học tại FPT Schools',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _children.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.child_care,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Chưa có tài khoản học sinh nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Liên hệ nhà trường để thêm tài khoản con',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _children.length,
                      itemBuilder: (context, index) {
                        final child = _children[index];
                        final isSelected = _selectedChildId == child['id'];

                        return GestureDetector(
                          onTap: () => setState(() => _selectedChildId = child['id']),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFF6B00)
                                    : Colors.transparent,
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
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B00),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF6B00).withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getInitials(child['hoTen']),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
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
                                          color: Color(0xFF405E92),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        child['lop'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFFF6B00),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        child['truong'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          if (child['noiTru'] == true)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0062A1).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(0xFF0062A1).withOpacity(0.2),
                                                ),
                                              ),
                                              child: const Text(
                                                'Nội trú',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF0062A1),
                                                ),
                                              ),
                                            ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEDEEEF),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              child['maHocSinh'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF5A4136),
                                              ),
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
                                      color: isSelected
                                          ? const Color(0xFFFF6B00)
                                          : const Color(0xFFE1E3E4),
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFFF6B00),
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
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 20,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _children.isEmpty ? null : _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        shadowColor: const Color(0xFFFF6B00).withOpacity(0.4),
                      ),
                      child: const Text(
                        'Xem thông tin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Liên hệ nhà trường để thêm tài khoản con'),
                          ),
                        );
                      },
                      child: const Text(
                        'Bạn muốn thêm tài khoản con?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}