import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler{
  Future initialize(FlutterLocalNotificationsPlugin notificationsPlugin) async{
    AndroidInitializationSettings androidInitialize = new AndroidInitializationSettings('mipmap/ic_launcher');
    InitializationSettings initializationSettings = new InitializationSettings(android: androidInitialize);

    await notificationsPlugin.initialize(initializationSettings);
  }

  ///Shows notification with given title and body.
  Future showNotification(String title, String body, FlutterLocalNotificationsPlugin notificationsPlugin) async {

    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
        "channelId",
        "channelName",
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await notificationsPlugin.show(0, title, body, notificationDetails);
  }
}

