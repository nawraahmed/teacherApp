import 'package:flutter/material.dart';
import 'package:the_app/Services/APIStudentInfo.dart';
import 'package:the_app/evaluation_screen.dart';
import 'Styling_Elements/BackButtonRow.dart';
import 'main.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StudentProfilePage extends StatefulWidget {
  final String studentName;
  final int studentId;
  final String className;

  const StudentProfilePage({
    Key? key,
    required this.studentName,
  required this.studentId,
    required this.className,
  }) : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> with SingleTickerProviderStateMixin {

  int? selectedIndexToggle = 0;
  bool isLoading = true;

  // Define fake data for testing
  List<String> oldEvaluations = [
    'Old Evaluation 1',
    'Old Evaluation 2',
    'Old Evaluation 3',
    'Old Evaluation 4',
  ];

  List<String> newEvaluations = [
    'New Evaluation 1',
    'New Evaluation 2',
    'New Evaluation 3',
    'New Evaluation 4',
  ];

  late String grade = '';
  late int contact_number1 = 0;
  late int contact_number2 = 0;
  late String guardian = '';
  late String medicalHistory = '';
  late String gender = '';
  late String personalPicture = '';

  // Create lists of titles and values
  List<String> titles = [
    'Grade',
    'Contact Number 1',
    'Contact Number 2',
    'Guardian',
    'Medical History',
    'Gender'
  ];
  List<String> values = [''];

  @override
  void initState() {
    super.initState();
    fetchStudentInfo(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80.0),
            const BackButtonRow(title: 'Student Profile',),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Circular image using Image.network
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: personalPicture.isNotEmpty
                        ? Image.network(
                      personalPicture,
                      fit: BoxFit.cover, // Adjust the BoxFit as needed
                    ).image : const AssetImage('assets/avatar.png'),
                  ),
                  const SizedBox(height: 20.0),

                  // Name text
                  Text(
                    widget.studentName,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                  ),

                  const SizedBox(height: 10.0),

                  // Class name text
                  Text(
                    'Class ${widget.className}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),


            //Student Personal Info
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Personal Details',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 10.0),


            // Show Personal Details
            isLoading ? buildLoadingIndicator() : buildRoundedContainer(
                titles, values, context),


            const SizedBox(height: 30.0),
            // Left-aligned heading
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Student Evaluation',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Toggle button to switch between old and new evaluations
            ToggleSwitch(
              minWidth: 170.0,
              cornerRadius: 20.0,
              activeBgColor: const [Styles.primaryNavy],
              inactiveBgColor: Colors.grey,
              activeFgColor: Colors.white,
              inactiveFgColor: Colors.white,
              initialLabelIndex: selectedIndexToggle,
              totalSwitches: 2,
              labels: const ['Old evaluations', ' New evaluations'],
              radiusStyle: true,
              onToggle: (index) {
                print('switched to: $index');
                setState(() {
                  selectedIndexToggle = index;
                });
              },
            ),


            // Display the appropriate widget based on the selected index
            Visibility(
              visible: selectedIndexToggle == 0,
              child: buildOldEvaluationsWidget(context, oldEvaluations),
            ),

            Visibility(
              visible: selectedIndexToggle == 1,
              child: buildOldEvaluationsWidget(context, newEvaluations),
            ),


          ],
        ),
      ),
    );
  }


//FUNCTIONS
  Future<void> fetchStudentInfo(int studentId) async {
    try {
      final APIStudentInfo studentInfo = APIStudentInfo();
      Student student = await studentInfo.getStudentInfo(studentId);

      setState(() {
        grade = student.grade;
        contact_number1 = student.contactNumber1;
        contact_number2 = student.contactNumber2;
        guardian = student.guardianName;
        medicalHistory = student.medicalHistory;
        gender = student.gender;
        personalPicture = student.personalPicture;

        values = [
          grade,
          contact_number1.toString(),
          contact_number2.toString(),
          guardian,
          medicalHistory,
          gender
        ];


        // Add debugging print statements
        print('Grade: $grade');
        print('Contact Number 1: $contact_number1');
        print('Contact Number 2: $contact_number2');
        print('Guardian: $guardian');
        print('Medical History: $medicalHistory');
        print('Gender: $gender');
        print('Personal Picture: $personalPicture');

        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      print("Student info fetching issue: $e");
      // Handle error and set loading to false
      setState(() {
        isLoading = false;
      });
    }
  }


//WIDGETS
  Widget buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }


  Widget buildOldEvaluationsWidget(BuildContext context,
      List<String> oldEvaluations) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.5,
      child: ListView.separated(
        itemCount: oldEvaluations.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(oldEvaluations[index].toString(), style: Theme
                .of(context)
                .textTheme
                .bodyMedium),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const EvaluationScreen(isEditable: true),
                ),
              );
            },
          );
        },
      ),
    );
  }


  Widget buildNewEvaluationsWidget(BuildContext context,
      List<String> newEvaluations) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.5,
      child: ListView.separated(
        itemCount: newEvaluations.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(newEvaluations[index]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const EvaluationScreen(isEditable: false),
                ),
              );
            },
          );
        },
      ),
    );
  }

// Rounded Rectangle Container Widget
  Widget buildRoundedContainer(List<String> titles, List<String> values, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          titles.length,
              (index) => Column(
            children: [
              // Row containing title and value
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title with circular background
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Styles.primaryBlue,
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Text(
                      titles[index],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),

                  // Value
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      values[index],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // // Divider
              // Container(
              //   height: 1,
              //   color: Colors.grey.withOpacity(0.5),
              // ),
            ],
          ),
        ),
      ),
    );
  }




}
