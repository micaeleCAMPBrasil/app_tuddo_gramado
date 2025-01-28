import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/screens/rede_social/widgets/post_header_normal.dart';
import 'package:app_tuddo_gramado/screens/rede_social/widgets/post_header_small.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final Usuario usuario;
  final UsuarioStore storeUsuario;
  final PublicacaoStore storePost;
  final QueryDocumentSnapshot<Map<String, dynamic>> post;
  final bool isSmallScree;

  const PostHeader({
    super.key,
    required this.usuario,
    required this.storeUsuario,
    required this.storePost,
    required this.post,
    required this.isSmallScree,
  });

  Future<Usuario> gerarUsuario(String uid) async {
    await storeUsuario.getUID(uid);
    return storeUsuario.state.value;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gerarUsuario(post['idUsuario']),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Usuario usuarioQPublicou = snapshot.data!;
          return isSmallScree
              ? PostHeaderSmall(
                  usuario: usuario,
                  usuarioQPublicou: usuarioQPublicou,
                  storePost: storePost,
                  post: post,
                )
              : PostHeaderNormal(
                  usuario: usuario,
                  usuarioQPublicou: usuarioQPublicou,
                  storePost: storePost,
                  post: post,
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
    );
  }
}
