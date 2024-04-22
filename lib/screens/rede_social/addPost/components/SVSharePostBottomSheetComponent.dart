// ignore_for_file: file_names

import 'package:app_tuddo_gramado/data/models/SVSearchModel.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVSharePostBottomSheetComponent extends StatefulWidget {
  const SVSharePostBottomSheetComponent({super.key});

  @override
  State<SVSharePostBottomSheetComponent> createState() =>
      _SVSharePostBottomSheetComponentState();
}

class _SVSharePostBottomSheetComponentState
    extends State<SVSharePostBottomSheetComponent> {
  List<SVSearchModel> list = getSharePostList();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        30.height,
        Row(
          children: [
            Image.asset('assets/social/post_one.png',
                    height: 80, width: 80, fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(12),
            10.width,
            SizedBox(
              width: context.width() * 0.6,
              child: AppTextField(
                textFieldType: TextFieldType.OTHER,
                decoration: InputDecoration(
                  hintText: 'Write A Comment',
                  hintStyle: color94SemiBold16,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        20.height,
        Container(
          decoration:
              BoxDecoration(color: scaffoldColor, borderRadius: radius(12)),
          child: AppTextField(
            textFieldType: TextFieldType.NAME,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search Here',
              hintStyle: color94SemiBold16,
              prefixIcon: Image.asset(
                'assets/social/ic_Search.png',
                height: 16,
                width: 16,
                fit: BoxFit.cover,
                color: primaryColor,
              ).paddingAll(16),
            ),
          ),
        ),
        16.height,
        Row(
          children: [
            Image.asset('assets/social/face_5.png',
                    height: 48, width: 48, fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(12),
            10.width,
            Text(
              'Add post to your story',
              style: color94SemiBold16,
            ),
          ],
        ),
        const Divider(height: 40),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: list.map((e) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(e.profileImage.validate(),
                        height: 56, width: 56, fit: BoxFit.cover),
                    10.width,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(e.name.validate(), style: boldTextStyle()),
                        6.width,
                        e.isOfficialAccount.validate()
                            ? Image.asset('assets/social/ic_TickSquare.png',
                                height: 14, width: 14, fit: BoxFit.cover)
                            : const Offstage(),
                      ],
                    ),
                  ],
                ),
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                  text: 'Send',
                  textStyle: secondaryTextStyle(
                      color: e.doSend.validate() ? Colors.white : primaryColor,
                      size: 10),
                  onTap: () {
                    e.doSend = !e.doSend.validate();
                    setState(() {});
                  },
                  elevation: 0,
                  height: 30,
                  width: 50,
                  color: e.doSend.validate() ? primaryColor : secondaryColor,
                  padding: const EdgeInsets.all(0),
                ),
              ],
            ).paddingSymmetric(vertical: 8);
          }).toList(),
        )
      ],
    ).paddingAll(16);
  }
}
