import 'dart:async';
import 'dart:developer' as dev;

import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/screens/inicio/ASplashScreen.dart';
import 'package:app_tuddo_gramado/services/firebase_messaging_service.dart';
import 'package:app_tuddo_gramado/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/firebase_options.dart';
import 'package:app_tuddo_gramado/services/auth_service.dart';
import 'package:app_tuddo_gramado/utils/ADataProvider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initialize(aLocaleLanguageList: languageList());

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      final notificationService = NotificationService();
      FirebaseMessagingService(notificationService).initialize();

      defaultToastGravityGlobal = ToastGravity.BOTTOM;
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthService(),
          ),
          ChangeNotifierProvider(
            create: (context) => ControlNav(),
          ),
          ChangeNotifierProvider(
            create: (context) => UsuarioProvider(),
          ),
          Provider<NotificationService>(
            create: (context) => notificationService,
          ),
          Provider<FirebaseMessagingService>(
            create: (context) => FirebaseMessagingService(context.read<NotificationService>()),
          ),
        ],
        child: const MyApp(),
      ));
    },
    (error, stackTrace) => dev.log(error.toString(), stackTrace: stackTrace, name: 'ERROR'),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ASplashScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: scaffoldColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
      ),
    );
  }
}
