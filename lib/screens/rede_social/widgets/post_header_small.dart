import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/screens/rede_social/widgets/post_header_user_control.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'post_header_profile_picture.dart';

class PostHeaderSmall extends StatelessWidget {
  final Usuario usuario;
  final Usuario usuarioQPublicou;
  final PublicacaoStore storePost;
  final QueryDocumentSnapshot<Map<String, dynamic>> post;

  const PostHeaderSmall({
    super.key,
    required this.usuario,
    required this.usuarioQPublicou,
    required this.storePost,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              PostHeaderProfilePicture(usuarioQPublicou: usuarioQPublicou),
              widthSpace10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        formatarNome(usuarioQPublicou.nome),
                        style: whiteSemiBold18,
                      ),
                      Image.asset(
                        'assets/social/ic_TickSquare.png',
                        height: 14,
                        width: 14,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  heightSpace2,
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Text(
                      post['data'],
                      style: color94SemiBold16,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        if (usuarioQPublicou.uid == usuario.uid)
          PostHeaderControl(usuarioQPublicou: usuarioQPublicou, storePost: storePost, post: post),
      ],
    );
  }
}
