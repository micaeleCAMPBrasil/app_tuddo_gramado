import 'dart:convert';
import 'package:app_tuddo_gramado/data/models/SVCommentModel.dart';
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
  Future<bool> addPost(Usuario usuario, String description, String imageUrl);
  Future<bool> addLike(String uid, String idPost);
  Future<List<SVCommentModel>> getComentarioPost(String uid, String idPost);
  Future<bool> addLikeComentario(String uid, String idComentario);
  Future<bool> addComentario(Usuario usuario, String comentario, String idPost);

  Future<bool> deletePost(String idPost);
}

class IFuncoesPHP implements IFuncoes {
  final IHttpClient client;

  IFuncoesPHP({required this.client});

  @override
  Future<List<Patrocinadores>> getListPatrocinadores() async {
    List<Patrocinadores> getPatrocinadores = [
      Patrocinadores(
        id: 1,
        nome: 'Space Adventure',
        logo: 'https://i.ibb.co/5jZjB7p/space-adventure-foto-principal.png',
        imagemBG: 'https://i.ibb.co/LPrncHc/space-adventure-slide-1.png',
        descricao:
            'Uma exposição inédita com itens de missões da NASA jamais exibidos fora dos Estados Unidos. Com mais de 270 itens ORIGINAIS de missões da NASA, experiências imersivas e diversas atrações. \n Venha viver uma experiência única! \n Adquira seu ingresso antecipadamente! \n ⏰ De Seg a Ter: das 9h às 18h. Entrada até 16h \n ⏰Sexta a Dom: das 9h às 19h \n Entrada até 17h',
        isFavorite: false,
        isBannerInicial: true,
        isMostrarSite: true,
        linkWebSite: 'http://www.spaceadventure.com.br',
        galeria: [
          GaleriaPatrocinador(
            idPatrocinador: 1,
            img: 'https://i.ibb.co/bg0H02f/space-adventure-foto1.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 1,
            img: 'https://i.ibb.co/CzNr6qQ/space-adventure-foto2.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 1,
            img: 'https://i.ibb.co/Bgd1d4F/space-adventure-foto3.png',
          ),
        ],
      ),
      Patrocinadores(
        id: 2,
        nome: 'Gatzz',
        logo: 'https://i.ibb.co/XkVThBv/gatzz-principal.png',
        imagemBG: 'https://i.ibb.co/TTLrMnJ/Gatzz-Slide-2.png',
        descricao:
            'Um pedacinho da Broadway em Gramado-RS \n ✨Bellepoque \n 🔞Dezoito + \n 🎈Imaginadores \n Reservas no site ⬇ ou Bilheteria a partir das 14h',
        isFavorite: false,
        isBannerInicial: true,
        isMostrarSite: true,
        linkWebSite: 'http://gatzz.com',
        galeria: [
          GaleriaPatrocinador(
            idPatrocinador: 2,
            img: 'https://i.ibb.co/7Xzd0VQ/gatzz-foto1.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 2,
            img: 'https://i.ibb.co/VmHmwJK/gatzz-foto-2.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 2,
            img: 'https://i.ibb.co/xFPhPRh/gatzz-foto3.png',
          ),
        ],
      ),
      Patrocinadores(
        id: 3,
        nome: 'Laghetto',
        logo: 'https://i.ibb.co/252VVfZ/laghetto-principal.png',
        imagemBG: 'https://i.ibb.co/F51vN99/laghetto-slide-3.png',
        descricao:
            'Hotéis, Resorts & Experiências A rede Laghetto é sinônimo de hospitalidade excepcional, oferecendo hotéis, resorts e experiências de alto nível. Com um compromisso inabalável com o profissionalismo. Hospede-se com quem tem paixão em servir 💚',
        isFavorite: false,
        isMostrarSite: false,
        isBannerInicial: true,
        galeria: [
          GaleriaPatrocinador(
            idPatrocinador: 3,
            img: 'https://i.ibb.co/THQY4PQ/laghetto-foto-1.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 3,
            img: 'https://i.ibb.co/yP7rQ94/laghetto-foto-2.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 3,
            img: 'https://i.ibb.co/y66k1B7/laghetto-foto3.png',
          ),
        ],
      ),
      Patrocinadores(
        id: 4,
        nome: 'Faça Parte!',
        logo: 'https://i.ibb.co/1n2VTK2/principal-exemplo.png',
        imagemBG: 'https://i.ibb.co/BPVz0mV/slide-4-marca.png',
        descricao:
            'Você já parou para pensar no impacto que a presença da sua marca nos principais meios de publicidade pode ter? 💡 É a oportunidade de alcançar um público certo, construir reconhecimento e estabelecer sua marca como referência no mercado. 💼✨ Não fique de fora dessa oportunidade! Seja visto, seja lembrado. 🚀 Adquira sua cota anual hoje mesmo e faça parte do grupo seleto de empresas visionárias que vão levar a marca ao próximo nível!',
        isFavorite: false,
        isMostrarSite: false,
        isBannerInicial: true,
        galeria: [],
      ),
      Patrocinadores(
        id: 5,
        nome: 'Faça Parte!',
        logo: 'https://i.ibb.co/pJzkVNS/foto2-exemplo.png',
        descricao:
            'Você já parou para pensar no impacto que a presença da sua marca nos principais meios de publicidade pode ter? 💡 É a oportunidade de alcançar um público certo, construir reconhecimento e estabelecer sua marca como referência no mercado. 💼✨ Não fique de fora dessa oportunidade! Seja visto, seja lembrado. 🚀 Adquira sua cota anual hoje mesmo e faça parte do grupo seleto de empresas visionárias que vão levar a marca ao próximo nível!',
        imagemBG: 'https://i.ibb.co/BPVz0mV/slide-4-marca.png',
        isFavorite: true,
        isBannerInicial: false,
        isMostrarSite: false,
        galeria: [],
      ),
      Patrocinadores(
        id: 6,
        nome: 'Faça Parte!',
        logo: 'https://i.ibb.co/9NvH5h8/foto3-exemplo.png',
        descricao:
            'Você já parou para pensar no impacto que a presença da sua marca nos principais meios de publicidade pode ter? 💡 É a oportunidade de alcançar um público certo, construir reconhecimento e estabelecer sua marca como referência no mercado. 💼✨ Não fique de fora dessa oportunidade! Seja visto, seja lembrado. 🚀 Adquira sua cota anual hoje mesmo e faça parte do grupo seleto de empresas visionárias que vão levar a marca ao próximo nível!',
        imagemBG: 'https://i.ibb.co/BPVz0mV/slide-4-marca.png',
        isFavorite: false,
        isBannerInicial: false,
        isMostrarSite: false,
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

          if (uidUser == '' || description == '' || linkImage == '') {
          } else {
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

            int totalComentario = 0;

            final response3 = await client.get(
              url:
                  "https://campbrasil.com/tuddo_gramado/php/posts/getComentarios.php?idPost=${idPub.toString()}&uid=$uid",
            );
            var bodys2 = jsonDecode(response3.body);

            if (bodys2 == 'Database erro') {
            } else {
              bodys2['total_comentarios'].map((e) {
                totalComentario = e;
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
              commentCount: totalComentario,
              like: checkUserLike,
              likeCount: userQCurtiu.length,
              usuarioQCurtiram: userQCurtiu,
            );

            i = i + 1;
            post.add(postBD);
          }
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
      Usuario usuario, String description, String imageURL) async {
    String uid = usuario.uid;

    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/addPost.php?uid=$uid&description=$description&imageURL=$imageURL",
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (body == 'false') {
        return false;
      } else if (body == 'ja_tem') {
        return false;
      } else {
        return true;
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
  Future<bool> deletePost(String idPost) async {
    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/deletePost=$idPost",
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (body == 'false') {
        return false;
      } else if (body == 'ja_tem') {
        return false;
      } else {
        return true;
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

      if (body == 'false') {
        return false;
      } else {
        return true;
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
  Future<List<SVCommentModel>> getComentarioPost(
      String uid, String idPost) async {
    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/getComentarios.php?uid=$uid&idPost=$idPost",
    );

    if (response.statusCode == 200) {
      List<SVCommentModel> comentarios = [];
      var body = jsonDecode(response.body);

      if (body == 'Database erro') {
      } else {
        int i = 0;

        for (var v in body['dados_comentarios']) {
          int idComentario = int.parse(v['id'].toString());
          String uidUser = v['idUsuario'];
          String dataTime = v['data'];
          String comentario = v['comentario'];

          int totalComentario =
              int.parse(body['total_comentarios'][i].toString());
          bool checkUserLike = totalComentario == 0
              ? false
              : bool.parse(body['check_like_comentario'][i].toString());

          bool checkUserComentou = totalComentario == 0
              ? false
              : bool.parse(body['check_user_comentou'][i].toString());

          List<Usuario> usuarioQComentou = [];

          int totalLike =
              int.parse(body['total_likes_comentarios'][i].toString());

          final response2 = await client.get(
            url:
                "https://campbrasil.com/tuddo_gramado/php/getUsuarioUID.php?uid=${uidUser.toString()}",
          );
          var bodys = jsonDecode(response2.body);

          if (bodys == 'Database erro') {
          } else {
            bodys.map((usuario) {
              Usuario userConvertido = Usuario.fromMap(usuario);
              usuarioQComentou.add(userConvertido);
            }).toList();
          }

          SVCommentModel comentarioBD = SVCommentModel(
            id: idComentario,
            idPost: int.parse(idPost),
            uid: uidUser,
            name: usuarioQComentou[0].nome,
            profileImage: usuarioQComentou[0].photo,
            time: dataTime,
            comment: comentario,
            like: checkUserLike,
            likeCount: totalLike,
            isCommentReply: checkUserComentou,
          );

          i = i + 1;
          comentarios.add(comentarioBD);
        }
      }
      return comentarios;
    } else if (response.statusCode == 404) {
      debugPrint('erro 404');
      throw NotFoundException("A url informada não é válida.");
    } else {
      debugPrint('outro erro');
      throw Exception("Não foi possível carregar os post.");
    }
  }

  @override
  Future<bool> addComentario(
      Usuario usuario, String comentario, String idPost) async {
    String uid = usuario.uid;

    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/addComentario.php?uid=$uid&comentario=$comentario&idPost=$idPost",
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (body == 'false') {
        return false;
      } else if (body == 'ja_tem') {
        return false;
      } else {
        return true;
      }
    } else if (response.statusCode == 404) {
      debugPrint('erro 404');
      throw NotFoundException("A url informada não é válida.");
    } else {
      debugPrint('outro erro');
      throw Exception("Não foi possível adicionar o comentário.");
    }
  }

  @override
  Future<bool> addLikeComentario(String uid, String idComentario) async {
    debugPrint('id comentário - $idComentario');
    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/addLikeComentario.php?uid=$uid&idComentario=$idComentario",
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (body == 'false') {
        return false;
      } else {
        return true;
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
