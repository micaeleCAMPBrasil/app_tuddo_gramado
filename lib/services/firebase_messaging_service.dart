import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/utils/routes.dart';
import 'package:app_tuddo_gramado/services/notification_service.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    
    await FirebaseMessaging.instance.requestPermission();

    getDeviceFirebaseToken();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    //_onMessage();
    _onMessageOpenedApp();
  }

  getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('=======================================');
    debugPrint('TOKEN: $token');
    debugPrint('=======================================');
  }

  /*_onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showLocalNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: '/notificacao',
          ),
        );
      }
    });
  }*/

  _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  _goToPageAfterMessage(message) {
    const String route = '/notificacao';
    if (route.isNotEmpty) {
      Routes.navigatorKey.currentState?.pushNamed(route);
    }
  }
}
