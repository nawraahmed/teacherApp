import 'Services/APICreateRequest.dart';
import 'Services/APIListStationary.dart';
import 'Styling_Elements/BackButtonRow.dart';
import 'package:flutter/material.dart';
import 'Services/APIClassesLister.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

import 'main.dart';

class StationaryRequestForm extends StatefulWidget {
  const StationaryRequestForm({Key? key}) : super(key: key);

  @override
  _StationaryRequestFormState createState() => _StationaryRequestFormState();
}

class _StationaryRequestFormState extends State<StationaryRequestForm>
    with SingleTickerProviderStateMixin {
  List<Class> classesList = [
    Class(className: 'Select class', id: 1)
  ]; // Initialize with a default value
  Class? selectedClass; // Selected class
  Stationary? selectedItem;
  final statCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  List<Stationary> stationaryList = [
    Stationary(stationaryName: 'Select Item', quantityAvailable: 0, id: 0, )
  ]; // Initialize with a default item
  final _formKey = GlobalKey<FormState>();
  TextEditingController quantityController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClassesList(1);
    fetchStationary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Column(
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
                  Align(
                    alignment: Alignment.topLeft,
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
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30.0), // Adjust the space as needed

                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Choose Stationary Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Styles.primaryGray,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomDropdown(
                      hintText: 'Select Item',
                      items: stationaryList
                          .map((Stationary item) => item.stationaryName)
                          .toList(),
                      controller: statCtrl,
                      fillColor: Colors.transparent,
                      onChanged: (selected) {
                        setState(() {
                          selectedItem = stationaryList
                              .firstWhere((item) => item.stationaryName == selected);
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
      ),
    );
  }




//WIDGETS
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          TextFormField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
            ),
          ),

          const SizedBox(height: 16.0),

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


          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Process the form data
                print('Requested Quantity: ${quantityController.text}');
                print('Notes: ${notesController.text}');

                // Create an instance of APICreateRequest
                final apiCreateRequest = APICreateRequest();

                // Call the createNewStaReq function and pass the relevant data
                apiCreateRequest.createNewStaReq('pending', int.parse(quantityController.text),
                  2, selectedItem?.id ?? 0, notesController.text,);
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


  //A function to fetch all the stationary along with the quantity
  Future<void> fetchStationary() async {
    try {
      final aPIListStationary = APIListStationary();
      List<Stationary> allStationary = await aPIListStationary.getStationaryRecords();

      setState(() {
        // Update the global list with the received stationary requests
        stationaryList = allStationary;
      });

      // Do something with each stationary request
      for (Stationary stationary in stationaryList) {
        print('Request ID: ${stationary.quantityAvailable}');
        print('Request ID: ${stationary.stationaryName}');
        print('-------------------'); // Separator between records
      }

    } catch (e) {
      print('Error fetching stationary: $e');
      // Handle the error as needed
    }
  }

}
