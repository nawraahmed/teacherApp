import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'Services/APIClassesLister.dart' as APIClassesLister;
import 'Services/APIDeleteEvent.dart';
import 'Services/APIListEvents.dart' as APIListEvents;
import 'Styling_Elements/NewEventDialog.dart';
import 'main.dart';
import 'package:the_app//Users/nawraalhaji/StudioProjects/teacherApp/.dart_tool/flutter_gen/gen_l10n/app_localization.dart';

// The stateful widget for the home page
class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  _AllEventsState createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> with SingleTickerProviderStateMixin {
DateTime today = DateTime.now();
late DateTime _selectedDay;
List<APIClassesLister.Class> classesList = [];
List<int> selectedClasses = [];

late DateTime _focusedDay = DateTime.now();
late final DateTime _firstDay = DateTime.now().subtract(const Duration(days: 1000));
late final DateTime _lastDay = DateTime.now().add(const Duration(days: 1000));

List<APIListEvents.Event> _events = [];
List<APIListEvents.Event> _eventsForSelectedDay = [];
bool _showDetails = false;

// Define markers variable
var defaultMarkers = const BoxDecoration(
  color: Styles.primaryBlue,  // Default color for markers
  shape: BoxShape.circle,
);


@override
void initState() {
  super.initState();


  // Holds the currently selected date
  _selectedDay = DateTime.now();

  // Call the events lister
  fetchAllEvents(1);

  fetchClassesList(1);
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('${AppLocalizations.of(context)!.events}'),
      automaticallyImplyLeading: false,
    ),
    body: Stack(
        children: [
    SingleChildScrollView(
    child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),

            child: TableCalendar(
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),

              focusedDay: _focusedDay,
              firstDay: _firstDay,
              lastDay: _lastDay,


              availableGestures: AvailableGestures.all,

              calendarStyle: CalendarStyle(

                markerDecoration: defaultMarkers,
              ),

              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showEventDetails(selectedDay);
              },

              eventLoader: (day) {
                List<Widget> dayMarkers = [];

                for (var event in _events) {
                  DateTime eventDate = DateTime.parse(event.eventDate);
                  if (isSameDay(eventDate, day)) {
                    // Customize marker based on event type
                    defaultMarkers = const BoxDecoration(color: Styles.primaryBlue,  shape: BoxShape.circle);

                    dayMarkers.add(Container(
                      decoration: defaultMarkers,
                      width: 8.0,
                      height: 8.0,
                    ));
                  }
                }

                return dayMarkers;
              },

            ),
          ),
          const SizedBox(height: 15.0),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 140.0), // Added bottom margin
              child: GestureDetector(
                onTap: () {
                  DateTime selectedDay = _selectedDay;

                  // Check if the selected date is in the past
                  if (selectedDay.isBefore(today)) {
                    // Show an error dialog
                    Styles.showCustomDialog(
                      context,
                      'error',
                      'Invalid Date',
                      'Event date must be a future date',
                      Icons.error_outline_rounded,
                    );

                  } else {

                    // Check if there is already an event for the selected date
                    bool hasOverlappingEvent = _events.any((event) {
                      DateTime eventDate = DateTime.parse(event.eventDate);
                      return isSameDay(eventDate, selectedDay);
                    });

                    if (hasOverlappingEvent) {
                      // Show an error dialog for overlapping events
                      Styles.showCustomDialog(
                        context,
                        'error',
                        'Invalid Date',
                        'Overlapping events is not allowed',
                        Icons.error_outline_rounded,
                      );
                    } else {
                      // Show the new event sheet
                      newEventSheet(context, selectedDay, classesList);
                    }

                  }

                },
                child: Container(
                  height: 45.0,
                  width: 150,
                  margin: const EdgeInsets.only(bottom: 66.0), // Add bottom margin here
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
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
    ),
    ),


          if (_showDetails)
            Positioned(

              bottom: 0,
              left: 0,
              right: 0,
              child: EventDetailsWidget(_eventsForSelectedDay),
            ),

        ],
    ),
  );
}






  void _showEventDetails(DateTime selectedDate) {
    // Retrieve events for the selected date
    List<APIListEvents.Event> selectedDateEvents = _events
        .where((event) => isSameDay(DateTime.parse(event.eventDate), selectedDate))
        .toList();

    // Show details only if there are events for the selected date
    if (selectedDateEvents.isNotEmpty) {
      // Update _eventsForSelectedDay
      _eventsForSelectedDay = selectedDateEvents;


      _showDetails = true;

    } else {
      // Clear _eventsForSelectedDay and hide details if there are no events
      _eventsForSelectedDay.clear();
      _showDetails = false;
    }

    // Refresh the UI to show/hide the EventDetailsWidget
    setState(() {});
  }










// WIDGETS
  void newEventSheet(BuildContext context, DateTime selectedDate, List<APIClassesLister.Class> classesList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewEventDialog(selectedDate: selectedDate, classesList: classesList, onEventCreated: refreshEvents);
      },
    );
  }











  //FUNCTIONS
