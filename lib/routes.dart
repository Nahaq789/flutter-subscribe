import 'package:flutter/widgets.dart';
import 'package:subscribe/presentation/screens/congratulations/congratulations_page.dart';
import 'package:subscribe/presentation/screens/login_page.dart';
import 'package:subscribe/presentation/screens/register/register_account.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes {
    return {
      '/': (context) => const LoginPage(),
      '/register': (context) => const RegisterAccountPage(),
      '/congratulations': (context) => const CongratulationsPage()
    };
  }
}
