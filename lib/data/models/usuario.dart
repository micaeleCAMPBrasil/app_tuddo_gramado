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

class UsuarioProvider extends ChangeNotifier {
  Usuario usuario = Usuario(
      uid: '',
      nome: '',
      username: '',
      tokenAlert: '',
      email: '',
      telefone: '',
      photo: '',
      data: '');

  Usuario get getUsuario => usuario;

  updateUsuario(Usuario newUser) {
    usuario = newUser;
    notifyListeners();
  }
}
