import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Class {
  final int id;
  final String className;
  final int? preschoolId;
  final int? supervisor;
  final String? grade;
  final int? capacity;
  final String? classroom;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Preschool? preschool;
  final dynamic? staff; // You might want to replace this with the actual Staff class

  Class({
    required this.id,
    required this.className,
    this.preschoolId,
    this.supervisor,
    this.grade,
    this.capacity,
    this.classroom,
    this.createdAt,
    this.updatedAt,
    this.preschool,
    this.staff,
  });


  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      className: json['class_name'],
      preschoolId: json['preschool_id'],
      supervisor: json['supervisor'],
      grade: json['grade'],
      capacity: json['capacity'],
      classroom: json['classroom'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      preschool: Preschool.fromJson(json['Preschool']),
      staff: json['Staff'],
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

class ApiClassesLister {
  late String baseUrl;
  late String endPoint;


  // Reads API info from JSON file

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

  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/class_lister.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }






  // Reads classes endpoint from JSON file
  Future<String> initializeEndpoint() async {
    final classesEndpoint = await readAPIInfoFromJSONFile();

    endPoint = classesEndpoint['endpoints']['classes'] as String;
    print("this is the EP: $endPoint");
    return endPoint;
  }


  Future<List<Class>> getClassesList(int preschoolId) async {

    await initializeBaseURL();
    await initializeEndpoint();
    final response = await http.get(Uri.parse('$baseUrl$endPoint/$preschoolId'));

    if (response.statusCode == 200) {
      print("YES, we got 200");
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Class.fromJson(json)).toList();

    } else {
      print(response.statusCode);
      throw Exception('Failed to load classes');
    }
  }


}
