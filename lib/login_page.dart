import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Notifications.dart';
import 'Styling_Elements/CustomTextField.dart';
import 'main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Styles.primaryNavy,
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  const Center(
                    // child: Image.asset('assets/alef_logo.png'),
                  ),
                  const SizedBox(height: 20.0),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 40.0, 0, 0),
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),


                ],
              ),


            ),
          ),

          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/LoginContainer.png',
              fit: BoxFit.fill,
            ),
          ),



          Container(
            color: Colors.transparent,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // Column containing Alef logo and Login heading

                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(55, 100, 55, 20),
                  child: CustomTextField(
                    hintText: 'Email',
                    onChanged: (value) {
                      setState(() {
                        _usernameController.text = value;
                        email = value;
                      });
                    },
                    errorText: '',
                    isPassword: false,
                  ),
                ),




            Padding(
              padding: const EdgeInsets.fromLTRB(55, 0, 55, 25),
              child: CustomTextField(
                  hintText: 'password',
                  onChanged: (value) {
                    setState(() {
                      password = value;
                      _passwordController.text = value;
                    });
                  },
                  errorText: '',
                  isPassword: true,
                ),
            ),

                const SizedBox(height: 5),


            Padding(
              padding: const EdgeInsets.fromLTRB(100, 15, 100, 5),
              child:ElevatedButton(
                  onPressed: () {
                    authenticateUser();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCustomTab(initialPage: SelectedPage.home),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primaryNavy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),

                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ),


                const SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewAccount()));
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: "Account Not Working?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' Contact Administration',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Styles.primaryPink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Future<void> authenticateUser() async {
    try {
      // Use the email and password from the text controllers
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      User? user = FirebaseAuth.instance.currentUser;
      if(user != null){

        try{
          // Authentication successful, you can handle the result if needed
          print('Authentication successful: ${credential.user?.email}');
          print('uid? ${user.uid}');

          //store uid in flutter secure storage
          const secureStorage = FlutterSecureStorage();
          await secureStorage.write(key: 'uid', value: user.uid ?? '');

          IdTokenResult userDTO = await user.getIdTokenResult(true);
          Map<String, dynamic>? customClaims = userDTO.claims;

          final dbid = customClaims?['dbId'].toString();

          // Print for debugging
          print("database user id is here: $dbid");

          // Store the database user id in Flutter Secure Storage
          await secureStorage.write(key: 'dbId', value: dbid);

          // Print the value immediately after storing
          // final storedDbId = await secureStorage.read(key: 'dbId');
          //
          // print("Stored Staff ID: $storedDbId");



          //print("Is this the token???? ${userDTO.token}");

          //save user email and token in Flutter Secure Storage
          await secureStorage.write(key: 'user_email', value: credential.user?.email ?? '');
          await secureStorage.write(key: 'user_token', value: userDTO.token ?? '');



          //if platform is == android, enable the setup for notifications using Notification class
          if(Platform.isAndroid){
            await Notifications().initNotification(credential.user!.uid);
          }

        }catch (e){
          print("Error accessing custom claims: $e");

        }
      }


    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      if (e.code == 'user-not-found') {
        print('No user found for that email.');

      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');


      } else {
        // Handle other exceptions if needed
        print('Authentication failed: ${e.message}');
      }
    } catch (error) {
      // Handle other errors
      print('Error during authentication: $error');
    }
  }







}



