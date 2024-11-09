import 'dart:async';

import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/exceptions.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PublicacaoStore {
  final IFuncoes repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<bool> likeCheck = ValueNotifier<bool>(false);
  final ValueNotifier<bool> likeComentarioCheck = ValueNotifier<bool>(false);
  final ValueNotifier<bool> addCheck = ValueNotifier<bool>(false);
  final ValueNotifier<bool> deleteCheck = ValueNotifier<bool>(false);

  /*final ValueNotifier<List<SVPostModel>> list =
      ValueNotifier<List<SVPostModel>>([]);*/

  final ValueNotifier<List<Usuario>> listUser =
      ValueNotifier<List<Usuario>>([]);

  /*final ValueNotifier<List<SVCommentModel>> comentarios =
      ValueNotifier<List<SVCommentModel>>([]);*/

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  PublicacaoStore({required this.repository});

  /*Future addPost(Usuario usuario, String description, String imageURL) async {
    final result = await repository.addPost(usuario, description, imageURL);
    addCheck.value = result;
  }

  Future addComentario(
      Usuario usuario, String comentario, String idPost) async {
    final result = await repository.addComentario(usuario, comentario, idPost);
    addCheck.value = result;
  }*/

  Future addLike(bool isLiked, String uid, String idPost) async {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Post').doc(idPost);

    if (isLiked) {
      postRef.update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    } else {
      postRef.update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    }
    /*final result = await repository.addLike(uid, idPost);
    likeCheck.value = result;*/
  }

  Future deletePost(String idPost) async {
    final commmentDocs = await FirebaseFirestore.instance
        .collection("User Post")
        .doc(idPost)
        .collection("Comments")
        .get();

    for (var doc in commmentDocs.docs) {
      await FirebaseFirestore.instance
          .collection("User Post")
          .doc(idPost)
          .collection("Comments")
          .doc(doc.id)
          .delete();
    }

    FirebaseFirestore.instance
        .collection("User Post")
        .doc(idPost)
        .delete()
        .then((value) => debugPrint('post deletado'))
        .catchError((error) => debugPrint('erro $error'));

    /*final result = await repository.deletePost(idPost);
    deleteCheck.value = result;*/
  }

  Future deleteComentario(String idPost, String idComentario) async {
    await FirebaseFirestore.instance
        .collection("User Post")
        .doc(idPost)
        .collection("Comments")
        .doc(idComentario)
        .delete();

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Post').doc(idPost);
    DocumentSnapshot snapshot = await postRef.get();
    final data = snapshot.data() as Map<String, dynamic>;

    int totalComentario = int.parse(data['totalComentario'].toString());

    postRef.update({
      'totalComentario': totalComentario - 1,
    });

    /*final result = await repository.deleteComentario(idComentario);
    deleteCheck.value = result;*/
  }

  Future addLikeComentario(
      bool idLiked, String uid, String idPost, String idComentario) async {
    DocumentReference postRef = FirebaseFirestore.instance
        .collection("User Post")
        .doc(idPost)
        .collection("Comments")
        .doc(idComentario);

    if (idLiked) {
      postRef.update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    } else {
      postRef.update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    }

    /*final result = await repository.addLikeComentario(uid, idComentario);
    likeComentarioCheck.value = result;*/
  }

  fecharModal(BuildContext context) {
    Navigator.pop(context);
  }

  Future getListUsersLikes(List<String> uidUsers, String uid) async {
    isLoading.value = true;
    try {
      final result = await repository.getListUsersLikes(uidUsers, uid);
      listUser.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;

    return listUser.value;
  }

  /*Future getAllPost(String uid, String idPost) async {
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
  }*/
}
