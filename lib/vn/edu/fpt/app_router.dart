import 'package:flutter/material.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/auth/login_screen.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/auth/forgot_password_screen.dart';
import 'package:myfschoolse1915/vn/edu/fpt/view/student/dashboard/student_dashboard_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String forgotPassword = '/forgot-password';
  static const String studentDashboard = '/student-dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case studentDashboard:
        final userId = settings.arguments as String? ?? 'hs_001';
        return MaterialPageRoute(
          builder: (_) => StudentDashboardScreen(),
          settings: RouteSettings(arguments: {'userId': userId}),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
