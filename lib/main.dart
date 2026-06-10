import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'vn/edu/fpt/view/auth/login_screen.dart';
import 'vn/edu/fpt/view/auth/forgot_password_screen.dart';
import 'vn/edu/fpt/view/student/dashboard/student_dashboard_screen.dart';
import 'vn/edu/fpt/view/guardian/select_child/select_child_screen.dart';
import 'vn/edu/fpt/view/guardian/dashboard/guardian_dashboard_screen.dart';
import 'vn/edu/fpt/view/guardian/grades/child_grades_overview_screen.dart';
import 'vn/edu/fpt/view/guardian/grades/child_grades_detail_screen.dart';
import 'vn/edu/fpt/view/guardian/attendance/child_attendance_screen.dart';
import 'vn/edu/fpt/view/guardian/dormitory/child_dormitory_screen.dart';
import 'vn/edu/fpt/view/guardian/tuition/tuition_screen.dart';
import 'vn/edu/fpt/view/guardian/contact/contact_screen.dart';
import 'vn/edu/fpt/view/guardian/chat/chat_list_screen.dart';
import 'vn/edu/fpt/view/guardian/chat/chat_detail_screen.dart';
import 'vn/edu/fpt/view/guardian/profile/guardian_profile_screen.dart';
import 'vn/edu/fpt/view/guardian/news/guardian_news_screen.dart';
import 'vn/edu/fpt/view/guardian/timetable/child_timetable_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFschool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF004AC6)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        // Auth
        '/': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),

        // Student
        '/student-dashboard': (context) => const StudentDashboardScreen(),

        // Guardian
        '/select-child': (context) => const SelectChildScreen(),
        '/guardian-dashboard': (context) => const GuardianDashboardScreen(),
        '/guardian-grades': (context) => const ChildGradesOverviewScreen(),
        '/guardian-grades-detail': (context) => const ChildGradesDetailScreen(),
        '/guardian-attendance': (context) => const ChildAttendanceScreen(),
        '/guardian-dormitory': (context) => const ChildDormitoryScreen(),
        '/guardian-tuition': (context) => const TuitionScreen(),
        '/guardian-contact': (context) => const ContactScreen(),
        '/guardian-chat': (context) => const ChatListScreen(),
        '/guardian-chat-detail': (context) => const ChatDetailScreen(),
        '/guardian-profile': (context) => const GuardianProfileScreen(),
        '/guardian-news': (context) => const GuardianNewsScreen(),
        '/guardian-timetable': (context) => const ChildTimetableScreen(),
      },
    );
  }
}
