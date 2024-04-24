// ignore_for_file: file_names

import 'package:app_tuddo_gramado/data/models/SVCommentModel.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVCommentComponent extends StatefulWidget {
  final SVCommentModel comment;

  const SVCommentComponent({super.key, required this.comment});

  @override
  State<SVCommentComponent> createState() => _SVCommentComponentState();
}

class _SVCommentComponentState extends State<SVCommentComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  widget.comment.profileImage.validate(),
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(8),
                widthSpace15,
                Text(
                  widget.comment.name.validate(),
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
            Row(
              children: [
                Image.asset(
                  'assets/social/ic_TimeSquare.png',
                  height: 14,
                  width: 14,
                  fit: BoxFit.cover,
                  color: context.iconColor,
                ),
                4.width,
                Text('${widget.comment.time.validate()} ago',
                    style: color94SemiBold16),
              ],
            )
          ],
        ),
        heightSpace15,
        Text(
          widget.comment.comment.validate(),
          style: color94SemiBold16,
        ),
        heightSpace15,
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: radius(4),
                color: primaryColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.comment.like.validate()
                      ? Image.asset(
                          'assets/social/ic_HeartFilled.png',
                          height: 14,
                          width: 14,
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          'assets/social/ic_Heart.png',
                          height: 14,
                          width: 14,
                          fit: BoxFit.cover,
                          color: whiteColor,
                        ),
                  2.width,
                  Text(
                    widget.comment.likeCount.toString(),
                    style: whiteRegular12,
                  ),
                ],
              ),
            ).onTap(() {
              widget.comment.like = !widget.comment.like.validate();
              setState(() {});
            }, borderRadius: radius(4)),
          ],
        )
      ],
    ).paddingOnly(
      top: 16,
      left: widget.comment.isCommentReply.validate() ? 70 : 16,
      right: 16,
      bottom: 16,
    );
  }
}
