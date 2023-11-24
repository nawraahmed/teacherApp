import 'package:flutter/material.dart';
import 'package:the_app/login_page.dart';
import 'main.dart';
import 'walkthrough_one.dart';
import 'walkthrough_two.dart';

class WTpageController extends StatefulWidget {
  @override
  _WTpageControllerState createState() => _WTpageControllerState();
}

class _WTpageControllerState extends State<WTpageController> {
  int currentPage = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // Scaffold with a white background as the root widget
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // WalkthroughPageView wrapped with Positioned.fill to take the whole screen
         WalkthroughPageView(
              pageController: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),


          // Container holding the navigation buttons and "Get Started" button
          Padding(padding: const EdgeInsets.only(top: 100.0,),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Row containing the animated containers
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Button for the first page
                    GestureDetector(
                      onTap: () {
                        // When the first button is tapped, update the current page and navigate to the first page
                        setState(() {
                          currentPage = 0;
                        });
                        pageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: currentPage == 0 ? 60 : 15,
                        height: 12,
                        decoration: BoxDecoration(
                          color: currentPage == 0
                              ? Styles.primaryNavy // Active button color
                              : Styles.inactivePrimaryNavy, // Inactive button color
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(width: 5), // Horizontal space between buttons

                    // Button for the second page
                    GestureDetector(
                      onTap: () {
                        // When the second button is tapped, update the current page and navigate to the second page
                        setState(() {
                          currentPage = 1;
                        });
                        pageController.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: currentPage == 1 ? 60 : 15,
                        height: 12,
                        decoration: BoxDecoration(
                          color: currentPage == 1
                              ? Styles.primaryNavy // Active button color
                              : Styles.inactivePrimaryNavy, // Inactive button color
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),


                  ],
                ),

              ],
            ),
    ),


          // "Get Started" button displayed when currentPage is 1
          if (currentPage == 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0), // Add 100 bottom padding
              child: ElevatedButton(
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));

                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(color: Styles.primaryNavy, width: 2), // Set the border color to pink
                  ),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            ),
        ],
      ),
    );
  }
}


// Separate widget to hold the PageView for the walkthrough screens
class WalkthroughPageView extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  WalkthroughPageView({required this.pageController, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    // PageView to display the walkthrough screens
    return PageView(
      controller: pageController, // Use the provided page controller
      onPageChanged: onPageChanged, // Callback when the page changes
      children: [
        WalkthroughPageOne(),
        WalkthroughPageTwo(),
      ],
    );
  }
}
