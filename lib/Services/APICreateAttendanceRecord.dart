import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class NewAttendanceResponse {
  String message;
  NewAttendance newAttendance;

  NewAttendanceResponse({required this.message, required this.newAttendance});

  factory NewAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return NewAttendanceResponse(
      message: json['message'],
      newAttendance: NewAttendance.fromJson(json['newAttendance']),
    );
  }
}

class NewAttendance {
  int id;
  String attendanceStatus;
  String date;
  String createdAt;
  String updatedAt;
  int studentId;

  NewAttendance({
    required this.id,
    required this.attendanceStatus,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.studentId,
  });

  factory NewAttendance.fromJson(Map<String, dynamic> json) {
    return NewAttendance(
      id: json['id'],
      attendanceStatus: json['attendance_status'],
      date: json['date'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      studentId: json['student_id'],
    );
  }
}


class APICreateAttendanceRecord {
  late String baseUrl;
  late String endPoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString(
        'lib/Json_Files/attendance_endpoints.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  // Read the Base URL and the Endpoint from the JSON file
  Future<Map<String, dynamic>> readBASEFromJSONFile() async {
    final jsonString = await rootBundle.loadString(
        'lib/Json_Files/base_url.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  //Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readBASEFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the attendance base: $baseUrl");
  }

  // Reads students endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final studentsEndpoint = await readAPIInfoFromJSONFile();

    endPoint = studentsEndpoint['endpoints']['create_attendance'] as String;
    print("this is the EP: $endPoint");
  }


  Future<NewAttendanceResponse> newAttendanceRecord({
    required int studentId,
    required String attendanceStatus,
  }) async {
    await initializeBaseURL();
    await initializeEndpoint();

    try {
      // Create the current date in the format 'yyyy-MM-ddTHH:mm:ss.SSSZ'
      String currentDate = DateTime.now().toUtc().toIso8601String();

      // Create the JSON request body
      final Map<String, dynamic> requestBody = {
        'attendance_status': attendanceStatus,
        'student_id': studentId,
        'date': currentDate,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse('$baseUrl$endPoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Parse the response JSON using NewAttendanceResponse
        Map<String, dynamic> data = json.decode(response.body);
        NewAttendanceResponse attendanceResponse = NewAttendanceResponse
            .fromJson(data);

        return attendanceResponse;
      } else {
        // Handle non-200 status codes
        print('Unexpected response: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create attendance record');
      }
    } catch (error) {
      // Handle request errors
      print('Error creating attendance record: $error');
      throw Exception('Failed to create attendance record');
    }
  }
}