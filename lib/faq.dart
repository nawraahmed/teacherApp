import 'package:flutter/material.dart';
import 'package:the_app/Services/APITeacherInfo.dart';
import 'Styling_Elements/BackButtonRow.dart';
import 'main.dart';

class FAQpage extends StatefulWidget {
  const FAQpage({Key? key}) : super(key: key);

  @override
  _FAQpageState createState() => _FAQpageState();
}

class _FAQpageState extends State<FAQpage> with SingleTickerProviderStateMixin {
  final List<FAQItem> faqs = FAQData.getFrequentlyAskedQuestions();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80.0),
            const BackButtonRow(title: 'FAQs'),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FAQList(faqs: faqs),
            ),
          ],
        ),
      ),
    );
  }
}


class FAQList extends StatelessWidget {
  final List<FAQItem> faqs;

  FAQList({required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: faqs.map((faq) {
        return FAQItem(question: faq.question, answer: faq.answer);
      }).toList(),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero, // Set tilePadding directly on ExpansionTile
        title: Text(
          question,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}



class FAQData {
  static List<FAQItem> getFrequentlyAskedQuestions() {
    return [
      FAQItem(
        question: 'How do I create a new class?',
        answer: 'To create a new class, go to the Classes tab and click on the "+" button.',
      ),
      FAQItem(
        question: 'How can I mark attendance?',
        answer: 'You can mark attendance by going to the Attendance tab and selecting the class.',
      ),
      FAQItem(
        question: 'Can I customize the app theme?',
        answer: 'Yes, you can customize the app theme by going to the Settings tab and enabling Dark Mode.',
      ),
      FAQItem(
        question: 'What is the Events tab for?',
        answer: 'The Events tab allows you to view and manage upcoming events and activities.',
      ),
      FAQItem(
        question: 'How do I report a bug?',
        answer: 'To report a bug, go to the Settings tab and select "Report a Bug" from the options.',
      ),
      FAQItem(
        question: 'Is there a language preference setting?',
        answer: 'Yes, you can set your preferred language in the Language section of the Settings tab.',
      ),
      FAQItem(
        question: 'How do I navigate to my profile?',
        answer: 'You can navigate to your profile by tapping on the avatar in the top-right corner.',
      ),
      FAQItem(
        question: 'Can I add attachments to events?',
        answer: 'Yes, you can add attachments to events by editing the event details.',
      ),
      FAQItem(
        question: 'Is there a quick way to view all attendance records?',
        answer: 'Yes, you can view all attendance records by going to the Attendance tab and selecting "All Attendance".',
      ),
      FAQItem(
        question: 'How do I change my password?',
        answer: 'To change your password, go to the Settings tab and select "Change Password".',
      ),
      // Add more FAQs as needed
    ];
  }
}

