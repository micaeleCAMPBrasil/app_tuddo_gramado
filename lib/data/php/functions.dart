import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/exceptions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';

abstract class IFuncoes {
  Future<List<Usuario>> getAllUsuario();
  Future<Usuario> getUsuarioUID(String uid);
  Future<bool> updateUser(Usuario usuario);
}

class IFuncoesPHP implements IFuncoes {
  final IHttpClient client;

  IFuncoesPHP({required this.client});

  @override
  Future<List<Usuario>> getAllUsuario() async {
    final response = await client.get(
      url: "https://campbrasil.com/tuddo_gramado/php/getAllUsuario.php",
    );

    if (response.statusCode == 200) {
      List<Usuario> usuarioFinal = [];

      final body = jsonDecode(response.body);

      if (body == 'dados_vazios') {
      } else if (body == 'Database erro') {
      } else {
        body.map((users) {
          Usuario userConvertido = Usuario.fromMap(users);
          usuarioFinal.add(userConvertido);
        }).toList();
      }
      return usuarioFinal;
    } else if (response.statusCode == 404) {
      throw NotFoundException("A url informada não é válida.");
    } else {
      throw Exception("Não foi possível carregar os usuários.");
    }
  }

  @override
  Future<bool> updateUser(Usuario usuario) async {
    String uid = usuario.uid;
    String nome = usuario.nome;
    String email = usuario.email;
    String phone = usuario.telefone;
    String userName = usuario.username;
    String foto = usuario.photo;
    String token = usuario.tokenAlert;

    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/updateUser.php?uid=$uid&nome=$nome&email=$email&phone=$phone&username=$userName&photo=$foto&token=$token",
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      debugPrint("resposta - $body");
      if (body == 'dados_vazios') {
        return false;
      } else if (body == 'Database erro') {
        return false;
      } else {
        return true;
      }
    } else if (response.statusCode == 404) {
      throw NotFoundException("A url informada não é válida.");
    } else {
      throw Exception("Não foi possível carregar os usuários.");
    }
  }

  @override
  Future<Usuario> getUsuarioUID(String uid) async {
    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/getUsuarioUID.php?uid=$uid",
    );

    if (response.statusCode == 200) {
      late Usuario usuarioFinal;

      final body = jsonDecode(response.body);

      if (body == 'dados_vazios') {
        usuarioFinal = Usuario(
          uid: '',
          tokenAlert: '',
          nome: '',
          username: '',
          email: '',
          telefone: '',
          photo: '',
          data: '',
        );
      } else if (body == 'Database erro') {
        usuarioFinal = Usuario(
          uid: '',
          tokenAlert: '',
          nome: '',
          username: '',
          email: '',
          telefone: '',
          photo: '',
          data: '',
        );
      } else {
        body.map((users) {
          Usuario userConvertido = Usuario.fromMap(users);
          usuarioFinal = userConvertido;
        }).toList();
      }
      return usuarioFinal;
    } else if (response.statusCode == 404) {
      throw NotFoundException("A url informada não é válida.");
    } else {
      throw Exception("Não foi possível carregar os usuários.");
    }
  }
}
