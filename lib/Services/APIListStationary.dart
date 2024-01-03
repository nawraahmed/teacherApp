import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class Stationary {
  final int id;
  final String stationaryName;
  final int quantityAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? preschoolId;
  final Preschool? preschool;

  Stationary({
    required this.id,
    required this.stationaryName,
    required this.quantityAvailable,
     this.createdAt,
     this.updatedAt,
     this.preschoolId,
     this.preschool,
  });

  factory Stationary.fromJson(Map<String, dynamic> json) {
    return Stationary(
      id: json['id'],
      stationaryName: json['stationary_name'],
      quantityAvailable: json['quantity_available'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      preschoolId: json['preschool_id'],
      preschool: Preschool.fromJson(json['Preschool']),
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
  final double monthlyFees;
  final String curriculum;
  final double registrationFees;
  final String phone;
  final String email;
  final String logo;
  final String representativeName;
  final String description;
  final String cr;
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
    required this.phone,
    required this.email,
    required this.logo,
    required this.representativeName,
    required this.description,
    required this.cr,
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
      monthlyFees: json['monthly_fees'].toDouble(),
      curriculum: json['cirriculum'],
      registrationFees: json['registration_fees'].toDouble(),
      phone: json['phone'],
      email: json['email'],
      logo: json['logo'],
      representativeName: json['representitive_name'],
      description: json['description'],
      cr: json['CR'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}


class APIListStationary {
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
    final jsonString = await rootBundle.loadString('lib/Json_Files/staionairy_endpoints.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  //Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readBASEFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the requests base: $baseUrl");
  }
  // Reads teacher endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final statEndpoint = await readAPIInfoFromJSONFile();

    endPoint = statEndpoint['endpoints']['list_stationary'] as String;
    print("this is the EP: $endPoint");
  }


  Future<List<Stationary>> getStationaryRecords() async {
    await initializeBaseURL();
    await initializeEndpoint();

    //read the token from flutter secure storage, and add it to the header
    final storage = FlutterSecureStorage();
    String? userToken = await storage.read(key: 'user_token');



    if (userToken != null) {



      final response = await http.get(
      Uri.parse('$baseUrl$endPoint'),
        headers: {'Authorization': 'Bearer $userToken'},
    );

    if (response.statusCode == 200) {
      // Decode the response body
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      // Map the decoded JSON to a list of StationaryRequest objects
      List<Stationary> stationary = jsonResponse
          .map((json) => Stationary.fromJson(json))
          .toList();

      return stationary;
    } else {
      print(response.request);
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to load stationary records');
    }

    }else{
      print("there is no json token here!!, this is a guest");
      throw Exception('Failed to load stationary records');
    }

  }




}

