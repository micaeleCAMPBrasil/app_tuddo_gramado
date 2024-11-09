// ignore_for_file: file_names, deprecated_member_use

import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatefulWidget {
  int index;

  NotificationScreen({
    super.key,
    this.index = 0,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

List notificationList = [
  {
    'title': 'Upgrade premium now',
    'subtitle':
        'Lorem ipsum dolor sit amet, consectetur Ipsun adipiscing elit. Ipsum, placerat nunc.',
    'time': 'Today'
  },
  {
    'title': 'You haven’t watched The Crown.',
    'subtitle':
        'Lorem ipsum dolor sit amet, consectetur Ipsun adipiscing elit. Ipsum, placerat nunc.',
    'time': 'Today'
  },
  {
    'title': 'Watch now new trending movies',
    'subtitle':
        'Lorem ipsum dolor sit amet, consectetur Ipsun adipiscing elit. Ipsum, placerat nunc.',
    'time': 'Today'
  },
];

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ControlNav>(context, listen: false)
            .updateIndex(widget.index, 0);
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(
              selectedIndex: widget.index,
            ),
          ),
        );*/
        return true;
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: MyAppBar(
              backgroundColor: color00,
            ),
          ),
          body: notificationList.isNotEmpty
              ? activeNotifiaction()
              : emptyNotificationMethod()),
    );
  }

  ListView activeNotifiaction() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        var item = notificationList[index];
        return Dismissible(
          onDismissed: (direction) {
            setState(() {
              notificationList.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: primaryColor,
                duration: const Duration(seconds: 1),
                content: Text(
                  "${item['title']} dismissed",
                  style: whiteRegular16,
                ),
              ),
            );
          },
          background: Container(
            color: Colors.red,
            margin: const EdgeInsets.only(bottom: 5),
          ),
          key: Key('$item'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                heightSpace15,
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 20,
                      child: Image.asset(
                        'assets/icones/bell.png',
                        fit: BoxFit.fill,
                        width: 15,
                        height: 17,
                        color: white,
                      ),
                    ),
                    widthSpace20,
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                item['title'],
                                maxLines: 3,
                                overflow: TextOverflow.fade,
                                style: whiteMedium18,
                              ),
                              Text(
                                'Today',
                                style: color94Regular12,
                              )
                            ],
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur Ipsun adipiscing elit. Ipsum, placerat nunc.',
                            style: color94Regular15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                heightSpace10,
                Divider(
                  color: color28,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget emptyNotificationMethod() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icones/bell.png',
              fit: BoxFit.fill,
              width: 25,
              height: 27,
              color: white,
            ),
            heightSpace10,
            Text('No new notification', style: color94Medium18)
          ],
        ),
      ),
    );
  }
}
