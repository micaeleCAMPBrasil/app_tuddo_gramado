import 'dart:async';
import 'dart:io';

import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/exceptions.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:flutter/material.dart';

class PostStore {
  final IFuncoes repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<bool> likeCheck = ValueNotifier<bool>(false);
  final ValueNotifier<bool> addCheck = ValueNotifier<bool>(false);

  final ValueNotifier<List<SVPostModel>> list =
      ValueNotifier<List<SVPostModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  PostStore({required this.repository});

  Future addPost(Usuario usuario, String description, File imageURL) async {
    final result = await repository.addPost(usuario, description, imageURL);
    addCheck.value = result;
  }

  Future addLike(String uid, String idPost) async {
    final result = await repository.addLike(uid, idPost);
    likeCheck.value = result;
  }

  Future getAll(String uid, String idPost) async {
    isLoading.value = true;

    try {
      final result = await repository.getListAllPost(uid, idPost);
      list.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}
