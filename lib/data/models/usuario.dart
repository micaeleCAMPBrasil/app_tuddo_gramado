import 'package:flutter/material.dart';

class Usuario {
  String uid, tokenAlert, nome, username, email, telefone, photo, data;

  Usuario({
    required this.uid,
    required this.tokenAlert,
    required this.nome,
    required this.username,
    required this.email,
    required this.telefone,
    required this.photo,
    required this.data,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'],
      tokenAlert: map['token_alert'],
      nome: map['name'],
      username: map['username'],
      email: map['email'],
      telefone: map['telefone'],
      photo: map['photoUrl'],
      data: map['data'],
    );
  }
}

class CustomerModel {
  String? firstName, lastName, password, email;

  CustomerModel({
    this.firstName,
    this.lastName,
    this.password,
    this.email,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'username': email,
    });

    return map;
  }
}

class LoginResponseModel {
  bool? success;
  int? statusCode;
  String? code, message;
  Data? data;

  LoginResponseModel({
    this.success,
    this.statusCode,
    this.code,
    this.message,
    this.data,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dados = <String, dynamic>{};

    dados['success'] = success;
    dados['statusCode'] = statusCode;
    dados['code'] = code;
    dados['message'] = message;

    dados['data'] = data?.toJson();
    
    /*if (data != null) {}*/

    return dados;
  }
}

class Data {
  String? token, email, nicename, firstName, lastName, displayName;
  int? id;

  Data({
    this.id,
    this.token,
    this.email,
    this.nicename,
    this.firstName,
    this.lastName,
    this.displayName,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    email = json['email'];
    nicename = json['nicename'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['token'] = token;
    data['email'] = email;
    data['nicename'] = nicename;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['displayName'] = displayName;

    return data;
  }
}

class UsuarioProvider extends ChangeNotifier {
  Usuario usuario = Usuario(
    uid: '',
    nome: '',
    username: '',
    tokenAlert: '',
    email: '',
    telefone: '',
    photo: '',
    data: '',
  );

  Usuario get getUsuario => usuario;

  updateUsuario(Usuario newUser) {
    usuario = newUser;
    notifyListeners();
  }
}
