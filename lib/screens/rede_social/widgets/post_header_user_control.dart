import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

import '../../../data/models/SVPostModel.dart';
import '../../../data/stores/control_nav.dart';
import '../../../utils/constant.dart';

class PostHeaderControl extends StatelessWidget {
  final Usuario usuarioQPublicou;
  final PublicacaoStore storePost;
  final QueryDocumentSnapshot<Map<String, dynamic>> post;

  const PostHeaderControl({
    super.key,
    required this.usuarioQPublicou,
    required this.storePost,
    required this.post,
  });

  alterar(bool fecharModal, BuildContext context) {
    debugPrint("fechar modal $fecharModal");

    if (fecharModal) {
      storePost.fecharModal(context);
    }
  }

  void onEditPost(BuildContext context) {
    Provider.of<ControlNav>(context, listen: false).updatepost(
      SVPostModel(
        idPost: post.id,
        idUsuario: usuarioQPublicou.uid,
        description: post['description'],
        postImage: post['postImage'],
      ),
    );
    Navigator.of(context).pop();
    Provider.of<ControlNav>(context, listen: false).updateIndex(3, 3);
  }

  Future<void> onDeletePost(BuildContext context) async {
    bool fecharModal = false;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: color28,
        title: Text('Apagar Post', style: whiteBold16),
        content: Text('Você tem certeza que quer apagar esse post?', style: whiteRegular16),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              alterar(!fecharModal, context);
              Navigator.pop(context);
            },
            child: Text('Voltar', style: whiteBold16),
          ),
          // Delete button
          TextButton(
            onPressed: () async {
              await storePost.deletePost(post.id);
              alterar(!fecharModal, context);
              storePost.fecharModal(context);
            },
            child: Text('Sim', style: whiteBold16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(right: 15),
      child: GestureDetector(
        onTap: () => showPopover(
          context: context,
          arrowHeight: 15,
          arrowWidth: 30,
          bodyBuilder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  InkWell(
                    onTap: () => onEditPost(context),
                    child: Container(
                      height: 50,
                      color: color22,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: color94),
                          widthSpace10,
                          Text('Editar', style: color94SemiBold16),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () async => onDeletePost(context),
                    child: Container(
                      height: 50,
                      color: color22,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: color94),
                          widthSpace10,
                          Text('Excluir', style: color94SemiBold16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          width: MediaQuery.of(context).size.width * 0.9,
          height: 150,
          backgroundColor: scaffoldColor,
          direction: PopoverDirection.bottom,
        ),
        child: Icon(
          Icons.more_vert_rounded,
          color: color94,
        ),
      ),
    );
  }
}
