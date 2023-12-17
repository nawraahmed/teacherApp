import 'package:flutter/material.dart';
import 'Styling_Elements/BackButtonRow.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80.0),
            const BackButtonRow(title: 'About Us'),
            Padding(
              padding: const EdgeInsets.all(20.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'About ALEF Team',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    'Welcome to ALEF, where we strive to make education administration processes easier for everyone. Our dedicated team at ALEF works on innovative solutions for educators, administrators, parents, and students.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30.0),


                   Text(
                    'Our Products',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '- ALEF Teacher: Empowering teachers with tools to enhance productivity.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '- ALEF Admin: Streamlining education administration for efficient management.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '- ALEF Parent: Fostering better communication and engagement between parents and educators.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30.0),


                   Text(
                    'Our Mission',
                     style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'At ALEF, our mission is to transform education by providing user-friendly, reliable, and efficient tools. We believe in the power of technology to simplify complex processes and create a positive impact on the education system.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
