import 'dart:io';
import 'package:flutter/material.dart';
import 'package:the_app/Services/APIFaceReco.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'Services/APIClassesLister.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'Services/APIStudentInfo.dart' as info;
import 'Services/APIStudentsLister.dart' as lister;
import 'main.dart';
import 'package:image_picker/image_picker.dart';


class AllAttendance extends StatefulWidget{
  const AllAttendance({Key? key}) : super(key: key);

  @override
  _AllAttendanceState createState() => _AllAttendanceState();
}



class _AllAttendanceState extends State<AllAttendance> with SingleTickerProviderStateMixin {
  List<Class> classesList = [Class(className: 'Select class', id: 1)]; // Initialize with a default value
  Class? selectedClass; // Selected class
  String? selectedState;
  Map<String, String> hasConsentStudents = {};
  Map<String, String> noConsentStudents = {};
  int? selectedIndex = 0; // Keep track of the selected index

  final classCtrl = TextEditingController();
  Map<String, TextEditingController> attendanceControllers = {};

  List<lister.Student> studentsList = [];
  int? selectedIndexToggle=0;

  File _image = File(''); // Initialize _image with an empty File
  final picker = ImagePicker();
  final APIFaceReco apiFaceReco = APIFaceReco();


  @override
  void initState() {
    super.initState();
    fetchClassesList(1);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
    body: SingleChildScrollView(
    child: Column(
    children: [
          // Add top edge spacing (unified in all screens)
          const SizedBox(height: 30.0),

          // Wrap the heading and dropdown in the same column
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Current Class',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Styles.primaryGray,
                      fontSize: 17.0,
                    ),
                  ),
                ),

                const SizedBox(height: 5.0),

                SizedBox(
                  width: 150,
                  child: CustomDropdown(
                    hintText: 'Select class',
                    items: classesList.map((Class classItem) => classItem.className).toList(),
                    controller: classCtrl,
                    fillColor: Colors.transparent,
                    onChanged: (selectedItem) {
                      setState(() {
                        selectedClass = classesList.firstWhere((classItem) => classItem.className == selectedItem);

                        // Access the selected class
                        if (selectedClass != null) {
                          print('Selected Class ID: ${selectedClass!.id}');
                          print('Selected Class Name: ${selectedClass!.className}');

                          //call the students lister API
                          listStudents(1, selectedClass!.id);
                        }
                      });
                    },
                  ),


                ),
              ],
            ),
          ),



          //toggle button to switch between manual and automated attendance
          ToggleSwitch(
            minWidth: 170.0,
            cornerRadius: 20.0,
            activeBgColor: const [Styles.primaryNavy],
            inactiveBgColor: Colors.grey[300],
            activeFgColor: Colors.white,
            inactiveFgColor: Styles.primaryNavy,
            initialLabelIndex: selectedIndexToggle,
            totalSwitches: 2,
            labels: const ['Auto Attendance', 'Manual Attendance'],
            radiusStyle: true,
            onToggle: (index) {
              print('switched to: $index');
              setState(() {

                selectedIndexToggle=index;
              });

              },
          ),


          // Display the appropriate attendance widget based on the selected index
          Visibility(
            visible: selectedIndexToggle == 0,
            child: buildAutoAttendanceWidget(
              hasConsentStudents.keys.map((studentName) => lister.Student(
                studentName: studentName,
                personalPicture: hasConsentStudents[studentName]!,
              )).toList(),
            ),

          ),
          Visibility(
            visible: selectedIndexToggle == 1,
            child: buildManualAttendanceWidget(
              noConsentStudents.keys.map((studentName) => lister.Student(
                studentName: studentName,
                personalPicture: noConsentStudents[studentName]!,
              )).toList(),
            ),

          ),
          // _image.path.isNotEmpty
          //     ? Image.file(File(_image.path))
          //     : Container(), // Show the image if it exists, otherwise an empty container
        ],
      ),
    ),
    );
  }









  //WIDGETS


// ---------------- Automated Attendance Widget ----------------
  Widget buildAutoAttendanceWidget(List<lister.Student> hasConsentStudents) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200.0, // Set a fixed height for the ListView.builder
            child: ListView.builder(
              itemCount: hasConsentStudents.length,
              itemBuilder: (context, index) {
                return buildAutoAttendanceListItem(hasConsentStudents[index]);

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAutoAttendanceListItem(lister.Student student) {
    String studentName = student.studentName;
    String personalPic = student.personalPicture;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Circular image
          Container(
            width: 45.0,
            height: 45.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: personalPic.isNotEmpty
                    ? Image.network(
                  personalPic,
                  fit: BoxFit.cover, // Adjust the BoxFit as needed
                ).image : const AssetImage('assets/avatar.png'), // Use the image path
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          // Student name
          Text(
            studentName,
            style: const TextStyle(fontSize: 16.0),
          ),
          // Spacer to add space between student name and buttons
          const Spacer(),
          // Buttons for taking photo and picking image
          ElevatedButton(
            onPressed: () {
              // Implement a function to handle taking a photo
              takePhoto();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primaryNavy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            ),
            child: const Text('Take Photo'),
          ),
          const SizedBox(width: 10.0), // Add spacing between buttons
          ElevatedButton(
            onPressed: () {
              // Call the pickImage function when the button is pressed
              pickImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primaryNavy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            ),
            child: const Text('Pick Image'),
          ),
        ],
      ),
    );
  }



  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print("You picked an image: $_image");
        }
      });

      await apiFaceReco.compareImage(_image!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }





