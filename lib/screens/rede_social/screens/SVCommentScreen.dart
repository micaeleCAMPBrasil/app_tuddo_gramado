// ignore_for_file: file_names

import 'package:app_tuddo_gramado/data/models/SVCommentModel.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVCommentComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVCommentReplyComponent.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVCommentScreen extends StatefulWidget {
  const SVCommentScreen({super.key});

  @override
  State<SVCommentScreen> createState() => _SVCommentScreenState();
}

class _SVCommentScreenState extends State<SVCommentScreen> {
  List<SVCommentModel> commentList = [];

  @override
  void initState() {
    commentList = getComments();
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
  }

  @override
  void dispose() {
    setStatusBarColor(scaffoldColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Comments', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: commentList.map((e) {
                return SVCommentComponent(comment: e);
              }).toList(),
            ),
          ),
          const SVCommentReplyComponent(),
        ],
      ),
    );
  }
}
