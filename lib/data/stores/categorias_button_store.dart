import 'package:app_tuddo_gramado/screens/rede_social/SVHomeFragment.dart';
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/data/models/categoriasButton.dart';
import 'package:app_tuddo_gramado/screens/patrocinadores/patrocinadores_page.dart';
import 'package:app_tuddo_gramado/screens/webscreens/WebViewScreen.dart';

class CategoriasButoonStore {
  static List<CategoriasButoon> getbuttons = [
    CategoriasButoon(
      name: 'Patrocinadores',
      route: MaterialPageRoute(
        builder: (context) => PatrocinadoresScreen(),
      ),
    ),
    CategoriasButoon(
      name: 'Tuddo em Dobro',
      route: MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: "https://www.google.com/",
        ),
      ),
    ),
    CategoriasButoon(
      name: 'Transfer',
      route: MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: "https://www.google.com/",
        ),
      ),
    ),
    CategoriasButoon(
      name: 'Hospedagem',
      route: MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: "https://www.google.com/",
        ),
      ),
    ),
    CategoriasButoon(
      name: 'Dicas e Roteiros',
      route: MaterialPageRoute(
        builder: (context) => const SVHomeFragment(),
      ),
    ),
    CategoriasButoon(
      name: 'Assine',
      route: MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: "https://www.google.com/",
        ),
      ),
    ),
    CategoriasButoon(
      name: 'Faça Parte',
      route: MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: "https://www.google.com/",
        ),
      ),
    ),
  ];
}
