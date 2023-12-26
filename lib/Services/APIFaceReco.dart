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
    final jsonString = await rootBundle.loadString('lib/Json_Files/base_url.json');
    final jsonMap = json.decode(jsonString);
    return jsonMap;
  }


  // Read the Base URL and the Endpoint from the JSON file
  Future<void> initializeBaseURL() async {
    final base = await readAPIInfoFromJSONFile();
    baseUrl = base['base_url'] as String? ?? 'https://us-central1-alef-229ac.cloudfunctions.net/app'; // Provide a default value if null
    print("this is the reco base: $baseUrl");
  }

  // Reads teacher endpoint from JSON file
  // Future<void> initializeEndpoint() async {
  //   final studentsEndpoint = await readAPIInfoFromJSONFile();
  //
  //   endPoint = studentsEndpoint['endpoints']['face_reco'] as String? ?? '/faceDetection';
  //   print("this is the EP: $endPoint");
  // }


  Future<Uint8List?> compareImage(File takenImage) async {
    await initializeBaseURL();
    //await initializeEndpoint();

    // Create a MultipartRequest
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/attendance/faceDetection'));

    print(request);

    // Add the image as form-data with the key "file"
    request.files.add(await http.MultipartFile.fromPath('file', takenImage.path));

    print(takenImage.path);

    try {
      // Send the request
      var response = await request.send();

      // Check the response status code
      if (response.statusCode == 200) {

        // Check if the response contains image data
        if (response.headers['content-type']?.startsWith('image') ?? false) {
          return Uint8List.fromList(await response.stream.toBytes());
        } else {
          // Handle other types of responses (JSON, etc.) as needed
          final Map<String, dynamic> data = jsonDecode(await response.stream.bytesToString());
          print("YES, we got 200");
          print(data);
          return null; // Adjust this based on your needs
        }

      } else {
        // Handle non-200 status codes
        print('Unexpected response: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        print('Response bodaay: ${await response.request}');
        return null; // Adjust this based on your needs
      }


    } catch (error) {
      // Handle request errors
      print('Error comparing image (from API): $error');
      return null; // Adjust this based on your needs
    }
  }
}
