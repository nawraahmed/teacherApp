import 'package:flutter/material.dart';

class BackButtonRow extends StatelessWidget {
  final String title;

  const BackButtonRow({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Image.asset('assets/back.png'),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}