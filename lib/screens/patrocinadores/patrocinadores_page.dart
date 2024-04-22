// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:app_tuddo_gramado/data/stores/patrocinadores_store.dart';
import 'package:app_tuddo_gramado/screens/patrocinadores/patrocinadores_detail_page.dart';
import 'package:app_tuddo_gramado/screens/webscreens/WebViewScreen.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';

// ignore: must_be_immutable
class PatrocinadoresScreen extends StatefulWidget {
  int index;

  PatrocinadoresScreen({
    super.key,
    this.index = 0,
  });

  @override
  State<PatrocinadoresScreen> createState() => _PatrocinadoresScreenState();
}

class _PatrocinadoresScreenState extends State<PatrocinadoresScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(
              selectedIndex: widget.index,
            ),
          ),
        );
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: MyAppBar(),
        ),
        //appBar: getAppBar("Select #Hashtag", backWidget: BackButton(color: white)),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                right: 16,
                left: 16,
                top: MediaQuery.of(context).padding.top +
                    (MediaQuery.of(context).size.width * 0.1),
                bottom: 80,
              ),
              child: Wrap(
                runSpacing: 12,
                spacing: 16,
                children: List.generate(
                  PatrocinadoresStore.getPatrocinadores.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatrocinadoresDetailPage(
                              patrocinador:
                                  PatrocinadoresStore.getPatrocinadores[index],
                              index: 2,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                                  PatrocinadoresStore
                                      .getPatrocinadores[index].imagemBG,
                                  height: 250,
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  fit: BoxFit.cover)
                              .cornerRadiusWithClipRRect(16),
                          10.height,
                          Text(
                            PatrocinadoresStore.getPatrocinadores[index].nome,
                            style: whiteRegular16,
                          ).paddingLeft(8),
                          /*Text(PatrocinadoresStore.getPatrocinadores[index].nome,
                                  style: secondaryTextStyle())
                              .paddingLeft(8),*/
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 4,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(20),
                width: context.width(),
                height: 50,
                decoration: boxDecorationWithShadow(
                    borderRadius: radius(24),
                    gradient:
                        LinearGradient(colors: [primaryColor, secondaryColor])),
                child: Text(
                  "Faça Parte!".toUpperCase(),
                  style: whiteRegular16,
                ),
              ).onTap(() {
                // IR P OUTRA
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    url: "https://www.google.com/",
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
