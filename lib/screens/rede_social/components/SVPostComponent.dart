// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';

import 'package:app_tuddo_gramado/screens/rede_social/widgets/post_body.dart';
import 'package:app_tuddo_gramado/screens/rede_social/widgets/post_bottom.dart';
import 'package:app_tuddo_gramado/screens/rede_social/widgets/post_bottom_comments.dart';
import 'package:app_tuddo_gramado/screens/rede_social/widgets/post_header.dart';
import 'package:http/http.dart' as http;

import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/post_card.dart';

// ignore: must_be_immutable
class SVPostComponent extends StatefulWidget {
  Usuario usuario;
  SVPostComponent({super.key, required this.usuario});

  @override
  State<SVPostComponent> createState() => _SVPostComponentState();
}

class _SVPostComponentState extends State<SVPostComponent> {
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

  List<SVPostModel> postList = [];

  @override
  void initState() {
    super.initState();
  }

  bool checkNovo = false;

  checkPost() {
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
    /*await storePost.getAllPost(widget.usuario.uid, '');
    if (mounted) {
      setState(() {
        postList = storePost.list.value;
      });
    }*/
    //pause ? null : checkUserName();
  }

  Future<Usuario> gerarUsuario(String uid) async {
    await storeUsuario.getUID(uid);
    return storeUsuario.state.value;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void shareMensagem(String imageURL, String nome, String texto) async {
    final url = Uri.parse(imageURL);
    final response = await http.get(url);
    Share.shareXFiles(
      [
        XFile.fromData(response.bodyBytes, name: 'Imagem de $nome', mimeType: 'image/png'),
      ],
      subject: 'Publicação de $nome',
      text: texto,
    );
  }

  Future<void> onLikeButton(String postId, bool isLiked) async {
    setState(() {
      isLiked = !isLiked;
    });
    await storePost.addLike(isLiked, widget.usuario.uid, postId);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    bool isSmallScreen = mediaQuery.width <= 320 || mediaQuery.height <= 320;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('User Post').orderBy('TimeStamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.docs[index];

              List<String> listUIDUser = List<String>.from(post['likes'] ?? []);
              bool isLiked = listUIDUser.contains(widget.usuario.uid);
              String? nomeUsuarioQPublicou = '';

              return PostCard(
                onDoubleTap: () => onLikeButton(post.id, isLiked),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostHeader(
                      storeUsuario: storeUsuario,
                      storePost: storePost,
                      usuario: widget.usuario,
                      isSmallScree: isSmallScreen,
                      post: post,
                    ),
                    heightSpace15,
                    PostBody(post: post),
                    PostBottom(
                      isLiked: isLiked,
                      usuario: widget.usuario,
                      storePost: storePost,
                      post: post,
                      onPressLikeButton: () => onLikeButton(post.id, isLiked),
                      onShareMessage: () => shareMensagem(
                        post['postImage'],
                        nomeUsuarioQPublicou,
                        post['description'],
                      ),
                    ),
                    PostBottomComments(
                      isSmallScreen: isSmallScreen,
                      usuario: widget.usuario,
                      listUIDUser: listUIDUser,
                      storePost: storePost,
                    ),
                  ],
                ),
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
    );
  }
}
