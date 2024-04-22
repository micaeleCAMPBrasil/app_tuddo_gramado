// ignore_for_file: file_names

import 'dart:io';

import 'package:app_tuddo_gramado/screens/rede_social/components/SVHomeDrawerComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVPostComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVStoryComponent.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVHomeFragment extends StatefulWidget {
  const SVHomeFragment({super.key});

  @override
  State<SVHomeFragment> createState() => _SVHomeFragmentState();
}

class _SVHomeFragmentState extends State<SVHomeFragment> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  File? image;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(scaffoldColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/icones/ic_More.png',
            width: 18,
            height: 18,
            fit: BoxFit.cover,
            color: context.iconColor,
          ),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text('Home', style: boldTextStyle(size: 18)),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icones/ic_Camera.png',
              width: 24,
              height: 22,
              fit: BoxFit.fill,
              color: context.iconColor,
            ),
            onPressed: () async {
              image = await svGetImageSource();
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: context.cardColor,
        child: const SVHomeDrawerComponent(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            16.height,
            const SVStoryComponent(),
            16.height,
            const SVPostComponent(),
            16.height,
          ],
        ),
      ),
    );
  }
}
