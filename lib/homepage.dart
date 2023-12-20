import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:the_app/profile_page.dart';
import 'package:the_app/stationary_request.dart';

import 'Services/APITeacherInfo.dart';
import 'classes_lister.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late String name = '';
  late int preschoolId = 0;
  bool isLoading = true;


  List<String> imagesPath= [
    'assets/classes.png',
    'assets/events_home.png',
    'assets/events_home.png',
  ];

  List<String> headings = ['Classes', 'Events', 'Stationary'];

  @override
  void initState() {
    super.initState();

    fetchTeacherName();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Row at the top
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // Text on the left
                 Text(
                  'Hello Teacher \n${name}',
                   style: Theme.of(context).textTheme.titleMedium,
                ),

                // Spacer to push the next widget to the right
                const Spacer(),

                // Circle container with the avatar image
                GestureDetector(
                  onTap: () {
                    // Navigate to the ProfilePage when the avatar is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: Container(
                    width: 50.0, // Adjust the size as needed
                    height: 50.0, // Adjust the size as needed
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Heading for the collection view
           Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                "For You",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),

            ),
          ),


      // containers with horizontal scrolling
          SizedBox(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle tap on pink container
                      if (index == 0) {

                        // Navigate to the classes page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ClassLister()),
                        );

                      } else if (index == 1) {
                        // Navigate to the events page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ClassLister()),
                        );
                      }
                      else if (index == 2) {
                        // Navigate to the Stationary page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Stationary()),
                        );
                      }
                    },
                    child: Container(
                      width: 150.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Styles.primaryNavy,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            imagesPath[index], // Select the corresponding image asset path
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),

                          const SizedBox(height: 10.0),
                          Text(
                            headings[index], // Select the corresponding heading
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),



          const SizedBox(height: 30),

          // Heading for the collection view
           Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                "Today's Tasks",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
            ),
          ),

          // containers with horizontal scrolling
          SizedBox(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1, // Adjust the number of pink containers as needed
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle tap on pink container
                    },
                    child: Container(
                      width: 350.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Styles.primaryNavy,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //FUNCTIONS
  Future<void> fetchTeacherName() async {
    try {
      // Read the id from Flutter Secure Storage
      final secureStorage = FlutterSecureStorage();
      final staffId = await secureStorage.read(key: 'dbId');

      print("Staff ID: $staffId");

      // Check if staffId is not null and is a non-empty string
      if (staffId != null && staffId.isNotEmpty) {
        // Parse staffId to int
        final intStaffId = int.tryParse(staffId);

        if (intStaffId != null) {
          // pass the ID to the API to get the name
          final APITeacherInfo teacherInfo = APITeacherInfo();
          TeacherInfo teacher = await teacherInfo.getTeacherInfo(intStaffId);

          //store teacher's name
          setState(() {
            name = teacher.name;
            isLoading = false;
          });

          //store the preschool id in flutter secure storage
          preschoolId = teacher.preschoolId;
          const secureStorage = FlutterSecureStorage();
          await secureStorage.write(key: 'preschoolId', value: preschoolId.toString());


        } else {
          print("Staff ID is not a valid integer.");
        }
      } else {
        print("Staff ID is null or empty.");
      }
    } catch (e) {
      print("Teacher name fetching issue: $e");
    }
  }



}
