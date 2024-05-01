// ignore_for_file: deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:share_plus/share_plus.dart';
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
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {
          _loading = true;
        });
      },
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
  }

  void shareMensagem() {
    String mensagem = "Olha que lugar legal ${widget.patrocinador.linkWebSite}";
    Share.share(
      mensagem,
    );
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
      child: _loading
          ? Scaffold(
              extendBodyBehindAppBar: true,
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(56),
                child: MyAppBar(),
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.patrocinador.logo,
                        /*progressIndicatorBuilder:
                            (context, url, downloadProgress) => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: primaryColor,
                        ),*/
                        imageBuilder: (context, imageProvider) => Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
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
                    builder: (BuildContext context,
                        ScrollController scrollController) {
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
                            heightSpace20,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.patrocinador.nome,
                                        style: whiteSemiBold20,
                                      ),
                                      Row(
                                        children: [
                                          widget.patrocinador.linkInstagram ==
                                                  ''
                                              ? widthSpace10
                                              : GestureDetector(
                                                  onTap: () {
                                                    _launchUrl(
                                                      Uri.parse(
                                                        widget.patrocinador
                                                            .linkInstagram,
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
                                          widthSpace10,
                                          GestureDetector(
                                            onTap: shareMensagem,
                                            child: Icon(
                                              Icons.share_outlined,
                                              color: primaryColor,
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
                                        padding:
                                            const EdgeInsets.only(right: 5),
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
                                  widget.patrocinador.isMostrarSite
                                      ? GestureDetector(
                                          onTap: () {
                                            _launchUrl(
                                              Uri.parse(widget
                                                  .patrocinador.linkWebSite),
                                            );
                                          },
                                          child: Text(
                                            widget.patrocinador.linkWebSite,
                                            style: whiteRegular14,
                                          ),
                                        )
                                      : heightSpace20,
                                  widget.patrocinador.linkEndereco == ''
                                      ? heightSpace5
                                      : GestureDetector(
                                          onTap: () {
                                            _launchUrl(
                                              Uri.parse(widget
                                                  .patrocinador.linkEndereco),
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
            )
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
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
                      child: CachedNetworkImage(
                        imageUrl: item.img,
                        /*progressIndicatorBuilder:
                            (context, url, downloadProgress) => SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: primaryColor,
                        ),*/
                        imageBuilder: (context, imageProvider) => Container(
                          height: 90,
                          width: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: color22,
                          ),
                        ),
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
