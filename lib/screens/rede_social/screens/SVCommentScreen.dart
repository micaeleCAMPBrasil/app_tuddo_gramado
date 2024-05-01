// ignore_for_file: file_names, deprecated_member_use

import 'dart:async';

import 'package:app_tuddo_gramado/data/models/SVCommentModel.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/screens/rede_social/SVHomeFragment.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVCommentComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVCommentReplyComponent.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

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
    checkComentario();
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
    await storePost.getComentarios(widget.usuario.uid, widget.idPost);
    if (mounted) {
      setState(() {
        commentList = storePost.comentarios.value;
      });
    }
    //pause ? null : checkUserName();
  }

  @override
  void dispose() {
    setStatusBarColor(scaffoldColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SVHomeFragment(),
          ),
        );
        return true;
      },
      child: Scaffold(
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SVHomeFragment(),
                ),
              );
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: SingleChildScrollView(
                child: Column(
                  children: commentList.map((e) {
                    return SVCommentComponent(comment: e);
                  }).toList(),
                ),
              ),
            ),
            SVCommentReplyComponent(
              usuario: widget.usuario,
              idPost: widget.idPost,
            ),
          ],
        ),
      ),
    );
  }
}
