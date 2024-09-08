import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/presentation/components/input_verification_code.dart';

class EnterVerifyCode extends ConsumerWidget {
  const EnterVerifyCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeNotifier = ref.watch(verificationCodeProvider.notifier);
    bool isLoading = false;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    double mediumFontSize = isTablet ? 18.0 : max(size.width * 0.04, 14.0);
    double largeFontSize = isTablet ? 32.0 : max(size.width * 0.06, 20.0);

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseHeight = screenHeight * 0.6;

    String? code;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height:
          keyboardHeight > 0 ? baseHeight + keyboardHeight * 0.3 : baseHeight,
      curve: Curves.easeInOut,
      child: Container(
        height: baseHeight, // 画面の90%の高さ
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
                      6, (index) => InputVerificationCode(index: index)),
                ),
                SizedBox(height: size.height * 0.02),
                TextButton(
                  onPressed: () {
                    codeNotifier.clearAllCode();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Text(
                    'Clear all code',
                    style: TextStyle(
                        color: const Color(0xFF9489F5),
                        fontSize: mediumFontSize),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                ElevatedButton(
                  onPressed: () {
                    codeNotifier.isCodeComplete()
                        ? code = codeNotifier.getCompleteCode()
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
                    "Verify Code",
                    style: TextStyle(fontSize: mediumFontSize),
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
