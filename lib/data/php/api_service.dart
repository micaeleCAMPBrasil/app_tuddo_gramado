import 'dart:convert';
import 'dart:io';

import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wp_json_api/models/responses/wp_user_register_response.dart';
import 'package:wp_json_api/wp_json_api.dart';
import 'package:http/http.dart' as http;

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
    Map? data =
        await getIdTG(Config.tokenURLTG, 'admin', 'K17s31D02@milenaepedro');
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
    WPJsonAPI.instance.init(
      baseUrl: "https://site.tuddogramado.com.br",
    );

    // String email, String senha
    /*Map? data = await getIdTG(
        Config.tokenURL, 'tuddoemdobro', 'K17s31D02@milenaepedro');
    String tokenadm = data!['token'];*/

    debugPrint('model - ${model.toJson()}');

    try {
      await WPJsonAPI.instance.api(
        (request) => request.wpNonce(),
      );
      debugPrint('sucesso nonce');

      try {
        WPUserRegisterResponse wpUserRegisterResponse =
            await WPJsonAPI.instance.api(
          (request) => request.wpRegister(
            email: model.email.toString(),
            password: model.password.toString(),
            saveTokenToLocalStorage: true,
          ),
        );
        if (wpUserRegisterResponse.status == 200) {
          debugPrint('login  - ${wpUserRegisterResponse.data?.email}');

          await WPJsonAPI.instance.api(
            (request) => request.wpUpdateUserInfo(
              firstName: model.firstName,
              lastName: model.lastName,
              displayName: model.displayName,
            ),
          );

          await WPJsonAPI.instance.api(
            (request) => request.wpUserAddRole(
              role: "subscriber", // e.g. customer, subscriber
            ),
          );
          ret = true;
        } else {
          debugPrint("something went wrong 1");
          ret = false;
        }
      } catch (e) {
        debugPrint('registrer $e');
        ret = false;
      }
    } catch (e) {
      debugPrint('noce $e');
      ret = false;
    }

    return ret;
  }

  Future<bool> criandonovousuarioTransfer(CustomerModel model) async {
    bool ret = false;

    // String email, String senha
    Map? data = await getIdTG(
        Config.tokenURLTransfer, 'tuddotransfer', 'K17s31D02@milenaepedro');
    String tokenadm = data!['token'];

    try {
      var response = await Dio().post(
        Config.urlTuddoTransfer + Config.customerURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $tokenadm',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        debugPrint('usuario do transfer cadastrado');
        ret = true;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        debugPrint("Cadastro Erro transfer - ${e.message}");
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }

  Future<String> getUserId(String jwtToken, String email, String urls) async {
    final url = Uri.parse(urls);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(response.body);
      email.replaceAll('@', '');
      email.replaceAll('.', '-');

      for (var user in users) {
        String emails = user['slug'];

        print('ID: ${user['id']}, Nome: ${user['name']}, Email: ${emails}');
      }

      // Suponha que você já tenha o email ou nome do usuário que quer excluir
      // Exemplo de filtro por email:
      final user = users.firstWhere(
        (u) => u['slug'] == email,
        orElse: () => null,
      );

      if (user != null) {
        print('ID do usuário desejado: ${user['id']}');
        //return user['id'];
      } else {
        print('Usuário não encontrado');
        //return '';
      }
    } else {
      print('Erro ao buscar usuários: ${response.statusCode}');
      //return '';
    }

    return '';
  }

  // delete
  Future<bool> deleteUsuarioTuddoGramado(Usuario usuario) async {
    bool ret = false;

    // String email, String senha
    Map? data =
        await getIdTG(Config.tokenURLTG, 'admin', 'K17s31D02@milenaepedro');
    String tokenadm = data!['token'];

    String url = Config.urlTuddo + Config.customerURL;

    String iduser = await getUserId(
      tokenadm,
      usuario.email.toString(),
      url,
    );

    debugPrint('id user firebse $url');

    /*if (iduser == '') {
    } else {
      try {
        var response = await Dio().delete(
          '${Config.urlTuddo}${Config.customerURL}/$iduser',
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
    }*/

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

  Future<bool> editandousuariowordpress(
      String urlToken, String url, Usuario usuario) async {
    bool ret = false;

    // String email, String senha
    Map? data = await getIdTG(urlToken, usuario.email, usuario.uid);
    String iduser = data!['id'].toString();
    String tokenuser = data['token'];

    List<String> split = usuario.nome.split(' ');
    String primeiroNome = split[0] == '' ? '' : split[0].toUpperCase();
    String segundoNome = split[1] == '' ? '' : split[1].toUpperCase();

    try {
      var response = await Dio().post(
        '$url/$iduser',
        data: jsonEncode({
          'first_name': primeiroNome,
          'last_name': segundoNome,
          'name': usuario.nome,
          'email': usuario.email,
          'username': usuario.email,
        }),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $tokenuser',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('usuario editado');
        ret = true;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        debugPrint("Edição Erro - ${e.message}");
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }
}
