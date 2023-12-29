import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiFaceRecoResponse {
  String image;
  List<Result> results;

  ApiFaceRecoResponse({required this.image, required this.results});

  factory ApiFaceRecoResponse.fromJson(Map<String, dynamic> json) {
    return ApiFaceRecoResponse(
      image: json['image'],
      results: List<Result>.from(json['results'].map((result) => Result.fromJson(result))),
    );
  }
}


class Result {
  String name;
  String studentId;

  Result({required this.name, required this.studentId});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      name: json['name'],
      studentId: json['student_id'],
    );
  }
}




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
    baseUrl = 'https://face-roco-zisqqdegwa-uc.a.run.app'; // Provide a default value if null
    print("this is the reco base: $baseUrl");
  }

  Future<ApiFaceRecoResponse?> compareImage(File file) async {
    await initializeBaseURL();

    //parse the Uri
    var uri = Uri.parse('$baseUrl/detect_faces');

    try {
      // Create a MultipartRequest and add the form-data body
      var request = http.MultipartRequest('POST', uri);

      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('file', fileStream, length, filename: file.path.split("/").last);

      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();



      // Check the response status code
      if (response.statusCode == 200) {

        // Parse the response JSON using ApiFaceRecoResponse
        Map<String, dynamic> data = json.decode(await response.stream.bytesToString());
        ApiFaceRecoResponse apiResponse = ApiFaceRecoResponse.fromJson(data);

        print("3aaad ${apiResponse.results.first.name}");

        return apiResponse;


      } else {
        // Handle non-200 status codes
        print('Unexpected response: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        return null; // Adjust this based on your needs
      }


    } catch (error) {
      // Handle request errors
      print('Error comparing image (from API): $error');
      return null; // Adjust this based on your needs
    }
  }

}
