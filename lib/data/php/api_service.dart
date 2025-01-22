import 'dart:convert';
import 'dart:io';

import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wp_json_api/models/responses/wp_user_register_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

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

    debugPrint('criando usuario tuddo em dobro');

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
            username: model.email.toString(),
          ),
        );

        /*WPUserInfoUpdatedResponse wpUserInfoUpdatedResponse =
          await WPJsonAPI.instance.api(
        (request) => request.wpUpdateUserInfo(
          firstName: 'CleideaneSales',
          lastName: 'Sales',
          displayName: 'Cleideane Sales Ribeiro',
        ),
      );

      debugPrint('update tuddo gramado - $wpUserInfoUpdatedResponse');*/

        if (wpUserRegisterResponse.status == 200) {
          debugPrint('login tuddo em dobro  - ${wpUserRegisterResponse.data}');

          await WPJsonAPI.instance.api(
            (request) => request.wpUpdateUserInfo(
              firstName: model.firstName,
              lastName: model.lastName,
              displayName: model.email,
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

  /*Future<void> uploadImage(String token, XFile imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://seu-site.com/wp-json/wp/v2/media'),
    );

    // Adiciona o arquivo de imagem no corpo da requisição
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: imageFile.name,
      ),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Disposition'] =
        'attachment; filename="${imageFile.name}"';

    final response = await request.send();

    if (response.statusCode == 201) {
      print('Imagem enviada com sucesso');
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);
      print('ID da mídia: ${data['id']}');
    } else {
      print('Falha no upload de imagem');
    }
  }

  Future<void> updateProfilePicture(
      String token, int userId, int mediaId) async {
    final response = await http.put(
      Uri.parse('https://seu-site.com/wp-json/wp/v2/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'meta': {
          'avatar_id': mediaId, // Supondo que o plugin utilize esse meta field
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Avatar atualizado com sucesso');
    } else {
      print('Falha ao atualizar avatar');
    }
  }
  */
}
