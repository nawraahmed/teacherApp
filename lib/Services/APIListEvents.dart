import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class EventListResponse {
  List<Event> events;

  EventListResponse({required this.events});

  factory EventListResponse.fromJson(List<dynamic> json) {
    List<Event> events = json.map((e) => Event.fromJson(e)).toList();
    return EventListResponse(events: events);
  }
}

class Event {
  int id;
  int createdBy;
  String eventName;
  String eventDate;
  bool notifyParents;
  bool notifyStaff;
  bool publicEvent;
  String notes;
  int preschoolId;
  String createdAt;
  String updatedAt;
  List<Class> classes;

  Event({
    required this.id,
    required this.createdBy,
    required this.eventName,
    required this.eventDate,
    required this.notifyParents,
    required this.notifyStaff,
    required this.publicEvent,
    required this.notes,
    required this.preschoolId,
    required this.createdAt,
    required this.updatedAt,
    required this.classes,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    List<Class> classes = (json['Classes'] as List<dynamic>)
        .map((e) => Class.fromJson(e))
        .toList();

    return Event(
      id: json['id'],
      createdBy: json['created_by'],
      eventName: json['event_name'],
      eventDate: json['event_date'],
      notifyParents: json['notify_parents'],
      notifyStaff: json['notify_staff'],
      publicEvent: json['public_event'],
      notes: json['notes'],
      preschoolId: json['preschool_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      classes: classes,
    );
  }
}

class Class {
  int id;
  String className;
  int preschoolId;
  int supervisor;
  String grade;
  int capacity;
  String classroom;
  String createdAt;
  String updatedAt;
  EventClass eventClass;

  Class({
    required this.id,
    required this.className,
    required this.preschoolId,
    required this.supervisor,
    required this.grade,
    required this.capacity,
    required this.classroom,
    required this.createdAt,
    required this.updatedAt,
    required this.eventClass,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    EventClass eventClass = EventClass.fromJson(json['Event_Class']);

    return Class(
      id: json['id'],
      className: json['class_name'],
      preschoolId: json['preschool_id'],
      supervisor: json['supervisor'],
      grade: json['grade'],
      capacity: json['capacity'],
      classroom: json['classroom'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      eventClass: eventClass,
    );
  }
}

class EventClass {
  String createdAt;
  String updatedAt;
  int eventId;
  int classId;

  EventClass({
    required this.createdAt,
    required this.updatedAt,
    required this.eventId,
    required this.classId,
  });

  factory EventClass.fromJson(Map<String, dynamic> json) {
    return EventClass(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      eventId: json['event_id'],
      classId: json['class_id'],
    );
  }
}





class APIListEvents {
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

    endPoint = classesEndpoint['endpoints']['list_events'] as String;
    print("this is the EP for listing events: $endPoint");
    return endPoint;
  }




  Future<EventListResponse?> GetEventsList(int preschoolId) async {
    await initializeBaseURL();
    await initializeEndpoint();

    // Create the request
    final response = await http.get(
      Uri.parse('$baseUrl$endPoint?preschool_id=$preschoolId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Decode the response and return the list of events
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Check if the 'events' key exists in the response
      if (jsonResponse.containsKey('events')) {
        // Parse the 'events' key into a List<dynamic>
        List<dynamic> eventsJson = jsonResponse['events'];

        // Use the factory constructor of EventListResponse to convert the JSON list into a List<Event>
        EventListResponse eventListResponse = EventListResponse.fromJson(eventsJson);

        return eventListResponse;
      } else {
        // If the 'events' key is missing, handle the error accordingly
        print("Error: 'events' key not found in the response");
        return null; // or throw an exception, return an empty list, etc.
      }

    } else {
      print(response.statusCode);
      throw Exception('Failed to List this preschool events');
    }
  }




}