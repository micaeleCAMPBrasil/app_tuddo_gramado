import 'package:app_tuddo_gramado/data/models/categoriasButton.dart';

class CategoriasButoonStore {
  static List<CategoriasButoon> getbuttons = [
    CategoriasButoon(
      name: 'Patrocinadores',
      backgroundImage: 'assets/image/a1.png',
      route: 1,
    ),
    CategoriasButoon(
      name: 'Tuddo em Dobro',
      backgroundImage: 'assets/image/a2.png',
      route: 2,
    ),
    CategoriasButoon(
      name: 'Transfer',
      backgroundImage: 'assets/image/a3.png',
      route: 3,
    ),
    CategoriasButoon(
      name: 'Hospedagem',
      backgroundImage: 'assets/image/a4.png',
      route: 4,
    ),
    /*CategoriasButoon(
      name: 'Dicas e Roteiros',
      backgroundImage: 'assets/image/a5.png',
      route: 5,
    ),*/
    CategoriasButoon(
      name: 'Assine',
      backgroundImage: 'assets/image/a6.png',
      route: 6,
    ),
    CategoriasButoon(
      name: 'Faça Parte',
      backgroundImage: 'assets/image/a7.png',
      route: 7,
    ),
  ];
}
