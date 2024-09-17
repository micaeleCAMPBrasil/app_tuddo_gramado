import 'dart:convert';
import 'dart:io';

import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class APIService {
  Future<bool> createCustomer(Usuario usuario, CustomerModel model) async {
    debugPrint('criando novo usuário');

    bool ret = false;

    try {
      bool check1 = await criandonovousuarioTuddoGramado(model);

      if (check1) {
        await criandonovousuarioTuddoDobro(model);
      }

      ret = true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        debugPrint("Cadastro Erro${e.message}");
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }

  Future<bool> criandonovousuarioTuddoGramado(CustomerModel model) async {
    bool ret = false;

    // String email, String senha
    Map? data = await getIdTG(Config.tokenURLTG, 'admin', 'K17s31D02@tuddo');
    String tokenadm = data!['token'];

    try {
      var response = await Dio().post(
        Config.urlTuddo + Config.customerURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $tokenadm',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        debugPrint('usuario do tuddo gramado cadastrado');
        ret = true;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        debugPrint("Cadastro Erro TUDDO GRAMADO ${e.message}");
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }

  Future<bool> criandonovousuarioTuddoDobro(CustomerModel model) async {
    bool ret = false;

    // String email, String senha
    Map? data = await getIdTG(Config.tokenURL, 'tuddoemdobro', 'K17s31D02@');
    String tokenadm = data!['token'];

    try {
      var response = await Dio().post(
        Config.url + Config.customerURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $tokenadm',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        debugPrint('usuario do tuddo em dobro cadastrado');
        ret = true;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        debugPrint("Cadastro Erro Tuddo em dobro - ${e.message}");
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }

  Future<Map<String, dynamic>?> getIdTG(
      String url, String email, String senha) async {
    var authToken = base64.encode(
      utf8.encode("${Config.keyTuddo}:${Config.screetTuddo}"),
    );

    try {
      var response = await Dio().post(
        "$url?username=$email&password=$senha",
        data: {
          'username': email,
          'password': senha,
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('tuddo gramado - ${response.data}');
        return response.data['data'];
      } else {}
    } on DioException catch (e) {
      debugPrint("GET ID Erro Tuddo Gramado - ${e.message}");
    }
    return null;
  }
}
