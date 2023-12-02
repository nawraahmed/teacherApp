


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'Services/APIClassesLister.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'Services/APIStudentsLister.dart';
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
  List<String> hasConsentStudents = [];
  List<String> noConsentStudents = [];
  int? selectedIndex = 0; // Keep track of the selected index

  final classCtrl = TextEditingController();
  List<Student> studentsList = [];
  int? selectedIndexToggle=0;

  File _image = File(''); // Initialize _image with an empty File
  final picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    fetchClassesList(1);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Add top edge spacing (unified in all screens)
          const SizedBox(height: 80.0),
        //buildAutoAttendanceListItem('Nawraao'),

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
                          listStudents(1, 110);
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
            inactiveBgColor: Colors.grey,
            activeFgColor: Colors.white,
            inactiveFgColor: Colors.white,
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
            child: buildAutoAttendanceWidget(hasConsentStudents),
          ),
          Visibility(
            visible: selectedIndexToggle == 1,
            child: buildManualAttendanceWidget(noConsentStudents),
          ),

        ],
      ),
    );
  }









  //WIDGETS


// ---------------- Automated Attendance Widget ----------------
  Widget buildAutoAttendanceWidget(List<String> hasConsentStudents) {
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
                // return buildAutoAttendanceListItem(hasConsentStudents[index]);
                return buildAutoAttendanceListItem('Nawraa');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAutoAttendanceListItem(String studentName) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Circular image (you can replace the placeholder with an actual image)
          Container(
            width: 40.0,
            height: 40.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/avatar.png'),
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



          // Button to take a photo
          ElevatedButton(
            onPressed: () {
              // Implement a function to handle taking a photo
              takePhoto();
            },
            child: const Text('Take Photo'),
          ),
        ],
      ),
    );
  }

// Function to handle taking a photo
  Future<void> takePhoto() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });

      // After taking the photo, you can integrate AI model logic for verification
    } catch (e) {
      print('Error taking photo: $e');
    }
  }













  // ---------------- Manual Attendance Widget ----------------
  Widget buildManualAttendanceWidget(List<String> noConsentStudents) {
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



  Widget buildManualAttendanceListItem(String studentName) {
    // List of attendance states
    List<String> attendanceStates = ['Present', 'Late', 'Absent'];

    // Variable to store the selected attendance state
    String selectedAttendanceState = attendanceStates[0];

    // Controller for the CustomDropdown
    final attendanceStateCtrl = TextEditingController();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Circular image (you can replace the placeholder with an actual image)
              Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/avatar.png'),
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
                  controller: attendanceStateCtrl, // Add the controller
                  hintText: 'present',
                  items: attendanceStates,
                  fillColor: Colors.transparent,

                  onChanged: (value) {
                    setState(() {
                      selectedAttendanceState = value.toString();

                      // Access the selected class
                      if (selectedAttendanceState != null) {
                        print('Selected attendance: ${selectedAttendanceState}');

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
      final APIStudentsLister studentsLister = APIStudentsLister();
      final List<Student> students = await studentsLister.getStudentsList(preschoolId, classId);

      setState(() {
        // Update the global list with the received students
        studentsList = students;
      });

      // Clear existing lists
      hasConsentStudents.clear();
      noConsentStudents.clear();

      for (var studentItem in students) {
        print('Student Name: ${studentItem.studentName}, student say yes to AI: ${studentItem.hasConsent}');

        // Classify based on hasConsent boolean
        if (studentItem.hasConsent == true) {
          hasConsentStudents.add(studentItem.studentName);
        } else {
          noConsentStudents.add(studentItem.studentName);
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
