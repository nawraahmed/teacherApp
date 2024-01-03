import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Student {
  final int? id;
  final int? preschoolId;
  final int? classId;
  final String studentName;
  final String grade;
  final DateTime dob;
  final int? cpr;
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
    this.id,
    this.preschoolId,
    this.classId,
    required this.studentName,
    required this.grade,
    required this.dob,
    this.cpr,
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
      id: json['id'],
      preschoolId: json['preschool_id'],
      classId: json['class_id'],
      studentName: json['student_name'] ?? '',
      grade: json['grade'] ?? 'mew',
      dob: json['DOB'] != null ? DateTime.parse(json['DOB']) : DateTime.now(),
      cpr: json['CPR'],
      contactNumber1: json['contact_number1'] ?? 0,
      contactNumber2: json['contact_number2'] ?? 0,
      guardianName: json['guardian_name'] ?? '',
      enrollmentDate: json['enrollment_date'] != null ? DateTime.parse(json['enrollment_date']) : DateTime.now(),
      medicalHistory: json['medical_history'] ?? '',
      gender: json['gender'] ?? '',
      personalPicture: json['personal_picture'] ?? '',
      certificateOfBirth: json['certificate_of_birth'] ?? '',
      passport: json['passport'] ?? '',
      hasConsent: json['hasConsent'] as bool? ?? false,
      userId: json['user_id'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
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


    //read the token from flutter secure storage, and add it to the header
    final storage = FlutterSecureStorage();
    String? userToken = await storage.read(key: 'user_token');



    if (userToken != null) {

    try{

      final response = await http.get(
      Uri.parse('$baseUrl$endPoint/$studentId'),
        headers: {'Authorization': 'Bearer $userToken'},
    );


      final Map<String, dynamic> data = jsonDecode(response.body);
      //print("YES, we got 200");
      print(response.request);
      return Student.fromJson(data);

    }  catch (e) {
    // Handle errors
    print('Error: $e');
    throw Exception('Failed to delete evaluation');
    }

    }else{
      print("there is no json token here!!, this is a guest");
      throw Exception('Failed to load student info');
    }

  }

}
