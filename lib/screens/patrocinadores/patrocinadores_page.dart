// ignore_for_file: deprecated_member_use

import 'package:app_tuddo_gramado/data/models/categoriasButton.dart';
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/categorias_button_store.dart';
import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/data/stores/patrocinadores_store.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NewPatrocinadoresScreen extends StatefulWidget {
  Usuario usuario;
  NewPatrocinadoresScreen({super.key, required this.usuario});

  @override
  // ignore: library_private_types_in_public_api
  _NewPatrocinadoresScreenState createState() =>
      _NewPatrocinadoresScreenState();
}

class _NewPatrocinadoresScreenState extends State<NewPatrocinadoresScreen> {
  GlobalKey<FormState> mykey = GlobalKey<FormState>();

  final PatrocinadoresStore controller = PatrocinadoresStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightDisponivel = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 110,
            color: color00,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 10,
                    top: MediaQuery.of(context).viewPadding.top,
                    left: MediaQuery.of(context).size.width * 0.01,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/image/Tuddo logo branca.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: controller.listBannerInicial,
                      builder: (context, value, child) {
                        return banner(context, heightDisponivel, value);
                      },
                    ),
                    heightSpace10,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          Text('O que você precisa?', style: whiteSemiBold20),
                    ),
                    heightSpace10,
                    categoryMethod(heightDisponivel),
                    heightSpace10,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Mais Pedidos', style: whiteSemiBold20),
                    ),
                    heightSpace10,
                    continueWatchingMethod(),
                    heightSpace30,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CarouselSlider banner(BuildContext context, double heightDisponivel,
      List<Patrocinadores> list) {
    return CarouselSlider(
      options: CarouselOptions(
        height: heightDisponivel * 0.5,
        viewportFraction: 0.65,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: list.map((i) {
        return GestureDetector(
          onTap: () {
            Provider.of<ControlNav>(context, listen: false)
                .updatepatrocinador(i);
            Provider.of<ControlNav>(context, listen: false).updateIndex(2, 2);

            /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PatrocinadoresDetailPage(
                  patrocinador: i,
                  routa: MaterialPageRoute(
                    builder: (context) => BottomNavigation(
                      selectedIndex: 0,
                    ),
                  ),
                ),
              ),
            );*/
          },
          child: Image(
            image: CachedNetworkImageProvider(
              i.imagemMaster,
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              );
            },
          ), /*CachedNetworkImage(
            imageUrl: i.imagemBG,
            imageBuilder: (context, imageProvider) => Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),*/
          /*child: ,*/
        );
      }).toList(),
    );
  }

  Container categoryMethod(double heightDisponivel) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: ValueListenableBuilder<List<CategoriasButoon>>(
        valueListenable: controller.listCategorias,
        builder: (context, list, child) {
          return SizedBox(
            height: heightDisponivel * 0.1,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var item = list[index];
                return GestureDetector(
                  onTap: () {
                    /*Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatrocinadoresScreen(
                        idCategoria: item.route,
                        usuario: widget.usuario,
                        index: 2,
                      ),
                    ),
                  );*/
                    Provider.of<ControlNav>(context, listen: false)
                        .updateidcategori(item.route);

                    debugPrint('route ${item.route}');

                    if (item.route == 0) {
                      Provider.of<ControlNav>(context, listen: false)
                          .updateIndex(0, 6);
                    } else {
                      Provider.of<ControlNav>(context, listen: false)
                          .updateIndex(2, 1);
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: index == 0
                            ? const EdgeInsets.only(right: 5)
                            : index ==
                                    CategoriasButoonStore.getbuttons.length - 1
                                ? const EdgeInsets.only(left: 5)
                                : const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.name,
                            style: whiteMedium14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        margin: index == 0
                            ? const EdgeInsets.only(right: 5)
                            : index ==
                                    CategoriasButoonStore.getbuttons.length - 1
                                ? const EdgeInsets.only(left: 5)
                                : const EdgeInsets.symmetric(horizontal: 5),
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                black,
                                black,
                              ]),
                          borderRadius: BorderRadius.circular(5),
                          /*image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            item.backgroundImage,
                          ),
                          fit: BoxFit.fill,
                        ),*/
                        ),
                        child: Image(
                          image: CachedNetworkImageProvider(
                            item.backgroundImage,
                          ),
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: index == 0
                            ? const EdgeInsets.only(right: 5)
                            : index ==
                                    CategoriasButoonStore.getbuttons.length - 1
                                ? const EdgeInsets.only(left: 5)
                                : const EdgeInsets.symmetric(horizontal: 5),
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                black.withOpacity(.65),
                                black.withOpacity(.65),
                              ]),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item.name,
                          style: whiteMedium14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  SizedBox continueWatchingMethod() {
    return SizedBox(
      height: 180,
      child: ValueListenableBuilder<List<Patrocinadores>>(
          valueListenable: controller.listPatrocinadores,
          builder: (context, list, child) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];

                return GestureDetector(
                  onTap: () {
                    Provider.of<ControlNav>(context, listen: false)
                        .updatepatrocinador(item);
                    Provider.of<ControlNav>(context, listen: false)
                        .updateIndex(2, 3);
                    /*Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatrocinadoresDetailPage(
                          patrocinador: item,
                          routa: MaterialPageRoute(
                            builder: (context) => NewPatrocinadoresScreen(
                              usuario: widget.usuario,
                            ),
                          ),
                        ),
                      ),
                    );*/
                  },
                  child: Padding(
                    padding: index == 0
                        ? const EdgeInsets.only(right: 5)
                        : index == list.length - 1
                            ? const EdgeInsets.only(left: 5)
                            : const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      height: 180,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: color22,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image(
                        image: CachedNetworkImageProvider(
                          item.imagemBusca,
                        ),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

// ignore: must_be_immutable
class PatrocinadoresScreen extends StatefulWidget {
  int index, idCategoria;
  Usuario usuario;

  PatrocinadoresScreen({
    super.key,
    this.index = 0,
    required this.usuario,
    required this.idCategoria,
  });

  @override
  State<PatrocinadoresScreen> createState() => _PatrocinadoresScreenState();
}

class _PatrocinadoresScreenState extends State<PatrocinadoresScreen> {
  PatrocinadoresStore? controller;

  @override
  void initState() {
    controller = PatrocinadoresStore(
      idCategoria: widget.idCategoria,
      repository: IFuncoesPHP(
        client: HttpClient(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool checksize = MediaQuery.of(context).size.width <= 320 ||
            MediaQuery.of(context).size.height <= 320
        ? true
        : false;

    return WillPopScope(
      onWillPop: () async {
        Provider.of<ControlNav>(context, listen: false).updateIndex(0, 0);
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
        extendBodyBehindAppBar: true,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: MyAppBar(),
        ),
        //appBar: getAppBar("Select #Hashtag", backWidget: BackButton(color: white)),
        body: ValueListenableBuilder<List<Patrocinadores>>(
          valueListenable: controller!.listPatrocinadoresCategories,
          builder: (context, list, child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          Provider.of<ControlNav>(context,
                                                  listen: false)
                                              .updatepatrocinador(list[index]);
                                          Provider.of<ControlNav>(context,
                                                  listen: false)
                                              .updateIndex(2, 3);
                                          /*Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PatrocinadoresDetailPage(
                                                patrocinador: list[index],
                                                index: 2,
                                                routa: MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewPatrocinadoresScreen(
                                                    usuario: widget.usuario,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );*/
                                        },
                                        child: SizedBox(
                                          height: 250,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.43,
                                          child: Image(
                                            image: CachedNetworkImageProvider(
                                              list[index].imagemBusca,
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
                            /*Positioned(
                              left: 0,
                              right: 0,
                              bottom: 4,
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
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
                                    builder: (context) => InAppView(
                                      index: 2,
                                      url:
                                          "https://tuddogramado.com.br/venda-mais-com-tuddo-em-dobro/",
                                      data: {
                                        "token": widget.usuario.token,
                                        "usuario": widget.usuario.email,
                                        "senha": widget.usuario.uid,
                                      },
                                      routa: MaterialPageRoute(
                                        builder: (context) => BottomNavigation(
                                          selectedIndex: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),*/
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
                    onChanged: controller!.onChange,
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
