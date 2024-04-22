// ignore_for_file: library_private_types_in_public_api, file_names, deprecated_member_use
import 'package:app_tuddo_gramado/screens/notifications/NotificationScreen.dart';
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
                    top: MediaQuery.of(context).viewPadding.top,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url:
                                "https://www.accuweather.com/pt/br/gramado/40979/weather-forecast/40979",
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
                    left: MediaQuery.of(context).size.width * 0.16,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/image/Tuddo nome branca.png',
                        fit: BoxFit.fill,
                        width: 80,
                        height: 40,
                      ),
                      widthSpace20,
                      Image.asset(
                        'assets/image/Tuddo favicon.png',
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
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
                          Navigator.pushNamed(context, '/NotificationPage');
                        },
                        child: SvgPicture.asset(
                          'assets/icones/heart.svg',
                          color: primaryColor,
                          width: 27,
                          height: 27,
                        ),
                      ),
                      widthSpace5,
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/icones/bell.png',
                          fit: BoxFit.fill,
                          width: 25,
                          height: 27,
                          color: primaryColor,
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
                    carouselMethod(context, heightDisponivel),
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

  CarouselSlider carouselMethod(BuildContext context, double heightDisponivel) {
    return CarouselSlider(
      options: CarouselOptions(
        height: heightDisponivel * 0.6,
        viewportFraction: 0.62,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: PatrocinadoresStore.getPatrocinadores.map((i) {
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: AssetImage(i.imagemBG),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      }).toList(),
    );
  }

  Container categoryMethod(double heightDisponivel) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: SizedBox(
        height: heightDisponivel * 0.07,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: CategoriasButoonStore.getbuttons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var item = CategoriasButoonStore.getbuttons[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  item.route,
                );
              },
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: index == 0
                        ? const EdgeInsets.only(right: 5)
                        : index ==
                                PatrocinadoresStore.getPatrocinadores.length - 1
                            ? const EdgeInsets.only(left: 5)
                            : const EdgeInsets.symmetric(horizontal: 5),
                    width: 120,
                    height: 80,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
