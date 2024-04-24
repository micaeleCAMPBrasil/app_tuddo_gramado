// ignore_for_file: file_names

import 'dart:async';

import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/post_store.dart';
import 'package:app_tuddo_gramado/screens/rede_social/screens/SVCommentScreen.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class SVPostComponent extends StatefulWidget {
  Usuario usuario;
  SVPostComponent({super.key, required this.usuario});

  @override
  State<SVPostComponent> createState() => _SVPostComponentState();
}

class _SVPostComponentState extends State<SVPostComponent> {
  final PostStore storePost = PostStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  List<SVPostModel> postList = [];

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    //getListsData();
    checkSystem();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          _loading = true;
        });
      },
    );
  }

  bool checkNovo = false;

  checkSystem() {
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
    await storePost.getAll(widget.usuario.uid, '');
    if (mounted) {
      setState(() {
        postList = storePost.list.value;
      });
    }
    //pause ? null : checkUserName();
  }

  gerarListUsuario(String idPost) async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? postList.isEmpty
            ? Center(
                child: Text(
                  'Nenhum Post',
                  style: color94SemiBold16,
                ),
              )
            : ListView.builder(
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  List<Usuario> listUsersQCurte =
                      postList[index].usuarioQCurtiram.validate();
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: radius(12),
                      color: color00,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  postList[index].profileImage.validate() == ''
                                      ? Image.asset(
                                          'assets/image/nopicture.png',
                                          height: 56,
                                          width: 56,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(12)
                                      : Image.network(
                                          postList[index]
                                              .profileImage
                                              .validate(),
                                          height: 56,
                                          width: 56,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(12),
                                  widthSpace10,
                                  Text(
                                    formatarNome(
                                        postList[index].name.validate()),
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
                              margin: const EdgeInsets.only(right: 15),
                              child: Text(
                                postList[index].time.validate(),
                                style: color94SemiBold16,
                              ),
                            ),
                          ],
                        ),
                        heightSpace15,
                        postList[index].description.validate().isNotEmpty
                            ? Text(
                                postList[index].description.validate(),
                                textAlign: TextAlign.start,
                                style: color94SemiBold16,
                              ).paddingSymmetric(horizontal: 16)
                            : const Offstage(),
                        postList[index].description.validate().isNotEmpty
                            ? heightSpace15
                            : const Offstage(),
                        postList[index].postImage.validate() != ''
                            ? Image.network(
                                postList[index].postImage.validate(),
                                height: 300,
                                width: context.width() - 32,
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(12).center()
                            : heightSpace10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: postList[index].like.validate()
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
                                      postList[index].like =
                                          !postList[index].like.validate();
                                    });

                                    String idPost = postList[index]
                                        .idPost
                                        .validate()
                                        .toString();
                                    await storePost.addLike(
                                        widget.usuario.uid, idPost);
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SVCommentScreen(),
                                      ),
                                    );
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
                                    svShowShareBottomSheet(context);
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                ),
                              ],
                            ),
                            Text(
                              '${postList[index].commentCount.validate()} comentários',
                              style: whiteMedium14,
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        const Divider(indent: 16, endIndent: 16, height: 20),
                        listUsersQCurte.isEmpty
                            ? heightSpace5
                            : listUsersQCurte.length == 1
                                ? Row(
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
                                            child: listUsersQCurte[0].photo ==
                                                    ''
                                                ? Image.asset(
                                                    'assets/image/nopicture.png',
                                                    height: 24,
                                                    width: 24,
                                                    fit: BoxFit.cover,
                                                  ).cornerRadiusWithClipRRect(
                                                    100)
                                                : Image.network(
                                                    listUsersQCurte[0].photo,
                                                    height: 24,
                                                    width: 24,
                                                    fit: BoxFit.cover,
                                                  ).cornerRadiusWithClipRRect(
                                                    100),
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
                                              text: listUsersQCurte[0].nome ==
                                                      postList[index]
                                                          .name
                                                          .validate()
                                                  ? 'você'
                                                  : formatarNome(
                                                      listUsersQCurte[0].nome),
                                              style: whiteMedium14,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : listUsersQCurte.length == 2
                                    ? Row(
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
                                                child: listUsersQCurte[0]
                                                            .photo ==
                                                        ''
                                                    ? Image.asset(
                                                        'assets/image/nopicture.png',
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,
                                                      ).cornerRadiusWithClipRRect(
                                                        100)
                                                    : Image.network(
                                                        listUsersQCurte[0]
                                                            .photo,
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,
                                                      ).cornerRadiusWithClipRRect(
                                                        100),
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
                                                  text: listUsersQCurte[0]
                                                              .nome ==
                                                          postList[index]
                                                              .name
                                                              .validate()
                                                      ? listUsersQCurte[1]
                                                                  .nome ==
                                                              postList[index]
                                                                  .name
                                                                  .validate()
                                                          ? ''
                                                          : formatarNome(
                                                              listUsersQCurte[1]
                                                                  .nome,
                                                            )
                                                      : formatarNome(
                                                          listUsersQCurte[0]
                                                              .nome,
                                                        ),
                                                  style: whiteMedium14,
                                                ),
                                                TextSpan(
                                                  text: ' e ',
                                                  style: whiteMedium14,
                                                ),
                                                TextSpan(
                                                  text: '1 Outro ',
                                                  style: whiteMedium14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : listUsersQCurte.length == 3
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 56,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  children: [
                                                    Positioned(
                                                      right: 0,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2),
                                                          borderRadius:
                                                              radius(100),
                                                        ),
                                                        child: listUsersQCurte[
                                                                        0]
                                                                    .photo ==
                                                                ''
                                                            ? Image.asset(
                                                                'assets/image/nopicture.png',
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100)
                                                            : Image.network(
                                                                listUsersQCurte[
                                                                        0]
                                                                    .photo,
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 14,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2),
                                                          borderRadius:
                                                              radius(100),
                                                        ),
                                                        child: listUsersQCurte[
                                                                        1]
                                                                    .photo ==
                                                                ''
                                                            ? Image.asset(
                                                                'assets/image/nopicture.png',
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100)
                                                            : Image.network(
                                                                listUsersQCurte[
                                                                        1]
                                                                    .photo,
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2),
                                                          borderRadius:
                                                              radius(100),
                                                        ),
                                                        child: listUsersQCurte[
                                                                        2]
                                                                    .photo ==
                                                                ''
                                                            ? Image.asset(
                                                                'assets/image/nopicture.png',
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100)
                                                            : Image.network(
                                                                listUsersQCurte[
                                                                        2]
                                                                    .photo,
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
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
                                                  style: whiteMedium14,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: listUsersQCurte[0]
                                                                  .nome ==
                                                              postList[index]
                                                                  .name
                                                                  .validate()
                                                          ? listUsersQCurte[1]
                                                                      .nome ==
                                                                  postList[
                                                                          index]
                                                                      .name
                                                                      .validate()
                                                              ? listUsersQCurte[
                                                                              1]
                                                                          .nome ==
                                                                      postList[
                                                                              index]
                                                                          .name
                                                                          .validate()
                                                                  ? ''
                                                                  : formatarNome(
                                                                      listUsersQCurte[
                                                                              2]
                                                                          .nome,
                                                                    )
                                                              : formatarNome(
                                                                  listUsersQCurte[
                                                                          1]
                                                                      .nome,
                                                                )
                                                          : formatarNome(
                                                              listUsersQCurte[0]
                                                                  .nome,
                                                            ),
                                                      style: whiteMedium14,
                                                    ),
                                                    TextSpan(
                                                      text: ' e ',
                                                      style: whiteMedium14,
                                                    ),
                                                    TextSpan(
                                                      text: '2 Outros ',
                                                      style: whiteMedium14,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        : heightSpace10 /*: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 56,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  children: [
                                                    Positioned(
                                                      right: 0,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2),
                                                          borderRadius:
                                                              radius(100),
                                                        ),
                                                        child: listUsersQCurte[
                                                                        0]
                                                                    .photo ==
                                                                ''
                                                            ? Image.asset(
                                                                'assets/image/nopicture.png',
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100)
                                                            : Image.network(
                                                                listUsersQCurte[
                                                                        0]
                                                                    .photo,
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 14,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2),
                                                          borderRadius:
                                                              radius(100),
                                                        ),
                                                        child: listUsersQCurte[
                                                                        1]
                                                                    .photo ==
                                                                ''
                                                            ? Image.asset(
                                                                'assets/image/nopicture.png',
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100)
                                                            : Image.network(
                                                                listUsersQCurte[
                                                                        1]
                                                                    .photo,
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2),
                                                          borderRadius:
                                                              radius(100),
                                                        ),
                                                        child: listUsersQCurte[
                                                                        2]
                                                                    .photo ==
                                                                ''
                                                            ? Image.asset(
                                                                'assets/image/nopicture.png',
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ).cornerRadiusWithClipRRect(
                                                                100)
                                                            : Image.network(
                                                                listUsersQCurte[
                                                                        2]
                                                                    .photo,
                                                                height: 24,
                                                                width: 24,
                                                                fit: BoxFit
                                                                    .cover,
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
                                                  style: whiteMedium14,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: listUsersQCurte[0]
                                                                  .nome ==
                                                              postList[index]
                                                                  .name
                                                                  .validate()
                                                          ? listUsersQCurte[1]
                                                                      .nome ==
                                                                  postList[
                                                                          index]
                                                                      .name
                                                                      .validate()
                                                              ? listUsersQCurte[
                                                                              1]
                                                                          .nome ==
                                                                      postList[
                                                                              index]
                                                                          .name
                                                                          .validate()
                                                                  ? ''
                                                                  : formatarNome(
                                                                      listUsersQCurte[
                                                                              2]
                                                                          .nome,
                                                                    )
                                                              : formatarNome(
                                                                  listUsersQCurte[
                                                                          1]
                                                                      .nome,
                                                                )
                                                          : formatarNome(
                                                              listUsersQCurte[0]
                                                                  .nome,
                                                            ),
                                                      style: whiteMedium14,
                                                    ),
                                                    TextSpan(
                                                      text: 'And ',
                                                      style: whiteMedium14,
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${postList[index].likeCount.validate()} Outros ',
                                                      style: whiteMedium14,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )*/
                      ],
                    ),
                  );
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              )
        : Container();
  }
}
