import 'package:flutter/material.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
                const SizedBox(height: 40.0),
                Center(
                  child: Image.asset('assets/alef_logo.png'),
                ),
                const SizedBox(height: 10.0),

                // Login heading centered
                const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),

            Image.asset('assets/login.png'),
            const SizedBox(height: 16.0),


            Styles.customTextField('assets/email.png'),
            const SizedBox(height: 20.0),
            Styles.customTextField('assets/password.png'),

            // TextField(
            //   controller: _usernameController,
            //   decoration: const InputDecoration(
            //     hintText: 'Username',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // const SizedBox(height: 8.0),
            //
            // TextField(
            //   controller: _passwordController,
            //   decoration: const InputDecoration(
            //     hintText: 'Password',
            //     border: OutlineInputBorder(),
            //   ),
            //   obscureText: true,
            // ),
            const SizedBox(height: 16.0),



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

}
