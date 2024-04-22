// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/helper/ui_helper.dart';
import 'package:app_tuddo_gramado/screens/profile/edit_profile/edit_profile_page_2.dart';
import 'package:app_tuddo_gramado/screens/webscreens/WebViewScreen.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  Usuario usuario;
  ProfilePage({
    required this.usuario,
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool loaded;
  @override
  void initState() {
    loaded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          appBarType(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    ...userDetailMethod(widget.usuario),
                    heightSpace20,
                    ...tapablePanels(context, widget.usuario),
                  ],
                ),
              ],
            ),
          ),
          advertiseContainer(context),
        ],
      ),
    );
  }

  Container appBarType(BuildContext context) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width,
      color: color00,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Perfil', style: whiteBold22),
                GestureDetector(
                  onTap: () {
                    UiHelper.showLogOutDialog(context);
                  },
                  child: Text('Sair', style: primarySemiBold16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> userDetailMethod(Usuario user) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: ChangeNotifierProvider(
          create: (_) => UsuarioProvider(),
          child: Consumer<UsuarioProvider>(builder: (context, provider, child) {
            return Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor,
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: user.photo == ''
                          ? Image.asset(
                              "assets/image/nopicture.png",
                              fit: BoxFit.fill,
                            )
                          : Image.network(
                              user.photo,
                              fit: BoxFit.fill,
                            )),
                ),
                widthSpace20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.nome, style: whiteSemiBold20),
                    Row(
                      children: [
                        SizedBox(
                          child: Image.asset(
                            "assets/icones/crown.png",
                            width: 15,
                            cacheWidth: 15,
                          ),
                        ),
                        widthSpace10,
                        Text(user.photo, style: color94Regular15),
                      ],
                    )
                  ],
                )
              ],
            );
          }),
        ),
      ),
    ];
  }

  List<Widget> tapablePanels(BuildContext context, Usuario usuario) {
    List tapableItems = [
      {
        'icon': 'assets/icones/profile1.png',
        'title': 'Meu Perfil',
        'navigate': '/EditProfilePage'
      },
      {
        'icon': 'assets/icones/heart.svg',
        'title': 'Favoritos',
        'navigate': '/FavoritesListPage'
      },
      {
        'icon': 'assets/icones/profile4.png',
        'title': 'Configurações',
        'navigate': '/SettingsPage'
      },
      {
        'icon': 'assets/icones/profile5.png',
        'title': 'Termos & Condições',
        'navigate': '/TermsAndConditionPage'
      },
      {
        'icon': 'assets/icones/profile6.png',
        'title': 'Suporte',
        'navigate': '/SupportPage',
      },
    ];

    return [
      ...tapableItems.map(
        (e) => ListTile(
          onTap: () {
            if (e['navigate'] == "/TermsAndConditionPage") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    url:
                        "https://wordpress.com/hosting/?aff=13357&url=https://wordpress.com/hosting/%3Fgad_source%3D1&gclid=Cj0KCQjwlN6wBhCcARIsAKZvD5hDxiJrS-k0iSj7iCIBP7DRRYUQ0R7Ed7nTrxeZ4tolemIAT5tGmYsaAiVwEALw_wcB",
                    index: 4,
                  ),
                ),
              );
            } else if (e['navigate'] == "/SupportPage") {
            } else if (e['navigate'] == "/SettingsPage") {
            } else if (e['navigate'] == "/FavoritesListPage") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    url:
                        "https://wordpress.com/hosting/?aff=13357&url=https://wordpress.com/hosting/%3Fgad_source%3D1&gclid=Cj0KCQjwlN6wBhCcARIsAKZvD5hDxiJrS-k0iSj7iCIBP7DRRYUQ0R7Ed7nTrxeZ4tolemIAT5tGmYsaAiVwEALw_wcB",
                    index: 4,
                  ),
                ),
              );
            } else if (e['navigate'] == "/EditProfilePage") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    index: 4,
                    usuario: usuario,
                  ),
                ),
              );
            }
          },
          leading: SizedBox(
            child: e['title'] == 'Favoritos'
                ? SvgPicture.asset(
                    e['icon'],
                    color: primaryColor,
                  )
                : Image.asset(
                    e['icon'],
                    color: color94,
                    width: 30,
                    height: 30,
                  ),
          ),
          title: Text(
            e['title'],
            style: color94Medium18,
          ),
        ),
      ),
    ];
  }

  Widget advertiseContainer(BuildContext context) {
    return SizedBox(
      height: 187,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 100,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                addvertise1(),
                addvertise2(),
                addvertise3(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/SubscribePage');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image.asset(
                      'assets/icones/premiumCrown.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  widthSpace10,
                  Text(
                    'Seja Assinante',
                    style: whiteBold18,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding addvertise3() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 280,
            decoration: BoxDecoration(
              color: color22,
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                image: AssetImage('assets/image/add3.png'),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 100,
            width: 280,
            decoration: BoxDecoration(
                color: color22,
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(colors: [
                  black.withOpacity(.40),
                  black.withOpacity(.40),
                ])),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text('Watch\nPremium Contents', style: whiteSemiBold18),
            ),
          ),
        ],
      ),
    );
  }

  Padding addvertise2() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 280,
            decoration: BoxDecoration(
              color: color22,
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                image: AssetImage('assets/image/add2.png'),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 100,
            width: 280,
            decoration: BoxDecoration(
              color: color22,
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                colors: [
                  black.withOpacity(.40),
                  black.withOpacity(.40),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text('Enable\nDownload Movies', style: whiteSemiBold18),
            ),
          ),
        ],
      ),
    );
  }

  Widget addvertise1() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 280,
            decoration: BoxDecoration(
              color: color22,
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                image: AssetImage('assets/image/add1.png'),
              ),
            ),
          ),
          Container(
            height: 100,
            width: 280,
            decoration: BoxDecoration(
                color: color22,
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(colors: [
                  black.withOpacity(.40),
                  black.withOpacity(.40),
                ])),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text('Get Access to\nAll Full HD\nContents',
                  style: whiteSemiBold18),
            ),
          ),
        ],
      ),
    );
  }
}
