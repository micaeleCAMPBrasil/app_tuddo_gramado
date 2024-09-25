// ignore_for_file: file_names, use_build_context_synchronously

import 'package:app_tuddo_gramado/data/models/SVCommentModel.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class SVCommentComponent extends StatefulWidget {
  bool check;
  final SVCommentModel comment;

  SVCommentComponent({super.key, required this.comment, required this.check});

  @override
  State<SVCommentComponent> createState() => _SVCommentComponentState();
}

class _SVCommentComponentState extends State<SVCommentComponent> {
  final PublicacaoStore storePost = PublicacaoStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  final UsuarioStore storeUsuario = UsuarioStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  Future<Usuario> gerarUsuario(String uid) async {
    await storeUsuario.getUID(uid);
    return storeUsuario.state.value;
  }

  @override
  Widget build(BuildContext context) {
    bool checksize = MediaQuery.of(context).size.width <= 320 ||
            MediaQuery.of(context).size.height <= 320
        ? true
        : false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
              future: gerarUsuario(widget.comment.uid),
              builder: (context, dadosUsuario) {
                Usuario? usuarioQPublicou = dadosUsuario.data;
                if (dadosUsuario.hasData) {
                  return Row(
                    children: [
                      usuarioQPublicou!.photo == ''
                          ? Image.asset(
                              'assets/image/nopicture.png',
                              height: 56,
                              width: 56,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(12)
                          : Image(
                              image: CachedNetworkImageProvider(
                                usuarioQPublicou.photo.validate(),
                              ),
                              height: 56,
                              width: 56,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).cornerRadiusWithClipRRect(
                              12) /*Image.network(
                              usuarioQPublicou.photo.validate(),
                              height: 56,
                              width: 56,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(12)*/
                      ,
                      widthSpace15,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                formatarNome(usuarioQPublicou.nome.validate()),
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
                          Text(
                            widget.comment.time.validate(),
                            style: color94SemiBold16,
                          ),
                        ],
                      ),
                      widthSpace20,
                      widget.check
                          ? GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: color94,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: color28,
                                    title: Text(
                                      'Apagar Comentário',
                                      style: whiteBold16,
                                    ),
                                    content: Text(
                                      'Você tem certeza que quer apagar esse comentário?',
                                      style: whiteRegular16,
                                    ),
                                    actions: [
                                      // Cancel button
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Voltar',
                                          style: whiteBold16,
                                        ),
                                      ),
                                      // Delete button
                                      TextButton(
                                        onPressed: () async {
                                          await storePost.deleteComentario(
                                            widget.comment.idPost,
                                            widget.comment.id,
                                          );

                                          storePost.fecharModal(context);
                                        },
                                        child: Text(
                                          'Sim',
                                          style: whiteBold16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container()
                    ],
                  );
                } else if (dadosUsuario.hasError) {
                  return Center(
                    child: Text('Error: ${dadosUsuario.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
        heightSpace15,
        Text(
          widget.comment.comment.validate(),
          style: color94SemiBold16,
        ),
        heightSpace15,
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: radius(4),
                color: primaryColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.comment.like.validate()
                      ? Image.asset(
                          'assets/social/ic_HeartFilled.png',
                          height: 14,
                          width: 14,
                          fit: BoxFit.fill,
                          color: Colors.black,
                        )
                      : Image.asset(
                          'assets/social/ic_Heart.png',
                          height: 14,
                          width: 14,
                          fit: BoxFit.cover,
                          color: Colors.black,
                        ),
                  3.width,
                  Text(
                    widget.comment.likeCount.toString(),
                    style: blackRegular12,
                  ),
                ],
              ),
            ).onTap(() async {
              setState(() {
                widget.comment.like = !widget.comment.like.validate();
              });
              String idComentario = widget.comment.id.toString();
              bool idLiked = widget.comment.like ?? false;

              await storePost.addLikeComentario(idLiked, widget.comment.uid,
                  widget.comment.idPost, idComentario);
            }, borderRadius: radius(4)),
          ],
        )
      ],
    ).paddingOnly(
      top: 16,
      left: widget.comment.isCommentReply.validate()
          ? checksize
              ? 40
              : 70
          : 16,
      right: 16,
      bottom: 16,
    );
  }
}
