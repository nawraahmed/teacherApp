import 'dart:io';
import 'package:flutter/material.dart';
import 'package:the_app/Services/APIFaceReco.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'Services/APIAttendancCIDbased.dart';
import 'Services/APIClassesLister.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'Services/APICreateAttendanceRecord.dart';
import 'Services/APIStudentInfo.dart' as info;
import 'Services/APIStudentsLister.dart' as lister;
import 'main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


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
  Map<String, String> hasConsentStudentIds = {};
  Map<String, String> noConsentStudentIds = {};
  bool reportGenerated = false;

  int? selectedIndex = 0; // Keep track of the selected index

  final classCtrl = TextEditingController();
  Map<String, TextEditingController> attendanceControllers = {};

  List<lister.Student> studentsList = [];
  int? selectedIndexToggle=0;

  File _image = File(''); // Initialize _image with an empty File
  final picker = ImagePicker();
  final APIFaceReco apiFaceReco = APIFaceReco();

  Set<int> studentIdsSet = {};

  final APIAttendanceCIDbased apiAttendance = APIAttendanceCIDbased();


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
                          getAttendanceRecords(selectedClass!.id);
                          print('Selected Class ID: ${selectedClass!.id}');
                          // print('Selected Class Name: ${selectedClass!.className}');

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
              //print('switched to: $index');
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
                id: int.parse(noConsentStudentIds[studentName]!), // Convert to int
              )).toList(),
            ),
          ),


      // Add the Generate Attendance Report button
      Visibility(
        visible: selectedClass != null && !reportGenerated, // Show the button if report is not generated
        child: ElevatedButton(
          onPressed: studentIdsSet.isEmpty ? generateAttendanceReport : null,
          child: const Text('Generate Attendance Report'),
          style: ElevatedButton.styleFrom(
            backgroundColor: studentIdsSet.isEmpty ? Styles.primaryBlue : Colors.grey, // Adjust colors accordingly
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          ),
        ),
      ),


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
                ).image
                    : const AssetImage('assets/avatar.png'), // Use the image path
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
          Visibility(
            visible: !reportGenerated, // Show the buttons if report is not generated
            child: Row(
              children: [
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
          //print("You picked an image: $_image");
        }
      });

      final apiResponse = await apiFaceReco.compareImage(_image);

      if (apiResponse != null) {
        // Format the student name (remove underscore)
        String formattedName = apiResponse.results.first.name.replaceAll(RegExp(r'[_0-9]'), ' ');

        // Remove the student ID from studentIdsSet after taking attendance
        int studentId = int.parse(apiResponse.results.first.studentId);
        studentIdsSet.remove(studentId);
        print("Removed an id $studentIdsSet");

        // Display a dialog with the retrieved image and formatted student name
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Attendance Recorded!'),
              content: Column(
                children: [
                  Image.memory(apiResponse.decodedImage!), // Display the decoded image
                  const SizedBox(height: 16),
                  Text('Student Name:$formattedName'), // Display the formatted student name with ID
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle the case where the API response is null
        print('API response is null');
      }
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
          //print("u did take an image: $_image");
        }
      });

      // After taking the photo, you can integrate AI model logic for verification
      if (_image != null) {
        //print("Shakla it worked");

        try {
          await apiFaceReco.compareImage(_image);
        } catch (e) {
          print('Error comparing image (from ui): $e');
        }
      }


    } catch (e) {
      print('Error taking photo: $e');
    }
  }



















  // ---------------- Manual Attendance Widget ----------------
  Widget buildManualAttendanceWidget(List<lister.Student> noConsentStudentsMW,) {
    // Declare attendanceStates at the beginning of the method
    List<String> attendanceStates = ['Present', 'Late', 'Absent'];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          SizedBox(
            height: 230.0,
            child: ListView.builder(
              itemCount: noConsentStudentsMW.length,
              itemBuilder: (context, index) {
                return buildManualAttendanceListItem(noConsentStudentsMW[index], attendanceStates);
              },
            ),
          ),

          const Divider(
            thickness: 0.2,
            color: Colors.grey,
          ),

          // Add the Visibility widget for "Submit Manual Attendance" button
          Visibility(
            visible: !reportGenerated, // Show the button if report is not generated
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Create a list to store manual attendance information for all students
                  List<Map<String, dynamic>> manualAttendanceList = [];

                  // Iterate over each student and add their attendance information to the list
                  noConsentStudentsMW.forEach((student) {
                    String studentName = student.studentName;
                    String selectedAttendanceState = attendanceControllers[studentName]?.text ?? attendanceStates[0];

                    manualAttendanceList.add({
                      'studentId': student.id,
                      'studentName': studentName,
                      'attendanceState': selectedAttendanceState,
                    });
                  });

                  // Call the function to create attendance records for manual attendance
                  createAttendanceRecords(manualAttendanceList);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primaryNavy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                ),
                child: const Text('Submit Manual Attendance'),
              ),
            ),
          ),


        ],
      ),
    );
  }





  Widget buildManualAttendanceListItem(lister.Student student, List<String> attendanceStates) {
    int studentId = student.id ?? 0;
    String studentName = student.studentName;
    String personalPic = student.personalPicture;

    // List of attendance states
    List<String> attendanceStates = ['Present', 'Late', 'Absent'];

    // Variable to store the selected attendance state
    String selectedAttendanceState = attendanceStates[0];


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
        ),

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

        //print("Student ID: ${studentItem.id}");
        //print('Student Name: ${studentItem.studentName}, student say yes to AI: ${studentItem.hasConsent}');

        //create a personalPicture getter client
        final info.APIStudentInfo studentInfo = info.APIStudentInfo();
        info.Student studentPicGetter = await studentInfo.getStudentInfo(studentItem.id!);


        // Classify based on hasConsent boolean
        if (studentItem.hasConsent == true) {
          // Store information for students with consent
          if (studentIdsSet.add(studentItem.id!)) {
            hasConsentStudents[studentItem.studentName] = studentPicGetter.personalPicture;
            hasConsentStudentIds[studentItem.studentName] = studentItem.id.toString();
          }
        } else {
          // Store information for students without consent
          if (studentIdsSet.add(studentItem.id!)) {
            noConsentStudents[studentItem.studentName] = studentPicGetter.personalPicture;
            noConsentStudentIds[studentItem.studentName] = studentItem.id.toString();
          }
        }

        print("students ids: $studentIdsSet");

      }

      // Debugging print statements
      //print('List of students with consent: $hasConsentStudents');
      //print('List of students without consent: $noConsentStudents');

    } catch (e) {
  print("Error listing students: $e");
  }

}




  Future<void> createAttendanceRecords(List<Map<String, dynamic>> attendanceData) async {
    try {
      final APICreateAttendanceRecord createAttendanceRecord = APICreateAttendanceRecord();
      await createAttendanceRecord.initializeBaseURL();
      await createAttendanceRecord.initializeEndpoint();

      for (var data in attendanceData) {
        int studentId = data["studentId"];
        String studentName = data['studentName'];
        String attendanceState = data['attendanceState'];

        try {
          // Use the createAttendanceRecord function to create attendance records
          await createAttendanceRecord.newAttendanceRecord(
            studentId: studentId,
            attendanceStatus: attendanceState,
          );

          // Remove the student ID from studentIdsSet after creating attendance record
          studentIdsSet.remove(studentId);
          print("Removed an id $studentIdsSet");

          print('Attendance record created for Student ID $studentId');

        } catch (e) {
          print('Error creating attendance record for Student $studentName: $e');
        }
      }

      // Optionally, you can show a success message or handle the completion
      print('All attendance records created successfully!');

      Styles.showCustomDialog(context, 'success', 'Attendance Recorded!', 'attendance recorded for all students', Icons.check);

    } catch (e) {
      print('Error initializing API for creating attendance records: $e');
    }
  }



  Future<void> getAttendanceRecords(int classId) async {
    try {
      // Call the API to get attendance records
      final List<AttendanceRecord> allAttendanceRecords = await apiAttendance.getAttendanceRecords(classId);

      // Get the current date
      final String currentDay = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Filter records for the current day
      final List<AttendanceRecord> attendanceRecords = allAttendanceRecords
          .where((record) => record.date.startsWith(currentDay))
          .toList();


      // Print details for each attendance record
      for (var record in attendanceRecords) {
        print('Student ID: ${record.studentId}');
        print('Date: ${record.date}');
        print('-----');
      }

      // Handle the retrieved attendance records as needed
      // print('Attendance Records for the current day: $allAttendanceRecords');
      // print('Attendance Records for the current day: $attendanceRecords');
      // You can update the state or perform other actions based on the retrieved data
      // setState(() {
      //   // Update the state with the retrieved attendance records
      // });

    } catch (e) {
      print('Error getting attendance records: $e');
      // Handle the error as needed
    }
  }


  void generateAttendanceReport() {
    // Replace this with your actual logic to generate the attendance report
    print('Generating Attendance Report...');
    // Add your logic here, such as generating a report file, sending data to the server, etc.
    // Once the report is generated, you can show a success message or handle it accordingly.

    setState(() {
      reportGenerated = true;
    });

    if(reportGenerated){
      Styles.showCustomDialog(context, 'success', 'Attendance Report Generated!', 'attendance recorded for all students', Icons.check);
    }
  }


  Future<bool> checkAttendanceRecordForCurrentDay(int studentId) async {
    try {
      // Call the API to get attendance records for the current day
      final List<AttendanceRecord> allAttendanceRecords = await apiAttendance.getAttendanceRecords(selectedClass!.id);

      // Get the current date
      final String currentDay = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Check if the student has an attendance record for the current day
      return allAttendanceRecords.any((record) => record.studentId == studentId && record.date.startsWith(currentDay));
    } catch (e) {
      print('Error checking attendance records: $e');
      // Handle the error as needed
      return false;
    }
  }






}
