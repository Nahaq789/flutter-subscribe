import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/presentation/components/input_verification_code.dart';
import 'package:subscribe/presentation/dto/auth_request.dart';
import 'package:subscribe/services/provider/auth_provider.dart';

class EnterVerifyCode extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const EnterVerifyCode(
      {super.key, required this.email, required this.password});
  @override
  EnterVerifyCodeState createState() => EnterVerifyCodeState();
}

class EnterVerifyCodeState extends ConsumerState<EnterVerifyCode> {
  late AuthRequest _verifyRequest;
  late String _verifyCode;
  bool _isLoading = false;
  bool _isValidCode = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _verifyCode = "";
    _verifyRequest = AuthRequest(email: "", password: "", verifyCode: "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submitVerifyCode() async {
    if (_isLoading || !_isValidCode) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _verifyRequest.email = widget.email;
      _verifyRequest.password = widget.password;
      _verifyRequest.verifyCode = _verifyCode;
    });

    final authService = ref.read(authServiceProvider);

    try {
      final result = await authService.confirmCode(auth: _verifyRequest);

      if (!mounted) return;
      if (result.isAuth && result.errorMessage == '') {
        Navigator.of(context).pushReplacementNamed('/congratulations');
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result.errorMessage;
        });
      }
    } catch (e) {
      _errorMessage = "An unexpected error occurred. Please try again.";
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _validateVerifyCode(String code) {
    setState(() {
      _verifyCode = code;
      _isValidCode = code.length == 6 && int.tryParse(code) != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final codeNotifier = ref.watch(verificationCodeProvider.notifier);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    double mediumFontSize = isTablet ? 18.0 : max(size.width * 0.04, 14.0);
    double largeFontSize = isTablet ? 32.0 : max(size.width * 0.06, 20.0);

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseHeight = screenHeight * 0.6;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height:
          keyboardHeight > 0 ? baseHeight + keyboardHeight * 0.35 : baseHeight,
      curve: Curves.easeInOut,
      child: Container(
        height: baseHeight,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 38, 42, 45),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Verify Your Code',
                    style: TextStyle(
                        fontSize: largeFontSize, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => InputVerificationCode(
                      index: index,
                      onChanged: (value) =>
                          _validateVerifyCode(codeNotifier.getCompleteCode()),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        codeNotifier.clearAllCode();
                        _validateVerifyCode("");
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Text(
                        'Clear all code',
                        style: TextStyle(
                            color: const Color(0xFF9489F5),
                            fontSize: mediumFontSize),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                      width: size.width * 0.07,
                    ),
                    ElevatedButton(
                      onPressed: !_isLoading && _isValidCode
                          ? _submitVerifyCode
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF39D2C0),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
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
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              "Verify Code",
                              style: TextStyle(fontSize: mediumFontSize),
                            ),
                    ),
                  ],
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.02,
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                          color: Colors.red, fontSize: mediumFontSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
