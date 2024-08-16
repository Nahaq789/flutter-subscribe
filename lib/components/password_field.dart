import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final passwordVisibilityProvider = StateProvider<bool>((ref) => true);

class CustomInputField extends ConsumerStatefulWidget {
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextEditingController textController;
  final ValueChanged<String> onChanged;

  const CustomInputField(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.isPassword,
      required this.textController,
      required this.onChanged});

  @override
  CustomerInputFieldState createState() => CustomerInputFieldState();
}

class CustomerInputFieldState extends ConsumerState<CustomInputField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final double hintFontSize =
        max(MediaQuery.of(context).size.width * 0.0254, 13);

    print(MediaQuery.of(context).size.width);
    return TextField(
      controller: widget.textController,
      obscureText: _isObscure ? widget.isPassword : false,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: hintFontSize),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(15),
        filled: true,
        fillColor: const Color(0xFF101213),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon:
                    Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
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
