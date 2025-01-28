// ignore_for_file: file_names, deprecated_member_use

import 'dart:async';

import 'package:app_tuddo_gramado/data/models/SVCommentModel.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVCommentComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVCommentReplyComponent.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SVCommentScreen extends StatefulWidget {
  String idPost;
  Usuario usuario;
  SVCommentScreen({super.key, required this.usuario, required this.idPost});

  @override
  State<SVCommentScreen> createState() => _SVCommentScreenState();
}

class _SVCommentScreenState extends State<SVCommentScreen> {
  final PublicacaoStore storePost = PublicacaoStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );
  List<SVCommentModel> commentList = [];

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
  }

  checkComentario() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      //await storePost.check();

      /*if (mounted) {
        setState(() {
          checkNovo = storePost.temNovo.value;
        });
      }*/

      //if (checkNovo) {
      getListsData();
      //}
    });
  }

  getListsData() async {
    /*await storePost.getComentarios(widget.usuario.uid, widget.idPost);
    if (mounted) {
      setState(() {
        commentList = storePost.comentarios.value;
      });
    }*/
    //pause ? null : checkUserName();
  }

  @override
  void dispose() {
    setStatusBarColor(scaffoldColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: color00,
        iconTheme: IconThemeData(color: color94),
        title: Text(
          'Comentários',
          style: whiteBold18,
        ),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Provider.of<ControlNav>(context, listen: false).updateIndex(3, 0);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Post")
                  .doc(widget.idPost)
                  .collection("Comments")
                  .orderBy('TimeStamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final comentarios = snapshot.data!.docs[index];

                      String uidUser = comentarios['idUsuario'];
                      String idPulicacao = comentarios['idPulicacao'];

                      if (idPulicacao == widget.idPost) {
                        List<String> listUIDUser = List<String>.from(comentarios['likes'] ?? []);

                        bool isLiked = listUIDUser.contains(widget.usuario.uid);

                        SVCommentModel e = SVCommentModel(
                          id: comentarios.id,
                          idPost: widget.idPost,
                          uid: uidUser,
                          time: comentarios['data'],
                          comment: comentarios['comentario'],
                          like: isLiked,
                          likeCount: listUIDUser.length,
                          isCommentReply: widget.usuario.uid == uidUser ? true : false,
                        );

                        return SVCommentComponent(
                          comment: e,
                          check: uidUser == widget.usuario.uid ? true : false,
                        );
                      } else {
                        return heightSpace5;
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          SVCommentReplyComponent(
            usuario: widget.usuario,
            idPost: widget.idPost,
          ),
        ],
      ),
    );
  }
}
