// ignore_for_file: deprecated_member_use

import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final PatrocinadoresStore controller = PatrocinadoresStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

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
        body: ValueListenableBuilder<List<Patrocinadores>>(
          valueListenable: controller.listPatrocinadores,
          builder: (context, list, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  appBarLikeMethod(),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                right: 16,
                                left: 16,
                              ),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  runSpacing: 12,
                                  spacing: 16,
                                  children: List.generate(
                                    list.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PatrocinadoresDetailPage(
                                                patrocinador: list[index],
                                                index: 2,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(list[index].imagemBG,
                                                    height: 250,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.43,
                                                    fit: BoxFit.cover)
                                                .cornerRadiusWithClipRRect(16),
                                            10.height,
                                            Text(
                                              list[index].nome,
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
                                  gradient: LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                  ),
                                ),
                                child: Text(
                                  "Faça Parte!".toUpperCase(),
                                  style: whiteRegular16,
                                ),
                              ).onTap(() {
                                // IR P OUTRA
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(
                                      index: 2,
                                      url: "https://www.google.com/",
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget appBarLikeMethod() {
    return Container(
      height: 120,
      color: color00,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: color28,
              ),
              child: Row(children: [
                SizedBox(
                  height: 25,
                  child: SvgPicture.asset(
                    'assets/icones/search.svg',
                    color: primaryColor,
                    width: 27,
                    height: 27,
                  ),
                ),
                widthSpace10,
                Expanded(
                  child: TextField(
                    cursorColor: primaryColor,
                    onChanged: controller.onChange,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Digite...',
                      hintStyle: color94Regular15,
                    ),
                  ),
                )
              ]),
            ),
            heightSpace15,
          ],
        ),
      ),
    );
  }
}
