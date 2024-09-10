import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:flutter/material.dart';

class Routa {
  int page, index;

  Routa(this.page, this.index);
}

class ControlNav extends ChangeNotifier {
  Routa routa = Routa(0, 0);
  Routa get getrouta => routa;

  late Patrocinadores patrocinador;
  Patrocinadores get getPatrocinador => patrocinador;

  int idPatrocinador = 0;
  int get getIdPatrocinador => idPatrocinador;

  String urllinkinscricoes = '';
  String get urllinksubcribe => urllinkinscricoes;

  String idPost = '';
  String get getidpost => idPost;

  SVPostModel post = SVPostModel(idPost: '', idUsuario: '');
  SVPostModel get getpost => post;

  updateIndex(int page, int index) {
    routa.page = page;
    routa.index = index;

    debugPrint('upload ${routa.page} - ${routa.index}');
    notifyListeners();
  }

  updatepatrocinador(Patrocinadores pat) {
    patrocinador = pat;
    notifyListeners();
  }

  updateidcategori(int id) {
    idPatrocinador = id;
    notifyListeners();
  }

  updateurllinks(String link) {
    urllinkinscricoes = link;
    notifyListeners();
  }

  updateidpost(String post) {
    idPost = post;
    notifyListeners();
  }

  updatepost(SVPostModel posts) {
    post = posts;
    notifyListeners();
  }
}
