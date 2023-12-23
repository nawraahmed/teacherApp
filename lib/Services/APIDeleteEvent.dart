import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class APIDeleteEventResponse {
  final String message;


  APIDeleteEventResponse({required this.message});

  factory APIDeleteEventResponse.fromJson(Map<String, dynamic> json) {
    return APIDeleteEventResponse(
      message: json['message'] ?? '',
    );
  }
}


class APIDeleteEvent {
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
    print("this is the events base: $baseUrl");
  }



  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/events_endpoints.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }




  // Reads classes endpoint from JSON file
  Future<String> initializeEndpoint() async {
    final classesEndpoint = await readAPIInfoFromJSONFile();

    endPoint = classesEndpoint['endpoints']['delete_event'] as String;
    print("this is the EP for deleting events: $endPoint");
    return endPoint;
  }




  Future<APIDeleteEventResponse> DeleteEventById(int eventId) async {
    await initializeBaseURL();
    await initializeEndpoint();


    // Create the request
    final response = await http.delete(
      Uri.parse('$baseUrl$endPoint'.replaceAll('{event_id}', eventId.toString())),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Decode the response and return the message
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return APIDeleteEventResponse.fromJson(jsonResponse);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to Delete the Event');
    }
  }




}
