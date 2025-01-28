import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../data/stores/publicacao_store.dart';

class PostBottom extends StatelessWidget {
  final bool isLiked;
  final Usuario usuario;
  final PublicacaoStore storePost;
  final QueryDocumentSnapshot<Map<String, dynamic>> post;
  final VoidCallback onPressLikeButton;
  final VoidCallback onShareMessage;

  const PostBottom({
    super.key,
    required this.isLiked,
    required this.usuario,
    required this.storePost,
    required this.post,
    required this.onPressLikeButton,
    required this.onShareMessage,
  });

  void onCommentButton(BuildContext context) {
    Provider.of<ControlNav>(context, listen: false).updateidpost(post.id.toString());

    Provider.of<ControlNav>(context, listen: false).updateIndex(3, 2);
    /*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SVCommentScreen(
                                      usuario: widget.usuario,
                                      idPost: post.id.toString(),
                                    ),
                                  ),
                                );*/
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: isLiked
                  ? Image.asset(
                      'assets/social/ic_HeartFilled.png',
                      height: 20,
                      width: 22,
                      fit: BoxFit.fill,
                      color: primaryColor,
                    )
                  : Image.asset(
                      'assets/social/ic_Heart.png',
                      height: 22,
                      width: 22,
                      fit: BoxFit.cover,
                      color: color94,
                    ),
              onPressed: onPressLikeButton,
            ),
            GestureDetector(
              onTap: () => onCommentButton(context),
              child: Image.asset(
                'assets/social/ic_Chat.png',
                height: 22,
                width: 22,
                fit: BoxFit.cover,
                color: color94,
              ),
            ),
            widthSpace10,
            GestureDetector(
              onTap: onShareMessage,
              child: Image.asset(
                'assets/social/ic_Send.png',
                height: 22,
                width: 22,
                fit: BoxFit.cover,
                color: color94,
              ),
            ),
          ],
        ),
        Text(
          '${post['totalComentario'] ?? 0} comentários',
          style: whiteMedium14,
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
