import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LoginResponse {
  final String message;
  final String jsonToken;

  LoginResponse({required this.message, required this.jsonToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      jsonToken: json['jsontoken'],
    );
  }
}

class APILoginClient {
  late String baseUrl;
  late String endpoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString =
    await rootBundle.loadString('lib/Json_Files/login_client.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  //Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readAPIInfoFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the base: $baseUrl");
  }

  // Reads login endpoint from JSON file
  Future<String> initializeEndpoint() async {
    final loginEndpoint = await readAPIInfoFromJSONFile();

    endpoint = loginEndpoint['endpoints']['login'] as String;
    print("this is the EP: $endpoint");
    return endpoint;
  }


  Future<LoginResponse> login(String email, String password) async {

    await initializeBaseURL();
    await initializeEndpoint();

    final loginURL = Uri.parse(baseUrl + endpoint);
    print("login url $loginURL");

    final requestBody = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(
      loginURL,
      body: requestBody,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(response.request);
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return LoginResponse.fromJson(jsonResponse);

    } else {
      print(response.request);
      print(response.body);
      throw Exception('Failed to load data');
    }

  }
}
