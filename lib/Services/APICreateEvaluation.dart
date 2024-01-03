import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class ApiCreateEvaluationResponse {
  final String message;
  final StudentEvaluation newStudentEvaluation;

  ApiCreateEvaluationResponse({required this.message, required this.newStudentEvaluation});

  factory ApiCreateEvaluationResponse.fromJson(Map<String, dynamic> json) {
    return ApiCreateEvaluationResponse(
      message: json['message'] ?? '',
      newStudentEvaluation: StudentEvaluation.fromJson(json['newStudentEvaluation'] ?? {}),
    );
  }
}

class StudentEvaluation {
  final int id;
  final int neatness;
  final int attentiveness;
  final int communication;
  final int emotionalIntelligence;
  final int comprehension;
  final int grammaticalCompetence;
  final int oralCommunication;
  final int soundRecognition;
  final int readingProficiency;
  final int mathematicsProficiency;
  final int islamic;
  final int participation;
  final int exploration;
  final int arabicWritingSkills;
  final int arabicReadingSkills;
  final int arabicListeningSpeakingSkills;
  final int globalCitizenship;
  final int behavior;
  final int punctuality;
  final int confidence;
  final int independence;
  final int studentId;
  final String updatedAt;
  final String createdAt;

  StudentEvaluation({
    required this.id,
    required this.neatness,
    required this.attentiveness,
    required this.communication,
    required this.emotionalIntelligence,
    required this.comprehension,
    required this.grammaticalCompetence,
    required this.oralCommunication,
    required this.soundRecognition,
    required this.readingProficiency,
    required this.mathematicsProficiency,
    required this.islamic,
    required this.participation,
    required this.exploration,
    required this.arabicWritingSkills,
    required this.arabicReadingSkills,
    required this.arabicListeningSpeakingSkills,
    required this.globalCitizenship,
    required this.behavior,
    required this.punctuality,
    required this.confidence,
    required this.independence,
    required this.studentId,
    required this.updatedAt,
    required this.createdAt,
  });

  factory StudentEvaluation.fromJson(Map<String, dynamic> json) {
    return StudentEvaluation(
      id: json['id'] ?? 0,
      neatness: json['neatness'] ?? 0,
      attentiveness: json['attentiveness'] ?? 0,
      communication: json['communication'] ?? 0,
      emotionalIntelligence: json['emotional_intelligence'] ?? 0,
      comprehension: json['comprehension'] ?? 0,
      grammaticalCompetence: json['grammatical_competence'] ?? 0,
      oralCommunication: json['oral_communication'] ?? 0,
      soundRecognition: json['sound_recognition'] ?? 0,
      readingProficiency: json['reading_proficiency'] ?? 0,
      mathematicsProficiency: json['mathematics_proficiency'] ?? 0,
      islamic: json['islamic'] ?? 0,
      participation: json['participation'] ?? 0,
      exploration: json['exploration'] ?? 0,
      arabicWritingSkills: json['arabic_writing_skills'] ?? 0,
      arabicReadingSkills: json['arabic_reading_skills'] ?? 0,
      arabicListeningSpeakingSkills: json['arabic_listening_speaking_skills'] ?? 0,
      globalCitizenship: json['global_citizenship'] ?? 0,
      behavior: json['behavior'] ?? 0,
      punctuality: json['punctuality'] ?? 0,
      confidence: json['confidence'] ?? 0,
      independence: json['independence'] ?? 0,
      studentId: json['student_id'] ?? 0,
      updatedAt: json['updatedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}


class APICreateEvaluation {
  late String baseUrl;
  late String endPoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/create_evaluation.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  Future<Map<String, dynamic>> readBASEFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/base_url.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  //Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readBASEFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the classes base: $baseUrl");
  }

  // Reads create evaluation endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final studentsEndpoint = await readAPIInfoFromJSONFile();
    endPoint = studentsEndpoint['endpoints']['create_evaluation'] as String;
    print("this is the EP: $endPoint");
  }

  Future<ApiCreateEvaluationResponse> createEvaluation({
    required int neatness,
    required int attentiveness,
    required int communication,
    required int emotionalIntelligence,
    required int comprehension,
    required int grammaticalCompetence,
    required int oralCommunication,
    required int soundRecognition,
    required int readingProficiency,
    required int mathematicsProficiency,
    required int islamic,
    required int participation,
    required int exploration,
    required int arabicWritingSkills,
    required int arabicReadingSkills,
    required int arabicListeningSpeakingSkills,
    required int globalCitizenship,
    required int behavior,
    required int punctuality,
    required int confidence,
    required int independence,
    required int studentId,
  }) async {
    await initializeBaseURL();
    await initializeEndpoint();

    //read the token from flutter secure storage, and add it to the header
    final storage = FlutterSecureStorage();
    String? userToken = await storage.read(key: 'user_token');

    if (userToken != null) {


    final url = '$baseUrl$endPoint';

    // Print parameter values before making the request
    print('neatness: $neatness');
    print('attentiveness: $attentiveness');
    print('communication: $communication');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken'
        },

        body: jsonEncode({
          'neatness': neatness,
          'attentiveness': attentiveness,
          'communication': communication,
          'emotional_intelligence': emotionalIntelligence,
          'comprehension': comprehension,
          'grammatical_competence': grammaticalCompetence,
          'oral_communication': oralCommunication,
          'sound_recognition': soundRecognition,
          'reading_proficiency': readingProficiency,
          'mathematics_proficiency': mathematicsProficiency,
          'islamic': islamic,
          'participation': participation,
          'exploration': exploration,
          'arabic_writing_skills': arabicWritingSkills,
          'arabic_reading_skills': arabicReadingSkills,
          'arabic_listening_speaking_skills': arabicListeningSpeakingSkills,
          'global_citizenship': globalCitizenship,
          'behavior': behavior,
          'punctuality': punctuality,
          'confidence': confidence,
          'independence': independence,
          'student_id': studentId,
        }),
      );

      final statusCode = response.statusCode;
      final responseBody = response.body;

      print('Status Code: $statusCode');
      print('Response Body: $responseBody');

      final jsonResponse = json.decode(responseBody);

      return ApiCreateEvaluationResponse.fromJson(jsonResponse);

    } catch (e) {
      // Handle errors
      print('Error: $e');
      throw Exception('Failed to create evaluation');
    }

  }else {
  print("there is no json token here!!, this is a guest");
  throw Exception('Failed to create evaluation');
  }


  }



}


