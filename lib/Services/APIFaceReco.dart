import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class APIFaceReco {
  late String baseUrl;
  late String endPoint;

  // Reads API info from JSON file
  Future<Map<String, dynamic>> readAPIInfoFromJSONFile() async {
    final jsonString = await rootBundle.loadString('lib/Json_Files/face_reco.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  // Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readAPIInfoFromJSONFile();
    baseUrl = base['base_url'] as String;
    print("this is the reco base: $baseUrl");
  }

  // Reads teacher endpoint from JSON file
  Future<void> initializeEndpoint() async {
    final studentsEndpoint = await readAPIInfoFromJSONFile();

    endPoint = studentsEndpoint['endpoints']['face_reco'] as String;
    print("this is the EP: $endPoint");
  }


  Future<Uint8List?> compareImage(File takenImage) async {
    await initializeBaseURL();
    await initializeEndpoint();

    // Read the image bytes
    List<int> imageBytes = await takenImage.readAsBytes();

    final response = await http.post(
      Uri.parse('$baseUrl$endPoint'),
      body: imageBytes,
      headers: {
        'Content-Type': 'application/octet-stream',
      },
    );

    if (response.statusCode == 200) {
      // Check if the response contains image data
      if (response.headers['content-type']?.startsWith('image') ?? false) {
        return response.bodyBytes;
      } else {
        // Handle other types of responses (JSON, etc.) as needed
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("YES, we got 200");
        print(response.body);
        return null; // Adjust this based on your needs
      }
    } else {
      throw Exception('Failed to compare image');
    }
  }
}