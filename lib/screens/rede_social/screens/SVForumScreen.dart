// ignore_for_file: file_names

import 'package:app_tuddo_gramado/screens/rede_social/components/SVForumRepliesComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVForumTopicComponent.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVForumScreen extends StatefulWidget {
  const SVForumScreen({super.key});

  @override
  State<SVForumScreen> createState() => _SVForumScreenState();
}

class _SVForumScreenState extends State<SVForumScreen> {
  List<String> tabList = ['Topics', 'Replies', 'Engagement', 'Favourite'];

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget getTabContainer() {
    if (selectedTab == 0) {
      return const SVForumTopicComponent(isFavTab: false);
    } else if (selectedTab == 1) {
      return SVForumRepliesComponent();
    } else if (selectedTab == 2) {
      return const Offstage();
    } else
      // ignore: curly_braces_in_flow_control_structures
      return const SVForumTopicComponent(isFavTab: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: color00,
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Forum', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: context.cardColor, borderRadius: radius(8)),
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
                    color: Colors.white,
                  ).paddingAll(16),
                ),
              ),
            ),
            HorizontalList(
              spacing: 0,
              padding: const EdgeInsets.all(16),
              itemCount: tabList.length,
              itemBuilder: (context, index) {
                return AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(8)),
                  text: tabList[index],
                  textStyle: boldTextStyle(
                      color: selectedTab == index ? Colors.white : primaryColor,
                      size: 14),
                  onTap: () {
                    selectedTab = index;
                    setState(() {});
                  },
                  elevation: 0,
                  color: selectedTab == index ? primaryColor : secondaryColor,
                );
              },
            ),
            getTabContainer(),
          ],
        ),
      ),
    );
  }
}
