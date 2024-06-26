// ignore_for_file: file_names

import 'package:app_tuddo_gramado/screens/rede_social/components/SVProfileHeaderComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVProfilePostsComponent.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVGroupProfileScreen extends StatelessWidget {
  const SVGroupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Group', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SVProfileHeaderComponent(),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Avengers Group', style: boldTextStyle(size: 20)),
                4.width,
                Image.asset('assets/social/ic_TickSquare.png',
                    height: 14, width: 14, fit: BoxFit.cover),
              ],
            ),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/social/ic_GlobeAntarctic.png',
                  height: 16,
                  width: 16,
                  fit: BoxFit.cover,
                  color: context.iconColor,
                ),
                8.width,
                Text('Public Group', style: color94SemiBold16),
                18.width,
                Image.asset(
                  'assets/social/ic_Calendar.png',
                  height: 16,
                  width: 16,
                  fit: BoxFit.cover,
                  color: context.iconColor,
                ),
                8.width,
                Text('03 Years Ago', style: color94SemiBold16),
              ],
            ),
            16.height,
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: context.cardColor, borderRadius: radius(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: radius(100)),
                              child: Image.asset('assets/social/face_2.png',
                                      height: 32, width: 32, fit: BoxFit.cover)
                                  .cornerRadiusWithClipRRect(100),
                            ),
                            Positioned(
                              left: 14,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: radius(100)),
                                child: Image.asset('assets/social/face_3.png',
                                        height: 32,
                                        width: 32,
                                        fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRect(100),
                              ),
                            ),
                            Positioned(
                              left: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: radius(100)),
                                child: Image.asset('assets/social/face_4.png',
                                        height: 32,
                                        width: 32,
                                        fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRect(100),
                              ),
                            ),
                            Positioned(
                              left: 46,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: radius(100)),
                                child: Image.asset('assets/social/face_5.png',
                                        height: 32,
                                        width: 32,
                                        fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRect(100),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: radius(100)),
                                child: Image.asset('assets/social/face_1.png',
                                        height: 32,
                                        width: 32,
                                        fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRect(100),
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.width,
                      Text('+6 Members',
                          style: secondaryTextStyle(color: context.iconColor)),
                    ],
                  ),
                  28.height,
                  AppButton(
                    shapeBorder:
                        RoundedRectangleBorder(borderRadius: radius(4)),
                    text: 'Join Group',
                    textStyle: boldTextStyle(color: Colors.white),
                    onTap: () {},
                    elevation: 0,
                    color: primaryColor,
                    width: context.width() - 64,
                  ),
                  10.height,
                ],
              ),
            ),
            16.height,
            const SVProfilePostsComponent(),
            16.height,
          ],
        ),
      ),
    );
  }
}
