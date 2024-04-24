// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:app_tuddo_gramado/services/firebase_messaging_service.dart';
import 'package:app_tuddo_gramado/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/screens/home/AHomeScreen.dart';
import 'package:app_tuddo_gramado/screens/patrocinadores/patrocinadores_page.dart';
import 'package:app_tuddo_gramado/screens/webscreens/WebViewScreen.dart';
import 'package:app_tuddo_gramado/screens/profile/profile_page.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';

class BottomNavigation extends StatefulWidget {
  int selectedIndex;

  BottomNavigation({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    initializeFirebaseMessaging();
    checkNotifications();
  }

  initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false)
        .initialize();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false)
        .checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario = Provider.of<UsuarioProvider>(context).getUsuario;

    _widgetOptions = <Widget>[
      //home
      AHomeScreen(
        usuario: usuario,
      ),
      // tuddo em dobro
      WebViewScreen(
        url: "https://www.google.com/",
      ),
      // patrocinadores
      PatrocinadoresScreen(),
      // transfer (link)
      WebViewScreen(
        url: "https://www.google.com/",
      ),
      // profile
      ProfilePage(
        usuario: usuario,
      ),
    ];
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          widget.selectedIndex = 0;
        });
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            // canvasColor: scaffoldColor,
            canvasColor: color00,
          ),
          child: BottomNavigationBar(
            elevation: 20,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: widget.selectedIndex == 0 ? primaryColor : color94,
                  size: 35,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icones/cup.png",
                  width: 35,
                  height: 35,
                  color: widget.selectedIndex == 1 ? primaryColor : color94,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: widget.selectedIndex == 2 ? primaryColor : color94,
                  size: 35,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icones/map.png",
                  width: 35,
                  height: 35,
                  color: widget.selectedIndex == 3 ? primaryColor : color94,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.people,
                  color: widget.selectedIndex == 4 ? primaryColor : color94,
                  size: 35,
                ),
                label: '',
              ),
            ],
            onTap: (int index) {
              setState(() => widget.selectedIndex = index);
            },
            currentIndex: widget.selectedIndex,
            selectedItemColor: primaryColor,
            unselectedItemColor: color94,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        body: _widgetOptions.elementAt(widget.selectedIndex),
      ),
    );
  }
}
