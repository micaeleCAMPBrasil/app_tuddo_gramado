import 'package:app_tuddo_gramado/data/models/categoriasButton.dart';
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PatrocinadoresStore {
  final IFuncoes repository;
  final int idCategoria;

  PatrocinadoresStore({required this.repository, this.idCategoria = 0}) {
    fetch(idCategoria);
  }

  ValueNotifier<List<CategoriasButoon>> listCategorias =
      ValueNotifier<List<CategoriasButoon>>([]);

  ValueNotifier<List<Patrocinadores>> listPatrocinadores =
      ValueNotifier<List<Patrocinadores>>([]);

  ValueNotifier<List<Patrocinadores>> listBannerInicial =
      ValueNotifier<List<Patrocinadores>>([]);

  ValueNotifier<List<Patrocinadores>> listPatrocinadoresCategories =
      ValueNotifier<List<Patrocinadores>>([]);

  List<Patrocinadores>? _chachedPatrocinadores;

  fetch(int idCategoria) async {
    listCategorias.value = await repository.getCategorias();

    listPatrocinadores.value = await repository.getListPatrocinadores()
      ..shuffle();

    listBannerInicial.value = listPatrocinadores.value
        .where((element) => element.isBannerInicial)
        .toList()
      ..shuffle();

    listPatrocinadoresCategories.value = listPatrocinadores.value
        .where((element) => element.idCategoria.contains(idCategoria))
        .toList()
      ..shuffle();

    _chachedPatrocinadores = listPatrocinadores.value;
  }

  onChange(String value) {
    List<Patrocinadores> list = _chachedPatrocinadores!
        .where((element) =>
            element.nome.toString().toLowerCase().contains(value.toLowerCase()))
        .toList();
    listPatrocinadores.value = list;
  }
}
