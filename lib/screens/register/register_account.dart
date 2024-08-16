import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/components/password_field.dart';

class RegisterAccountPage extends ConsumerStatefulWidget {
  const RegisterAccountPage({super.key});

  @override
  RegisterAccountPageState createState() => RegisterAccountPageState();
}

class RegisterAccountPageState extends ConsumerState<RegisterAccountPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confilmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confilmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confilmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = max(MediaQuery.of(context).size.width * 0.1, 100.0);
    double mediumFontSize = max(MediaQuery.of(context).size.width * 0.03, 15.0);
    double largeFontSize = max(MediaQuery.of(context).size.width * 0.05, 24.0);
    double padding = MediaQuery.of(context).size.width;
    String appName = dotenv.get('APP_NAME');

    debugPrint(_emailController.text);

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
                SizedBox(height: padding * 0.093),
                Row(
                  children: [
                    Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: largeFontSize, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: padding * 0.023),
                Row(
                  children: [
                    Text(
                      'Create your account below.',
                      style: TextStyle(
                          color: const Color(0xFF39D2C0),
                          fontSize: mediumFontSize),
                    ),
                  ],
                ),
                SizedBox(height: padding * 0.1),
                Column(
                  children: [
                    CustomInputField(
                      labelText: 'Email Address',
                      hintText: 'Enter your email...',
                      isPassword: false,
                      textController: _emailController,
                      onChanged: (value) => _emailController.text = value,
                    ),
                    SizedBox(height: padding * 0.046),
                    CustomInputField(
                      labelText: 'Password',
                      hintText: 'Enter your password...',
                      isPassword: true,
                      textController: _passwordController,
                      onChanged: (value) => _passwordController.text = value,
                    ),
                    SizedBox(height: padding * 0.046),
                    CustomInputField(
                      labelText: 'Confilm Password',
                      hintText: 'Re-enter your password...',
                      isPassword: true,
                      textController: _confilmPasswordController,
                      onChanged: (value) =>
                          _confilmPasswordController.text = value,
                    ),
                  ],
                ),
                SizedBox(height: padding * 0.046),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        ))
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
