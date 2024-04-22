// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'AWalkThroughScreen.dart';

class ASplashScreen extends StatefulWidget {
  const ASplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ASplashScreenState createState() => _ASplashScreenState();
}

class _ASplashScreenState extends State<ASplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AWalkThroughScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/Tuddo nome branca.png',
                    fit: BoxFit.fill,
                    width: 200,
                    height: 100,
                  ),
                  widthSpace20,
                  Image.asset(
                    'assets/image/Tuddo favicon.png',
                    fit: BoxFit.fill,
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
