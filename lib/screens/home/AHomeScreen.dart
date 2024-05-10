// ignore_for_file: library_private_types_in_public_api, file_names, deprecated_member_use
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/screens/patrocinadores/patrocinadores_page.dart';
import 'package:app_tuddo_gramado/screens/rede_social/SVHomeFragment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/stores/categorias_button_store.dart';
import 'package:app_tuddo_gramado/data/stores/patrocinadores_store.dart';
import 'package:app_tuddo_gramado/screens/patrocinadores/patrocinadores_detail_page.dart';
import 'package:app_tuddo_gramado/screens/webscreens/WebViewScreen.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';

// ignore: must_be_immutable
class AHomeScreen extends StatefulWidget {
  Usuario usuario;
  AHomeScreen({super.key, required this.usuario});

  @override
  _AHomeScreenState createState() => _AHomeScreenState();
}

class _AHomeScreenState extends State<AHomeScreen> {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url: "https://tuddogramado.com.br/clima/",
                            index: 0,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/icones/clima.png',
                      fit: BoxFit.fill,
                      width: 25,
                      height: 25,
                      color: primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 10,
                    top: MediaQuery.of(context).viewPadding.top,
                    left: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/image/Tuddo logo branca.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 10,
                    top: MediaQuery.of(context).viewPadding.top,
                    left: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                index: 0,
                                url:
                                    "https://tuddogramado.com.br/my-favorites/",
                              ),
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/icones/heart.svg',
                          color: primaryColor,
                          width: 27,
                          height: 27,
                        ),
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
                    heightSpace25,
                    ValueListenableBuilder(
                      valueListenable: controller.listBannerInicial,
                      builder: (context, value, child) {
                        return banner(context, heightDisponivel, value);
                      },
                    ),
                    heightSpace25,
                    categoryMethod(heightDisponivel),
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
        height: heightDisponivel * 0.6,
        viewportFraction: 0.75,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: list.map((i) {
        return GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PatrocinadoresDetailPage(
                  patrocinador: i,
                ),
              ),
            );
          },
          child: Image(
            image: CachedNetworkImageProvider(
              i.imagemBG,
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
      child: SizedBox(
        height: heightDisponivel * 0.1,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: CategoriasButoonStore.getbuttons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var item = CategoriasButoonStore.getbuttons[index];
            return GestureDetector(
              onTap: () {
                if (item.route == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatrocinadoresScreen(),
                    ),
                  );
                } else if (item.route == 2) {
                  //Tuddo em Dobro
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: "https://dobro.tuddogramado.com.br/",
                      ),
                    ),
                  );
                } else if (item.route == 3) {
                  // Transfer
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url:
                            "https://tuddogramado.com.br/transfer-aeroporto-x-gramado/",
                      ),
                    ),
                  );
                } else if (item.route == 4) {
                  // Hospedagem
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: "https://tuddogramado.com.br/",
                      ),
                    ),
                  );
                } else if (item.route == 5) {
                  // Dicas e Roteiros
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SVHomeFragment(),
                    ),
                  );
                } else if (item.route == 6) {
                  // Assine
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: "https://dobro.tuddogramado.com.br/planos/",
                      ),
                    ),
                  );
                } else if (item.route == 7) {
                  // Faça Parte
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url:
                            "https://tuddogramado.com.br/venda-mais-com-tuddo-em-dobro/",
                      ),
                    ),
                  );
                }
              },
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: index == 0
                        ? const EdgeInsets.only(right: 5)
                        : index == CategoriasButoonStore.getbuttons.length - 1
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
                        : index == CategoriasButoonStore.getbuttons.length - 1
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
                      image: DecorationImage(
                        image: AssetImage(
                          item.backgroundImage,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: index == 0
                        ? const EdgeInsets.only(right: 5)
                        : index == CategoriasButoonStore.getbuttons.length - 1
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
      ),
    );
  }
}
