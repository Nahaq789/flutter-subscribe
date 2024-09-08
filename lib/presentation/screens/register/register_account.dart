import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/presentation/components/enter_verify_code.dart';
import 'package:subscribe/presentation/components/password_field.dart';
import 'package:subscribe/presentation/dto/auth_request.dart';
import 'package:subscribe/services/provider/auth_provider.dart';

class RegisterAccountPage extends ConsumerStatefulWidget {
  const RegisterAccountPage({super.key});

  @override
  RegisterAccountPageState createState() => RegisterAccountPageState();
}

class RegisterAccountPageState extends ConsumerState<RegisterAccountPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late AuthRequest _registerRequest;
  String? _matchErrorText;
  String? _confirmErrorText;

  bool isRegisterSuccess = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    _registerRequest = AuthRequest(email: "", password: "", verifyCode: "");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitRegister() async {
    _registerRequest.email = emailController.text;
    _registerRequest.password = passwordController.text;

    final authService = ref.read(authServiceProvider);
    // final registerResult =
    //     await authService.registerAccount(auth: _registerRequest);
    isRegisterSuccess = true;

    if (!mounted) return;
    // if (registerResult.isAuth && registerResult.errorMessage == '') {
    //   // Navigator.of(context).pushReplacementNamed('/');
    //   isRegisterSuccess = registerResult.isAuth;
    // } else {
    //   setState(() {
    //     isRegisterSuccess = registerResult.isAuth;
    //     errorMessage = registerResult.errorMessage;
    //   });
    // }
  }

  void _validPassword(String password) {
    setState(() {
      _matchErrorText = _isValidPassword(password)
          ? null
          : 'Password must be at least 6 characters with upper and lowercase letters.';
    });
  }

  void _validConfirmPassword(String password, String confirmPassword) {
    setState(() {
      _confirmErrorText = _checkConfirmPassword(password, confirmPassword)
          ? null
          : 'Confirm password must be match the password';
    });
  }

  bool _isValidPassword(String password) {
    final passwordPattarn = RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{6,}$');
    return passwordPattarn.hasMatch(password);
  }

  bool _checkConfirmPassword(String password, String confirmPassword) {
    return password == confirmPassword ? true : false;
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
                  textController: emailController,
                  onChanged: (value) => emailController.text = value,
                  inputFormat: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@.+_-]'))
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                CustomInputField(
                  labelText: 'Password',
                  hintText: 'Enter your password...',
                  isPassword: true,
                  textController: passwordController,
                  onChanged: (value) {
                    passwordController.text = value;
                    _validPassword(value);
                    _validConfirmPassword(
                        value, confirmPasswordController.text);
                  },
                  errorText: _matchErrorText,
                ),
                SizedBox(height: size.height * 0.02),
                CustomInputField(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password...',
                    isPassword: true,
                    textController: confirmPasswordController,
                    errorText: _confirmErrorText,
                    onChanged: (value) {
                      confirmPasswordController.text = value;
                      _validConfirmPassword(passwordController.text, value);
                    }),
                SizedBox(height: size.height * 0.03),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            enableDrag: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            builder: (context) {
                              return const EnterVerifyCode();
                            },
                          );
                        },
                        child: Text(
                          'Enter verify code',
                          style: TextStyle(
                              color: const Color(0xFF9489F5),
                              fontSize: mediumFontSize),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _submitRegister();
                          isRegisterSuccess
                              ? await showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  builder: (context) {
                                    return const EnterVerifyCode();
                                  },
                                )
                              : null;
                        },
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
                          "Register",
                          style: TextStyle(fontSize: mediumFontSize),
                        ),
                      ),
                    ]),
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
                if (errorMessage != null && !isRegisterSuccess)
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
