import 'package:flutter/material.dart';

import '../main.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final bool isPassword;
  final String imagePath;

  CustomTextField({
    required this.hintText,
    required this.onChanged,
    this.errorText,
    this.isPassword = false,
    required this.imagePath,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.0),
        border: Border.all(
          color: widget.errorText != null && widget.errorText!.isNotEmpty
              ? Colors.red
              : Styles.primaryNavy, // Customize border color for error state
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 20),
              child: Image.asset(
                widget.imagePath,
                width: 20.0,
                height: 20.0,
              ),
            ),
            Expanded(
              child: TextFormField(
                onChanged: widget.onChanged,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: widget.isPassword,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (widget.errorText != null && widget.errorText!.isNotEmpty) {
                    return widget.errorText;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
