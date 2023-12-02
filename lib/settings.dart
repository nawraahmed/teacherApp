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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Implement logout functionality
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Logout'),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          buildSettingItem('Dark Mode', Icons.nightlight_round),
          buildSettingItem('FAQs', Icons.help),
          buildSettingItem('About Us', Icons.info),
          buildSettingItem('Report a Bug', Icons.bug_report),
          buildSettingItem('Language', Icons.language),
        ],
      ),
    );
  }

  Widget buildSettingItem(String settingName, IconData icon) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.grey[200],
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(settingName),
        onTap: () {
          // Implement action for each setting item
          print('Tapped on $settingName');
        },
        splashColor: Colors.transparent, // Set splashColor to transparent

      ),
    );
  }
}
