import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'all_events.dart';
import 'firebase_options.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_app/walkthrough_page_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_attendance.dart';
import 'attendance.dart';
import 'events.dart';
import 'homepage.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  HttpOverrides.global = MyHttpOverrides();

  runApp(
    // Wrap your app with the ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => DarkThemeProvider(), // Initialize DarkThemeProvider
      child: const AlefTeacher(),
    ),
  );
}

class AlefTeacher extends StatelessWidget {
  const AlefTeacher({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Retrieve the current theme mode using the DarkThemeProvider
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeProvider.darkTheme; // Move isDarkMode here

    return MaterialApp(
      title: 'Alef Teacher App',
      theme: Styles.themeData(isDarkMode, context), // Use the themeData
      debugShowCheckedModeBanner: false,
      home: WTpageController(),
    );
  }
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}





//this class maintains the image color based on the theme of the app (light/dark)
class MyImage extends StatelessWidget {
  final String imagePath;
  final bool isDarkMode;
  final double width; // Add width parameter
  final double height; // Add height parameter

  const MyImage(
      {super.key,
        required this.imagePath,
        required this.isDarkMode,
        this.width = 24,
        this.height = 24});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isDarkMode ? Colors.white : Colors.black,
        BlendMode.srcIn,
      ),
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
      ),
    );
  }
}



//define styles class here to use it across the application
class Styles{

  static const Color primaryPink = Color.fromRGBO(253, 132, 134, 1);
  static const Color primaryNavy = Color.fromRGBO(19, 40, 103, 1);
  static const Color inactivePrimaryNavy = Color.fromRGBO(19, 40, 103, 0.3);
  static const Color primaryBlue = Color.fromRGBO(160, 210, 209, 1);
  static const Color primaryGray = Color.fromRGBO(185, 188, 190, 1);
  static const Color primaryPurple = Color.fromRGBO(165, 167, 224, 1);





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


  static void showCustomDialog(BuildContext context, String type, String title, String text, IconData icon) {
    Color titleColor;
    Color iconColor;
    String positiveButtonLabel;
    String negativeButtonLabel;

    // Set colors and button labels based on the type
    switch (type) {
      case 'success':
        titleColor = Colors.green;
        iconColor = Colors.green;
        break;
      case 'warning':
        titleColor = const Color.fromRGBO(255, 193, 7, 1);
        iconColor = const Color.fromRGBO(255, 193, 7, 1);
        break;
      case 'error':
        titleColor = Colors.red;
        iconColor = Colors.red;
        break;
      default:
        titleColor = Colors.black;
        iconColor = Colors.black;
    }

    // Set button labels based on the message text
    if (text == "Are you sure you want to delete this event?") {
      positiveButtonLabel = 'Yes';
      negativeButtonLabel = 'Cancel';
    } else {
      positiveButtonLabel = 'OK';
      negativeButtonLabel = ''; // No negative button for other messages
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 50.0,
                ),
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        primary: negativeButtonLabel.isEmpty
                            ? Colors.transparent // Make the button transparent if no negative button
                            : titleColor,
                      ),
                      child: Text(
                        negativeButtonLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        primary: titleColor,
                      ),
                      child: Text(
                        positiveButtonLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(

      // Define the icon color based on dark mode status
      iconTheme: IconThemeData(
        color: isDarkTheme ? Colors.white : Colors.black,
      ),

      // Define hint color for input fields, based on dark mode status
      hintColor: isDarkTheme
          ? const Color.fromRGBO(105, 112, 122, 1)
          : const Color.fromRGBO(131, 145, 161, 1),

      // Define color for the main canvas area of the app
      scaffoldBackgroundColor: isDarkTheme
          ? const Color.fromRGBO(25, 32, 39, 1)
          : const Color.fromRGBO(255, 255, 255, 1),

      // Define the overall brightness of the app, based on dark mode status
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      // Customize the button theme based on the app's theme
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
        colorScheme: isDarkTheme
            ? const ColorScheme.dark()
            : const ColorScheme.light(),
      ),

      // // Customize the app bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme
            ? const Color.fromRGBO(25, 32, 39, 1)
            : const Color.fromRGBO(160, 210, 209, 1),
        // Add other app bar customizations as needed

      ),


      // Customize the text theme
      textTheme: GoogleFonts.urbanistTextTheme().copyWith(
        // Update text colors based on dark mode status
        bodyMedium: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontFamily: GoogleFonts.urbanist().fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),

