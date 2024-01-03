import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:the_app/about_us.dart';
import 'package:url_launcher/url_launcher.dart';
import 'faq.dart';
import 'login_page.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// The stateful widget for the home page
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with SingleTickerProviderStateMixin {
  bool darkModeEnabled = false; // Initialize default dark mode state
  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    // Fetch user preferences on initialization
    fetchUserPreferences();
  }


  @override
  Widget build(BuildContext context) {

    final lang = Localizations.localeOf(context);
    return Scaffold(

      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Implement logout functionality
                signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.primaryNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          buildSettingItem('Dark Mode', Icons.nightlight_round, CupertinoSwitch(
            value: darkModeEnabled,
            onChanged: (value) async {
              // Update the dark mode state
              // You may want to handle this state globally (e.g., using Provider)
              Provider.of<DarkThemeProvider>(context, listen: false).darkTheme = value;
              setState(() {
                darkModeEnabled = value;
              });

              // Save dark mode preference
              await saveUserPreference('darkMode', value.toString());

            },
            activeColor: CupertinoColors.systemGrey4,
            thumbColor: darkModeEnabled
                ? const Color.fromRGBO(0, 0, 0, 0.3)
                : const Color.fromRGBO(75, 75, 75, 1),
            trackColor: const Color.fromRGBO(255, 255, 255, 1),
          )),



          if (Platform.isAndroid) // Check if the platform is Android
            buildSettingItem('Notifications', Icons.notifications, CupertinoSwitch(
              value: notificationsEnabled,
              onChanged: (value) async {
                setState(() {
                  notificationsEnabled = value;
                });

                // Save notifications preference
                await saveUserPreference('notifications', value.toString());
              },
              activeColor: CupertinoColors.systemGrey4,
              thumbColor: darkModeEnabled
                  ? const Color.fromRGBO(0, 0, 0, 0.3)
                  : const Color.fromRGBO(75, 75, 75, 1),
              trackColor: const Color.fromRGBO(255, 255, 255, 1),
            )),

          buildSettingItem('FAQs', Icons.help),
          buildSettingItem('About Us', Icons.info),
          buildSettingItem('Report a Bug', Icons.bug_report),

        ],
      ),
    );
  }





  // WIDGETS
  Widget buildSettingItem(String settingName, IconData icon, [Widget? trailingWidget]) {
    final darkModeEnabled = Provider.of<DarkThemeProvider>(context).darkTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: darkModeEnabled ? Colors.grey[800] : Colors.grey[200], // Adjust the colors based on your preference
      ),
      child: ListTile(
        leading: Icon(icon, color: darkModeEnabled ? Colors.white : Colors.black), // Adjust icon color based on dark mode
        title: Text(
          settingName,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: () {
          // Implement action for each setting item
          print('Tapped on $settingName');

          if (settingName == 'FAQs') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FAQpage()), // Replace FAQsPage with the actual page
            );
          } else if (settingName == 'About Us') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUs()), // Replace FAQsPage with the actual page
            );
          } else if (settingName == 'Report a Bug') {
            launchEmail();
            }

        },
        trailing: trailingWidget ?? const SizedBox(), // Use trailingWidget if provided, otherwise use an empty SizedBox
        splashColor: Colors.transparent, // Set splashColor to transparent
      ),
    );
  }





  //FUNCTIONS
  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User logged out successfully');

      //clear Flutter secure Storage (token, Uid, DBid, email)
      const secureStorage = FlutterSecureStorage();
      await secureStorage.write(key: 'uid', value: '');
      await secureStorage.write(key: 'dbId', value: '');
      await secureStorage.write(key: 'user_email', value: '');
      await secureStorage.write(key: 'user_token', value: '');

      // Clear preferences related to dark mode and notifications
      await clearUserPreferences();

      //navigate to the login page
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>  LoginScreen(),),
      );


    } catch (e) {
      print('Error logging out: $e');
    }
  }

  Future<void> saveUserPreference(String key, String value) async {
    try {
      const secureStorage = FlutterSecureStorage();
      await secureStorage.write(key: key, value: value);
    } catch (e) {
      print('Error saving user preference: $e');
    }
  }

  Future<void> fetchUserPreferences() async {
    try {
      const secureStorage = FlutterSecureStorage();

      // Fetch dark mode preference
      String? darkModeValue = await secureStorage.read(key: 'darkMode');
      if (darkModeValue != null) {
        setState(() {
          darkModeEnabled = darkModeValue.toLowerCase() == 'true';
        });
      }

      // Fetch notifications preference
      String? notificationsValue = await secureStorage.read(key: 'notifications');
      if (notificationsValue != null) {
        setState(() {
          notificationsEnabled = notificationsValue.toLowerCase() == 'true';
        });
      }
    } catch (e) {
      print('Error fetching user preferences: $e');
    }
  }

  Future<void> clearUserPreferences() async {
    try {
      const secureStorage = FlutterSecureStorage();
      await secureStorage.delete(key: 'darkMode');
      await secureStorage.delete(key: 'notifications');
    } catch (e) {
      print('Error clearing user preferences: $e');
    }
  }

  void launchEmail()  {
    final mailToURi = Uri(
      scheme: 'mailto',
      path: 'alef.preschool@gmail.com',
      queryParameters: {'subject': 'Bug Report'},
    );

   launchUrl(mailToURi);

  }




}
