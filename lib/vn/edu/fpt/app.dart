import 'package:flutter/material.dart';
import 'app_router.dart';

class FptApp extends StatelessWidget {
  const FptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFPTSchools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
          primary: const Color(0xFFFF6B00),
        ),
        fontFamily: 'Be Vietnam Pro',
        useMaterial3: true,
      ),
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
