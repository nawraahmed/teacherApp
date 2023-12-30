import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AttendanceRecord {
  final int id;
  final int studentId;
  final String? attendanceStatus;
  final String date;
  final String createdAt;
  final String updatedAt;
  final Student student;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.attendanceStatus,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.student,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      studentId: json['student_id'],
      attendanceStatus: json['attendance_status'],
      date: json['date'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      student: Student.fromJson(json['Student']),
    );
  }
}

class Student {
  final int id;
  final int preschoolId;
  final int classId;
  final String studentName;
  final String grade;
  final String dob;
  final int cpr;
  final int contactNumber1;
  final int contactNumber2;
  final String guardianName;
  final String enrollmentDate;
  final String medicalHistory;
  final String gender;
  final String personalPicture;
  final String certificateOfBirth;
  final String passport;
  final dynamic hasConsent;
  final int? userId;
  final String studentCreatedAt;
  final String studentUpdatedAt;

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
    required this.studentCreatedAt,
    required this.studentUpdatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      preschoolId: json['preschool_id'],
      classId: json['class_id'],
      studentName: json['student_name'],
      grade: json['grade'],
      dob: json['DOB'],
      cpr: json['CPR'],
      contactNumber1: json['contact_number1'],
      contactNumber2: json['contact_number2'],
      guardianName: json['guardian_name'],
      enrollmentDate: json['enrollment_date'],
      medicalHistory: json['medical_history'],
      gender: json['gender'],
      personalPicture: json['personal_picture'],
      certificateOfBirth: json['certificate_of_birth'],
      passport: json['passport'],
      hasConsent: json['hasConsent'],
      userId: json['user_id'],
      studentCreatedAt: json['createdAt'],
      studentUpdatedAt: json['updatedAt'],
    );
  }
}


class APIAttendanceCIDbased {
  late String baseUrl;
  late String endPoint;


  // Read the Base URL and the Endpoint from the JSON file
  Future<Map<String, dynamic>> readBASEFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/base_url.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/attendance_endpoints.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  //Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readBASEFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the attendance base: $baseUrl");
  }
  // Reads teacher endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final getAttendanceEndpoint = await readAPIInfoFromJSONFile();

    endPoint = getAttendanceEndpoint['endpoints']['get_using_CID'] as String;
    print("this is the EP: $endPoint");
  }


  Future<List<AttendanceRecord>> getAttendanceRecords(int classId) async {
    await initializeBaseURL();
    await initializeEndpoint();

    final response = await http.get(
      Uri.parse('$baseUrl$endPoint'.replaceAll('{class_id}', classId.toString())),
    );

    if (response.statusCode == 200) {

      print("Retreiveing attendance records...");
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        // Convert each item in the list to an AttendanceRecord
        List<AttendanceRecord> attendanceRecords = data.map((record) => AttendanceRecord.fromJson(record)).toList();
        return attendanceRecords;

      } else {
        // Return an empty list if no records are found
        return [];
      }
    } else {
      print(response.request);
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to load attendance records');
    }
  }



}

