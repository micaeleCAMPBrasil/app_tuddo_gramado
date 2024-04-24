import 'dart:convert';
import 'dart:io';
import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/exceptions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';

abstract class IFuncoes {
  Future<List<Usuario>> getAllUsuario();
  Future<Usuario> getUsuarioUID(String uid);
  Future<bool> updateUser(Usuario usuario);

  Future<List<Patrocinadores>> getListPatrocinadores();

  Future<List<SVPostModel>> getListAllPost(String uid, String idPost);
  Future<bool> addPost(Usuario usuario, String description, File imageUrl);
  Future<bool> addLike(String uid, String idPost);
}

class IFuncoesPHP implements IFuncoes {
  final IHttpClient client;

  IFuncoesPHP({required this.client});

  @override
  Future<List<Patrocinadores>> getListPatrocinadores() async {
    List<Patrocinadores> getPatrocinadores = [
      Patrocinadores(
        id: 1,
        nome: 'Alimentos Júnior',
        logo: 'https://ibb.co/hszG0rb',
        descricao:
            'Nós, da Alimentos Júnior Consultoria, transformamos vidas, sabendo que é possível realizar sonhos, gerando oportunidades para um legado de impacto.',
        imagemBG: 'assets/image/p1.jpeg',
        isFavorite: true,
        linkWebSite:
            'https://alimentosjunior.com.br/?gad_source=1&gclid=CjwKCAjwrIixBhBbEiwACEqDJaqxdAmRRQ9PrM5TDMg6vNTADDjfqf_nzmzxsGuDMjHH2bZT0dk3zhoCMEAQAvD_BwE',
        linkEndereco:
            'https://www.google.com.br/maps/place/DTA+UFV/@-20.7610811,-42.8679205,17z/data=!4m10!1m2!2m1!1sDepartamento+de+Tecnologia+de+Alimentos+II+-+Campus+Universit%C3%A1rio+UFV,+Vi%C3%A7osa+-+MG!3m6!1s0xa367f798cb50c3:0xcc6d3cafb0288cd0!8m2!3d-20.761184!4d-42.8656758!15sClREZXBhcnRhbWVudG8gZGUgVGVjbm9sb2dpYSBkZSBBbGltZW50b3MgSUkgLSBDYW1wdXMgVW5pdmVyc2l0w6FyaW8gVUZWLCBWacOnb3NhIC0gTUeSAQp1bml2ZXJzaXR54AEA!16s%2Fg%2F120w3kyh?entry=ttu',
        linkInstagram: 'https://www.instagram.com/alimentos.junior/',
        galeria: [
          GaleriaPatrocinador(
            idPatrocinador: 1,
            img: 'https://i.ibb.co/nwJ3fpC/img3.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 1,
            img: 'https://i.ibb.co/zZLYpP4/img2.jpg',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 1,
            img: 'https://i.ibb.co/64JnqR6/img1.jpg',
          ),
        ],
      ),
      Patrocinadores(
        id: 2,
        nome: 'Patrocinador 2',
        logo: '',
        imagemBG: 'assets/image/p2.jpeg',
        isFavorite: false,
        linkEndereco:
            'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
        linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
        galeria: [],
      ),
      Patrocinadores(
        id: 3,
        nome: 'Patrocinador 3',
        logo: '',
        imagemBG: 'assets/image/p3.png',
        isFavorite: false,
        linkEndereco:
            'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
        linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
        galeria: [],
      ),
      Patrocinadores(
        id: 2,
        nome: 'Patrocinador 2',
        logo: '',
        imagemBG: 'assets/image/p2.jpeg',
        isFavorite: false,
        linkEndereco:
            'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
        linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
        galeria: [],
      ),
      Patrocinadores(
        id: 1,
        nome: 'Patrocinador 1',
        logo: '',
        imagemBG: 'assets/image/p1.jpeg',
        isFavorite: true,
        linkEndereco:
            'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
        linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
        galeria: [],
      ),
      Patrocinadores(
        id: 3,
        nome: 'Patrocinador 3',
        logo: '',
        imagemBG: 'assets/image/p3.png',
        isFavorite: false,
        linkEndereco:
            'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
        linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
        galeria: [],
      ),
    ];

    return getPatrocinadores;
  }

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

      debugPrint('Body - $body');

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

  @override
  Future<List<SVPostModel>> getListAllPost(String uid, String idPost) async {
    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/getAllPost.php?uid=$uid",
    );

    if (response.statusCode == 200) {
      List<SVPostModel> post = [];
      var body = jsonDecode(response.body);

      if (body == 'Database erro') {
      } else {
        int i = 0;
        for (var v in body['dados_publicacao']) {
          int idPub = int.parse(v['id'].toString());
          String uidUser = v['idUsuario'];
          String dataTime = v['data'];
          String description = v['description'];
          String linkImage = v['postImage'];

          var element = body['dados_usuario'][i];

          Usuario usuarioQFOPost = Usuario(
            uid: element['uid'],
            tokenAlert: element['token_alert'],
            nome: element['name'],
            username: element['username'],
            email: element['email'],
            telefone: element['telefone'],
            photo: element['photoUrl'],
            data: element['data'],
          );

          int totalLikes = int.parse(body['totalLikes'][i].toString());
          bool checkUserLike = totalLikes == 0
              ? false
              : bool.parse(body['checkUserLike'][i].toString());

          final response2 = await client.get(
            url:
                "https://campbrasil.com/tuddo_gramado/php/posts/getLikePost.php?idPost=${idPub.toString()}",
          );
          var bodys = jsonDecode(response2.body);
          List<Usuario> userQCurtiu = [];

          if (bodys == 'Database erro') {
          } else {
            bodys.map((usuario) {
              Usuario userConvertido = Usuario.fromMap(usuario);

              if (userConvertido.uid == uid) {
              } else {
                userQCurtiu.add(userConvertido);
              }
            }).toList();
          }

          SVPostModel postBD = SVPostModel(
            idPost: idPub,
            idUsuario: uidUser,
            name: usuarioQFOPost.nome,
            postImage: linkImage,
            profileImage: usuarioQFOPost.photo,
            time: dataTime,
            description: description,
            commentCount: totalLikes,
            like: checkUserLike,
            likeCount: userQCurtiu.length,
            usuarioQCurtiram: userQCurtiu,
          );

          i = i + 1;
          post.add(postBD);
        }
      }
      return post;
    } else if (response.statusCode == 404) {
      debugPrint('erro 404');
      throw NotFoundException("A url informada não é válida.");
    } else {
      debugPrint('outro erro');
      throw Exception("Não foi possível carregar os post.");
    }
  }

  @override
  Future<bool> addPost(
      Usuario usuario, String description, File imageURL) async {
    String uid = usuario.uid;

    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/addPost.php?uid=$uid&description=$description&file=$imageURL",
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (body == 'true') {
        return true;
      } else if (body == 'ja_tem') {
        return false;
      } else {
        return false;
      }
    } else if (response.statusCode == 404) {
      debugPrint('erro 404');
      throw NotFoundException("A url informada não é válida.");
    } else {
      debugPrint('outro erro');
      throw Exception("Não foi possível carregar os post.");
    }
  }

  @override
  Future<bool> addLike(String uid, String idPost) async {
    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/addLikePost.php?uid=$uid&idPost=$idPost",
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (body == 'true') {
        return true;
      } else {
        return false;
      }
    } else if (response.statusCode == 404) {
      debugPrint('erro 404');
      throw NotFoundException("A url informada não é válida.");
    } else {
      debugPrint('outro erro');
      throw Exception("Não foi possível carregar os post.");
    }
  }
}
