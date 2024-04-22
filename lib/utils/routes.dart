import 'package:app_tuddo_gramado/screens/notifications/NotificationScreen.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/home': (_) => BottomNavigation(),
    '/notificacao': (_) => NotificationScreen(),
  };

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
