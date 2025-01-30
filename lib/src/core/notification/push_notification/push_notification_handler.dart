import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lu_assist/src/core/router/router.dart';
import 'package:lu_assist/src/features/bus_request/presentation/view/request_screen.dart';
import 'package:lu_assist/src/features/news_feed/presentation/view/news_feed_screen.dart';

import '../../../shared/data/model/push_body_model.dart';
import '../../global/global_variables.dart';



@pragma("vm:entry-point")
enum AppMode { FOREGROUND, BACKGROUND, TERMINATED, REVIVED }

@pragma("vm:entry-point")
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.data}");
  print("Runtimetype: ${message.data.runtimeType}");
  await Firebase.initializeApp();
  //PushNotificationHandler.handleMessage(message, AppMode.TERMINATED);
}

@pragma("vm:entry-point")
class PushNotificationHandler {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  PushNotificationHandler() {
    init();
  }

  init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    /// Foreground State
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("APP FROM FOREGROUND");
        handleMessage(message, AppMode.FOREGROUND);
      },
    );

    /// Background State
    FirebaseMessaging.onMessageOpenedApp.listen(
      (data) {
        print("APP FROM BACKGROUND");
        handleMessage(data, AppMode.BACKGROUND);
      },
    );
  }

  static Future<RemoteMessage?> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    print("APP REVIVED");
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage, AppMode.REVIVED);
    }
    return initialMessage;
  }

  static void handleMessage(RemoteMessage message, AppMode appMode) async {
    // SharedPreferenceManager sharedPreferenceManager = SharedPreferenceManager();
    // sharedPreferenceManager.init();
    // bool isLoggedIn = sharedPreferenceManager.getValue(key: SharedPreferenceKeys.AUTH_STATE);
    Map<String, dynamic> data = message.data;
    PushBodyModel pushBodyModel = PushBodyModel.fromJson(data);
    // debug(message.data["type"]);
    if (appMode == AppMode.FOREGROUND) {
      print("Handle for FOREGROUND");
        // LocalNotificationHandler.showLocalNotification(
        //     title: message.notification?.title ?? "",
        //     body: message.notification?.body ?? "",
        //     pushBodyModel: pushBodyModel);
    } else if (appMode == AppMode.BACKGROUND) {
      print("Handle for BACKGROUND");
      if (pushBodyModel.type == "new_post") {
        container.read(goRouterProvider).go(NewsFeedScreen.route);
      }
      else if (pushBodyModel.type == "bus_request") {
        container.read(goRouterProvider).go(RequestScreen.route);
      }
    } else if (appMode == AppMode.TERMINATED) {
      if (pushBodyModel.type == "new_post") {
        container.read(goRouterProvider).go(NewsFeedScreen.route);
      }
      else if (pushBodyModel.type == "bus_request") {
        container.read(goRouterProvider).go(RequestScreen.route);
      }
    } else if (appMode == AppMode.REVIVED) {
      if (pushBodyModel.type == "new_post") {
        container.read(goRouterProvider).go(NewsFeedScreen.route);
      }
      else if (pushBodyModel.type == "bus_request") {
        container.read(goRouterProvider).go(RequestScreen.route);
      }
    }
  }

}
