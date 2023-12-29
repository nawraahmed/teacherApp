import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiCreateRequestResponse {
  final String message;
  final StationaryRequest staRequest;

  ApiCreateRequestResponse({required this.message, required this.staRequest});

  factory ApiCreateRequestResponse.fromJson(Map<String, dynamic> json) {
    return ApiCreateRequestResponse(
      message: json['message'] ?? '',
      staRequest: StationaryRequest.fromJson(json['staRequest'] ?? {}),
    );
  }
}

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
    );
  }
}



class APICreateRequest {
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
    final requestsEndpoint = await readAPIInfoFromJSONFile();

    endPoint = requestsEndpoint['endpoints']['create_requests'] as String;
    print("this is the EP: $endPoint");
  }


  Future<List<StationaryRequest>> createNewStaReq(
      String status_name,
      int requested_quantity,
      int staff_id,
      int stationary_id,
      String notes
      ) async {
    await initializeBaseURL();
    await initializeEndpoint();

    // Create a Map with the required parameters
    Map<String, dynamic> requestBody = {
      'status_name': status_name,
      'requested_quantity': requested_quantity,
      'staff_id': staff_id,
      'stationary_id': stationary_id,
      'notes': notes,
    };

    final response = await http.post(
      Uri.parse('$baseUrl$endPoint'),
      headers: {
        'Content-Type': 'application/json', // Specify the content type as JSON
      },
      body: jsonEncode(requestBody), // Encode the parameters as JSON
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
      throw Exception('Failed to create a new requests record');
    }
  }



}



