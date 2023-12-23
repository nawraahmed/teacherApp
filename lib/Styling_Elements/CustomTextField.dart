import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final bool isPassword;

  CustomTextField({
    required this.hintText,
    required this.onChanged,
    this.errorText,
    this.isPassword = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: widget.errorText != null && widget.errorText!.isNotEmpty
              ? Colors.red
              : Color.fromRGBO(185, 188, 190, 1),
          width: 1.0,
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: TextFormField(
          onChanged: widget.onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: widget.isPassword,
          style: const TextStyle(
            fontSize: 14.0, // Set the font size for non-obscured text
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            hintStyle: const TextStyle(fontSize: 15.0),
            errorText: widget.errorText,

          ),
          // Set a separate style for obscured text
          obscuringCharacter: '*', // Use a bullet character to represent obscured text

        ),
      ),


    );
  }
}
