import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/screens/inicio/ASplashScreen.dart';
import 'package:app_tuddo_gramado/services/firebase_messaging_service.dart';
import 'package:app_tuddo_gramado/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/firebase_options.dart';
import 'package:app_tuddo_gramado/services/auth_service.dart';
import 'package:app_tuddo_gramado/store/AppStore.dart';
import 'package:app_tuddo_gramado/utils/ADataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';

AppStore appStore = AppStore();

void main() async {
  // WPJsonAPI.instance.init(baseUrl: "https://site.tuddogramado.com.br");

  WidgetsFlutterBinding.ensureInitialized();
  await initialize(aLocaleLanguageList: languageList());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /*if (kIsWeb) {
    // Registrar o viewType 'iframeElement' com a fábrica para criar o IFrameElement
    ui.platformViewRegistry.registerViewFactory(
      'login_tuddo_dobro',
      (int viewId) => IFrameElement()
        ..src =
            'https://d.tuddogramado.com.br/wp-login.php?is_api=true&acao=login&user=sales.micaele1911@gmail.com&pass=bRUWHRaEbBbj0313KCtfSdgLWqO2'
        ..style.border = 'none',
    );
  }*/

  /*if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }*/

  LocationPermission permission = await Geolocator.checkPermission();
  debugPrint('$permission');
  await Geolocator.requestPermission();
  await Geolocator.getCurrentPosition();
  //await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  runApp(
    MultiProvider(
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
          create: (context) => NotificationService(),
        ),
        Provider<FirebaseMessagingService>(
          create: (context) =>
              FirebaseMessagingService(context.read<NotificationService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ASplashScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: scaffoldColor,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
              ),
        ),
      ),
    );
  }
}
