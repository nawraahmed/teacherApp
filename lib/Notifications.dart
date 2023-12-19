import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:the_app/Services/APISetTokenClient.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


Future<void> handleBackgroundMessage(RemoteMessage? message) async{
  print('Title: ${message?.notification?.title}');
  print('Body: ${message?.notification?.body}');

}

class Notifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  APISetToken tokenSetter = APISetToken();



  Future<void> initNotification(String? uid) async {
    await _firebaseMessaging.requestPermission();

    final FCMToken = await _firebaseMessaging.getToken();
    final storage = FlutterSecureStorage();
    String? uid = await storage.read(key: 'uid');
    print("FCMMM token: $FCMToken");
    print("uid again from notification: $uid");


    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // Send token to server
    if (FCMToken != null && uid != null) {
      tokenSetter.setToken(uid, FCMToken);
    }
  }



  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/notification',
      arguments: message,
    );
  }

  Future<void> initPushNotification() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessage(message);
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Handle messages when the app is launched
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Handle notifications received when the app is in the foreground
        // You can customize this part based on your app's requirements
        // For example, show a local notification
      }
    });
  }
}