// Function to handle taking a photo
  Future<void> takePhoto() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print("u did take an image: $_image");
        }
      });

      // After taking the photo, you can integrate AI model logic for verification
      if (_image != null) {
        print("Shakla it worked");

        try {
          await apiFaceReco.compareImage(_image!);

        } catch (e) {
          print('Error comparing image (from ui): $e');
        }
      }


    } catch (e) {
      print('Error taking photo: $e');
    }
  }













  // ---------------- Manual Attendance Widget ----------------
  Widget buildManualAttendanceWidget(List<lister.Student> noConsentStudents) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 450.0, // Set a fixed height for the ListView.builder
            child: ListView.builder(
              itemCount: noConsentStudents.length,
              itemBuilder: (context, index) {
                return buildManualAttendanceListItem(noConsentStudents[index]);
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget buildManualAttendanceListItem(lister.Student student) {
    String studentName = student.studentName;
    String personalPic = student.personalPicture;

    // List of attendance states
    List<String> attendanceStates = ['Present', 'Late', 'Absent'];

    // Variable to store the selected attendance state
    String selectedAttendanceState = attendanceStates[0];

    // Controller for the CustomDropdown
// Create a controller for each student
    if (!attendanceControllers.containsKey(student.studentName)) {
      attendanceControllers[student.studentName] = TextEditingController();
    }

    TextEditingController? attendanceController = attendanceControllers[student.studentName];


    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Circular image (you can replace the placeholder with an actual image)
              // Circular image
              Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: personalPic.isNotEmpty
                      ? Image.network(
                      personalPic,
                    fit: BoxFit.cover, // Adjust the BoxFit as needed
                  ).image : const AssetImage('assets/avatar.png'), // Use the image path
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              // Student name
              Text(
                studentName,
                style: const TextStyle(fontSize: 16.0),
              ),


              // Spacer to add space between student name and dropdown button
              const Spacer(),
              // CustomDropdown for attendance state
              SizedBox(
                width: 140, // Adjust the width as needed
                child: CustomDropdown(
                  hintText: 'choose',
                  items: attendanceStates
                      .map((String state) => state.toString())
                      .toList(),

                  controller: attendanceController!,
                  fillColor: Colors.transparent,
                  onChanged: (selectedItem) {

                    setState(() {
                      selectedAttendanceState = selectedItem.toString(); // Directly assign the selected item

                      // Access the selected class
                      if (selectedAttendanceState != null) {
                        print('Selected attendance: $selectedAttendanceState');

                      }
                    });
                  },
                ),


              ),
            ],
          ),
        ),

        const Divider(
          thickness: 0.2,
          color: Colors.grey,
        ), // Divider after each student
      ],
    );
  }












  //FUNCTIONS

  // function fetches all the classes from the API
  Future<void> fetchClassesList(int preschoolId) async {
    try {
      final ApiClassesLister classesLister = ApiClassesLister();
      final List<Class> classes = await classesLister.getClassesList(preschoolId);

      setState(() {
        // Update the global list with the received classes
        classesList = classes.map((classItem) => Class(id: classItem.id, className: classItem.className)).toList();
      });

    } catch (e) {
      print("Classes listing issue!$e");
    }
  }



  //function to fetch all students in a class from the API
  Future<void> listStudents(int preschoolId, int classId) async {
    try {
      final lister.APIStudentsLister studentsLister = lister.APIStudentsLister();
      final List<lister.Student> students = await studentsLister.getStudentsList(preschoolId, classId);

      setState(() {
        // Update the global list with the received students
        studentsList = students;
      });

      // Clear existing lists
      hasConsentStudents.clear();
      noConsentStudents.clear();

      for (var studentItem in students) {
        print("Student ID: ${studentItem.id}");
        print('Student Name: ${studentItem.studentName}, student say yes to AI: ${studentItem.hasConsent}');
        print("Student personal PIC ${studentItem.personalPicture}");

        final info.APIStudentInfo studentInfo = info.APIStudentInfo();
        info.Student studentPicGetter = await studentInfo.getStudentInfo(studentItem.id!);



        // Classify based on hasConsent boolean
        if (studentItem.hasConsent == true) {
          hasConsentStudents[studentItem.studentName] = studentPicGetter.personalPicture;
          print(studentPicGetter.personalPicture);
        } else {
          noConsentStudents[studentItem.studentName] = studentPicGetter.personalPicture;
          print(studentPicGetter.personalPicture);
        }

      }

      // Debugging print statements
      print('List of students with consent: $hasConsentStudents');
      print('List of students without consent: $noConsentStudents');
    } catch (e) {
      print("Students listing issue!");
    }
  }





}
