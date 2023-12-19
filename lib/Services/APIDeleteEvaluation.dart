import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiDeleteEvaluationResponse {
  final String message;

  ApiDeleteEvaluationResponse({required this.message});

  factory ApiDeleteEvaluationResponse.fromJson(Map<String, dynamic> json) {
    return ApiDeleteEvaluationResponse(
      message: json['message'] ?? '',
    );
  }
}

class APIDeleteEvaluation {
  late String baseUrl;
  late String endPoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/delete_evaluation.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  // Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readAPIInfoFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the delete base: $baseUrl");
  }

  // Reads students endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final studentsEndpoint = await readAPIInfoFromJSONFile();
    endPoint = studentsEndpoint['endpoints']['delete_evaluation'] as String;
    print("this is the EP: $endPoint");
  }

  Future<ApiDeleteEvaluationResponse> deleteEvaluation(String evaluationId) async {
    await initializeBaseURL();
    await initializeEndpoint();

    final url = '$baseUrl${endPoint.replaceFirst('{evaluation_id}', evaluationId)}';

    try {
      final response = await http.delete(Uri.parse(url));
      final jsonResponse = json.decode(response.body);

      return ApiDeleteEvaluationResponse.fromJson(jsonResponse);
    } catch (e) {
      // Handle errors
      print('Error: $e');
      throw Exception('Failed to delete evaluation');
    }
  }
}
