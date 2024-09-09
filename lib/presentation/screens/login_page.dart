import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/presentation/components/password_field.dart';
import 'package:subscribe/presentation/dto/auth_request.dart';
import 'package:subscribe/services/provider/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late AuthRequest _loginRequest;
  bool isLoginSuccess = false;
  String? _errorMessage;

  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loginRequest = AuthRequest(email: "", password: "", verifyCode: "");

    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _submitLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _loginRequest.email = _emailController.text;
    _loginRequest.password = _passwordController.text;

    final authService = ref.read(authServiceProvider);

    try {
      final loginResult = await authService.login(auth: _loginRequest);

      if (!mounted) return;

      if (loginResult.isAuth && loginResult.errorMessage == '') {
        Navigator.of(context).pushReplacementNamed('/register');
      } else {
        setState(() {
          isLoginSuccess = loginResult.isAuth;
          _errorMessage = loginResult.errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                  textController: _emailController,
                  onChanged: (value) => _emailController.text = value,
                ),
                SizedBox(height: size.height * 0.02),
                CustomInputField(
                  labelText: 'Password',
                  hintText: "Enter your password...",
                  isPassword: true,
                  textController: _passwordController,
                  onChanged: (value) => _passwordController.text = value,
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
                      onPressed:
                          (_isFormValid && !_isLoading) ? _submitLogin : null,
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
                      child: _isLoading
                          ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator())
                          : Text(
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
                if (_errorMessage != null && !isLoginSuccess)
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.02),
                    child: Text(
                      _errorMessage!,
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
