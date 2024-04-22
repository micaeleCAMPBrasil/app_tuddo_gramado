// ignore_for_file: file_names

import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVCommentReplyComponent extends StatelessWidget {
  const SVCommentReplyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: scaffoldColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Divider(indent: 16, endIndent: 16, height: 20),
          Row(
            children: [
              16.width,
              Image.asset('images/socialv/faces/face_5.png',
                      height: 48, width: 48, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(8),
              10.width,
              SizedBox(
                width: context.width() * 0.6,
                child: AppTextField(
                  textFieldType: TextFieldType.OTHER,
                  decoration: InputDecoration(
                    hintText: 'Write A Comment',
                    hintStyle: whiteRegular12,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Reply',
                  style: whiteRegular12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
