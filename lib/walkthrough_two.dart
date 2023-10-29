import 'package:flutter/material.dart';


class WalkthroughPageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0, top: 50.0),// Adjust the top padding
            child: Image.asset(
              'assets/walkthrough_two.png',
              width: 410,
              height: 350,
              fit: BoxFit.contain,
            ),
          ),


          // Add spacing between the image and heading
          const SizedBox(height: 50.0),
          const Text(
            'Simplify Your \n Teaching Experience',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              height: 1.3, // Adjust the line height
            ),
            textAlign: TextAlign.center,
          ),

          //const SizedBox(height: 30.0), // Add spacing between the heading and button


        ],
      ),

    );
  }
}
