import 'package:flutter/material.dart';
import 'Services/APICreateEvaluation.dart';
import 'Styling_Elements/BackButtonRow.dart';
import 'main.dart';

class EvaluationScreen extends StatefulWidget {
  final bool isEditable;

  const EvaluationScreen({Key? key, required this.isEditable}) : super(key: key);

  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> with SingleTickerProviderStateMixin {
  // Define a map to store the numerical grades for each criterion
  Map<String, double> grades = {
    'Respects and follows class rules': 0,
    'Completes work on time': 0,
    'Understands and follows directions': 0,
    'Listens carefully during class': 0,
    'Shows self-confidence': 0,
    'Communicates well with teachers and classmates': 0,
    'Expresses feelings appropriately': 0,
    'Works independently': 0,
    'Keeps self and surroundings clean': 0,
    'Listening & Speaking Skills': 0,
    'Grammar & Writing Skills': 0,
    'Reading Skills': 0,
    'Phonics Skills': 0,
    'Numeracy Skills': 0,
    'Discovery Skills': 0,
    'Global Citizenship': 0,
    'Arabic Writing Skills': 0,
    'Arabic Reading Skills': 0,
    'Arabic Listening & Speaking Skills': 0,
    'Participation': 0,
    'Islamic': 0,
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80.0),
          const BackButtonRow(title: 'Evaluation',),
          Expanded( // Wrap the Column with an Expanded to allow it to take all available vertical space
            child: Padding(
              padding: const EdgeInsets.all(20.0),



              child: ListView( // Use a ListView for scrollable content
                children: [
                  // List of criteria with input fields
                  for (var criterion in grades.keys)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              criterion,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            width: 80.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  // Update the numerical grade for the criterion
                                  grades[criterion] = double.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Rounded button for "Send Evaluation"
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //call Create Evaluation Endpoint
                        submitEvaluation();


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.primaryNavy,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Send Evaluation',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




  //FUNCTIONS
// Function to handle the submission of the evaluation
  Future<void> submitEvaluation() async {
    try {
      // Extract values from the fields
      final neatness = grades['Respects and follows class rules'] ?? 0;
      final attentiveness = grades['Completes work on time'] ?? 0;
      final communication = grades['Understands and follows directions'] ?? 0;
      final emotionalIntelligence = grades['Shows self-confidence'] ?? 0;
      final comprehension = grades['Communicates well with teachers and classmates'] ?? 0;
      final grammaticalCompetence = grades['Expresses feelings appropriately'] ?? 0;
      final oralCommunication = grades['Works independently'] ?? 0;
      final soundRecognition = grades['Keeps self and surroundings clean'] ?? 0;
      final readingProficiency = grades['Listening & Speaking Skills'] ?? 0;
      final mathematicsProficiency = grades['Grammar & Writing Skills'] ?? 0;
      final islamic = grades['Reading Skills'] ?? 0;
      final participation = grades['Phonics Skills'] ?? 0;
      final exploration = grades['Numeracy Skills'] ?? 0;
      final arabicWritingSkills = grades['Discovery Skills'] ?? 0;
      final arabicReadingSkills = grades['Global Citizenship'] ?? 0;
      final arabicListeningSpeakingSkills = grades['Arabic Writing Skills'] ?? 0;
      final globalCitizenship = grades['Arabic Reading Skills'] ?? 0;
      final behavior = grades['Arabic Listening & Speaking Skills'] ?? 0;
      final punctuality = grades['Participation'] ?? 0;
      final confidence = grades['Islamic'] ?? 0;
      final independence = grades['Independence'] ?? 0;

      // Provide the student ID here; you can get it from your state or wherever it's stored
      final studentId = 33; // Replace with the actual student ID

      // Call createEvaluation function from APICreateEvaluation class
      final response = await APICreateEvaluation().createEvaluation(
        neatness: neatness.toInt(),
        attentiveness: attentiveness.toInt(),
        communication: communication.toInt(),
        emotionalIntelligence: emotionalIntelligence.toInt(),
        comprehension: comprehension.toInt(),
        grammaticalCompetence: grammaticalCompetence.toInt(),
        oralCommunication: oralCommunication.toInt(),
        soundRecognition: soundRecognition.toInt(),
        readingProficiency: readingProficiency.toInt(),
        mathematicsProficiency: mathematicsProficiency.toInt(),
        islamic: islamic.toInt(),
        participation: participation.toInt(),
        exploration: exploration.toInt(),
        arabicWritingSkills: arabicWritingSkills.toInt(),
        arabicReadingSkills: arabicReadingSkills.toInt(),
        arabicListeningSpeakingSkills: arabicListeningSpeakingSkills.toInt(),
        globalCitizenship: globalCitizenship.toInt(),
        behavior: behavior.toInt(),
        punctuality: punctuality.toInt(),
        confidence: confidence.toInt(),
        independence: independence.toInt(),
        studentId: studentId,
      );

      // Handle the response as needed
      print('Evaluation created successfully: ${response.message}');
    } catch (e) {
      // Handle errors
      print('Error creating evaluation: $e');
    }
  }

}
