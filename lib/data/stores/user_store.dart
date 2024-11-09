import 'package:app_tuddo_gramado/data/php/api_service.dart';
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

  APIService apiService = APIService();

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

      debugPrint('STORE USER - ${state.value}');
    } on NotFoundException catch (e) {
      erro.value = e.message;
      debugPrint('erros 1 ${e.message}');
    } catch (e) {
      debugPrint('erros 2 ${e.toString()}');
      erro.value = e.toString();
    }

    isLoading.value = false;
  }

  Future update(Usuario usuario) async {
    final result = await repository.updateUser(usuario);
    isEditable.value = result;
  }

  Future updatenew(Usuario usuario) async {
    try {
      final result = await repository.updateUserNew(usuario);
      isEditable.value = result;
    } catch (e) {
      erro.value = "Erro no update: ${e.toString()}";
      debugPrint('Erro ao atualizar usuário: $e');
      isEditable.value = false;
    }
  }

  Future excluirConta(Usuario usuario) async {
    bool resposta = await repository.deleteUsuario(usuario);
    return resposta;
  }
}
