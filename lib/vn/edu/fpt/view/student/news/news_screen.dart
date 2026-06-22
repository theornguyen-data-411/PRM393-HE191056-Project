import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/empty_state_widget.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/notification_model.dart';
import 'package:myfschoolse1915/vn/edu/fpt/model/news_model.dart';
import 'package:myfschoolse1915/vn/edu/fpt/service/notification_service.dart';
import 'package:myfschoolse1915/vn/edu/fpt/component/bottom_nav_bar.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NotificationService _service = NotificationService();
  String _currentUserId = 'hs_001';
  List<NotificationModel> _notifications = [];
  List<NewsModel> _news = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['userId'] != null) {
        _currentUserId = args['userId'];
      }
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      // Parallel fetch for speed
      final results = await Future.wait([
        _service.getNotifications(userId: _currentUserId),
        _service.getNews(),
      ]);
      
      if (mounted) {
        setState(() {
          _notifications = results[0] as List<NotificationModel>;
          _news = results[1] as List<NewsModel>;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading news/notifs: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onNavTap(int index) {
    if (index == 3) return;
    final routes = {
      0: '/student-dashboard',
      1: '/student-timetable',
      2: '/student-grades',
      4: '/student-profile',
    };
    if (routes.containsKey(index)) {
      Navigator.pushReplacementNamed(context, routes[index]!, arguments: {'userId': _currentUserId});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, '/student-dashboard', arguments: {'userId': _currentUserId}),
        ),
        title: const Text('Thông báo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(icon: const Icon(Icons.notifications, color: Colors.black), onPressed: () {}),
              if (_notifications.any((n) => !n.isRead))
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      '${_notifications.where((n) => !n.isRead).length}',
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFFF6B00),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFF6B00),
          tabs: const [Tab(text: 'Thông báo'), Tab(text: 'Tin tức')],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
            controller: _tabController,
            children: [_buildNotificationsList(), _buildNewsList()],
          ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3, onTap: _onNavTap),
    );
  }

  Widget _buildNotificationsList() {
    if (_notifications.isEmpty) {
      return EmptyStateWidget(
        message: 'Bạn chưa có thông báo nào',
        icon: Icons.notifications_none,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        if (notif.isGhim) return _buildPinnedNotice(notif);
        return _buildNotificationItem(notif);
      },
    );
  }

  Widget _buildPinnedNotice(NotificationModel notif) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFFFF3E8), borderRadius: BorderRadius.circular(12), border: const Border(left: BorderSide(color: Color(0xFFFF6B00), width: 4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [const Icon(Icons.push_pin, color: Color(0xFFFF6B00), size: 16), const SizedBox(width: 4), Text('GHIM', style: TextStyle(color: const Color(0xFFFF6B00), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))]),
          const SizedBox(height: 8),
          Text(notif.tieuDe, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(notif.noiDung, style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFD0E4FF), borderRadius: BorderRadius.circular(20)), child: Text(notif.loaiText, style: const TextStyle(color: Color(0xFF00497B), fontSize: 11, fontWeight: FontWeight.bold))),
              Text(_timeAgo(notif.ngayTao), style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notif) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: _getIconBgColor(notif.loai), shape: BoxShape.circle), child: Icon(_getIcon(notif.loai), color: _getIconColor(notif.loai), size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif.tieuDe, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(notif.noiDung, style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFF3F4F5), borderRadius: BorderRadius.circular(12)), child: Text(notif.loaiText, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 8),
                    Text('• ${_timeAgo(notif.ngayTao)}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          if (!notif.isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF059EFF), shape: BoxShape.circle)),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    if (_news.isEmpty) {
      return EmptyStateWidget(
        message: 'Hiện chưa có tin tức mới',
        icon: Icons.newspaper,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _news.length,
      itemBuilder: (context, index) {
        final news = _news[index];
        if (news.isNoiBat) return _buildFeaturedNews(news);
        return _buildNewsItem(news);
      },
    );
  }

  Widget _buildFeaturedNews(NewsModel news) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: news.anhBia.isNotEmpty
                  ? Image.network(
                      news.anhBia,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      },
                    )
                  : const Center(child: Icon(Icons.newspaper, color: Colors.grey, size: 40)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFFFDBCC), borderRadius: BorderRadius.circular(12)),
                  child: Text(news.chuyenMucText, style: const TextStyle(color: Color(0xFF7A3000), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Text(news.tieuDe, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(_timeAgo(news.ngayDang), style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(NewsModel news) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: news.anhBia.isNotEmpty
                  ? Image.network(
                      news.anhBia,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      },
                    )
                  : const Icon(Icons.newspaper, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(news.chuyenMucText.toUpperCase(), style: const TextStyle(color: Color(0xFF405E92), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text(news.tieuDe, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(_timeAgo(news.ngayDang), style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays == 1) return 'Hôm qua';
    return '${diff.inDays} ngày trước';
  }

  IconData _getIcon(String loai) {
    switch (loai) {
      case 'khen_thuong': return Icons.emoji_events;
      case 'su_kien': return Icons.campaign;
      case 'y_te': return Icons.vaccines;
      case 'tai_chinh': return Icons.payments;
      default: return Icons.notifications;
    }
  }

  Color _getIconColor(String loai) {
    switch (loai) {
      case 'khen_thuong': return const Color(0xFFFF6B00);
      case 'su_kien': return const Color(0xFF405E92);
      case 'y_te': return Colors.red;
      case 'tai_chinh': return Colors.green;
      default: return Colors.blue;
    }
  }

  Color _getIconBgColor(String loai) {
    return _getIconColor(loai).withValues(alpha: 0.1);
  }
}
