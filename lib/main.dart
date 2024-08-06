import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/screens/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env.dev');

  runApp(const ProviderScope(
    child: SubscribeApp(),
  ));
}

class SubscribeApp extends StatelessWidget {
  const SubscribeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Subscribe App",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1F24),
      ),
      home: const LoginPage(),
    );
  }
}
