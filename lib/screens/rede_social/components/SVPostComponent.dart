// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';

import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
        XFile.fromData(response.bodyBytes,
            name: 'Imagem de $nome', mimeType: 'image/png'),
      ],
      subject: 'Publicação de $nome',
      text: texto,
    );
  }

  alterar(bool fecharModal) {
    debugPrint("fechar modal $fecharModal");

    if (fecharModal) {
      storePost.fecharModal(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool checksize = MediaQuery.of(context).size.width <= 320 ||
            MediaQuery.of(context).size.height <= 320
        ? true
        : false;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('User Post')
          .orderBy('TimeStamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.docs[index];

              List<String> listUIDUser = List<String>.from(post['likes'] ?? []);

              bool isLiked = listUIDUser.contains(widget.usuario.uid);

              String? nomeUsuarioQPublicou = '';

              return GestureDetector(
                onDoubleTap: () async {
                  setState(() {
                    isLiked = !isLiked;
                  });
                  await storePost.addLike(isLiked, widget.usuario.uid, post.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: radius(12),
                    color: color00,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: gerarUsuario(post['idUsuario']),
                        builder: (context, dadosUsuario) {
                          Usuario? usuarioQPublicou = dadosUsuario.data;
                          if (dadosUsuario.hasData) {
                            nomeUsuarioQPublicou = usuarioQPublicou!.nome;
                            return checksize
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            usuarioQPublicou.photo == '' ||
                                                    usuarioQPublicou.photo ==
                                                        'https://tuddo.org/'
                                                ? Image.asset(
                                                    'assets/image/nopicture.png',
                                                    height: 56,
                                                    width: 56,
                                                    fit: BoxFit.cover,
                                                  ).cornerRadiusWithClipRRect(
                                                    12)
                                                : Image(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      usuarioQPublicou.photo,
                                                    ),
                                                    height: 56,
                                                    width: 56,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ).cornerRadiusWithClipRRect(
                                                    12),
                                            widthSpace10,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      formatarNome(
                                                          usuarioQPublicou
                                                              .nome),
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
                                                  margin: const EdgeInsets.only(
                                                      right: 15),
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
                                      usuarioQPublicou.uid == widget.usuario.uid
                                          ? Container(
                                              alignment: Alignment.centerLeft,
                                              margin: const EdgeInsets.only(
                                                  right: 15),
                                              child: GestureDetector(
                                                onTap: () => showPopover(
                                                  context: context,
                                                  arrowHeight: 15,
                                                  arrowWidth: 30,
                                                  bodyBuilder: (context) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8),
                                                      child: ListView(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Provider.of<ControlNav>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .updatepost(
                                                                SVPostModel(
                                                                  idPost:
                                                                      post.id,
                                                                  idUsuario:
                                                                      usuarioQPublicou
                                                                          .uid,
                                                                  description: post[
                                                                      'description'],
                                                                  postImage: post[
                                                                      'postImage'],
                                                                ),
                                                              );
                                                              Provider.of<ControlNav>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .updateIndex(
                                                                      3, 3);
                                                              /*Navigator.of(
                                                                      context)
                                                                  .pop();*/
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              color: color22,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.edit,
                                                                    color:
                                                                        color94,
                                                                  ),
                                                                  widthSpace10,
                                                                  Text(
                                                                    'Editar',
                                                                    style:
                                                                        color94SemiBold16,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(),
                                                          InkWell(
                                                            onTap: () async {
                                                              bool fecharModal =
                                                                  false;
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  backgroundColor:
                                                                      color28,
                                                                  title: Text(
                                                                    'Apagar Post',
                                                                    style:
                                                                        whiteBold16,
                                                                  ),
                                                                  content: Text(
                                                                    'Você tem certeza que quer apagar esse post?',
                                                                    style:
                                                                        whiteRegular16,
                                                                  ),
                                                                  actions: [
                                                                    // Cancel button
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        alterar(
                                                                            !fecharModal);

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Voltar',
                                                                        style:
                                                                            whiteBold16,
                                                                      ),
                                                                    ),
                                                                    // Delete button
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await storePost
                                                                            .deletePost(
                                                                          post.id,
                                                                        );

                                                                        alterar(
                                                                            !fecharModal);

                                                                        storePost
                                                                            .fecharModal(context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Sim',
                                                                        style:
                                                                            whiteBold16,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              color: color22,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        color94,
                                                                  ),
                                                                  widthSpace10,
                                                                  Text(
                                                                    'Excluir',
                                                                    style:
                                                                        color94SemiBold16,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: 150,
                                                  backgroundColor:
                                                      scaffoldColor,
                                                  direction:
                                                      PopoverDirection.bottom,
                                                ),
                                                child: Icon(
                                                  Icons.more_vert_rounded,
                                                  color: color94,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            usuarioQPublicou.photo == '' ||
                                                    usuarioQPublicou.photo ==
                                                        'https://tuddo.org/'
                                                ? Image.asset(
                                                    'assets/image/nopicture.png',
                                                    height: 56,
                                                    width: 56,
                                                    fit: BoxFit.cover,
                                                  ).cornerRadiusWithClipRRect(
                                                    12)
                                                : /*Image.network(
                                                    usuarioQPublicou.photo,
                                                    height: 56,
                                                    width: 56,
                                                    fit: BoxFit.cover,
                                                  ).cornerRadiusWithClipRRect(
                                                    12)*/
                                                Image(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      usuarioQPublicou.photo,
                                                    ),
                                                    height: 56,
                                                    width: 56,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ).cornerRadiusWithClipRRect(
                                                    12),
                                            widthSpace10,
                                            Text(
                                              formatarNome(
                                                  usuarioQPublicou.nome),
                                              style: whiteSemiBold20,
                                            ),
                                            widthSpace5,
                                            Image.asset(
                                              'assets/social/ic_TickSquare.png',
                                              height: 14,
                                              width: 14,
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        child: Text(
                                          post['data'],
                                          style: color94SemiBold16,
                                        ),
                                      ),
                                      usuarioQPublicou.uid == widget.usuario.uid
                                          ? Container(
                                              alignment: Alignment.centerLeft,
                                              margin: const EdgeInsets.only(
                                                  right: 15),
                                              child: GestureDetector(
                                                onTap: () => showPopover(
                                                  context: context,
                                                  arrowHeight: 15,
                                                  arrowWidth: 30,
                                                  bodyBuilder: (context) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8),
                                                      child: ListView(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Provider.of<ControlNav>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .updatepost(
                                                                SVPostModel(
                                                                  idPost:
                                                                      post.id,
                                                                  idUsuario:
                                                                      usuarioQPublicou
                                                                          .uid,
                                                                  description: post[
                                                                      'description'],
                                                                  postImage: post[
                                                                      'postImage'],
                                                                ),
                                                              );
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Provider.of<ControlNav>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .updateIndex(
                                                                      3, 3);
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              color: color22,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.edit,
                                                                    color:
                                                                        color94,
                                                                  ),
                                                                  widthSpace10,
                                                                  Text(
                                                                    'Editar',
                                                                    style:
                                                                        color94SemiBold16,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const Divider(),
                                                          InkWell(
                                                            onTap: () async {
                                                              bool fecharModal =
                                                                  false;
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  backgroundColor:
                                                                      color28,
                                                                  title: Text(
                                                                    'Apagar Post',
                                                                    style:
                                                                        whiteBold16,
                                                                  ),
                                                                  content: Text(
                                                                    'Você tem certeza que quer apagar esse post?',
                                                                    style:
                                                                        whiteRegular16,
                                                                  ),
                                                                  actions: [
                                                                    // Cancel button
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        alterar(
                                                                            !fecharModal);

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Voltar',
                                                                        style:
                                                                            whiteBold16,
                                                                      ),
                                                                    ),
                                                                    // Delete button
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await storePost
                                                                            .deletePost(
                                                                          post.id,
                                                                        );

                                                                        alterar(
                                                                            !fecharModal);

                                                                        storePost
                                                                            .fecharModal(context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Sim',
                                                                        style:
                                                                            whiteBold16,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              color: color22,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        color94,
                                                                  ),
                                                                  widthSpace10,
                                                                  Text(
                                                                    'Excluir',
                                                                    style:
                                                                        color94SemiBold16,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: 150,
                                                  backgroundColor:
                                                      scaffoldColor,
                                                  direction:
                                                      PopoverDirection.bottom,
                                                ),
                                                child: Icon(
                                                  Icons.more_vert_rounded,
                                                  color: color94,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  );
                          } else if (snapshot.hasError) {
                            debugPrint('Error: ${snapshot.error}');
                            return Center(
                              child: Icon(
                                Icons.error,
                                color: color94,
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      heightSpace15,
                      post['description'].isNotEmpty
                          ? Text(
                              post['description'],
                              textAlign: TextAlign.start,
                              style: color94SemiBold16,
                            ).paddingSymmetric(horizontal: 16)
                          : const Offstage(),
                      post['description'].isNotEmpty
                          ? heightSpace15
                          : const Offstage(),
                      post['postImage'] != ''
                          ? post['postImage'] != 'https://api.tuddo.org/'
                              ? /*Image.network(
                                  post['postImage'],
                                  height: 300,
                                  width: context.width() - 32,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(12).center()*/
                              Image(
                                  image: CachedNetworkImageProvider(
                                    post['postImage'],
                                  ),
                                  height: 300,
                                  width: context.width() - 32,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).cornerRadiusWithClipRRect(12).center()
                              : heightSpace10
                          : heightSpace10,
                      Row(
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
                                onPressed: () async {
                                  setState(() {
                                    isLiked = !isLiked;
                                  });
                                  await storePost.addLike(
                                      isLiked, widget.usuario.uid, post.id);
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  Provider.of<ControlNav>(context,
                                          listen: false)
                                      .updateidpost(post.id.toString());

                                  Provider.of<ControlNav>(context,
                                          listen: false)
                                      .updateIndex(3, 2);
                                  /*Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SVCommentScreen(
                                        usuario: widget.usuario,
                                        idPost: post.id.toString(),
                                      ),
                                    ),
                                  );*/
                                },
                                child: Image.asset(
                                  'assets/social/ic_Chat.png',
                                  height: 22,
                                  width: 22,
                                  fit: BoxFit.cover,
                                  color: color94,
                                ),
                              ),
                              widthSpace10,
                              Image.asset(
                                'assets/social/ic_Send.png',
                                height: 22,
                                width: 22,
                                fit: BoxFit.cover,
                                color: color94,
                              ).onTap(
                                () {
                                  shareMensagem(
                                    post['postImage'],
                                    nomeUsuarioQPublicou ?? '',
                                    post['description'],
                                  );
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                            ],
                          ),
                          Text(
                            '${post['totalComentario'] ?? 0} comentários',
                            style: whiteMedium14,
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      const Divider(indent: 16, endIndent: 16, height: 20),
                      listUIDUser.isEmpty
                          ? heightSpace10
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: FutureBuilder(
                                future: storePost.getListUsersLikes(
                                    listUIDUser, widget.usuario.uid),
                                builder: (context, listUsersQCurte) {
                                  if (listUsersQCurte.hasData) {
                                    int total = listUsersQCurte.data!.length;
                                    final userdata = listUsersQCurte.data;
                                    if (total == 0) {
                                      return heightSpace5;
                                    } else if (total == 1) {
                                      return Row(
                                        children: [
                                          widthSpace20,
                                          SizedBox(
                                            child: Positioned(
                                              right: 0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                  borderRadius: radius(100),
                                                ),
                                                child: userdata[0].photo ==
                                                            '' ||
                                                        userdata[0].photo ==
                                                            'https://tuddo.org/'
                                                    ? Image.asset(
                                                        'assets/image/nopicture.png',
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,
                                                      ).cornerRadiusWithClipRRect(
                                                        100)
                                                    : Image(
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          userdata[0].photo,
                                                        ),
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ).cornerRadiusWithClipRRect(
                                                        100) /*Image.network(
                                                        userdata[0].photo,
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,
                                                      ).cornerRadiusWithClipRRect(
                                                        100)*/
                                                ,
                                              ),
                                            ),
                                          ),
                                          widthSpace10,
                                          RichText(
                                            text: TextSpan(
                                              text: 'Curtido por ',
                                              style: whiteMedium14,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: userdata[0].nome ==
                                                          widget.usuario.nome
                                                      ? 'você'
                                                      : formatarNome(
                                                          userdata[0].nome,
                                                        ),
                                                  style: whiteMedium14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (total == 2) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius: radius(100),
                                                    ),
                                                    child: userdata[0].photo ==
                                                                '' ||
                                                            userdata[0].photo ==
                                                                'https://tuddo.org/'
                                                        ? Image.asset(
                                                            'assets/image/nopicture.png',
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                          ).cornerRadiusWithClipRRect(
                                                            100)
                                                        : Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              userdata[0].photo,
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).cornerRadiusWithClipRRect(
                                                            100),
                                                  ),
                                                ),
                                                Positioned(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius: radius(100),
                                                    ),
                                                    child: userdata[1].photo ==
                                                                '' ||
                                                            userdata[1].photo ==
                                                                'https://tuddo.org/'
                                                        ? Image.asset(
                                                            'assets/image/nopicture.png',
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                          ).cornerRadiusWithClipRRect(
                                                            100)
                                                        : Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              userdata[1].photo,
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).cornerRadiusWithClipRRect(
                                                            100),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Curtido por ',
                                              style: checksize
                                                  ? whiteMedium12
                                                  : whiteMedium14,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: userdata[0].nome ==
                                                          widget.usuario.nome
                                                      ? userdata[1].nome ==
                                                              widget
                                                                  .usuario.nome
                                                          ? ''
                                                          : formatarNome(
                                                              userdata[1].nome,
                                                            )
                                                      : formatarNome(
                                                          userdata[0].nome,
                                                        ),
                                                  style: checksize
                                                      ? whiteMedium12
                                                      : whiteMedium14,
                                                ),
                                                TextSpan(
                                                  text: ' e ',
                                                  style: checksize
                                                      ? whiteMedium12
                                                      : whiteMedium14,
                                                ),
                                                TextSpan(
                                                  text: '1 Outro',
                                                  style: checksize
                                                      ? whiteMedium12
                                                      : whiteMedium14,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    } else if (total == 3) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius: radius(100),
                                                    ),
                                                    child: userdata[0].photo ==
                                                                '' ||
                                                            userdata[0].photo ==
                                                                'https://tuddo.org/'
                                                        ? Image.asset(
                                                            'assets/image/nopicture.png',
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                          ).cornerRadiusWithClipRRect(
                                                            100)
                                                        : Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              userdata[0].photo,
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).cornerRadiusWithClipRRect(
                                                            100),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 14,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius: radius(100),
                                                    ),
                                                    child: userdata[1].photo ==
                                                                '' ||
                                                            userdata[1].photo ==
                                                                'https://tuddo.org/'
                                                        ? Image.asset(
                                                            'assets/image/nopicture.png',
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                          ).cornerRadiusWithClipRRect(
                                                            100)
                                                        : Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              userdata[1].photo,
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).cornerRadiusWithClipRRect(
                                                            100),
                                                  ),
                                                ),
                                                Positioned(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius: radius(100),
                                                    ),
                                                    child: userdata[2].photo ==
                                                                '' ||
                                                            userdata[2].photo ==
                                                                'https://tuddo.org/'
                                                        ? Image.asset(
                                                            'assets/image/nopicture.png',
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                          ).cornerRadiusWithClipRRect(
                                                            100)
                                                        : Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              userdata[2].photo,
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).cornerRadiusWithClipRRect(
                                                            100),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          widthSpace10,
                                          RichText(
                                            text: TextSpan(
                                              text: 'Curtido por ',
                                              style: checksize
                                                  ? whiteMedium12
                                                  : whiteMedium14,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: userdata[0].nome ==
                                                          widget.usuario.nome
                                                      ? userdata[1].nome ==
                                                              widget
                                                                  .usuario.nome
                                                          ? userdata[2].nome ==
                                                                  postList[
                                                                          index]
                                                                      .name
                                                              ? ''
                                                              : formatarNome(
                                                                  userdata[2]
                                                                      .nome,
                                                                )
                                                          : formatarNome(
                                                              userdata[1].nome,
                                                            )
                                                      : formatarNome(
                                                          userdata[0].nome,
                                                        ),
                                                  style: checksize
                                                      ? whiteMedium12
                                                      : whiteMedium14,
                                                ),
                                                TextSpan(
                                                  text: ' e ',
                                                  style: checksize
                                                      ? whiteMedium12
                                                      : whiteMedium14,
                                                ),
                                                TextSpan(
                                                  text: '2 Outros ',
                                                  style: checksize
                                                      ? whiteMedium12
                                                      : whiteMedium14,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius: radius(100),
                                                    ),
                                                    child: userdata[0].photo ==
                                                                '' ||
                                                            userdata[0].photo ==
                                                                'https://tuddo.org/'
                                                        ? Image.asset(
                                                            'assets/image/nopicture.png',
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                          ).cornerRadiusWithClipRRect(
                                                            100)
                                                        : Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              userdata[0].photo,
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).cornerRadiusWithClipRRect(
                                                            100),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 14,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius: radius(100),
                                                    ),
                                                    child: userdata[1].photo ==
                                                                '' ||
                                                            userdata[1].photo ==
                                                                'https://tuddo.org/'
                                                        ? Image.asset(
                                                            'assets/image/nopicture.png',
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                          ).cornerRadiusWithClipRRect(
                                                            100)
                                                        : Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              userdata[1].photo,
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).cornerRadiusWithClipRRect(
                                                            100),
                                                  ),
                                                ),
                                                Positioned(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius: radius(100),
                                                    ),
                                                    child: userdata[2].photo ==
                                                                '' ||
                                                            userdata[2].photo ==
                                                                'https://tuddo.org/'
                                                        ? Image.asset(
                                                            'assets/image/nopicture.png',
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                          ).cornerRadiusWithClipRRect(
                                                            100)
                                                        : Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              userdata[2].photo,
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).cornerRadiusWithClipRRect(
                                                            100),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          widthSpace10,
                                          RichText(
                                            text: TextSpan(
                                              text: 'Curtido por ',
                                              style: checksize
                                                  ? whiteMedium12
                                                  : whiteMedium14,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: userdata[0].nome ==
                                                          widget.usuario.nome
                                                      ? userdata[1].nome ==
                                                              widget
                                                                  .usuario.nome
                                                          ? userdata[2].nome ==
                                                                  postList[
                                                                          index]
                                                                      .name
                                                              ? ''
                                                              : formatarNome(
                                                                  userdata[2]
                                                                      .nome,
                                                                )
                                                          : formatarNome(
                                                              userdata[1].nome,
                                                            )
                                                      : formatarNome(
                                                          userdata[0].nome,
                                                        ),
                                                  style: checksize
                                                      ? whiteMedium12
                                                      : whiteMedium14,
                                                ),
                                                TextSpan(
                                                  text: ' e ',
                                                  style: checksize
                                                      ? whiteMedium12
                                                      : whiteMedium14,
                                                ),
                                                TextSpan(
                                                  text: '${total - 1} Outros ',
                                                  style: checksize
                                                      ? whiteMedium12
                                                      : whiteMedium14,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  } else {
                                    return heightSpace5;
                                  }
                                },
                              ),
                            ),
                    ],
                  ),
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
