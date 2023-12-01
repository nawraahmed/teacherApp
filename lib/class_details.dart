import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Services/APIStudentsLister.dart';
import 'Styling_Elements/BackButtonRow.dart';
import 'main.dart';


class ClassDetails extends StatefulWidget {
  final String className;

  const ClassDetails({Key? key, required this.className}) : super(key: key);



  @override
  _ClassDetailsState createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> with SingleTickerProviderStateMixin {
  String selectedTab = 'attendance';
  List<Student> studentsList = [];
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    listStudents(1, 26);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80.0),
          BackButtonRow(title: 'Class ${widget.className}'),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTab('attendance'),
              buildTab('students'),
              buildTab('events'),
            ],
          ),
          // Add your content based on the selectedTab here
          if (selectedTab == 'attendance') ...[
            // Content for attendance tab







          ] else if (selectedTab == 'students') ...[
              // Content for students tab

            const SizedBox(height: 15.0),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 10.0),
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Styles.primaryNavy,
                      ),
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),

                      child: const Icon(
                        Icons.search,
                        color: Colors.white, // Set the icon color to white
                      ),
                    ),
                    const SizedBox(width: 15.0), // Add some space between the text field and icon
                  ],
                ),

              ),
            ),



            // Students Listing
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: studentsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                    child: Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              studentsList[index].studentName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              icon: Image.asset('assets/enter_black.png'),
                              onPressed: () {
                                // Handle button press
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ClassDetails(className: classesList[index].className),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),









            // Content for events tab
            ] else if (selectedTab == 'events') ...[

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TableCalendar(
                headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
                focusedDay: today,
                firstDay: DateTime.utc(2002, 2, 19),
                lastDay: DateTime.utc(2100, 2, 19),
                onDaySelected: _onDaySelected,
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),


                //styling
                calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(13),
                color: Styles.primaryNavy,
                ),
                ),

              ),
            ),

            //New Event Button
          const SizedBox(height: 15.0), // Add some space between the calendar and the button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
                child: GestureDetector(
                  onTap: () {
                    // Handle button press
                    // Add the logic to create a new event
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

            //List of Existing Events

          ],
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: selectedTab == tabName ? Styles.primaryNavy : Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          tabName,
          style: TextStyle(
            color: selectedTab == tabName ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }



  Future<void> listStudents(int preschoolId, int classId) async {
    try {
      final APIStudentsLister studentsLister = APIStudentsLister();
      final List<Student> students = await studentsLister.getStudentsList(preschoolId, classId);

      setState(() {
        // Update the global list with the received students
        studentsList = students;
      });

      for (var studentItem in students) {
        print('student ID: ${studentItem.id}, Student Name: ${studentItem.studentName}');
      }

    }
    catch(e){
      print("Students listing issue!");
    }

  }

  void _onDaySelected(DateTime day, DateTime focusedDay){
  setState(() {
    today = day;

  });
  }

}