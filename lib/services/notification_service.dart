import 'package:app_tuddo_gramado/screens/notifications/NotificationScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timezone/timezone.dart' as tz;

class CustomNotification {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final RemoteMessage? remoteMessage;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.remoteMessage,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupAndroidDetails();
    _setupNotifications();
  }

  _setupAndroidDetails() {
    androidDetails = const AndroidNotificationDetails(
      'lembretes_notifications_details',
      'Lembretes',
      channelDescription: 'Este canal é para lembretes!',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
  }

  _setupNotifications() async {
    await _initializeNotifications();
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    // Fazer: macOs, iOS, Linux...
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
        iOS: iOS,
      ),
    );
  }

  static void notificationTapBackground(NotificationResponse details) {
    debugPrint('chamando a função de back');

    Future(() async {
      await Navigator.pushReplacement(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(),
        ),
      );
    });
  }

  /*_onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.of(Routes.navigatorKey.currentContext!).pushNamed(payload);
    }
  }*/

  showNotificationScheduled(CustomNotification notification, Duration duration) {
    final date = DateTime.now().add(duration);
    var location = tz.timeZoneDatabase.get('America/Brazil');

    localNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,

      tz.TZDateTime.from(date, location),
      NotificationDetails(
        android: androidDetails,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: notification.payload,
      // ignore: deprecated_member_use
      //androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  showLocalNotification(CustomNotification notification) {
    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
    );
  }

  checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      //notificationTapBackground(details);
    }
  }
}
