// ignore_for_file: deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PatrocinadoresDetailPage extends StatefulWidget {
  int index;
  Patrocinadores patrocinador;

  PatrocinadoresDetailPage({
    super.key,
    required this.patrocinador,
    this.index = 0,
  });

  @override
  State<PatrocinadoresDetailPage> createState() =>
      _PatrocinadoresDetailPageState();
}

class _PatrocinadoresDetailPageState extends State<PatrocinadoresDetailPage> {
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
  }

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
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.patrocinador.imagemBG),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer()
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: .51,
              maxChildSize: .51,
              minChildSize: .51,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return ShaderMask(
                  shaderCallback: (Rect rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        scaffoldColor,
                        transparent.withOpacity(.10),
                        transparent,
                        transparent,
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.patrocinador.nome,
                                  style: whiteSemiBold20,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          widget.patrocinador.isFavorite =
                                              !widget.patrocinador.isFavorite;
                                        });
                                        if (widget.patrocinador.isFavorite ==
                                            true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: primaryColor,
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: Text(
                                                'Adicionado aos Favoritos',
                                                style: whiteRegular16,
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: primaryColor,
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: Text(
                                                'Removido aos Favoritos',
                                                style: whiteRegular16,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: widget.patrocinador.isFavorite
                                          ? SvgPicture.asset(
                                              'assets/icones/heart-2.svg',
                                              color: primaryColor,
                                            )
                                          : SvgPicture.asset(
                                              'assets/icones/heart.svg',
                                              color: primaryColor,
                                            ),
                                    ),
                                    widthSpace10,
                                    GestureDetector(
                                      onTap: () {
                                        _launchUrl(
                                          Uri.parse(
                                            widget.patrocinador.linkInstagram,
                                          ),
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icones/instagram.svg',
                                        color: primaryColor,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            heightSpace5,
                            Row(
                              children: List.generate(
                                5,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: SvgPicture.asset(
                                    'assets/icones/rating_star.svg',
                                    color: starColor,
                                  ),
                                ),
                              ),
                            ),
                            heightSpace5,
                            AutoSizeText(
                              widget.patrocinador.descricao,
                              style: whiteRegular15,
                            ),
                            heightSpace20,
                            GestureDetector(
                              onTap: () {
                                _launchUrl(
                                  Uri.parse(widget.patrocinador.linkEndereco),
                                );
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icones/address.svg',
                                    color: primaryColor,
                                    width: 40,
                                    height: 40,
                                  ),
                                  widthSpace5,
                                  Text(
                                    'Nos encontre',
                                    style: whiteRegular14,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      heightSpace10,
                      widget.patrocinador.galeria == []
                          ? Container()
                          : galeria(),
                      heightSpace30,
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget galeria() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.patrocinador.galeria.length,
        itemBuilder: (context, index) {
          var item = widget.patrocinador.galeria[index];
          return Stack(
            children: [
              Padding(
                padding: index == 0
                    ? const EdgeInsets.only(right: 5)
                    : index == widget.patrocinador.galeria.length - 1
                        ? const EdgeInsets.only(left: 5)
                        : const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _launchUrl(
                          Uri.parse(
                            widget.patrocinador.linkWebSite,
                          ),
                        );
                      },
                      child: Container(
                        height: 90,
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              item.img,
                            ),
                            fit: BoxFit.fill,
                          ),
                          color: color22,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // child: Image.asset(item['image']),
                      ),
                    ),
                    // Text(item['title'], style: whiteRegular15)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
