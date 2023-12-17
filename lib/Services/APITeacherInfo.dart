import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TeacherInfo {
  final int id;
  final int preschoolId;
  final String staffRoleName;
  final String name;
  final int cpr;
  final int phone;
  final String hireDate;
  final String email;
  final String createdAt;
  final String updatedAt;

  TeacherInfo({
    required this.id,
    required this.preschoolId,
    required this.staffRoleName,
    required this.name,
    required this.cpr,
    required this.phone,
    required this.hireDate,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      id: json['id'],
      preschoolId: json['preschool_id'],
      staffRoleName: json['staff_role_name'],
      name: json['name'],
      cpr: json['CPR'],
      phone: json['phone'],
      hireDate: json['hire_date'],
      email: json['email'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}


class APITeacherInfo {
  late String baseUrl;
  late String endPoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/teacher_info.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  // Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readAPIInfoFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the teachers base: $baseUrl");
  }

  // Reads teacher endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final studentsEndpoint = await readAPIInfoFromJSONFile();

    endPoint = studentsEndpoint['endpoints']['staff'] as String;
    print("this is the EP: $endPoint");
  }


  Future<TeacherInfo> getTeacherInfo(int staffId) async {

    await initializeBaseURL();
    await initializeEndpoint();

    final response = await http.get(
      Uri.parse('$baseUrl$endPoint/$staffId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("YES, we got 200");
      print(response.body);
      return TeacherInfo.fromJson(data);
    } else {
      throw Exception('Failed to load teacher info');
    }
  }

}