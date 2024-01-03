import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  int? id;
  String statusName;
  int? preschoolId;
  int? classId;
  int? staffId;
  int? stationaryId;
  int? requestedQuantity;
  String? notes;
  String? createdAt;
  String? updatedAt;

  StationaryRequest({
    this.id,
     required this.statusName,
     this.preschoolId,
     this.classId,
     this.staffId,
     this.stationaryId,
     this.requestedQuantity,
     this.notes,
     this.createdAt,
     this.updatedAt,
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



  Future<StationaryRequest> createNewStaReq(
      String status_name,
      int requested_quantity,
      int staff_id,
      int stationary_id,
      String notes,
      int class_id
      ) async {
    await initializeBaseURL();
    await initializeEndpoint();

    //read the token from flutter secure storage, and add it to the header
    final storage = FlutterSecureStorage();
    String? userToken = await storage.read(key: 'user_token');

    if (userToken != null) {


    // Create a Map with the required parameters
    Map<String, dynamic> requestBody = {
      'preschool_id': 1,
      'class_id': class_id,
      'status_name': status_name,
      'requested_quantity': requested_quantity,
      'staff_id': staff_id,
      'stationary_id': stationary_id,
      'notes': notes,
    };

    print(requestBody);

    final response = await http.post(
      Uri.parse('$baseUrl$endPoint'),
      headers: {'Authorization': 'Bearer $userToken'},
      body: jsonEncode(requestBody), // Encode the parameters as JSON
    );

    if (response.statusCode == 200) {
      // Decode the response body
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Convert the decoded JSON directly to a StationaryRequest object
      final StationaryRequest request = StationaryRequest.fromJson(jsonResponse);

      print('JSON Response: $jsonResponse');


      return request;

    } else {
      print(response.request);
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to create a new requests record');
    }
    } else {
      print("there is no json token here!!, this is a guest");
      throw Exception('Failed to create a new requests record');
    }
  }



}



