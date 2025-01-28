import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constant.dart';

class PostBottomComments extends StatelessWidget {
  final bool isSmallScreen;
  final Usuario usuario;
  final List<String> listUIDUser;
  final PublicacaoStore storePost;

  const PostBottomComments({
    super.key,
    required this.isSmallScreen,
    required this.usuario,
    required this.listUIDUser,
    required this.storePost,
  });

  @override
  Widget build(BuildContext context) {
    if (listUIDUser.isEmpty) {
      return heightSpace10;
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Divider(indent: 16, endIndent: 16, height: 20),
          FutureBuilder(
            future: storePost.getListUsersLikes(listUIDUser, usuario.uid),
            builder: (context, listUsersQCurte) {
              if (listUsersQCurte.hasData) {
                final userdata = listUsersQCurte.data ?? [];
                int total = userdata.length;
                if (total == 0) {
                  return heightSpace5;
                } else if (total == 1) {
                  return PostBottomOneComment(usuario: usuario, userdata: userdata);
                } else if (total == 2) {
                  return PostBottomTwoComment(usuario: usuario, userdata: userdata, isSmallScreen: isSmallScreen);
                } else if (total == 3) {
                  return PostBottomThreeComment(userdata: userdata, isSmallScreen: isSmallScreen, usuario: usuario);
                } else {
                  return PostBottomManyComment(
                      userdata: userdata, isSmallScreen: isSmallScreen, usuario: usuario, total: total);
                }
              } else {
                return heightSpace5;
              }
            },
          )
        ],
      ),
    );
  }
}

class _PostBottomPicture extends StatelessWidget {
  final Usuario usuario;

  _PostBottomPicture({
    required this.usuario,
  }) : super(key: Key('_PostBottomPicture_${usuario.uid}_${usuario.photo}'));

  @override
  Widget build(BuildContext context) {
    if (usuario.photo != '' || usuario.photo != 'https://tuddo.org/') {
      return CachedNetworkImage(
        imageUrl: usuario.photo,
        height: 24,
        width: 24,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Image.asset(
            'assets/image/nopicture.png',
            height: 24,
            width: 24,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(100);
        },
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey[400],
            ),
          );
        },
      ).cornerRadiusWithClipRRect(100);
    } else {
      return Image.asset(
        'assets/image/nopicture.png',
        height: 24,
        width: 24,
        fit: BoxFit.cover,
      ).cornerRadiusWithClipRRect(100);
    }
  }
}

class PostBottomOneComment extends StatelessWidget {
  final Usuario usuario;
  final List<Usuario> userdata;

  const PostBottomOneComment({
    super.key,
    required this.usuario,
    required this.userdata,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widthSpace20,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: radius(100),
          ),
          child: _PostBottomPicture(usuario: userdata[0]),
        ),
        widthSpace10,
        RichText(
          text: TextSpan(
            text: 'Curtido por ',
            style: whiteMedium14,
            children: <TextSpan>[
              TextSpan(
                text: userdata[0].nome == usuario.nome ? 'você' : formatarNome(userdata[0].nome),
                style: whiteMedium14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PostBottomTwoComment extends StatelessWidget {
  final Usuario usuario;
  final List<Usuario> userdata;
  final bool isSmallScreen;

  const PostBottomTwoComment({
    super.key,
    required this.usuario,
    required this.userdata,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 56,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: radius(100),
                  ),
                  child: _PostBottomPicture(usuario: userdata[0]),
                ),
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: radius(100),
                  ),
                  child: _PostBottomPicture(usuario: userdata[1]),
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Curtido por ',
            style: isSmallScreen ? whiteMedium12 : whiteMedium14,
            children: <TextSpan>[
              TextSpan(
                text: userdata[0].nome == usuario.nome
                    ? userdata[1].nome == usuario.nome
                        ? ''
                        : formatarNome(userdata[1].nome)
                    : formatarNome(userdata[0].nome),
                style: isSmallScreen ? whiteMedium12 : whiteMedium14,
              ),
              TextSpan(
                text: ' e ',
                style: isSmallScreen ? whiteMedium12 : whiteMedium14,
              ),
              TextSpan(
                text: '1 Outro',
                style: isSmallScreen ? whiteMedium12 : whiteMedium14,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PostBottomThreeComment extends StatelessWidget {
  const PostBottomThreeComment({
    super.key,
    required this.userdata,
    required this.isSmallScreen,
    required this.usuario,
  });

  final List<Usuario> userdata;
  final bool isSmallScreen;
  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 56,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: radius(100),
                  ),
                  child: _PostBottomPicture(usuario: userdata[0]),
                ),
              ),
              Positioned(
                left: 14,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: radius(100),
                  ),
                  child: _PostBottomPicture(usuario: userdata[1]),
                ),
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: radius(100),
                  ),
                  child: _PostBottomPicture(usuario: userdata[2]),
                ),
              ),
            ],
          ),
        ),
        widthSpace10,
        RichText(
          text: TextSpan(
            text: 'Curtido por ',
            style: isSmallScreen ? whiteMedium12 : whiteMedium14,
            children: <TextSpan>[
              TextSpan(
                text: userdata[0].nome == usuario.nome
                    ? userdata[1].nome == usuario.nome
                        ? userdata[2].nome == usuario.nome
                            ? ''
                            : formatarNome(userdata[2].nome)
                        : formatarNome(userdata[1].nome)
                    : formatarNome(userdata[0].nome),
                style: isSmallScreen ? whiteMedium12 : whiteMedium14,
              ),
              TextSpan(
                text: ' e ',
                style: isSmallScreen ? whiteMedium12 : whiteMedium14,
              ),
              TextSpan(
                text: '2 Outros ',
                style: isSmallScreen ? whiteMedium12 : whiteMedium14,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PostBottomManyComment extends StatelessWidget {
  const PostBottomManyComment({
    super.key,
    required this.userdata,
    required this.isSmallScreen,
    required this.usuario,
    required this.total,
  });

  final List<Usuario> userdata;
  final bool isSmallScreen;
  final Usuario usuario;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 56,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: radius(100),
                  ),
                  child: _PostBottomPicture(usuario: userdata[0]),
                ),
              ),
              Positioned(
                left: 14,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: radius(100),
                  ),
                  child: _PostBottomPicture(usuario: userdata[1]),
                ),
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: radius(100),
                  ),
                  child: _PostBottomPicture(usuario: userdata[2]),
                ),
              ),
            ],
          ),
        ),
        widthSpace10,
        RichText(
          text: TextSpan(
            text: 'Curtido por ',
            style: isSmallScreen ? whiteMedium12 : whiteMedium14,
            children: <TextSpan>[
              TextSpan(
                text: userdata[0].nome == usuario.nome
                    ? userdata[1].nome == usuario.nome
                        ? userdata[2].nome == usuario.nome
                            ? ''
                            : formatarNome(
                                userdata[2].nome,
                              )
                        : formatarNome(userdata[1].nome)
                    : formatarNome(
                        userdata[0].nome,
                      ),
                style: isSmallScreen ? whiteMedium12 : whiteMedium14,
              ),
              TextSpan(
                text: ' e ',
                style: isSmallScreen ? whiteMedium12 : whiteMedium14,
              ),
              TextSpan(
                text: '${total - 1} Outros ',
                style: isSmallScreen ? whiteMedium12 : whiteMedium14,
              ),
            ],
          ),
        )
      ],
    );
  }
}
