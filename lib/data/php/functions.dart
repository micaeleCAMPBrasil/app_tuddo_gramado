import 'dart:convert';
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/exceptions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';

abstract class IFuncoes {
  Future<List<Usuario>> getAllUsuario();
  Future<Usuario> getUsuarioUID(String uid);
  Future<bool> updateUser(Usuario usuario);
  Future<bool> updateToken(String uid, String token1, String token2);

  Future<List<Patrocinadores>> getListPatrocinadores();

  Future<List<Usuario>> getListUsersLikes(List<String> uidUsers, String uid);
  //Future<List<SVPostModel>> getListAllPost(String uid, String idPost);
  //Future<bool> addPost(Usuario usuario, String description, String imageUrl);
  //Future<bool> addLike(String uid, String idPost);
  //Future<List<SVCommentModel>> getComentarioPost(String uid, String idPost);
  //Future<bool> addLikeComentario(String uid, String idComentario);
  //Future<bool> addComentario(Usuario usuario, String comentario, String idPost);

  //Future<bool> deleteComentario(String idComentario);
  //Future<bool> deletePost(String idPost);
}

class IFuncoesPHP implements IFuncoes {
  final IHttpClient client;

  IFuncoesPHP({required this.client});

  @override
  Future<List<Patrocinadores>> getListPatrocinadores() async {
    /*final response = await client.get(
      url: "https://tuddogramado.com.br/api/get_patrocinadores.php",
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body == '') {
      } else {
        body.map((patrocinadores) {
          debugPrint('Patrocinadores Web - $patrocinadores');
        }).toList();
      }
    }*/

    String link = "http://184.72.72.250/imagens/patrocinadores/";

    List<Patrocinadores> getPatrocinadores = [
      Patrocinadores(
        id: 1,
        idCategoria: 3,
        nome: 'Space Adventure',
        logo: '${link}p1/space%20adventure%20foto%20principal.png',
        imagemBG: '${link}p1/space%20adventure%20-%20slide%201.png',
        descricao:
            'Uma exposição inédita com itens de missões da NASA jamais exibidos fora dos Estados Unidos. Com mais de 270 itens ORIGINAIS de missões da NASA, experiências imersivas e diversas atrações. \n Venha viver uma experiência única! \n Adquira seu ingresso antecipadamente! \n ⏰ De Seg a Ter: das 9h às 18h. Entrada até 16h \n ⏰Sexta a Dom: das 9h às 19h \n Entrada até 17h',
        isFavorite: false,
        isBannerInicial: true,
        isMostrarSite: true,
        linkWebSite: 'http://www.spaceadventure.com.br',
        galeria: [
          GaleriaPatrocinador(
            idPatrocinador: 1,
            img: '${link}p1/space%20adventure%20foto1.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 1,
            img: '${link}p1/space%20adventure%20foto2.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 1,
            img: '${link}p1/space%20adventure%20foto3.png',
          ),
        ],
      ),
      Patrocinadores(
        id: 2,
        idCategoria: 8,
        nome: 'Gatzz',
        logo: '${link}p2/gatzz%20principal.png',
        imagemBG: '${link}p2/Gatzz%20Slide%202.png',
        descricao:
            'Um pedacinho da Broadway em Gramado-RS \n ✨Bellepoque \n 🔞Dezoito + \n 🎈Imaginadores \n Reservas no site ⬇ ou Bilheteria a partir das 14h',
        isFavorite: false,
        isBannerInicial: true,
        isMostrarSite: true,
        linkWebSite: 'http://gatzz.com',
        galeria: [
          GaleriaPatrocinador(
            idPatrocinador: 2,
            img: '${link}p2/gatzz%20foto1.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 2,
            img: '${link}p2/gatzz%20foto%202.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 2,
            img: '${link}p2/gatzz%20foto3.png',
          ),
        ],
      ),
      /*Patrocinadores(
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
      ),*/
      Patrocinadores(
        id: 4,
        idCategoria: 0,
        nome: 'Faça Parte!',
        logo: '${link}principal%20exemplo.png',
        imagemBG: '${link}slide%204%20marca%20.png',
        descricao:
            'Você já parou para pensar no impacto que a presença da sua marca nos principais meios de publicidade pode ter? 💡 É a oportunidade de alcançar um público certo, construir reconhecimento e estabelecer sua marca como referência no mercado. 💼✨ Não fique de fora dessa oportunidade! Seja visto, seja lembrado. 🚀 Adquira sua cota anual hoje mesmo e faça parte do grupo seleto de empresas visionárias que vão levar a marca ao próximo nível!',
        isFavorite: false,
        isMostrarSite: false,
        isBannerInicial: true,
        galeria: [],
      ),
      Patrocinadores(
        id: 5,
        idCategoria: 0,
        nome: 'Faça Parte!',
        logo: '${link}foto2%20exemplo.png',
        imagemBG: '${link}slide%204%20marca%20.png',
        descricao:
            'Você já parou para pensar no impacto que a presença da sua marca nos principais meios de publicidade pode ter? 💡 É a oportunidade de alcançar um público certo, construir reconhecimento e estabelecer sua marca como referência no mercado. 💼✨ Não fique de fora dessa oportunidade! Seja visto, seja lembrado. 🚀 Adquira sua cota anual hoje mesmo e faça parte do grupo seleto de empresas visionárias que vão levar a marca ao próximo nível!',
        isFavorite: true,
        isBannerInicial: false,
        isMostrarSite: false,
        galeria: [],
      ),
      Patrocinadores(
        id: 6,
        idCategoria: 0,
        nome: 'Faça Parte!',
        logo: '${link}foto3%20exemplo.png',
        imagemBG: '${link}slide%204%20marca%20.png',
        descricao:
            'Você já parou para pensar no impacto que a presença da sua marca nos principais meios de publicidade pode ter? 💡 É a oportunidade de alcançar um público certo, construir reconhecimento e estabelecer sua marca como referência no mercado. 💼✨ Não fique de fora dessa oportunidade! Seja visto, seja lembrado. 🚀 Adquira sua cota anual hoje mesmo e faça parte do grupo seleto de empresas visionárias que vão levar a marca ao próximo nível!',
        isFavorite: false,
        isBannerInicial: false,
        isMostrarSite: false,
        galeria: [],
      ),
      Patrocinadores(
        id: 7,
        idCategoria: 2,
        nome: 'GAV Resorts',
        logo: '${link}p5%20-%20hector/slides%20principal%20hector%20tuddo.png',
        imagemBG: '${link}slides%20master%20tuddo%20GAV.png',
        descricao:
            'A GAV Resorts é líder e pioneira na construção, incorporação imobiliária e multipropriedade do Norte do país. Sua história nasce da união de três importantes empresas do segmento, com mais de 20 anos de experiência: a Gratão Empreendimentos, a Amec Construtora e a Vallepar Empreendimentos.',
        isFavorite: false,
        isBannerInicial: true,
        isMostrarSite: true,
        linkWebSite: 'https://gavresorts.com.br/',
        //linkWebSite: 'https://d.tuddogramado.com.br/formulario-gav-resorts/',
        galeria: [
          GaleriaPatrocinador(
            idPatrocinador: 7,
            img: '${link}p4%20-%20gav/slides%20pequenos%20gav%201.png',
            link: 'https://d.tuddogramado.com.br/formulario-gav-resorts/',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 7,
            img: '${link}p4%20-%20gav/slides%20pequenos%20gav%202.png',
            link: 'https://d.tuddogramado.com.br/formulario-gav-resorts/',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 7,
            img: '${link}p4%20-%20gav/slides%20pequenos%20gav%203.png',
            link: 'https://d.tuddogramado.com.br/formulario-gav-resorts/',
          ),
        ],
      ),
      Patrocinadores(
        id: 8,
        idCategoria: 1,
        nome: 'Hector',
        logo: '${link}p5%20-%20hector/slides%20principal%20hector%20.png',
        imagemBG: '${link}slides%20master%20tuddo%20hector.png',
        descricao:
            'Era uma vez um pequeno dragão chamado Hector. Ele morava na ilha de Trélion, lar dos dragões azuis, e lá sonhava em conhecer o mundo e tudo que nele há. As histórias contadas por sua avó despertaram nele uma vontade tão grande que o dragãozinho resolveu sair de sua ilha escondido e iniciar uma aventura. Em seu primeiro contato com a terra de Megáligi, Hector foi atacado por um terrível ser mágico – uma criatura das sombras – capaz de roubar os dons mágicos de suas vítimas. Ele teria perdido sua vida se não fosse socorrido por três misteriosos e poderosos magos. Quando despertou do ataque, à beira de uma reconfortante fogueira, ele foi apresentado à um deles: professor Stan. O professor contou ao pequeno sobre uma escola de magia onde ele leciona, lugar em que Hector poderia tentar recuperar o seu poder mágico roubado. Ele falou de Ônyra, a escola que promove o bom uso da magia e o ensino da vida em harmonia com todas as criaturas. Hector parte então para encontrar esse lugar mágico e viver grandes aventuras.',
        isFavorite: false,
        isBannerInicial: true,
        isMostrarSite: false,
        linkWebSite:
            'https://hectorexperience.com.br/?origin=MB1-P6-89300-KEYLA',
        galeria: [
          GaleriaPatrocinador(
            idPatrocinador: 8,
            img: '${link}p5%20-%20hector/slides%20pequenos%20hector%201.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 8,
            img: '${link}p5%20-%20hector/slides%20pequenos%20hector%202.png',
          ),
          GaleriaPatrocinador(
            idPatrocinador: 8,
            img: '${link}p5%20-%20hector/slides%20pequenos%20hector%203.png',
          ),
        ],
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
  Future<bool> updateToken(String uid, String token1, String token2) async {

    debugPrint('atualizando token server');
    
    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/update_token.php?uid=$uid&token_1=$token1&token_2=$token2",
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

      debugPrint('body $body');

      if (body == 'dados_vazios') {
        usuarioFinal = Usuario(
          uid: '',
          tokenAlert: '',
          tokenTG: '',
          tokenTD: '',
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
          tokenTG: '',
          tokenTD: '',
          nome: '',
          username: '',
          email: '',
          telefone: '',
          photo: '',
          data: '',
        );
      } else {
        body.map((users) {
          /*debugPrint('user $users');

          usuarioFinal = Usuario(
            uid: users['uid'],
            tokenAlert: users['token_alert'],
            token: '',
            nome: users['name'],
            username: users['username'],
            email: users['uid'],
            telefone: users['uid'],
            photo: users['uid'],
            data: users['uid'],
          );*/
          Usuario userConvertido = Usuario.fromMap(users);
          usuarioFinal = userConvertido;
        }).toList();
      }

      debugPrint('usuario final ${usuarioFinal.nome}');
      return usuarioFinal;
    } else if (response.statusCode == 404) {
      throw NotFoundException("A url informada não é válida.");
    } else {
      throw Exception("Não foi possível carregar os usuários.");
    }
  }

  /*@override
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
          String idPub = v['id'].toString();
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
  }*/

  @override
  Future<List<Usuario>> getListUsersLikes(
      List<String> uidUsers, String uid) async {
    List<Usuario> users = [];

    for (var element in uidUsers) {
      final response = await client.get(
        url:
            "https://campbrasil.com/tuddo_gramado/php/getUsuarioUID.php?uid=$element",
      );

      if (response.statusCode == 200) {
        var bodys = jsonDecode(response.body);

        if (bodys == 'Database erro') {
        } else {
          bodys.map((usuario) {
            Usuario userConvertido = Usuario.fromMap(usuario);

            /*if (userConvertido.uid == uid) {
            } else {*/
            users.add(userConvertido);
            //}
          }).toList();
        }
      } else if (response.statusCode == 404) {
        debugPrint('erro 404');
        throw NotFoundException("A url informada não é válida.");
      } else {
        debugPrint('outro erro');
        throw Exception("Não foi possível carregar os post.");
      }
    }
    return users;
  }

  /*@override
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
  }*/

  /*@override
  Future<bool> deletePost(String idPost) async {
    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/deletePost.php?idPost=$idPost",
    );
    debugPrint('chamando a função - $idPost');

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
  }*/

  /*@override
  Future<bool> deleteComentario(String idComentario) async {
    final response = await client.get(
      url:
          "https://campbrasil.com/tuddo_gramado/php/posts/deleteComentario.php?idComentario=$idComentario",
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
  }*/

  /*@override
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
  }*/

  /*@override
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
          String idComentario = v['id'].toString();
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
            idPost: idPost,
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
  }*/

  /*@override
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
  }*/

  /*@override
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
  }*/
}
