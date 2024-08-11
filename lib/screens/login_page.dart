import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/models/login_model.dart';
import 'package:subscribe/services/provider/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late LoginModel _loginModel;
  bool isLoginSuccess = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _loginModel = LoginModel(email: "", password: "");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() async {
    _loginModel.email = emailController.text;
    _loginModel.password = passwordController.text;

    final authService = ref.read(authServiceProvider);
    final loginResult = await authService.login(model: _loginModel);

    if (!mounted) return;

    if (loginResult.success && loginResult.errorMessage == '') {
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      setState(() {
        isLoginSuccess = loginResult.success;
        errorMessage = loginResult.errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = max(MediaQuery.of(context).size.width * 0.1, 100.0);
    double mediumFontSize = max(MediaQuery.of(context).size.width * 0.02, 13.0);
    double largeFontSize = max(MediaQuery.of(context).size.width * 0.05, 24.0);

    double padding = MediaQuery.of(context).size.width;

    String appName = dotenv.get('APP_NAME');
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsetsDirectional.fromSTEB(
                padding * 0.069, padding * 0.116, padding * 0.069, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/app_logo.png",
                          fit: BoxFit.cover,
                          width: imageSize,
                          height: imageSize,
                        )
                      ],
                    ),
                    SizedBox(height: padding * 0.023),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appName,
                          style: TextStyle(
                            fontSize: largeFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto Mono',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: padding * 0.093,
                ),
                Row(
                  children: [
                    Text(
                      'Welcome back',
                      style: TextStyle(
                          fontSize: largeFontSize, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: padding * 0.023,
                ),
                Row(
                  children: [
                    Text(
                      'Login to access your account below.',
                      style: TextStyle(
                          color: const Color(0xFF39D2C0),
                          fontSize: mediumFontSize),
                    ),
                  ],
                ),
                SizedBox(
                  height: padding * 0.046,
                ),
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter your email...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        fillColor: const Color(0xFF101213),
                      ),
                      controller: emailController,
                    ),
                    SizedBox(height: padding * 0.046),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        fillColor: const Color(0xFF101213),
                      ),
                      controller: passwordController,
                    ),
                  ],
                ),
                SizedBox(
                  height: padding * 0.069,
                ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
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
                SizedBox(
                  height: padding * 0.046,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: mediumFontSize),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Create →',
                        style: TextStyle(
                            color: const Color(0xFF9489F5),
                            fontSize: mediumFontSize)),
                  ),
                ]),
                SizedBox(
                  height: padding * 0.046,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (errorMessage != null && !isLoginSuccess)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