        titleMedium: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontFamily: GoogleFonts.urbanist().fontFamily,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),

        bodySmall: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontFamily: GoogleFonts.urbanist().fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),



      ),

    );
  }



}


enum SelectedPage {
  home,
  events,
  attendance,
  settings,
}


//define the tab bar here
class MyCustomTab extends StatefulWidget {
  final SelectedPage initialPage;

  const MyCustomTab({Key? key, required this.initialPage}) : super(key: key);

  @override
  _MyCustomTabState createState() => _MyCustomTabState();
}

class _MyCustomTabState extends State<MyCustomTab> {
  late SelectedPage _selectedPage; // Declare the selected page variable

  @override
  void initState() {
    super.initState();
    _selectedPage = widget.initialPage;
  }

  bool isDarkMode = false; // Add a variable to track the theme mode

  @override
  Widget build(BuildContext context) {
    // Retrieve the current theme mode using the DarkThemeProvider
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    isDarkMode =
        themeProvider.darkTheme; // Update isDarkMode based on the current theme

    // Determine the background color based on the theme mode
    final tabBarBackgroundColor = isDarkMode
        ? const Color.fromRGBO(61, 66, 72, 1) // Dark mode background color
        : const Color.fromRGBO(255, 255, 255, 1); // Light mode background color

    return Scaffold(
      body: _getPageForTab(_selectedPage),
      bottomNavigationBar: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        decoration: BoxDecoration(
          color: tabBarBackgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(
              selectedIcon: 'assets/homeSelected.png',
              unselectedIcon: 'assets/Home.png',
              page: SelectedPage.home,
            ),
            _buildTabItem(
              selectedIcon: 'assets/eventsSelected.png',
              unselectedIcon: 'assets/events.png',
              page: SelectedPage.events,
            ),
            _buildTabItem(
              selectedIcon: 'assets/attendanceSelected.png',
              unselectedIcon: 'assets/attendance.png',
              page: SelectedPage.attendance,
            ),
            _buildTabItem(
              selectedIcon: 'assets/settingsSelected.png',
              unselectedIcon: 'assets/settings.png',
              page: SelectedPage.settings,
            ),
          ],
        ),

      ),
    );
  }

  Widget _buildTabItem({
    required String selectedIcon,
    required String unselectedIcon,
    required SelectedPage page,
  }) {
    final isSelected = _selectedPage == page;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPage = page;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(right: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [

                Image.asset(
                  isSelected ? selectedIcon : unselectedIcon,
                  width: 30,
                  height: 20,
                ),


              ],
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Styles.primaryBlue : Colors.transparent,
              ),
              width: 5,
              height: 5,
            ),
          ],
        ),
      ),
    );
  }


  Widget _getPageForTab(SelectedPage page) {
    switch (page) {
      case SelectedPage.home:
        return const HomePage();
      case SelectedPage.events:
        return const AllEvents();
      case SelectedPage.attendance:
        return const AllAttendance();
      case SelectedPage.settings:
        return const Settings();
      default:
        return Container(); // Return an empty container as a fallback
    }
  }
}


class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Empty View"),
      ),
      body: const Center(
        child: Text("This is an empty view"),
      ),
    );
  }
}



//Dark Mode Provider
class DarkThemeProvider with ChangeNotifier {
  // Create an instance of DarkThemePreference to manage theme preferences
  DarkThemePreference darkThemePreference = DarkThemePreference();

  // Define a private variable to store the Dark Theme status
  bool _darkTheme = false;

  // Define a getter for retrieving the Dark Theme status
  bool get darkTheme => _darkTheme;

  //setter for updating the Dark Theme status
  set darkTheme(bool value) {
    _darkTheme = value;
    // Call the setDarkTheme method of DarkThemePreference to save the value
    darkThemePreference.setDarkTheme(value);

    // Notify listeners (widgets) about the change in theme status
    notifyListeners();
  }
}

// Create a class to manage Dark Theme preferences using SharedPreferences
class DarkThemePreference {
  // Define a constant key to identify the theme status in SharedPreferences
  static const themeStatus = "THEMESTATUS";

  // Method to set the Dark Theme status in SharedPreferences
  setDarkTheme(bool value) async {
    // Get an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the provided Dark Theme status value
    prefs.setBool(themeStatus, value);
  }

  // Method to retrieve the Dark Theme status from SharedPreferences
  Future<bool> getTheme() async {
    // Get an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Return the saved Dark Theme status, defaulting to 'false' if not found
    return prefs.getBool(themeStatus) ?? false;
  }
}