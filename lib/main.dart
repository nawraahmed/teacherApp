import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_app/walkthrough_page_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'attendance.dart';
import 'events.dart';
import 'homepage.dart';
import 'settings.dart';

void main() {
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
        height: 60,
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
              icon: _selectedPage == SelectedPage.home ? 'assets/homeSelected.png' : 'assets/Home.png',
              label: _selectedPage == SelectedPage.home ? 'Home' : '',
              page: SelectedPage.home,
            ),
            _buildTabItem(
              icon: _selectedPage == SelectedPage.events ? 'assets/eventsSelected.png' : 'assets/events.png',
              label: _selectedPage == SelectedPage.events ? 'Events' : '',
              page: SelectedPage.events,
            ),
            _buildTabItem(
              icon:  _selectedPage == SelectedPage.attendance ? 'assets/attendanceSelected.png' : 'assets/attendance.png',
              label: _selectedPage == SelectedPage.attendance ? 'Attendance' : '',
              page: SelectedPage.attendance,
            ),
            _buildTabItem(
              icon: _selectedPage == SelectedPage.settings ? 'assets/settingsSelected.png' : 'assets/settings.png',
              label: _selectedPage == SelectedPage.settings ? 'Settings' : '',
              page: SelectedPage.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(
      {required String icon,
        required String label,
        required SelectedPage page}) {
    final isSelected = _selectedPage == page;
    final labelColor = isSelected ? Styles.primaryPink : Colors.black.withOpacity(0.5);

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
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(25),
                color: isSelected
                    ? Color.fromRGBO(253, 132, 134, 0.1)
                    : Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    icon,
                    width: 30,
                    height: 20,
                    color: isSelected ? Styles.primaryPink : null,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    label,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
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
        return const Events();
      case SelectedPage.attendance:
        return Attendance();
      case SelectedPage.settings:
        return const Settings();
      default:
        return Container(); // Return an empty container as a fallback
    }
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