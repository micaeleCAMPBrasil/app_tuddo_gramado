import 'dart:convert';
import 'dart:io';

import 'package:app_tuddo_gramado/data/models/modalidades_td.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wp_json_api/enums/wp_auth_type.dart';
import 'package:wp_json_api/models/responses/wp_user_login_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class APIService {
  Future<bool> createCustomer(Usuario usuario, CustomerModel model) async {
    debugPrint('criando novo usuário');

    bool ret = false;

    try {
      await criandonovousuarioTuddoGramado(model);
      await criandonovousuarioTuddoDobro(model);
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

  Future<bool> updaterole() async {
    var authToken = base64.encode(
      utf8.encode("${Config.keyTuddo}:${Config.screetTuddo}"),
    );

    debugPrint('atualizando regras');

    bool ret = false;

    try {
      var response = await Dio().post(
        'https://d.tuddogramado.com.br/wp-json/wp/v2/users/40',
        data: {
          "roles": ["author", "customer"]
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Authorization $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {}
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
    var authToken = base64.encode(
      utf8.encode("${Config.keyTuddo}:${Config.screetTuddo}"),
    );

    bool ret = false;

    try {
      var response = await Dio().post(
        Config.urlTuddo + Config.customerURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {}
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

  Future<bool> criandonovousuarioTuddoDobro(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.screet}"),
    );

    bool ret = false;

    try {
      var response = await Dio().post(
        Config.url + Config.customerURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {}
      ret = true;
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

  Future<bool> tuddoGramado(Usuario usuario, CustomerModel model) async {
    WPJsonAPI.instance.init(baseUrl: "https://tuddogramado.com.br/");

    debugPrint('criando novo usuário - tuddo gramado');

    bool ret = false;

    WPUserLoginResponse? wpUserLoginResponse;

    try {
      wpUserLoginResponse = await WPJsonAPI.instance.api(
        (request) => request.wpLogin(
          email: usuario.email,
          password: usuario.uid,
          authType: WPAuthType.WpEmail,
        ),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    if (wpUserLoginResponse == null) {
      // cadastre

      try {
        WPJsonAPI.instance.api((request) {
          return request.wpRegister(
            email: usuario.email,
            password: usuario.uid,
            username: usuario.email,
            expiry: '0',
          );
        });

        WPUserLoginResponse newLogin = await WPJsonAPI.instance.api(
          (request) => request.wpLogin(
            email: usuario.email,
            password: usuario.uid,
            authType: WPAuthType.WpEmail,
          ),
        );

        String? tokenFirebase = newLogin.data!.userToken;

        debugPrint('token tuddo gramado - $tokenFirebase');

        await WPJsonAPI.instance.api((request) {
          return request.wpUpdateUserInfo(
            userToken: tokenFirebase,
            firstName: model.firstName,
            lastName: model.lastName,
            displayName: usuario.nome,
          );
        });

        await WPJsonAPI.instance.api((request) => request.wpUserAddRole(
            userToken: tokenFirebase, role: "subscriber"));

        ret = true;
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          debugPrint("Cadastro Erro${e.message}");
          ret = false;
        } else {
          ret = false;
        }
      }
    } else {
      ret = true;
      String? tokenFirebase = wpUserLoginResponse.data!.userToken;

      debugPrint('token tuddo gramado - $tokenFirebase');
    }

    return ret;
  }

  Future<bool> tuddoemDobro(Usuario usuario, CustomerModel model) async {
    WPJsonAPI.instance.init(baseUrl: "https://d.tuddogramado.com.br/");

    debugPrint('criando novo usuário - tuddo em dobro');

    bool ret = false;

    WPUserLoginResponse? wpUserLoginResponse;

    try {
      wpUserLoginResponse = await WPJsonAPI.instance.api(
        (request) => request.wpLogin(
          email: usuario.email,
          password: usuario.uid,
          authType: WPAuthType.WpEmail,
        ),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    if (wpUserLoginResponse == null) {
      // cadastre

      try {
        WPJsonAPI.instance.api((request) {
          return request.wpRegister(
            email: usuario.email,
            password: usuario.uid,
            username: usuario.email,
            expiry: '0',
          );
        });

        WPUserLoginResponse newLogin = await WPJsonAPI.instance.api(
          (request) => request.wpLogin(
            email: usuario.email,
            password: usuario.uid,
            authType: WPAuthType.WpEmail,
          ),
        );

        String? tokenFirebase = newLogin.data!.userToken;

        debugPrint('token tuddo em dobro depois do cadastro - $tokenFirebase');

        await WPJsonAPI.instance.api((request) {
          return request.wpUpdateUserInfo(
            userToken: tokenFirebase,
            firstName: model.firstName,
            lastName: model.lastName,
            displayName: usuario.nome,
          );
        });

        await WPJsonAPI.instance.api((request) => request.wpUserAddRole(
            userToken: tokenFirebase, role: "subscriber"));

        ret = true;
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          debugPrint("Cadastro Erro${e.message}");
          ret = false;
        } else {
          ret = false;
        }
      }
    } else {
      ret = true;
      String? tokenFirebase = wpUserLoginResponse.data!.userToken;

      debugPrint('token tuddo em dobro - $tokenFirebase');
    }

    return ret;
  }

  Future<String?> getToken(String email, String senha) async {
    WPJsonAPI.instance.init(baseUrl: "https://tuddogramado.com.br/");
    WPUserLoginResponse? wpUserLoginResponse;
    try {
      wpUserLoginResponse = await WPJsonAPI.instance.api(
        (request) => request.wpLogin(
          email: email,
          password: senha,
          authType: WPAuthType.WpEmail,
        ),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    if (wpUserLoginResponse == null) {
      debugPrint("invalid login details");
      return "";
    } else {
      debugPrint('- token ${wpUserLoginResponse.data?.userToken}');
      return wpUserLoginResponse.data?.userToken;
    }
  }

  Future<List<Modalidade>> getModalidades() async {
    List<Modalidade> data = [];

    try {
      String url =
          "${Config.url2}${Config.modalidadesTDUrl}?consumer_key=${Config.key}&consumer_secret=${Config.screet}";
      var response = await Dio().get(url,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ));

      //debugPrint('Response Modalidades - ${response.data}');

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (e) => Modalidade.fromJson(e),
            )
            .toList();

        for (var element in response.data) {
          //var newLi = element['_links']['wp:featuredmedia'];
          debugPrint('Elemento ${element.data}');
          debugPrint("-----");
          /*for (var l in newLi) {
            String link = "${l['href']}";

            var response2 = await Dio().get(
              link,
              options: Options(
                headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                },
              ),
            );
          }*/
        }
      }
    } on DioException catch (e) {
      debugPrint("Get List Modalidades${e.message}");
    }

    //debugPrint('Data Modalidades - $data');
    return data;
  }
}
