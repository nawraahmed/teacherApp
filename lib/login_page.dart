import 'package:flutter/material.dart';
import 'package:the_app/Services/APILoginClient.dart';
import 'package:the_app/homepage.dart';

import 'Styling_Elemnts/CustomTextField.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String email = '';
  String password = '';
  String token = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // Column containing Alef logo and Login heading
            Column(
              children: [
                // Alef logo image centered
                const SizedBox(height: 30.0),
                Center(
                  child: Image.asset('assets/alef_logo.png'),
                ),
                const SizedBox(height: 5.0),

                // Login heading centered
                const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),

            Image.asset('assets/login.png'),
            const SizedBox(height: 10.0),


            CustomTextField(
              hintText: 'Enter your email',
              onChanged: (value) {
                setState(() {
                  email = value;
                  //_emailError = validateEmail(value);
                  print("EMAIL: $email");

                });
              },
              errorText: '', // Pass null or empty string for no error
              isPassword: false,
              imagePath: 'assets/email.png', // Replace with your image path
            ),
            const SizedBox(height: 20),


            CustomTextField(
              hintText: 'Enter your password',
              onChanged: (value) {
                setState(() {
                  password = value;
                  //_passwordError = validatePassword(value);

                });
              },
              errorText: '',
              isPassword: true,
              imagePath: 'assets/password.png', // Replace with your image path
            ),

            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                authenticateUser();

                //if authentication was successful, navigate to home page
                // Navigate to MyCustomTab after successful login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyCustomTab(initialPage: SelectedPage.home),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.primaryNavy,
                padding: const EdgeInsets.symmetric(horizontal: 5),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 14, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),


            // Contact Administration text
            Center(
              child: GestureDetector(
                onTap: () {

                  // Navigate to
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewAccount()));
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,

                    ),
                    children: [
                      TextSpan(
                        text: "Account Not Working?",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,

                        ),
                      ),
                      TextSpan(
                        text: ' Contact Administration',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Styles.primaryPink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }


  Future<void> authenticateUser() async {
    try {
      LoginResponse response = await APILoginClient().login(email, password);

      // Call the `authenticateUser` method of the `APIClient` and pass the email and password
      String jwtToken = response.jsonToken;
      print("here is the token $jwtToken");

    } catch (error) {
      print("FEEH MUSHKILAAA");
    }
  }






}



