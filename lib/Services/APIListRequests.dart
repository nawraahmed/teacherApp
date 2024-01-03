import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class StationaryRequest {
  int id;
  String statusName;
  int preschoolId;
  int classId;
  int staffId;
  int stationaryId;
  int requestedQuantity;
  String notes;
  String createdAt;
  String updatedAt;
  Stationary stationary;

  StationaryRequest({
    required this.id,
    required this.statusName,
    required this.preschoolId,
    required this.classId,
    required this.staffId,
    required this.stationaryId,
    required this.requestedQuantity,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.stationary,
  });

  factory StationaryRequest.fromJson(Map<String, dynamic> json) {
    return StationaryRequest(
      id: json['id'],
      statusName: json['status_name'],
      preschoolId: json['preschool_id'],
      classId: json['class_id'],
      staffId: json['staff_id'],
      stationaryId: json['stationary_id'],
      requestedQuantity: json['requested_quantity'],
      notes: json['notes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      stationary: Stationary.fromJson(json['Stationary']),
    );
  }
}

class Stationary {
  int id;
  String stationaryName;
  int quantityAvailable;
  String createdAt;
  String updatedAt;

  Stationary({
    required this.id,
    required this.stationaryName,
    required this.quantityAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Stationary.fromJson(Map<String, dynamic> json) {
    return Stationary(
      id: json['id'],
      stationaryName: json['stationary_name'],
      quantityAvailable: json['quantity_available'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class APIListRequests {
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
    //print("this is the requests base: $baseUrl");
  }
  // Reads teacher endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final requestsEndpoint = await readAPIInfoFromJSONFile();

    endPoint = requestsEndpoint['endpoints']['list_requests'] as String;
    print("this is the EP: $endPoint");
  }


  Future<List<StationaryRequest>> getRequestsRecords() async {
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
        List<StationaryRequest> requests = jsonResponse
            .map((json) => StationaryRequest.fromJson(json))
            .toList();

        return requests;
      } else {
        print(response.request);
        print(response.body);
        print(response.statusCode);
        throw Exception('Failed to load requests records');
      }
    }else{
      print("there is no json token here!!, this is a guest");
      throw Exception('Failed to load requests records');
    }

  }




}
