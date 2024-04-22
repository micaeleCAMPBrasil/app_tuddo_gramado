// ignore_for_file: file_names

import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/screens/rede_social/screens/SVCommentScreen.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVPostComponent extends StatefulWidget {
  const SVPostComponent({super.key});

  @override
  State<SVPostComponent> createState() => _SVPostComponentState();
}

class _SVPostComponentState extends State<SVPostComponent> {
  List<SVPostModel> postList = getPosts();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: postList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration:
              BoxDecoration(borderRadius: radius(12), color: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        postList[index].profileImage.validate(),
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(12),
                      12.width,
                      Text(postList[index].name.validate(),
                          style: boldTextStyle()),
                      4.width,
                      Image.asset('assets/social/ic_TickSquare.png',
                          height: 14, width: 14, fit: BoxFit.cover),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                  Row(
                    children: [
                      Text(
                        '${postList[index].time.validate()} ago',
                        style: whiteMedium14,
                      ),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                    ],
                  ).paddingSymmetric(horizontal: 8),
                ],
              ),
              16.height,
              postList[index].description.validate().isNotEmpty
                  ? Text(
                      postList[index].description.validate(),
                      textAlign: TextAlign.start,
                    ).paddingSymmetric(horizontal: 16)
                  : const Offstage(),
              postList[index].description.validate().isNotEmpty
                  ? 16.height
                  : const Offstage(),
              Image.asset(
                postList[index].postImage.validate(),
                height: 300,
                width: context.width() - 32,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(12).center(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/social/ic_Chat.png',
                        height: 22,
                        width: 22,
                        fit: BoxFit.cover,
                        color: context.iconColor,
                      ).onTap(() {
                        const SVCommentScreen().launch(context);
                      },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent),
                      IconButton(
                        icon: postList[index].like.validate()
                            ? Image.asset('assets/social/ic_HeartFilled.png',
                                height: 20, width: 22, fit: BoxFit.fill)
                            : Image.asset(
                                'assets/social/ic_Heart.png',
                                height: 22,
                                width: 22,
                                fit: BoxFit.cover,
                                color: context.iconColor,
                              ),
                        onPressed: () {
                          postList[index].like =
                              !postList[index].like.validate();
                          setState(() {});
                        },
                      ),
                      Image.asset(
                        'assets/social/ic_Send.png',
                        height: 22,
                        width: 22,
                        fit: BoxFit.cover,
                        color: context.iconColor,
                      ).onTap(() {
                        svShowShareBottomSheet(context);
                      },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent),
                    ],
                  ),
                  Text(
                    '${postList[index].commentCount.validate()} comments',
                    style: whiteMedium14,
                  ),
                ],
              ).paddingSymmetric(horizontal: 16),
              const Divider(indent: 16, endIndent: 16, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: radius(100)),
                            child: Image.asset('assets/social/face_1.png',
                                    height: 24, width: 24, fit: BoxFit.cover)
                                .cornerRadiusWithClipRRect(100),
                          ),
                        ),
                        Positioned(
                          left: 14,
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: radius(100)),
                            child: Image.asset('assets/social/face_2.png',
                                    height: 24, width: 24, fit: BoxFit.cover)
                                .cornerRadiusWithClipRRect(100),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: radius(100)),
                            child: Image.asset('assets/social/face_3.png',
                                    height: 24, width: 24, fit: BoxFit.cover)
                                .cornerRadiusWithClipRRect(100),
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.width,
                  RichText(
                    text: TextSpan(
                      text: 'Liked By ',
                      style: whiteMedium14,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Ms.Mountain ',
                          style: whiteMedium14,
                        ),
                        TextSpan(
                          text: 'And ',
                          style: whiteMedium14,
                        ),
                        TextSpan(
                          text: '1,10 Others ',
                          style: whiteMedium14,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
