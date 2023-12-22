import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:the_app/about_us.dart';
import 'faq.dart';
import 'login_page.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
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

              // logic to save dark mode preference

            },
            activeColor: CupertinoColors.systemGrey4,
            thumbColor: darkModeEnabled
                ? const Color.fromRGBO(0, 0, 0, 0.3)
                : const Color.fromRGBO(75, 75, 75, 1),
            trackColor: const Color.fromRGBO(255, 255, 255, 1),
          )),



          buildSettingItem('Notifications', Icons.notifications, CupertinoSwitch(
            value: notificationsEnabled,
            onChanged: (value) async {
              // Update the notifications state
              setState(() {
                notificationsEnabled = value;
              });

              // logic to save notifications mode preference

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
          buildSettingItem('Language', Icons.language),
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

      //navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  LoginScreen(),
        ),
      );


    } catch (e) {
      print('Error logging out: $e');
    }
  }

}
