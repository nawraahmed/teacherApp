import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_app/walkthrough_page_controller.dart';

void main() {
  runApp(const AlefTeacher());
}

class AlefTeacher extends StatelessWidget {
  const AlefTeacher({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alef Teacher App',
      theme: ThemeData(
        textTheme: GoogleFonts.urbanistTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,

      ),
      debugShowCheckedModeBanner: false,
      home: WTpageController(),
    );
  }
}




//define styles class here to use it across the application
class Styles{

}
