import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PostBody extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> post;

  const PostBody({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        heightSpace15,
        post['description'].isNotEmpty
            ? Text(
                post['description'],
                textAlign: TextAlign.start,
                style: color94SemiBold16,
              ).paddingSymmetric(horizontal: 16)
            : const Offstage(),
        post['description'].isNotEmpty ? heightSpace15 : const Offstage(),
        post['postImage'] != ''
            ? post['postImage'] != 'https://www.tuddo.org/'
                ? CachedNetworkImage(
                    imageUrl: post['postImage'],
                    height: 300,
                    width: context.width() - 32,
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
                  ).cornerRadiusWithClipRRect(12).center()
                : heightSpace10
            : heightSpace10,
      ],
    );
  }
}
