import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/presentation/components/password_field.dart';
import 'package:subscribe/presentation/dto/auth_request.dart';
import 'package:subscribe/services/provider/auth_provider.dart';

final emailProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late AuthRequest _loginRequest;
  bool isLoginSuccess = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _loginRequest = AuthRequest(email: "", password: "", verifyCode: "");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() async {
    _loginRequest.email = emailController.text;
    _loginRequest.password = passwordController.text;

    final authService = ref.read(authServiceProvider);
    final loginResult = await authService.login(auth: _loginRequest);

    if (!mounted) return;

    if (loginResult.isAuth && loginResult.errorMessage == '') {
      Navigator.of(context).pushReplacementNamed('/register');
    } else {
      setState(() {
        isLoginSuccess = loginResult.isAuth;
        if (loginResult.statusCode == 401) {
          errorMessage =
              "Invalid email or password. Please check your credentials and try again.";
        } else {
          errorMessage =
              "An unexpected error occurred. Please try again later.";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    double imageSize =
        isTablet ? size.width * 0.15 : max(size.width * 0.2, 80.0);
    double mediumFontSize = isTablet ? 18.0 : max(size.width * 0.04, 14.0);
    double largeFontSize = isTablet ? 32.0 : max(size.width * 0.06, 20.0);

    double horizontalPadding = size.width * (isTablet ? 0.1 : 0.05);
    double verticalPadding = size.height * 0.05;

    String appName = dotenv.get('APP_NAME');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "images/app_logo.png",
                  fit: BoxFit.cover,
                  width: imageSize,
                  height: imageSize,
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  appName,
                  style: TextStyle(
                    fontSize: largeFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto Mono',
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome back',
                    style: TextStyle(
                        fontSize: largeFontSize, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login to access your account below.',
                    style: TextStyle(
                        color: const Color(0xFF39D2C0),
                        fontSize: mediumFontSize),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                CustomInputField(
                  labelText: 'Email Address',
                  hintText: 'Enter your email...',
                  isPassword: false,
                  textController: emailController,
                  onChanged: (value) => {emailController.text = value},
                ),
                SizedBox(height: size.height * 0.02),
                CustomInputField(
                  labelText: 'Password',
                  hintText: "Enter your password...",
                  isPassword: true,
                  textController: passwordController,
                  onChanged: (value) => {passwordController.text = value},
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: const Color(0xFF9489F5),
                            fontSize: mediumFontSize),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submitLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF39D2C0),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: mediumFontSize),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: mediumFontSize),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/register');
                      },
                      child: Text(
                        'Create →',
                        style: TextStyle(
                            color: const Color(0xFF9489F5),
                            fontSize: mediumFontSize),
                      ),
                    ),
                  ],
                ),
                if (errorMessage != null && !isLoginSuccess)
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.02),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                          color: Colors.red, fontSize: mediumFontSize),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
