import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:trust_app_updated/Pages/home_screen/home_screen.dart';
import 'package:trust_app_updated/Pages/new_products/new_products.dart';
import 'package:trust_app_updated/Pages/offers/offers.dart';
import 'local_notification_service.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
    NavigatorNotification(message.notification!.android!.color);
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
    NavigatorNotification(message.notification!.android!.color);
  }
  // Or do other work.
}

NavigatorNotification(message) {
  if (message == "offer") {
    Get.to(
        HomeScreen(
          currentIndex: 2,
        ),
        preventDuplicates: false);
  } else if (message == "home") {
    Get.to(
        HomeScreen(
          currentIndex: 0,
        ),
        preventDuplicates: false);
  } else {
    Get.to(
        HomeScreen(
          currentIndex: 1,
        ),
        preventDuplicates: false);
  }
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications(context) {
    LocalNotificationService.initialize(context);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        NavigatorNotification(message.notification!.android!.color);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        LocalNotificationService.display(message);
        NavigatorNotification(message.notification!.android!.color);
      }
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      NavigatorNotification(message.notification!.android!.color);
    });
    // With this token you can test it easily on your phone
    final token =
        _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}
