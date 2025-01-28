import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PostHeaderProfilePicture extends StatelessWidget {
  const PostHeaderProfilePicture({
    super.key,
    required this.usuarioQPublicou,
  });

  final Usuario usuarioQPublicou;

  @override
  Widget build(BuildContext context) {
    return usuarioQPublicou.photo == '' || usuarioQPublicou.photo == 'https://tuddo.org/'
        ? Image.asset(
            'assets/image/nopicture.png',
            height: 56,
            width: 56,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(12)
        : CachedNetworkImage(
            imageUrl: usuarioQPublicou.photo,
            height: 56,
            width: 56,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) {
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
          ).cornerRadiusWithClipRRect(12);
  }
}
