// ignore_for_file: file_names

import 'package:app_tuddo_gramado/data/models/SVForumTopicModel.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVForumTopicComponent extends StatefulWidget {
  final bool isFavTab;

  const SVForumTopicComponent({super.key, required this.isFavTab});

  @override
  State<SVForumTopicComponent> createState() => _SVForumTopicComponentState();
}

class _SVForumTopicComponentState extends State<SVForumTopicComponent> {
  List<SVForumTopicModel> topicsList = getTopicsList();
  List<SVForumTopicModel> tempList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('build');
    tempList.clear();
    if (widget.isFavTab) {
      for (var element in topicsList) {
        if (element.isFav.validate()) {
          tempList.add(element);
        }
        setState(() {});
      }
    } else {
      for (var element in topicsList) {
        if (!element.isFav.validate()) {
          tempList.add(element);
        }
        setState(() {});
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Container(
          decoration:
              BoxDecoration(color: context.cardColor, borderRadius: radius(12)),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/social/ic_2User.png',
                          height: 16, width: 16, fit: BoxFit.cover),
                      8.width,
                      Text(tempList[index].name.validate(),
                          style: color94SemiBold16),
                      20.width,
                      Image.asset('assets/social/ic_Folder.png',
                          height: 16, width: 16, fit: BoxFit.cover),
                      8.width,
                      Text(tempList[index].domain.validate(),
                          style: color94SemiBold16),
                    ],
                  ),
                  if (tempList[index].isFav.validate())
                    Image.asset('assets/social/ic_HeartFilled.png',
                        height: 16, width: 16, fit: BoxFit.fill),
                ],
              ),
              12.height,
              Text(tempList[index].title.validate(), style: boldTextStyle()),
              const Divider(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('POST', style: color94SemiBold16),
                      4.height,
                      Text(tempList[index].postNo.validate(),
                          style: color94SemiBold16),
                    ],
                  ),
                  Column(
                    children: [
                      Text('VOICES', style: color94SemiBold16),
                      4.height,
                      Text(tempList[index].voicesNo.validate(),
                          style: color94SemiBold16),
                    ],
                  ),
                  Column(
                    children: [
                      Text('FRESHNESS', style: color94SemiBold16),
                      4.height,
                      Text(tempList[index].freshness.validate(),
                          style: color94SemiBold16),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
      itemCount: tempList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
