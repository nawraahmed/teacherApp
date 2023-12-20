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
  final DateTime createdAt;
  final DateTime updatedAt;
  final Preschool preschool;
  final bool hasConsent;

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
    required this.createdAt,
    required this.updatedAt,
    required this.preschool,
    required this.hasConsent
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      preschoolId: json['preschool_id'],
      classId: json['class_id'],
      studentName: json['student_name'],
      grade: json['grade'],
      dob: DateTime.parse(json['DOB']),
      cpr: json['CPR'],
      contactNumber1: json['contact_number1'],
      contactNumber2: json['contact_number2'],
      guardianName: json['guardian_name'],
      enrollmentDate: DateTime.parse(json['enrollment_date']),
      medicalHistory: json['medical_history'],
      gender: json['gender'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      preschool: Preschool.fromJson(json['Preschool']),
      hasConsent: json['hasConsent'] ?? true
    );
  }
}

class Preschool {
  final int id;
  final String preschoolName;
  final int planId;
  final int requestId;
  final DateTime subscriptionExpiryDate;
  final int minimumAge;
  final int maximumAge;
  final int monthlyFees;
  final String curriculum;
  final int registrationFees;
  final DateTime createdAt;
  final DateTime updatedAt;

  Preschool({
    required this.id,
    required this.preschoolName,
    required this.planId,
    required this.requestId,
    required this.subscriptionExpiryDate,
    required this.minimumAge,
    required this.maximumAge,
    required this.monthlyFees,
    required this.curriculum,
    required this.registrationFees,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Preschool.fromJson(Map<String, dynamic> json) {
    return Preschool(
      id: json['id'],
      preschoolName: json['preschool_name'],
      planId: json['plan_id'],
      requestId: json['request_id'],
      subscriptionExpiryDate: DateTime.parse(json['subscription_expiry_date']),
      minimumAge: json['minimum_age'],
      maximumAge: json['maximum_age'],
      monthlyFees: json['monthly_fees'],
      curriculum: json['cirriculum'],
      registrationFees: json['registration_fees'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class APIStudentsLister {
  late String baseUrl;
  late String endPoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/students_in_class.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  // Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readAPIInfoFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the students base: $baseUrl");
  }

  // Reads students endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final studentsEndpoint = await readAPIInfoFromJSONFile();

    endPoint = studentsEndpoint['endpoints']['students'] as String;
    print("this is the EP: $endPoint");
  }

  Future<List<Student>> getStudentsList(int preschoolId, int classId) async {
    await initializeBaseURL();
    await initializeEndpoint();

    final response = await http.get(
      Uri.parse('$baseUrl$endPoint'
          .replaceAll('{preschool_id}', preschoolId.toString())
          .replaceAll('{class_id}', classId.toString())),
    );

    if (response.statusCode == 200) {
      print("YES, we got 200 for students lister");
      print(response.body);
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Student.fromJson(json)).toList();

    } else {
      throw Exception('Failed to load students');
    }
  }
}
