// import 'package:flutter/material.dart';
//
//
// class AllTeachers extends StatefulWidget {
//   const AllTeachers({Key? key}) : super(key: key);
//
//   @override
//   _AllTeachersState createState() => _AllTeachersState();
// }
//
// class _AllTeachersState extends State<AllTeachers> {
//   //List<Teacher> teachers = []; // Replace 'Teacher' with your actual teacher class
//
//   @override
//   void initState() {
//     super.initState();
//     // Call your API function to fetch teachers' data
//     fetchTeachersList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('All Teachers'),
//       ),
//       body: ListView.builder(
//         itemCount: teachers.length,
//         itemBuilder: (context, index) {
//           Teacher teacher = teachers[index];
//
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               height: 80.0,
//               decoration: BoxDecoration(
//                 color: Styles.primaryNavy,
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Circular Avatar
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(teacher.avatarUrl),
//                       radius: 30.0,
//                     ),
//                     // Teacher Name
//                     Text(
//                       teacher.name,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     // Trailing Icon
//                     IconButton(
//                       icon: const Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         color: Styles.primaryBlue,
//                       ),
//                       onPressed: () {
//                         // Handle what happens when the arrow is pressed
//                         // You can navigate to a teacher details page or any other action
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // Function to fetch teachers list from API
//   void fetchTeachersList() async {
//     try {
//       // Replace the following line with your actual API call
//       List<Teacher> fetchedTeachers = await YourApi.fetchTeachers();
//
//       setState(() {
//         teachers = fetchedTeachers;
//       });
//     } catch (e) {
//       print('Error fetching teachers: $e');
//       // Handle the error as needed
//     }
//   }
//
// }
