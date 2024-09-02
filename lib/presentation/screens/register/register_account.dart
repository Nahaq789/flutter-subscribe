import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/presentation/components/password_field.dart';

class RegisterAccountPage extends ConsumerStatefulWidget {
  const RegisterAccountPage({super.key});

  @override
  RegisterAccountPageState createState() => RegisterAccountPageState();
}

class RegisterAccountPageState extends ConsumerState<RegisterAccountPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                    'Get Started',
                    style: TextStyle(
                        fontSize: largeFontSize, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create your account below.',
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
                  textController: _emailController,
                  onChanged: (value) => _emailController.text = value,
                ),
                SizedBox(height: size.height * 0.02),
                CustomInputField(
                  labelText: 'Password',
                  hintText: 'Enter your password...',
                  isPassword: true,
                  textController: _passwordController,
                  onChanged: (value) => _passwordController.text = value,
                ),
                SizedBox(height: size.height * 0.02),
                CustomInputField(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password...',
                  isPassword: true,
                  textController: _confirmPasswordController,
                  onChanged: (value) => _confirmPasswordController.text = value,
                ),
                SizedBox(height: size.height * 0.03),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
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
                      "Create Account",
                      style: TextStyle(fontSize: mediumFontSize),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF101213),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.002,
                    horizontal: size.width * 0.005,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        child: Text(
                          '← Login',
                          style: TextStyle(
                            color: const Color(0xFF9489F5),
                            fontSize: mediumFontSize,
                          ),
                        ),
                      ),
                      Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: mediumFontSize),
                      ),
                    ],
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
