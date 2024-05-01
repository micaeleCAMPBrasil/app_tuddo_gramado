import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PatrocinadoresStore {
  final IFuncoes repository;

  PatrocinadoresStore({required this.repository}) {
    fetch();
  }

  ValueNotifier<List<Patrocinadores>> listPatrocinadores =
      ValueNotifier<List<Patrocinadores>>([]);

  ValueNotifier<List<Patrocinadores>> listBannerInicial =
      ValueNotifier<List<Patrocinadores>>([]);

  List<Patrocinadores>? _chachedPatrocinadores;

  fetch() async {
    listPatrocinadores.value = await repository.getListPatrocinadores();
    listBannerInicial.value = listPatrocinadores.value
        .where((element) => element.isBannerInicial)
        .toList();
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
