import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Services/APICreateEvent.dart';
import '../Services/APIClassesLister.dart' as APIClassesLister;
import '../Services/APIListEvents.dart' as APIListEvents;
import '../main.dart';




class NewEventDialog extends StatefulWidget {
  final DateTime selectedDate;
  final List<APIClassesLister.Class> classesList;

  NewEventDialog({required this.selectedDate, required this.classesList});

  @override
  _NewEventDialogState createState() => _NewEventDialogState();
}

class _NewEventDialogState extends State<NewEventDialog> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  List<int> selectedClasses = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle the creation of the event
                        String eventName = eventNameController.text;
                        String notes = notesController.text;

                        // Call the endpoint, pass all parameters needed
                        APICreateEvent eventCreator = APICreateEvent();

                        eventCreator.createEvent(
                          eventName: eventName,
                          eventDate: widget.selectedDate.toString(),
                          notes: notes,
                          notifyParents: false,
                          notifyStaff: false,
                          publicEvent: false,
                          createdBy: 42,
                          preschoolId: 1,
                          classes: selectedClasses, // Pass the selected classes
                        ).then((result) {
                          if (result != null) {
                            // Handle successful response
                            print("Event created successfully");
                          } else {
                            // Handle failure
                            print("Failed to create event");
                          }
                        }).catchError((error) {
                          // Handle error
                          print("Error: $error");
                        });

                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Create Event',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                TextField(
                  controller: eventNameController,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Selected Date: ${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // DropdownButton for selecting classes
                DropdownButton<int>(
                  hint: const Text('Select Class(es)'),
                  value: selectedClasses.isEmpty ? null : selectedClasses[0],
                  onChanged: (int? newValue) {
                    // Update the selected classes
                    if (newValue != null) {
                      setState(() {
                        selectedClasses = [...selectedClasses];
                        if (selectedClasses.contains(newValue)) {
                          selectedClasses.remove(newValue);
                        } else {
                          selectedClasses.add(newValue);
                        }
                        print('Selected Classes: $selectedClasses');
                      });
                    }
                  },
                  items: widget.classesList.map((APIClassesLister.Class classItem) {
                    return DropdownMenuItem<int>(
                      value: classItem.id,
                      child: Text(classItem.className),
                    );
                  }).toList(),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                ),

                // Display selected classes as chips
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: selectedClasses.map((int classId) {
                      return Chip(
                        label: Text(
                          widget.classesList.firstWhere((classItem) => classItem.id == classId).className,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Styles.primaryBlue,
                        deleteIcon: const Icon(Icons.cancel, color: Colors.white),
                        onDeleted: () {
                          setState(() {
                            selectedClasses.remove(classId);
                            print('Selected Classes: $selectedClasses');
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}