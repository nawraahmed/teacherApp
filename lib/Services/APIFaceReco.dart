import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiResponseforAi {
  String message;
  Attendance newAttendance;

  ApiResponseforAi({required this.message, required this.newAttendance});

  factory ApiResponseforAi.fromJson(Map<String, dynamic> json) {
    return ApiResponseforAi(
      message: json['message'],
      newAttendance: Attendance.fromJson(json['newAttendance']),
    );
  }
}

class Attendance {
  int id;
  String attendanceStatus;
  String date;
  String createdAt;
  String updatedAt;
  int studentId;

  Attendance({
    required this.id,
    required this.attendanceStatus,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.studentId,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      attendanceStatus: json['attendance_status'],
      date: json['date'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      studentId: json['student_id'],
    );
  }
}


class APIFaceReco {
  late String baseUrl;
  late String endPoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/base_url.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  // Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readAPIInfoFromJSONFile();
    baseUrl = base['base_url'] as String? ?? 'https://server-bckggkpqeq-uc.a.run.app'; // Provide a default value if null
    print("this is the reco base: $baseUrl");
  }

  // Reads teacher endpoint from JSON file
  // Future<void> initializeEndpoint() async {
  //   final studentsEndpoint = await readAPIInfoFromJSONFile();
  //
  //   endPoint = studentsEndpoint['endpoints']['face_reco'] as String? ?? '/faceDetection';
  //   print("this is the EP: $endPoint");
  // }


  Future<ApiResponseforAi?> compareImage(File takenImage) async {
    await initializeBaseURL();

    // Create a MultipartRequest
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/attendance/faceDetection'));

    // Add the image as form-data with the key "file"
    request.files.add(await http.MultipartFile.fromPath('file', takenImage.path));


    try {
      // Send the request
      var response = await request.send();

      // Check the response status code
      if (response.statusCode == 200) {
        // Parse the response JSON using ApiResponseforAi
        Map<String, dynamic> data = json.decode(await response.stream.bytesToString());
        ApiResponseforAi apiResponse = ApiResponseforAi.fromJson(data);

        print('Message: ${apiResponse.message}');
        print('New Attendance ID: ${apiResponse.newAttendance.id}');
        print('Attendance Status: ${apiResponse.newAttendance.attendanceStatus}');

        return apiResponse;

      } else {
        // Handle non-200 status codes
        print('Unexpected response: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        print('Response bodaay: ${await response.request}');
        return null; // Adjust this based on your needs
      }

    } catch (error) {
      // Handle request errors
      print('Error comparing image (from API): $error');
      return null; // Adjust this based on your needs
    }
  }

}
