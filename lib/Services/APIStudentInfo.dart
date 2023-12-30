import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Student {
  final int id;
  final int preschoolId;
  final int classId;
  final String studentName;
  final String grade;
  final DateTime dob;
  final int cpr;
  final int contactNumber1;
  final int contactNumber2;
  final String guardianName;
  final DateTime enrollmentDate;
  final String medicalHistory;
  final String gender;
  final String personalPicture;
  final String certificateOfBirth;
  final String passport;
  final bool hasConsent;
  final int? userId; // Nullable
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor
  Student({
    required this.id,
    required this.preschoolId,
    required this.classId,
    required this.studentName,
    required this.grade,
    required this.dob,
    required this.cpr,
    required this.contactNumber1,
    required this.contactNumber2,
    required this.guardianName,
    required this.enrollmentDate,
    required this.medicalHistory,
    required this.gender,
    required this.personalPicture,
    required this.certificateOfBirth,
    required this.passport,
    required this.hasConsent,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Named constructor to create an instance from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      preschoolId: json['preschool_id'] as int,
      classId: json['class_id'] as int,
      studentName: json['student_name'] as String,
      grade: json['grade'] as String,
      dob: DateTime.parse(json['DOB'] as String),
      cpr: json['CPR'] as int,
      contactNumber1: json['contact_number1'] as int,
      contactNumber2: json['contact_number2'] as int,
      guardianName: json['guardian_name'] as String,
      enrollmentDate: DateTime.parse(json['enrollment_date'] as String),
      medicalHistory: json['medical_history'] as String,
      gender: json['gender'] as String,
      personalPicture: json['personal_picture'] as String,
      certificateOfBirth: json['certificate_of_birth'] as String,
      passport: json['passport'] as String,
      hasConsent: json['hasConsent'] as bool,
      userId: json['user_id'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}


class APIStudentInfo {
  late String baseUrl;
  late String endPoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/student_info.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  // Read the Base URL and the Endpoint from the JSON file
  Future<Map<String, dynamic>> readBASEFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/base_url.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  //Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readBASEFromJSONFile();
    baseUrl = base['base_url'] as String;
    //print("this is the classes base: $baseUrl");
  }

  Future<void> initializeEndpoint() async {
    final studentsEndpoint = await readAPIInfoFromJSONFile();

    endPoint = studentsEndpoint['endpoints']['student'] as String;
    //print("this is the EP: $endPoint");
  }


  Future<Student> getStudentInfo(int studentId) async {

    await initializeBaseURL();
    await initializeEndpoint();

    final response = await http.get(
      Uri.parse('$baseUrl$endPoint/$studentId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      //print("YES, we got 200");
      //print(response.body);
      return Student.fromJson(data);
    } else {
      throw Exception('Failed to load student info');
    }
  }

}
