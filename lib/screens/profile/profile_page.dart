// ignore_for_file: deprecated_member_use

import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/data/stores/patrocinadores_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/helper/ui_helper.dart';
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
  /*Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
  }*/

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
                        : /*Image.network(
                              user.photo,
                              fit: BoxFit.cover,
                            ),*/
                        Image(
                            image: CachedNetworkImageProvider(
                              user.photo,
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
                widthSpace20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.nome,
                      style: whiteSemiBold20,
                      overflow: TextOverflow.ellipsis,
                    ),
                    /*Row(
                      children: [
                        SizedBox(
                          child: Image.asset(
                            "assets/icones/crown.png",
                            width: 15,
                            cacheWidth: 15,
                          ),
                        ),
                        widthSpace10,
                        //Text('Non-Premium', style: color94Regular15),
                      ],
                    )*/
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
        'icon': 'assets/icones/profile6.png',
        'title': 'Suporte',
        'navigate': '/SupportPage',
      },
      {
        'icon': 'assets/icones/tickets-icon.svg',
        'title': 'Meus Pedidos',
        'navigate': '/MeusPedidosTuddoEmDobro',
      },
      {
        'icon': 'assets/icones/tickets-icon.svg',
        'title': 'Painel de Afiliado',
        'navigate': '/PaineldeAfiliado',
      },
    ];

    return [
      ...tapableItems.map(
        (e) => ListTile(
          onTap: () {
            if (e['navigate'] == "/SupportPage") {
              Provider.of<ControlNav>(context, listen: false).updateIndex(4, 1);

              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InAppView(
                    url: "https://www.google.com/",
                    index: 4,
                    data: {
                      "token": widget.usuario.token,
                      "usuario": widget.usuario.email,
                      "senha": widget.usuario.uid,
                    },
                    routa: MaterialPageRoute(
                      builder: (context) => BottomNavigation(
                        selectedIndex: 4,
                      ),
                    ),
                  ),
                ),
              );*/
            } else if (e['navigate'] == "/FavoritesListPage") {
              Provider.of<ControlNav>(context, listen: false).updateIndex(4, 2);
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InAppView(
                    url:
                        "https://d.tuddogramado.com.br/member-account/?vendor=wishlist",
                    index: 4,
                    data: {
                      "token": widget.usuario.token,
                      "usuario": widget.usuario.email,
                      "senha": widget.usuario.uid,
                    },
                    routa: MaterialPageRoute(
                      builder: (context) => BottomNavigation(
                        selectedIndex: 4,
                      ),
                    ),
                  ),
                ),
              );*/
            } else if (e['navigate'] == "/EditProfilePage") {
              Provider.of<ControlNav>(context, listen: false).updateIndex(4, 4);
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    index: 4,
                    usuario: usuario,
                  ),
                ),
              );*/
            } else if (e['navigate'] == "/MeusPedidosTuddoEmDobro") {
              Provider.of<ControlNav>(context, listen: false).updateIndex(4, 3);
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InAppView(
                    url:
                        "https://d.tuddogramado.com.br/member-account/?vendor=mybookings",
                    index: 4,
                    data: {
                      "token": widget.usuario.token,
                      "usuario": widget.usuario.email,
                      "senha": widget.usuario.uid,
                    },
                    routa: MaterialPageRoute(
                      builder: (context) => BottomNavigation(
                        selectedIndex: 4,
                      ),
                    ),
                  ),
                ),
              );*/
            } else if (e['navigate'] == "/PaineldeAfiliado") {
              Provider.of<ControlNav>(context, listen: false).updateIndex(4, 7);
            }
          },
          leading: SizedBox(
            child: e['title'] == 'Favoritos' || e['title'] == 'Meus Pedidos'
                ? SvgPicture.asset(
                    e['icon'],
                    color: color94,
                    width: 30,
                    height: 30,
                  )
                : e['title'] == 'Painel de Afiliado'
                    ? Icon(
                        Icons.monetization_on_outlined,
                        color: color94,
                        size: 30,
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

  // Parte Final

  final PatrocinadoresStore controller = PatrocinadoresStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  Widget advertiseContainer(BuildContext context) {
    return SizedBox(
      height: 187,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 100,
            child: ValueListenableBuilder<List<Patrocinadores>>(
              valueListenable: controller.listPatrocinadores,
              builder: (context, list, child) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return addvertise(list[index]);
                  },
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<ControlNav>(context, listen: false).updateIndex(4, 5);
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
                  /*SizedBox(
                    child: Image.asset(
                      "assets/icones/crown.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  widthSpace10,
                  */
                  Text(
                    'Faça Parte',
                    style: blackBold18,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget addvertise(Patrocinadores item) {
    return GestureDetector(
      onTap: () {
        Provider.of<ControlNav>(context, listen: false)
            .updatepatrocinador(item);
        Provider.of<ControlNav>(context, listen: false).updateIndex(2, 2);
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PatrocinadoresDetailPage(
              patrocinador: item,
              //index: 4,
              /*routa: MaterialPageRoute(
                builder: (context) => ProfilePage(
                  usuario: widget.usuario,
                ),
              ),*/
            ),
          ),
        );*/
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Stack(
          children: [
            Container(
              height: 100,
              width: 280,
              decoration: BoxDecoration(
                color: color22,
                borderRadius: BorderRadius.circular(5),
                /*image: DecorationImage(
                  image: NetworkImage(item.imagemBG),
                  fit: BoxFit.cover,
                ),*/
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
            Container(
              height: 100,
              width: 280,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: color22,
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(colors: [
                    black.withOpacity(.40),
                    black.withOpacity(.40),
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  item.nome,
                  style: whiteSemiBold18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
