import 'dart:async';

import 'package:app_tuddo_gramado/data/models/SVCommentModel.dart';
import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/exceptions.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:flutter/material.dart';

class PublicacaoStore {
  final IFuncoes repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<bool> likeCheck = ValueNotifier<bool>(false);
  final ValueNotifier<bool> likeComentarioCheck = ValueNotifier<bool>(false);
  final ValueNotifier<bool> addCheck = ValueNotifier<bool>(false);
  final ValueNotifier<bool> deleteCheck = ValueNotifier<bool>(false);

  final ValueNotifier<List<SVPostModel>> list =
      ValueNotifier<List<SVPostModel>>([]);

  final ValueNotifier<List<SVCommentModel>> comentarios =
      ValueNotifier<List<SVCommentModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  PublicacaoStore({required this.repository});

  Future addPost(Usuario usuario, String description, String imageURL) async {
    final result = await repository.addPost(usuario, description, imageURL);
    addCheck.value = result;
  }

  Future addComentario(
      Usuario usuario, String comentario, String idPost) async {
    final result = await repository.addComentario(usuario, comentario, idPost);
    addCheck.value = result;
  }

  Future addLike(String uid, String idPost) async {
    final result = await repository.addLike(uid, idPost);
    likeCheck.value = result;
  }

  Future deletePost(String idPost) async {
    final result = await repository.deletePost(idPost);
    deleteCheck.value = result;
  }

  Future addLikeComentario(String uid, String idComentario) async {
    final result = await repository.addLikeComentario(uid, idComentario);
    likeComentarioCheck.value = result;
  }

  Future getAllPost(String uid, String idPost) async {
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

  Future getComentarios(String uid, String idPost) async {
    isLoading.value = true;

    try {
      final result = await repository.getComentarioPost(uid, idPost);
      comentarios.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}
