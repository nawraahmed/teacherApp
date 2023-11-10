import 'package:flutter/material.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          // Row at the top
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // Text on the left
                const Text('Hello Teacher \nNawraa', style: TextStyle(
                  fontSize: 18, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                ),

                // Spacer to push the next widget to the right
                const Spacer(),

                // Circle container with the avatar image
                GestureDetector(
                  onTap: () {
                    // Navigate to the ProfilePage when the avatar is tapped
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ProfilePage()),
                    // );
                  },
                  child: Container(
                    width: 50.0, // Adjust the size as needed
                    height: 50.0, // Adjust the size as needed
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          // Heading for the collection view

          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'For You',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ),


          // Pink containers with horizontal scrolling
          SizedBox(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // Adjust the number of pink containers as needed
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle tap on pink container
                    },
                    child: Container(
                      width: 150.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: const Color.fromRGBO(253, 132, 134, 0.3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                );

              },
            ),
          ),



          const SizedBox(height: 30),
          // Heading for the collection view

          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ),

          // Pink containers with horizontal scrolling
          SizedBox(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1, // Adjust the number of pink containers as needed
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle tap on pink container
                    },
                    child: Container(
                      width: 350.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: const Color.fromRGBO(253, 132, 134, 0.3),
                        borderRadius: BorderRadius.circular(25),
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
}
