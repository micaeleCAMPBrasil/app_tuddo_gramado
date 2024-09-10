import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/exceptions.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';

class UsuarioStore {
  final IFuncoes repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isEditable = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isExist = ValueNotifier<bool>(false);

  final ValueNotifier<Usuario> state = ValueNotifier<Usuario>(
    Usuario(
      uid: '',
      tokenAlert: '',
      tokenTG: '',
      tokenTD: '',
      nome: '',
      username: '',
      email: '',
      telefone: '',
      photo: '',
      data: '',
    ),
  );

  final ValueNotifier<List<Usuario>> list = ValueNotifier<List<Usuario>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  UsuarioStore({required this.repository});

  Future getAll() async {
    isLoading.value = true;

    try {
      final result = await repository.getAllUsuario();
      list.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }

  Future getUID(String uid) async {
    isLoading.value = true;

    try {
      final result = await repository.getUsuarioUID(uid);
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }

  Future update(Usuario usuario) async {
    final result = await repository.updateUser(usuario);
    isEditable.value = result;
  }
}
