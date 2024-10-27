// ignore_for_file: file_names
import 'package:app_tuddo_gramado/services/auth_check.dart';
import 'package:app_tuddo_gramado/utils/ADataProvider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:pwa_install/pwa_install.dart';
import 'dart:html' as html;

class AWalkThroughScreen extends StatefulWidget {
  const AWalkThroughScreen({super.key});

  @override
  State<AWalkThroughScreen> createState() => _AWalkThroughScreenState();
}

class _AWalkThroughScreenState extends State<AWalkThroughScreen> {
  int initialValue = 0;
  int progressIndex = 0;
  bool _isIOS = false;
  bool _isIOSChrome = false;
  late PageController pageController;

  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    pageController = PageController(initialPage: 0);
    progressIndex = 0;
    _checkPlatform();
  }

  void _checkPlatform() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    setState(() {
      _isIOS = userAgent.contains('iphone') || 
               userAgent.contains('ipad') || 
               userAgent.contains('ipod');
      _isIOSChrome = _isIOS && userAgent.contains('chrome');
    });
  }

  void _handleInstallClick() {
    if (_isIOSChrome) {
      _showChromeIOSDialog();
    } else if (_isIOS) {
      _showIOSInstructions();
    } else if (PWAInstall().installPromptEnabled) {
      PWAInstall().promptInstall_();
    }
  }

  void _showChromeIOSDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Abrir no Safari',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Para instalar o app, por favor abra app.tuddogramado.com.br no Safari.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showIOSInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Como instalar o app',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          '1. Toque no botão de compartilhamento (ícone ⌵)\n'
          '2. Role a tela e selecione "Adicionar à Tela Inicial"\n'
          '3. Toque em "Adicionar" para confirmar',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendi',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  double containerWidth() {
    return (150 / modal.length) * (progressIndex + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (value) => setState(
              () {
                initialValue = value;
                progressIndex = value;
                debugPrint("$value");
              },
            ),
            children: modal.map((e) {
              return Stack(
                children: [
                  Image.asset(
                    e.image.toString(),
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.35),
                    colorBlendMode: BlendMode.darken,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).viewPadding.top + 16,
                          ),
                          initialValue < 2
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: primaryColor,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CheckUserLoggedInOrNot(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Pular',
                                          style: blackBold18,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              e.subtitle.toString(),
                              style: whiteMedium16,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 24),
                            // Botão de instalação
                            if (_isIOS || _isIOSChrome || PWAInstall().installPromptEnabled)
                              Container(
                                width: double.infinity,
                                height: 56,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: ElevatedButton(
                                  onPressed: _handleInstallClick,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
                                  child: Text(
                                    'Instalar App',
                                    style: blackBold18,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 56),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                    AnimatedContainer(
                      duration: 1.seconds,
                      width: containerWidth(),
                      height: 10,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 50,
                  width: 50,
                  child: InkWell(
                    onTap: () {
                      if (initialValue < 2) {
                        setState(
                          () => pageController.jumpToPage(initialValue + 1),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckUserLoggedInOrNot(),
                          ),
                        );
                      }
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}