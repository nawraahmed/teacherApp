import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_app/Services/APITeacherInfo.dart';
import 'Styling_Elements/BackButtonRow.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late String name = '';
  late String email = '';
  late String role = '';
  late String phone = '';
  late String cpr = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeacherInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80.0),
          const BackButtonRow(title: 'Profile',),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular image
                const CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('assets/pro.JPG'),
                ),
                const SizedBox(height: 20.0),

                // Name text
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10.0),

                // Role text
                Text(
                  role,
                  style: const TextStyle(
                    color: Styles.primaryPink,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 30.0),

                // Divider for better separation
                Divider(
                  height: 0.5,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 20.0),

                // Display loading indicator while data is being loaded
                isLoading
                    ? CircularProgressIndicator()
                    : Column(
                  children: [
                    // Additional Information
                    ProfileInfoRow(label: 'Preschool Name', value: 'ABC Preschool'),
                    ProfileInfoRow(label: 'Email', value: email),
                    ProfileInfoRow(label: 'Phone', value: phone),
                    ProfileInfoRow(label: 'CPR', value: cpr),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  //FUNCTIONS
  Future<void> fetchTeacherInfo() async {
    try {
      // Read the id from Flutter Secure Storage
      final secureStorage = FlutterSecureStorage();
      final staffId = await secureStorage.read(key: 'dbId');

      final intStaffId = int.tryParse(staffId!);


      final APITeacherInfo teacherInfo = APITeacherInfo();
      TeacherInfo teacher = await teacherInfo.getTeacherInfo(intStaffId!);

      setState(() {
        name = teacher.name;
        email = teacher.email;
        role = teacher.staffRoleName;
        phone = teacher.phone.toString();
        cpr = teacher.cpr.toString();
        isLoading = false;
      });
    } catch (e) {
      print("Teacher info fetching issue: $e");
    }
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label + ':',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
