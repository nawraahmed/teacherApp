import 'package:flutter/material.dart';
import 'package:the_app/evaluation_screen.dart';
import 'Styling_Elements/BackButtonRow.dart';
import 'main.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StudentProfilePage extends StatefulWidget {
  final String studentName;

  const StudentProfilePage({Key? key, required this.studentName}) : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> with SingleTickerProviderStateMixin {
  String className = 'Class ABC';
  int? selectedIndexToggle=0;
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
                // Circular image
                const CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('assets/avatar.png'),
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
                  className,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

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

}


//WIDGETS
Widget buildOldEvaluationsWidget(BuildContext context, List<String> oldEvaluations) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.5,
    child: ListView.separated(
      itemCount: oldEvaluations.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(oldEvaluations[index].toString(), style: Theme.of(context).textTheme.bodyMedium),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EvaluationScreen(isEditable: true),
              ),
            );
          },
        );
      },
    ),
  );
}


Widget buildNewEvaluationsWidget(BuildContext context, List<String> newEvaluations) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.5,
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
                builder: (context) => const EvaluationScreen(isEditable: false),
              ),
            );
          },
        );
      },
    ),
  );
}

