// ignore_for_file: file_names

import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class SVCommentReplyComponent extends StatefulWidget {
  String idPost;
  Usuario usuario;

  SVCommentReplyComponent(
      {super.key, required this.usuario, required this.idPost});

  @override
  State<SVCommentReplyComponent> createState() =>
      _SVCommentReplyComponentState();
}

class _SVCommentReplyComponentState extends State<SVCommentReplyComponent> {
  final PublicacaoStore storePost = PublicacaoStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  GlobalKey<FormState> mykey = GlobalKey<FormState>();
  final TextEditingController _comentariosTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool checksize = MediaQuery.of(context).size.width <= 320 ||
            MediaQuery.of(context).size.height <= 320
        ? true
        : false;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom),
      color: scaffoldColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Divider(indent: 16, endIndent: 16, height: 20),
          Row(
            children: [
              16.width,
              widget.usuario.photo == ''
                  ? Image.asset(
                      'assets/image/nopicture.png',
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRect(8)
                  : Image(
                      image: CachedNetworkImageProvider(
                        widget.usuario.photo.validate(),
                      ),
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
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
                    ).cornerRadiusWithClipRRect(8),
              /*Image.network(
                      widget.usuario.photo.validate(),
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRect(8),*/
              10.width,
              SizedBox(
                width:
                    checksize ? context.width() * 0.5 : context.width() * 0.6,
                child: AppTextField(
                  textFieldType: TextFieldType.OTHER,
                  textStyle: whiteRegular12,
                  controller: _comentariosTextController,
                  decoration: InputDecoration(
                    hintText: 'Escreva um comentário...',
                    hintStyle: whiteRegular12,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('dd/MM/yyyy').format(now);
                  String formattedTime = DateFormat('kk:mm').format(now);

                  FirebaseFirestore.instance
                      .collection("User Post")
                      .doc(widget.idPost)
                      .collection("Comments")
                      .add({
                    'idUsuario': widget.usuario.uid,
                    'idPulicacao': widget.idPost,
                    'comentario': _comentariosTextController.text,
                    'TimeStamp': Timestamp.now(),
                    'data': formattedDate,
                    'time': formattedTime,
                    'likes': [],
                  });

                  DocumentReference postRef = FirebaseFirestore.instance
                      .collection('User Post')
                      .doc(widget.idPost);
                  DocumentSnapshot snapshot = await postRef.get();
                  final data = snapshot.data() as Map<String, dynamic>;

                  int totalComentario =
                      int.parse(data['totalComentario'].toString());

                  postRef.update({
                    'totalComentario': totalComentario + 1,
                  });

                  _comentariosTextController.clear();

                  /*await storePost.addComentario(
                    widget.usuario,
                    _comentariosTextController.text,
                    widget.idPost,
                  );*/

                  /*Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SVHomeFragment(),
                    ),
                  );*/
                },
                child: Text(
                  'Enviar',
                  style: whiteRegular12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
