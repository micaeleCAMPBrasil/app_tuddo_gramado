// ignore_for_file: file_names

import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVProfilePostsComponent extends StatefulWidget {
  const SVProfilePostsComponent({super.key});

  @override
  State<SVProfilePostsComponent> createState() =>
      _SVProfilePostsComponentState();
}

class _SVProfilePostsComponentState extends State<SVProfilePostsComponent> {
  int selectedIndex = 0;

  List<String> allPostList = [
    'assets/social/post_one.png',
    'assets/social/post_two.png',
    'assets/social/post_three.png',
    'assets/social/post_one.png',
    'assets/social/post_two.png',
    'assets/social/post_three.png',
    'assets/social/post_one.png',
    'assets/social/post_two.png',
    'assets/social/post_three.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: context.cardColor, borderRadius: radius(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      selectedIndex = 0;
                      setState(() {});
                    },
                    child: Text(
                      'All Post',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: selectedIndex == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: context.width() / 2 - 32,
                    color: selectedIndex == 0
                        ? primaryColor
                        : primaryColor.withOpacity(0.5),
                  ),
                ],
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      selectedIndex = 1;
                      setState(() {});
                    },
                    child: Text(
                      'Mentions',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: selectedIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: context.width() / 2 - 32,
                    color: selectedIndex == 1
                        ? primaryColor
                        : primaryColor.withOpacity(0.5),
                  ),
                ],
              ),
              16.height,
            ],
          ),
          16.height,
          GridView.builder(
            itemCount: allPostList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(allPostList[index],
                      height: 100, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(8);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
          ),
        ],
      ),
    );
  }
}
