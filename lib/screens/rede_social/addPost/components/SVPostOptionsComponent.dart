// ignore_for_file: file_names

import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVPostOptionsComponent extends StatefulWidget {
  const SVPostOptionsComponent({super.key});

  @override
  State<SVPostOptionsComponent> createState() => _SVPostOptionsComponentState();
}

class _SVPostOptionsComponentState extends State<SVPostOptionsComponent> {
  List<String> list = [
    'assets/social/post_one.png',
    'assets/social/post_two.png',
    'assets/social/post_three.png',
    'assets/social/postImage.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scaffoldColor,
        borderRadius: radiusOnly(topRight: 12, topLeft: 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 62,
                  width: 52,
                  color: context.cardColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Image.asset('assets/social/ic_CameraPost.png',
                      height: 22, width: 22, fit: BoxFit.cover),
                ),
                HorizontalList(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Image.asset(list[index],
                        height: 62, width: 52, fit: BoxFit.cover);
                  },
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/social/ic_Video.png',
                  height: 32, width: 32, fit: BoxFit.cover),
              //Image.asset('assets/social/ic_CameraPost.png', height: 32, width: 32, fit: BoxFit.cover),
              Image.asset('assets/social/ic_Voice.png',
                  height: 32, width: 32, fit: BoxFit.cover),
              Image.asset('assets/social/ic_Location.png',
                  height: 32, width: 32, fit: BoxFit.cover),
              Image.asset('assets/social/ic_Paper.png',
                  height: 32, width: 32, fit: BoxFit.cover),
            ],
          ),
        ],
      ),
    );
  }
}
