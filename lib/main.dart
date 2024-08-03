import 'package:flutter/material.dart';
import 'package:subscribe/screens/login_page.dart';

void main() {
  runApp(SubscribeApp());
}

class SubscribeApp extends StatelessWidget {
  const SubscribeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Subscribe App",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1F24),
      ),
      home: const LoginPage(),
    );
  }
}
