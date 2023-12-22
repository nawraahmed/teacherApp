import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

//class for the response
class ApiCreateEventResponse {
  final String message;
  final EventData newEvent;

  ApiCreateEventResponse({required this.message, required this.newEvent});

  factory ApiCreateEventResponse.fromJson(Map<String, dynamic> json) {
    return ApiCreateEventResponse(
      message: json['message'] ?? '',
      newEvent: EventData.fromJson(json['newEvent'] ?? {}),
    );
  }
}



//class for the event
class EventData {
  final String eventName;
  final String eventDate;
  final String notes;
  final bool notifyParents;
  final bool notifyStaff;
  final bool publicEvent;
  final int createdBy;
  final int preschoolId;
  final List<int> classes;

  EventData({
    required this.eventName,
    required this.eventDate,
    required this.notes,
    required this.notifyParents,
    required this.notifyStaff,
    required this.publicEvent,
    required this.createdBy,
    required this.preschoolId,
    required this.classes,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      eventName: json['event_name'],
      eventDate: json['event_date'],
      notes: json['notes'],
      notifyParents: json['notify_parents'],
      notifyStaff: json['notify_staff'],
      publicEvent: json['public_event'],
      createdBy: json['created_by'],
      preschoolId: json['preschool_id'],
      classes: List<int>.from(json['classes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_name': eventName,
      'event_date': eventDate,
      'notes': notes,
      'notify_parents': notifyParents,
      'notify_staff': notifyStaff,
      'public_event': publicEvent,
      'created_by': createdBy,
      'preschool_id': preschoolId,
      'classes': classes,
    };
  }
}



class APICreateEvent {
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

    endPoint = classesEndpoint['endpoints']['create_event'] as String;
    print("this is the EP: $endPoint");
    return endPoint;
  }




  Future<ApiCreateEventResponse?> createEvent({
    String eventName = "",
    String eventDate = "",
    String notes = "",
    bool notifyParents = false,
    bool notifyStaff = false,
    bool publicEvent = false,
    int createdBy = 0,
    int preschoolId = 0,
    List<int> classes = const [],
  }) async {
    await initializeBaseURL();
    await initializeEndpoint();

    // Build the request body
    final Map<String, dynamic> requestBody = {
      "event_name": eventName,
      "event_date": eventDate,
      "notes": notes,
      "notify_parents": notifyParents,
      "notify_staff": notifyStaff,
      "public_event": publicEvent,
      "created_by": createdBy,
      "preschool_id": preschoolId,
      "classes": classes,
    };

    // Create the request
    final response = await http.post(
      Uri.parse('$baseUrl$endPoint'),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("YES, we got 200");
      return ApiCreateEventResponse.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('Failed to Create New Event haha, try again later');
    }
  }



}