import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomInputField extends ConsumerStatefulWidget {
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextEditingController textController;
  final ValueChanged<String> onChanged;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.isPassword,
    required this.textController,
    required this.onChanged,
  });

  @override
  CustomInputFieldState createState() => CustomInputFieldState();
}

class CustomInputFieldState extends ConsumerState<CustomInputField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // レスポンシブなフォントサイズの計算
    final double labelFontSize = isTablet ? 18.0 : max(size.width * 0.04, 14.0);
    final double hintFontSize = isTablet ? 16.0 : max(size.width * 0.035, 12.0);

    // パディングの調整
    final double verticalPadding = isTablet ? 20.0 : 15.0;
    final double horizontalPadding = isTablet ? 20.0 : 15.0;

    return TextField(
      controller: widget.textController,
      obscureText: widget.isPassword ? _isObscure : false,
      onChanged: widget.onChanged,
      style: TextStyle(fontSize: labelFontSize),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.labelText,
        labelStyle: TextStyle(fontSize: labelFontSize),
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: hintFontSize),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        filled: true,
        fillColor: const Color(0xFF101213),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  size: isTablet ? 24.0 : 20.0,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
