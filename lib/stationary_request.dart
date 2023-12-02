import 'Styling_Elements/BackButtonRow.dart';
import 'package:flutter/material.dart';
import 'Services/APIClassesLister.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

import 'main.dart';

class Stationary extends StatefulWidget {
  const Stationary({Key? key}) : super(key: key);

  @override
  _StationaryState createState() => _StationaryState();
}

class _StationaryState extends State<Stationary>
    with SingleTickerProviderStateMixin {
  List<Class> classesList = [
    Class(className: 'Select class', id: 1)
  ]; // Initialize with a default value
  Class? selectedClass; // Selected class
  final classCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  TextEditingController quantityController = TextEditingController();
  TextEditingController notesController = TextEditingController();

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
          const SizedBox(height: 80.0),
          const BackButtonRow(title: 'Stationary'),
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
                    items: classesList
                        .map((Class classItem) => classItem.className)
                        .toList(),
                    controller: classCtrl,
                    fillColor: Colors.transparent,
                    onChanged: (selectedItem) {
                      setState(() {
                        selectedClass = classesList.firstWhere(
                                (classItem) => classItem.className == selectedItem);

                        // Access the selected class
                        if (selectedClass != null) {
                          // Display the form on the screen
                          //_buildForm();
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20.0), // Adjust the space as needed
                // Display the form directly on the screen
                _buildForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }



//WIDGETS
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          // Requested Quantity Field
          TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Requested Quantity',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a quantity';
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Please enter numbers only';
              }
              return null;
            },
          ),

          const SizedBox(height: 16.0),

          // Notes Field
          TextFormField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
            ),
          ),

          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Process the form data
                print('Requested Quantity: ${quantityController.text}');
                print('Notes: ${notesController.text}');
              }
            },

            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }


  //FUNCTIONS
  Future<void> fetchClassesList(int preschoolId) async {
    try {
      final ApiClassesLister classesLister = ApiClassesLister();
      final List<Class> classes = await classesLister.getClassesList(
        preschoolId,
      );

      setState(() {
        // Update the global list with the received classes
        classesList =
            classes.map((classItem) => Class(id: classItem.id, className: classItem.className)).toList();
      });
    } catch (e) {
      print("Classes listing issue!$e");
    }
  }
}
