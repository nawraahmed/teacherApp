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
  //final _usernameController = TextEditingController();
  //final _passwordController = TextEditingController();
  String email = '';
  String password = '';
  String? _emailError;
  String? _passwordError;
  bool isValid = true;
  bool showPassword = false;

  InputDecoration customInputDecoration({
    required String hintText,
    required String? hasError,
    bool isPassword = false,
  }) {
    Color borderColor;
    Color errorColor = const Color(0xffcd3232);
    Color successColor = const Color(0xff0cc334);
    Color defaultColor = const Color.fromARGB(255, 228, 228, 228);

    if (hasError == null) {
      borderColor = defaultColor;
    } else if (hasError!.isEmpty) {
      borderColor = successColor;
    } else {
      borderColor = errorColor;
    }

    Color _fillColor = hasError != null && hasError.isNotEmpty
        ? errorColor.withOpacity(0.1)
        : const Color.fromARGB(16, 226, 226, 226);

    Widget? suffixIcon;
    if (isPassword) {
      suffixIcon = GestureDetector(
        onTap: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
        child: Icon(
          showPassword ? Icons.visibility : Icons.visibility_off,
          size: 20,
          color: Colors.black, // Set the color as needed
        ),

      );
    }

    final _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: borderColor,
        width: 1,
      ),
    );

    return InputDecoration(
      hintText: hintText,
      border: _border,
      enabledBorder: _border.copyWith(
        borderSide: BorderSide(
          color: borderColor,
          width: 2,
        ),
      ),
      focusedBorder: _border.copyWith(
        borderSide: BorderSide(
          color: borderColor,
          width: 2,
        ),
      ),
      errorBorder: _border.copyWith(
        borderSide: BorderSide(
          color: errorColor,
          width: 2,
        ),
      ),
      focusedErrorBorder: _border.copyWith(
        borderSide: BorderSide(
          color: errorColor.withOpacity(0.1),
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      filled: true,
      fillColor: _fillColor,
      enabled: true,
      errorStyle:
      TextStyle(color: errorColor),
      suffixIcon: suffixIcon,
    );
  }

  String validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (value.length < 5) {
      return 'Email must be at least 5 characters long';
    }
    final emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return '';
  }

  String validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    // if (!value.contains(RegExp(r'[a-z]'))) {
    //   return 'Password must contain at least one lowercase letter';
    // }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }
    // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'Password must contain at least one special character';
    // }
    return '';
  }

  bool validateErrors() {
    if (_emailError == null || _emailError == '') {
      if (_passwordError == null || _passwordError == '') {
        return true;
      }
    }
    return false;
  }


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
                   Center(
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

                const SizedBox(height: 100.0),

                Padding(padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 5.0), // Adjust the padding as needed
                  child: Container(
                    color: const Color.fromARGB(255, 255, 255, 255), // Set the desired background color
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          _emailError = validateEmail(value);
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: (Theme.of(context).textTheme.bodySmall),
                      decoration: customInputDecoration(
                        hintText: 'Email',
                        hasError: _emailError,
                      ),
                    ),
                  ),
                ),

                if (_emailError != null && _emailError!.isNotEmpty)

                  Padding(padding: const EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 5.0),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color.fromARGB(255, 255, 0, 0),
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          _emailError!,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 0, 0),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),


                Padding(padding: const EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 25.0),

                  child: Visibility(
                    visible: _emailError == null || (_emailError != null && _emailError!.isEmpty),
                    maintainSize: false,

                    child: Row(
                      children: [
                        if (_emailError != null)

                          //show valid icon
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Color.fromARGB(255, 0, 202, 44),
                              size: 14,
                            ),
                          ),

                        //show valid text
                        Text(
                          _emailError == null ? '' : 'Valid Email',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 202, 44),
                            fontSize: 14,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),





                Padding(
                    padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 5.0), // Adjust the padding as needed
                    child: Container(
                  color: const Color.fromARGB(255, 255, 255, 255), // Set the desired background color
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        _passwordError = validatePassword(value);
                      });
                    },

                    obscureText: !showPassword,
                    style: (Theme.of(context).textTheme.bodySmall),
                    decoration: customInputDecoration(
                      hintText: 'Password',
                      hasError: _passwordError,
                      isPassword: true,
                     ),
                    ),
                  ),
                ),

                if (_passwordError != null && _passwordError!.isNotEmpty)

                  Padding(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color.fromARGB(255, 255, 0, 0),
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          _passwordError!,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 0, 0),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                  child: Visibility(
                    visible: _passwordError == null ||
                        (_passwordError != null && _passwordError!.isEmpty),
                    maintainSize: false,
                    child: Row(
                      children: [
                        if (_passwordError != null)
                          const Icon(
                            Icons.check_circle_outline,
                            color: Color.fromARGB(255, 0, 202, 44),
                            size: 14,
                          ),
                        const SizedBox(width: 3),
                        Text(
                          _passwordError == null ? '' : 'Valid Password',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 202, 44),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 5),


            Padding(
              padding: const EdgeInsets.fromLTRB(100, 15, 100, 5),
              child:ElevatedButton(
                onPressed: () {
                  authenticateUser(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_passwordError == 'Valid Password' && email.isNotEmpty && password.isNotEmpty) ? Styles.primaryNavy : Colors.grey ,
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



  Future<void> authenticateUser(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          print('Authentication successful: ${credential.user?.email}');
          print('uid? ${user.uid}');

          const secureStorage = FlutterSecureStorage();
          await secureStorage.write(key: 'uid', value: user.uid ?? '');

          IdTokenResult userDTO = await user.getIdTokenResult(true);
          Map<String, dynamic>? customClaims = userDTO.claims;

          final dbid = customClaims?['dbId'].toString();
          print("database user id is here: $dbid");
          await secureStorage.write(key: 'dbId', value: dbid);

          await secureStorage.write(key: 'user_email', value: credential.user?.email ?? '');
          await secureStorage.write(key: 'user_token', value: userDTO.token ?? '');

          if (Platform.isAndroid) {
            await Notifications().initNotification(credential.user!.uid);
          }

          // Only navigate to the home page on successful authentication
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyCustomTab(initialPage: SelectedPage.home),
            ),
          );

        } catch (e) {
          print("Error accessing custom claims: $e");
        }
      }

    } on FirebaseAuthException catch (e) {
      // Handle authentication errors

      if (e.code == 'user-not-found') {

        print('No user found for that email.');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Authentication Failed'),
              content: Text(e.message ?? 'No user found for that email'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

      } else if (e.code == 'wrong-password') {

        print('Wrong password provided for that user.');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Authentication Failed'),
              content: Text(e.message ?? 'Incorrect password'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

      } else {
        // Show a dialog for other authentication exceptions
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Authentication Failed'),
              content: Text(e.message ?? 'An error occurred during authentication.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error during authentication: $error');
    }
  }







}



