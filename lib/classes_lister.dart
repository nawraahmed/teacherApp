import 'package:flutter/material.dart';

import 'Services/APIClassesLister.dart';
import 'Styling_Elemnts/BackButtonRow.dart';

class ClassLister extends StatefulWidget {
  const ClassLister({Key? key}) : super(key: key);

  @override
  _ClassListerState createState() => _ClassListerState();
}



class _ClassListerState extends State<ClassLister> with SingleTickerProviderStateMixin {

  List<Class> classesList = [];

  @override
  void initState() {
    super.initState();
    listTeacherClasses(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80.0),
          BackButtonRow(title: 'Classes'),

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: classesList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                  child: Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(214, 214, 214, 1),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Class ${classesList[index].className}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                          IconButton(
                            icon: Image.asset('assets/enter_black.png'),
                            onPressed: () {
                              // Handle button press
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
        ],
      ),
    );
  }


  //call the API Classes Lister to list all the classes based on teacher's preschool id
  Future<void> listTeacherClasses(int preschoolId) async {
    try {
      final ApiClassesLister apiClassesLister = ApiClassesLister();
      final List<Class> classes = await apiClassesLister.getClassesList(preschoolId);

      setState(() {
        // Update the global list with the received classes
        classesList = classes;
      });

      classes.forEach((classItem) {
        print('Class ID: ${classItem.id}, Class Name: ${classItem.className}');
      });

    }
      catch(e){
        print("Classes listing issue!");
    }

  }

}
