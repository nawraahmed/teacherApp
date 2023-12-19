import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApisetTokenResponse {
  final String message;


  ApisetTokenResponse({required this.message});

  factory ApisetTokenResponse.fromJson(Map<String, dynamic> json) {
    return ApisetTokenResponse(
      message: json['message'] ?? '',
    );
  }
}


class APISetToken {
  late String baseUrl;
  late String endPoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/set_token.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  // Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readAPIInfoFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the set token base: $baseUrl");
  }

  // Reads students endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final studentsEndpoint = await readAPIInfoFromJSONFile();
    endPoint = studentsEndpoint['endpoints']['set_token'] as String;
    print("this is the EP: $endPoint");
  }

  Future<ApisetTokenResponse> setToken(String uid, String FCMtoken) async {
    await initializeBaseURL();
    await initializeEndpoint();

    final url = '$baseUrl$endPoint';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Specify that you are sending JSON
        },
        body: jsonEncode({
          'uid': uid,
          'token': FCMtoken,
        }),
      );

      print(FCMtoken);

      final statusCode = response.statusCode;
      final responseBody = response.body;

      print('Status Code: $statusCode');
      print('Response Body: $responseBody');

      final jsonResponse = json.decode(responseBody);

      return ApisetTokenResponse.fromJson(jsonResponse);
    } catch (e) {
      // Handle errors
      print('Error: $e');
      throw Exception('Failed to set token');
    }
  }

}