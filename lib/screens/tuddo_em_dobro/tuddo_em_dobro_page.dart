// ignore_for_file: deprecated_member_use

import 'package:app_tuddo_gramado/data/models/modalidades_td.dart';
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/data/php/api_service.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
class TuddoemDobroScreen extends StatefulWidget {
  int index;

  TuddoemDobroScreen({
    super.key,
    this.index = 0,
  });

  @override
  State<TuddoemDobroScreen> createState() => _TuddoemDobroScreenState();
}

class _TuddoemDobroScreenState extends State<TuddoemDobroScreen> {
  late APIService apiService;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  Widget _modalidadesList() {
    return FutureBuilder(
      future: apiService.getModalidades(),
      builder: (BuildContext context, AsyncSnapshot<List<Modalidade>> model) {
        if (model.hasData) {
          return const Text('Sucesso');
          //return _buildCategoryList(model.data);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildCategoryList(List<Modalidade>? modalidade) {
    return Container(
      height: 150,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: modalidade?.length,
        itemBuilder: (context, index) {
          var data = modalidade![index];
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 5),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Image.network(
                  data.image!.url,
                  height: 80,
                ),
              ),
              Row(
                children: [
                  Text(
                    data.nome.toString(),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool checksize = MediaQuery.of(context).size.width <= 320 ||
            MediaQuery.of(context).size.height <= 320
        ? true
        : false;

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
        body:
            _modalidadesList(), /*ValueListenableBuilder<List<Patrocinadores>>(
          valueListenable: apiService.listPatrocinadores,
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
                                  runSpacing: checksize ? 1 : 12,
                                  spacing: checksize ? 4 : 16,
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
                                        child: SizedBox(
                                          height: 250,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.43,
                                          child: Image(
                                            image: CachedNetworkImageProvider(
                                              list[index].imagemBG,
                                            ),
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ), /*CachedNetworkImage(
                                          imageUrl: list[index].imagemBG,
                                          /*progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.error,
                                            color: primaryColor,
                                          ),*/
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 250,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.43,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ).cornerRadiusWithClipRRect(16),
                                              10.height,
                                              Text(
                                                list[index].nome,
                                                style: whiteRegular16,
                                              ).paddingLeft(8),
                                            ],
                                          ),
                                        ),*/
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
                                      url:
                                          "https://tuddogramado.com.br/venda-mais-com-tuddo-em-dobro/",
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
        ),*/
      ),
    );
  }

  /*Widget appBarLikeMethod() {
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
  }*/
}
