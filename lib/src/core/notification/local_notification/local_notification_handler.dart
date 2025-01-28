import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../shared/data/model/push_body_model.dart';



class LocalNotificationHandler {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotificationHandler() {
    init();
  }

  init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("launch_background");
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse);
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    PushBodyModel pushBodyModel =
        PushBodyModel.fromJson(jsonDecode(payload ?? ""));
    var data;
    String type = pushBodyModel.type;
    if (notificationResponse.payload != null) {
      switch (type) {
        case "incoming_call":
          {
            //TODO
            break;
          }
        case "message":
          {
            //TODO
            break;
          }
      }
    }
  }

  static showLocalNotification(
      {required String title,
      required String body,
      required PushBodyModel pushBodyModel}) {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails,
        payload: jsonEncode(pushBodyModel));
  }
}
