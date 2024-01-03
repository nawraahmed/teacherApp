import 'package:flutter/material.dart';
import 'Styling_Elements/BackButtonRow.dart';


class AttendanceDetailsScreen extends StatelessWidget {
  final String date;
  final List<StudentAttendance> studentAttendanceList;

  const AttendanceDetailsScreen({
    Key? key,
    required this.date,
    required this.studentAttendanceList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80.0),
          BackButtonRow(title: 'Attendance Details'),

      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          'Date: $date',
          style: Theme.of(context).textTheme.titleMedium, // Adjust the style as needed
        ),
      ),

          // TODO: design changes
      Expanded(
        child: ListView.builder(
              itemCount: studentAttendanceList.length,
              itemBuilder: (BuildContext context, int index) {
                final studentAttendance = studentAttendanceList[index];

                return ListTile(
                  title: Text(studentAttendance.studentName),
                  subtitle: Text('Attendance Status: ${studentAttendance.attendanceStatus}'),
                  // You can customize the ListTile based on your needs
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}

class StudentAttendance {
  final String studentName;
  final String attendanceStatus;

  StudentAttendance({
    required this.studentName,
    required this.attendanceStatus,
  });
}
