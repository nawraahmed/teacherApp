import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:the_app/profile_page.dart';
import 'package:the_app/stationary_request.dart';
import 'Services/APITeacherInfo.dart';
import 'classes_lister.dart';
import 'main.dart';
import 'package:the_app//Users/nawraalhaji/StudioProjects/teacherApp/.dart_tool/flutter_gen/gen_l10n/app_localization.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late String name = '';
  late int preschoolId = 0;
  bool isLoading = true;
  late String nameFromStorage = '';


  List<String> imagesPath= [
    'assets/notebook.png',
    'assets/paint.png',
    'assets/reports.png',
  ];

  List<String> otherImagesPath= [
    'assets/mega.png',
    'assets/tasks.png',
    'assets/events_home.png',
  ];




  @override
  void initState() {
    super.initState();

    fetchTeacherName();
  }


  @override
  Widget build(BuildContext context) {
    List<String> headings = ['${AppLocalizations.of(context)!.classes}', '${AppLocalizations.of(context)!.stationary}', '${AppLocalizations.of(context)!.reports}'];
    List<String> otherHeadings = [ '${AppLocalizations.of(context)!.teachers}'];
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
                  '${AppLocalizations.of(context)!.helloTeacher} \n${nameFromStorage}',
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
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                  child: Container(
                    width: 50.0, // Adjust the size as needed
                    height: 50.0, // Adjust the size as needed
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/pro.JPG'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Heading for the collection view
           const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0),
              // child: Text(
              //   "For You",
              //   style: Theme.of(context).textTheme.bodyMedium,
              //   textAlign: TextAlign.left,
              // ),

            ),
          ),


      // containers with horizontal scrolling
          SizedBox(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: headings.length,
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

                        // Navigate to the Stationary page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StationaryRequestForm()),
                        );
                      }

                      else if (index == 2) {
                        // Navigate to the events page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ClassLister()),
                        );
                      }
                    },
                    child: Container(
                      width: 150.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Styles.primaryBlue,
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



          const SizedBox(height: 70),

          // Heading for the collection view
           Padding(
              padding: const EdgeInsets.only(right: 290.0),
              child: Text(
                  '${AppLocalizations.of(context)!.forYou}',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
            ),
          

          // containers with horizontal scrolling
          SizedBox(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: otherHeadings.length, // Adjust the number of pink containers as needed
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
                        color: Styles.primaryBlue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            otherImagesPath[index], // Select the corresponding image asset path
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),

                          const SizedBox(height: 10.0),
                          Text(
                            otherHeadings[index], // Select the corresponding heading
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
        ],
      ),
    );
  }


  //FUNCTIONS
  Future<void> fetchTeacherName() async {
    try {
      // Read the id from Flutter Secure Storage
      final secureStorage = const FlutterSecureStorage();
      final staffId = await secureStorage.read(key: 'dbId');

      print("Staff ID: $staffId");

      // Check if staffId is not null and is a non-empty string
      if (staffId != null && staffId.isNotEmpty) {
        // Parse staffId to int
        final intStaffId = int.tryParse(staffId);

        if (intStaffId != null) {
          // Retrieve the teacher's name from Flutter Secure Storage
          final storedName = await secureStorage.read(key: 'teacherName');

          if (storedName != null) {
            // If the name is already stored, use it
            setState(() {
              nameFromStorage = storedName;
              isLoading = false;
            });
          } else {
            // If the name is not stored, fetch it from the API
            final APITeacherInfo teacherInfo = APITeacherInfo();
            TeacherInfo teacher = await teacherInfo.getTeacherInfo(intStaffId);

            // Store teacher's name in Flutter Secure Storage
            await secureStorage.write(key: 'teacherName', value: teacher.name);

            // Update the state with the fetched name
            setState(() {
              nameFromStorage = teacher.name;
              isLoading = false;
            });
          }

          // Store the preschool id in flutter secure storage
          preschoolId = intStaffId;
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
