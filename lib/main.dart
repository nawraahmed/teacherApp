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

  static const Color primaryPink = Color.fromRGBO(253, 132, 134, 1);


  // static Widget customTextField(String imagePath) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(35.0), // Rounded rectangle border
  //       border: Border.all(
  //         color: primaryPink,
  //         width: 2.0, // Stroke width
  //       ),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(2.0),
  //       child: Row(
  //         children: [
  //           // Left aligned image
  //           Padding(
  //             padding: const EdgeInsets.only(left: 15.0, right: 20),
  //             child: Image.asset(
  //               imagePath,
  //               width: 20.0, // Adjust the width as per your requirement
  //               height: 20.0, // Adjust the height as per your requirement
  //             ),
  //           ),
  //           const Expanded(
  //             child: TextField(
  //               decoration: InputDecoration(
  //                 border: InputBorder.none, // Hide the default border of TextField
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


}



//define the tab bar here