Future<void> fetchAllEvents(int preschoolId) async {

  try {
    // Create an instance of APIListEvents
    APIListEvents.APIListEvents apiListEvents = APIListEvents.APIListEvents();
    APIListEvents.EventListResponse? eventsResponse = await apiListEvents.GetEventsList(preschoolId);

    // Check if the response is not null
    if (eventsResponse != null) {
      // Assign the list of events to the global variable
      _events = eventsResponse.events;

      // Now you can work with the list of events
      for (APIListEvents.Event event in _events) {
        print('Event Name: ${event.eventName}');
        print("Public Event? ${event.publicEvent}");
        // Add more properties as needed
      }
    } else {
      print('Failed to get the list of events.');
    }
  } catch (e) {
    print("Events listing issue! $e");
  }

}





  Future<void> fetchClassesList(int preschoolId) async {
    try {
      final APIClassesLister.ApiClassesLister classesLister = APIClassesLister.ApiClassesLister();
      final List<APIClassesLister.Class> classes = await classesLister.getClassesList(preschoolId);

      setState(() {
        // Update the global list with the received classes
        classesList = classes.map((classItem) => APIClassesLister.Class(id: classItem.id, className: classItem.className)).toList();
      });

    } catch (e) {
      print("Classes listing issue!$e");
    }
  }



  Future<void> refreshEvents() async {
    await fetchAllEvents(1); // Assuming 1 is your preschoolId
    setState(() {});
  }


}



//CLASSES
class EventDecoration {
  final BoxDecoration decoration;
  final TextStyle textStyle;

  EventDecoration({
    required this.decoration,
    required this.textStyle,
  });

  // Copy constructor for creating a new instance
  EventDecoration.fromPublic()
      : decoration = BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(13),
    color: Colors.red,
  ),
        textStyle = const TextStyle(
          color: Colors.white,
        );

  // Copy constructor for creating a new instance
  EventDecoration.fromPrivate()
      : decoration = BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(13),
    color: Colors.blue,
  ),
        textStyle = const TextStyle(
          color: Colors.white,
        );
}



class EventDetailsWidget extends StatelessWidget {
  final List<APIListEvents.Event> events;

  const EventDetailsWidget(this.events, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          'Event Details',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: events.length,
          itemBuilder: (context, index) {
            APIListEvents.Event event = events[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0), // Adjust the height to add space between title and subtitle

            Padding(
            padding: const EdgeInsets.all(15.0),

              child: Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0), // Adjust the border radius for rounded corners
                color: Styles.primaryNavy, // Adjust the color of the rounded rectangle
                ),
                child: ListTile(
                  title: Text(
                  event.eventName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Styles.primaryBlue),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const SizedBox(height: 8.0), // Adjust the height to add space between title and subtitle
                      Text(
                      event.notes,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        event.publicEvent
                            ? 'Public Event'
                            : 'Private Event',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),


                trailing: MoreActionsButton(
                  onEditPressed: () {
                  // Handle edit action
                  // You may want to navigate to a new screen for editing
                  // or show another dialog for editing.
                  },


                  onDeletePressed: () {
                    // Handle delete action
                    // You may want to show a confirmation dialog before deleting.
                    showDeleteEventDialog(context, event.id);
                  },
                  ),
                ),
              ),
            ),

            ],
            );
          },
        ),
      ],
    );
  }






  static void showDeleteEventDialog(BuildContext context, int eventIdToDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(255, 193, 7, 0.3),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0), // Adjust the padding as needed
                    child: Icon(
                      Icons.warning_rounded,
                      color: Color.fromRGBO(255, 193, 7, 1),
                      size: 40.0,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),


                const Text(
                  'Warning',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'Are you sure you want to delete this event?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 20.0),



                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // User chose Delete, call APIDeleteEvent client here
                        APIDeleteEvent deleteEventClient = APIDeleteEvent();

                        deleteEventClient.DeleteEventById(eventIdToDelete).then((result) {
                          if (result != null) {
                            // Handle successful deletion
                            print("Event deleted successfully");


                          } else {
                            // Handle deletion failure
                            print("Failed to delete event");

                            //show another prompt

                          }
                        }).catchError((error) {
                          // Handle error
                          print("Error: $error");
                        });

                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: const Color.fromRGBO(252, 41, 41, 1),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // User chose Cancel, simply close the dialog
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: Styles.primaryGray,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),


              ],
            ),
          ),
        );
      },
    );

  }



}






class MoreActionsButton extends StatelessWidget {
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  MoreActionsButton({
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.white),
        onSelected: (value) {
          if (value == 'edit') {
            onEditPressed();
          } else if (value == 'delete') {
            onDeletePressed();
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'edit',
            child: ListTile(
              title: Text(
                'Edit Event',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          PopupMenuItem<String>(
            height: 1,
            child: Container(
              height: 1,
              color: Colors.grey.withOpacity(0.5), // Set the alpha value for transparency
            ),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
              title: Text(
                'Delete Event',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}






