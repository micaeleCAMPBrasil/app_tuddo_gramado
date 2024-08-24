import 'dart:convert';
import 'dart:io';

import 'package:app_tuddo_gramado/data/models/modalidades_td.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class APIService {
  Future<bool> createCustomer(CustomerModel model) async {
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

      if (response.statusCode == 201) {
        ret = true;
      }
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

  Future<LoginResponseModel> loginCustomer(
      String username, String password) async {
    late LoginResponseModel model;
    try {
      var response = await Dio().post(
        Config.tokenURL,
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.statusCode == 200) {
        model = LoginResponseModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      debugPrint("Login Erro${e.message}");
    }
    return model;
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
