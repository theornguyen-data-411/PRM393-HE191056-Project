import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF004AC6)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Student Portal',
          style: TextStyle(color: Color(0xFF004AC6), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Color(0xFF004AC6)),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16, left: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC_xI7hUrc54_iDJ75RQvw8leOT3GBiTHNa7ZMRkDQ_mbsVE9GT3rzbFfONubv4FnCKWLNImM_lbJFFzzNkdYqlr8J14jv2SlMhTmxq-EaUYVMC6H4O4cGYtt5PZIhw3QBgcw5dS2ohHOdWL05JFBc7j7ipV9OzhRgRw13oTlxV7h1qZAfujHIkx3NG49sjnnVsr6pCLq2KDxsiNW_XCIybtvAApJFvQzpjW7_kgIujyRQkmVyIoJq_O_qXiTIN6w5Hwjuj6GLTFV8'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const Text(
              'Good Morning, Jesmin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF191C1D)),
            ),
            const Text(
              'Thursday, June 6, 2025',
              style: TextStyle(fontSize: 14, color: Color(0xFF585F6C)),
            ),
            const SizedBox(height: 24),

            // Next Class & Tasks
            _buildNextClassCard(),
            const SizedBox(height: 16),
            _buildTodayTasksCard(),
            const SizedBox(height: 16),

            // Quick Access Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildQuickAccessItem(Icons.calendar_today, 'Class Routine', const Color(0xFFE0E7FF), const Color(0xFF4338CA)),
                _buildQuickAccessItem(Icons.menu_book, 'Homework', const Color(0xFFEDEEEF), const Color(0xFF585F6C)),
                _buildQuickAccessItem(Icons.campaign, 'Notice', const Color(0xFFFEE2E2), const Color(0xFFB91C1C)),
                _buildQuickAccessItem(Icons.how_to_reg, 'Attendance', const Color(0xFFDCFCE7), const Color(0xFF15803D)),
              ],
            ),
            const SizedBox(height: 32),

            // Progress Snapshot
            const Text(
              'Progress Snapshot',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProgressCard(),
            const SizedBox(height: 32),

            // Updates
            const Text(
              'Updates',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildUpdatesList(),
            const SizedBox(height: 32),

            // Latest Notices
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Latest Notices', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            _buildNoticesList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF585F6C),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Routine'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active), label: 'Notice'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDq7kmKmJktbVtCuxCbvUr_cxPB-D0wLnXVp-y5M9WSBRNVmkf20YSa5WtsKUv100_avOAoRlmUQEQohf1Wjh3TyET6hF92Zh-tpak7QuDCilxnkxjdOiw2jRy-maBw2cfFOKRxlimMnZlN3YdJCHUErVXdO8PVe8aRl37pT3eNu8-mkTr8OkkLE0Mo9VZwcGh1gOk99R4BD5bLu5Sfm1xN3u1P5ZNA1C3o6njxSOwS0w1MtyY71pDyWzDrLnvjVNrVj51R-7GQltE'),
            ),
            accountName: const Text('Alex Johnson', style: TextStyle(color: Color(0xFF004AC6), fontWeight: FontWeight.bold)),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Grade 10-B', style: TextStyle(color: Color(0xFF434655))),
                Text('ID: #88291', style: TextStyle(color: const Color(0xFF434655).withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
          _drawerItem(Icons.person_outline, 'My Profile'),
          _drawerItem(Icons.check_circle_outline, 'Attendance'),
          _drawerItem(Icons.grade_outlined, 'Grades'),
          _drawerItem(Icons.payments_outlined, 'Fees'),
          _drawerItem(Icons.settings_outlined, 'Settings'),
          _drawerItem(Icons.help_outline, 'Help'),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF585F6C)),
      title: Text(title, style: const TextStyle(color: Color(0xFF191C1D))),
      onTap: () {},
    );
  }

  Widget _buildNextClassCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.schedule, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NEXT CLASS', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 12)),
              Text('Math with Mr. Rahim', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Color(0xFF60A5FA)),
                  Text(' Room 204 • 10:00 AM', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 14)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTasksCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.checklist, color: Color(0xFFE11D48)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s Tasks', style: TextStyle(color: Color(0xFF9F1239), fontWeight: FontWeight.bold, fontSize: 16)),
                Text('3 assignments due', style: TextStyle(color: Color(0xFFFB7185), fontSize: 14)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFE11D48)),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItem(IconData icon, String title, Color bgColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF434655))),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _buildProgressBar('Attendance', 0.92, '92%', Colors.green),
          const SizedBox(height: 20),
          _buildProgressBar('Avg Score', 0.85, '85%', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double value, String percentage, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF434655), fontWeight: FontWeight.w600)),
            Text(percentage, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: const Color(0xFFE7E8E9),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(10),
          minHeight: 10,
        ),
      ],
    );
  }

  Widget _buildUpdatesList() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildEventCard(),
          const SizedBox(width: 16),
          _buildMessageCard(),
        ],
      ),
    );
  }

  Widget _buildEventCard() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.event, size: 20, color: Color(0xFF434655)),
              SizedBox(width: 8),
              Text('Upcoming Events', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          _buildEventItem('Jun 12', 'Science Fair'),
          const SizedBox(height: 8),
          _buildEventItem('Jun 15', 'Parent-Teacher Mtg'),
        ],
      ),
    );
  }

  Widget _buildEventItem(String date, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF2563EB).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
          child: Text(date, style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(color: Color(0xFF191C1D))),
      ],
    );
  }

  Widget _buildMessageCard() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.mail_outline, size: 20, color: Color(0xFF434655)),
              SizedBox(width: 8),
              Text('Teacher Messages', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDLOvd3MmEWMKpKtMvvyBK0EaorytuqIquZ-OYLTUWX5pAtWGyRqU0UUrmVthVgNB8FZU2vj21ahhnJnxHC2ARcBU5wKsqFUTWApKICD2bp6PDwer2h44XCj_UKpSs9_0q3R9M5IX0PMBoe7P90wbQldqujV5S2Liv5rh_R5EteUeGuChtpXhjri-Zf2fZTP1FClhCe-78PD4_EkG_LFiD6AVm_qIekQ0VFMUQQmItZFJt3R73qtRdmGTNkVdbzS4FaTs9WDFHbmqQ'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mr. Rahim', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Don\'t forget the assignment is due...', style: TextStyle(color: const Color(0xFF434655).withOpacity(0.8), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoticesList() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _buildNoticeItem('Library books due date extended', 'The deadline for returning borrowed books has been extended...', '2 hours ago'),
          const Divider(height: 1),
          _buildNoticeItem('Annual Sports Day Registration', 'Register for the upcoming sports day events by the end of this week.', 'Yesterday'),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 6), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF434655), fontSize: 13)),
                const SizedBox(height: 8),
                Text(time, style: const TextStyle(color: Color(0xFF737686), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
