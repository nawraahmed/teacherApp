import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:the_app/student_profile.dart';
import 'Services/APIAttendancCIDbased.dart' as AttendancCIDbased;
import 'Services/APIListRequests.dart';
import 'Services/APIStudentsLister.dart' as StudentsLister;
import 'StationaryRequestDetails.dart';
import 'Styling_Elements/BackButtonRow.dart';
import 'attendance_details.dart';
import 'main.dart';
import 'package:intl/intl.dart';



class ClassDetails extends StatefulWidget {
  final String className;
  final int classId;

  const ClassDetails({
    Key? key,
    required this.className,
    required this.classId,
  }) : super(key: key);



  @override
  _ClassDetailsState createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> with SingleTickerProviderStateMixin {
  String selectedTab = 'attendance';
  List<StudentsLister.Student> studentsList = [];
  DateTime today = DateTime.now();
  List<String> tabs = ['attendance', 'students', 'events', 'stationary'];
  List<AttendancCIDbased.AttendanceRecord> recordsList = [];
  late Map<String, List<AttendancCIDbased.AttendanceRecord>> groupedRecords;
  late List<String> uniqueDates;
  List<StationaryRequest> requestsList = [];

  @override
  void initState() {
    super.initState();
    listStudents(1, widget.classId);

    print("Your in class: ${widget.classId}");

    fetchAttendanceRecords(110);
    initializeGroupedRecords();
    fetchStationaryRequests();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80.0),
          BackButtonRow(title: 'Class ${widget.className}'),
          const SizedBox(height: 30.0),
          buildTabRow(['attendance', 'students', 'events', 'stationary']),


          // Add your content based on the selectedTab here
          if (selectedTab == 'attendance') ...[
            // Content for attendance tab

            // Heading for past attendance records
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
              child: Text(
                'Past Attendance Records',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            // List of past attendance records
            Expanded(
              child: ListView.builder(
                itemCount: uniqueDates.length,
                itemBuilder: (BuildContext context, int index) {
                  // Get the unique date for the current index
                  final formattedDate = uniqueDates[index];

                  // Get all records for the current date
                  final recordsForDate = groupedRecords[formattedDate]!;

                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: Styles.primaryNavy,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Record of $formattedDate', // Use the formatted date here
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                        ),
                        onTap: () {
                          // Handle tap on a past record
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendanceDetailsScreen(
                                date: formattedDate,
                                studentAttendanceList: recordsForDate.map((record) {
                                  return StudentAttendance(
                                    studentName: record.student.studentName,
                                    attendanceStatus: record.attendanceStatus ?? 'Not recorded',
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),





          ] else if (selectedTab == 'students') ...[
            // Content for students tab
            const SizedBox(height: 15.0),

            // Search Bar
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Container(
            //     height: 45.0,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(30.0),
            //       border: Border.all(color: Colors.grey[300]!),
            //     ),
            //     child: Row(
            //       children: [
            //         const Expanded(
            //           child: TextField(
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //               hintText: 'Search',
            //               contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 10.0),
            //             ),
            //           ),
            //         ),
            //         Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20.0),
            //             color: Styles.primaryNavy,
            //           ),
            //           padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
            //           child: const Icon(
            //             Icons.search,
            //             color: Colors.white,
            //           ),
            //         ),
            //         const SizedBox(width: 15.0),
            //       ],
            //     ),
            //   ),
            // ),




            // Students Listing
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: studentsList.length,
                itemBuilder: (BuildContext context, int? index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                    child: Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: Styles.primaryNavy,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Text(
                          studentsList[index!].studentName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // Handle tap on a student
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentProfilePage(
                                studentName: studentsList[index!].studentName,
                                studentId: studentsList[index!].id,
                                className: widget.className,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),







          ] else if (selectedTab == 'events') ...[
            // Content for events tab
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TableCalendar(
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                focusedDay: today,
                firstDay: DateTime.utc(2002, 2, 19),
                lastDay: DateTime.utc(2100, 2, 19),
                onDaySelected: _onDaySelected,
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(13),
                    color: Styles.primaryNavy,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // Handle button press
                  },
                  child: Container(
                    height: 45.0,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Styles.primaryNavy,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'New Event',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


          ]else if (selectedTab == 'stationary') ...[

            // Heading for past attendance records
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
              child: Text(
                'Past Stationary Requests Records',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),


            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: requestsList.length,
                itemBuilder: (BuildContext context, int index) {
                  Color statusColor = Colors.white; // Default color

                  if (requestsList[index].statusName == 'Approved') {
                    statusColor = Styles.primaryPink;
                  } else if (requestsList[index].statusName == 'Pending') {
                    statusColor = Colors.white;
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                    child: Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: Styles.primaryNavy,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5.0),
                            Text(
                              '${formatDate(requestsList[index].createdAt)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Status: ${requestsList[index].statusName}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: statusColor),
                            ),
                            const SizedBox(height: 5.0),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // Handle tap on a stationary request
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StationaryRequestDetailsPage(stationaryRequest: requestsList[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),




          ],


        ],
      ),
    );
  }






  //WIDGETS
  Widget buildTabRow(List<String> tabs) {

    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (BuildContext context, int index) {
          final tabName = tabs[index];
          return buildTab(tabName);
        },
      ),
    );
  }



  Widget buildTab(String tabName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tabName;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: selectedTab == tabName ? Styles.primaryBlue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          tabName,
          style: TextStyle(
            color: selectedTab == tabName ? Colors.black : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }




  Widget buildEmptyScreen({required String imagePath, required String text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 150.0,
            width: 150.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }









//FUNCTIONS
  Future<void> listStudents(int preschoolId, int classId) async {
    try {
      final StudentsLister.APIStudentsLister studentsLister = StudentsLister.APIStudentsLister();
      final List<StudentsLister.Student> students = await studentsLister.getStudentsList(preschoolId, classId);

      setState(() {
        // Update the global list with the received students
        studentsList = students;
      });

      for (var studentItem in students) {
        print('student ID: ${studentItem.id}, Student Name: ${studentItem.studentName}');
      }
    } catch (e) {
      print("Students listing issue: $e");
    }

  }


  Future<void> fetchAttendanceRecords(int classId) async {
    try {
      final apiAttendance = AttendancCIDbased.APIAttendanceCIDbased();
      List<AttendancCIDbased.AttendanceRecord> attendanceRecords = await apiAttendance.getAttendanceRecords(classId);

      setState(() {
        // Update the global list with the received students
        recordsList = attendanceRecords;
      });

      // Initialize groupedRecords after updating the state
      initializeGroupedRecords();

      // Do something with each attendance record
      for (AttendancCIDbased.AttendanceRecord attendanceRecord in attendanceRecords) {
        print('Attendance Record Date: ${attendanceRecord.date}');
        print('Student Name: ${attendanceRecord.student.studentName}');
        print('Attendance Status: ${attendanceRecord.attendanceStatus}');
        // Add more fields as needed
        print('-------------------'); // Separator between records
      }

    } catch (e) {
      print('Error fetching attendance records: $e');
      // Handle the error as needed
    }
  }


  // Function to group records by date
  Map<String, List<AttendancCIDbased.AttendanceRecord>> groupRecordsByDate(List<AttendancCIDbased.AttendanceRecord> records) {
    final groupedRecords = <String, List<AttendancCIDbased.AttendanceRecord>>{};

    for (final record in records) {
      final formattedDate = DateFormat.yMMMMd().format(DateTime.parse(record.date));
      if (!groupedRecords.containsKey(formattedDate)) {
        groupedRecords[formattedDate] = [];
      }
      groupedRecords[formattedDate]!.add(record);
    }

    return groupedRecords;
  }

  void initializeGroupedRecords() {
    // Initialize groupedRecords
    groupedRecords = groupRecordsByDate(recordsList);

    // Get the list of unique dates
    uniqueDates = groupedRecords.keys.toList();
  }



  Future<void> fetchStationaryRequests() async {
    try {
      final apiListRequests = APIListRequests();
      List<StationaryRequest> allRequests = await apiListRequests.getRequestsRecords();

      // Filter requests based on the classId
      List<StationaryRequest> filteredRequests = allRequests.where((request) => request.classId == 27).toList();

      setState(() {
        // Update the global list with the received stationary requests
        requestsList = filteredRequests;
      });

      // Do something with each stationary request
      for (StationaryRequest request in filteredRequests) {
        print('Request ID: ${request.id}');
        print('Status Name: ${request.createdAt}');
        // print('Requested Quantity: ${request.requestedQuantity}');
        // // Add more fields as needed
        // print('-------------------'); // Separator between records
      }

    } catch (e) {
      print('Error fetching stationary requests: $e');
      // Handle the error as needed
    }
  }



  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  // Function to format date
  String formatDate(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final formattedDate = DateFormat.yMMMMd().format(dateTime);
    return formattedDate;
  }


}


class StationaryTab extends StatelessWidget {
  final List<StationaryRequest> requestsList;

  const StationaryTab({
    Key? key,
    required this.requestsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Heading for past stationary requests records
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
          child: Text(
            'Past Stationary Requests Records',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        // List of past stationary requests records
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: requestsList.length,
            itemBuilder: (BuildContext context, int index) {
              Color statusColor = Colors.white; // Default color

              if (requestsList[index].statusName == 'Approved') {
                statusColor = Styles.primaryPink;
              } else if (requestsList[index].statusName == 'Pending') {
                statusColor = Colors.white;
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                child: Container(
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Styles.primaryNavy,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5.0),
                        Text(
                          '${formatDate(requestsList[index].createdAt)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'Status: ${requestsList[index].statusName}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: statusColor),
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                    onTap: () {
                      // Handle tap on a stationary request
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StationaryRequestDetailsPage(stationaryRequest: requestsList[index]),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to format date
  String formatDate(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final formattedDate = DateFormat.yMMMMd().format(dateTime);
    return formattedDate;
  }
}


