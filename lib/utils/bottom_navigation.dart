// ignore_for_file: deprecated_member_use, must_be_immutable
import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';
import 'package:app_tuddo_gramado/data/php/api_service.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/data/stores/patrocinadores_store.dart';
import 'package:app_tuddo_gramado/screens/patrocinadores/patrocinadores_detail_page.dart';
import 'package:app_tuddo_gramado/screens/profile/edit_profile/edit_profile_page.dart';
import 'package:app_tuddo_gramado/screens/profile/subscribe_page.dart';
import 'package:app_tuddo_gramado/screens/rede_social/SVHomeFragment.dart';
import 'package:app_tuddo_gramado/screens/rede_social/screens/SVCommentScreen.dart';
import 'package:app_tuddo_gramado/screens/rede_social/screens/SVPostAdd.dart';
import 'package:app_tuddo_gramado/screens/rede_social/screens/SVPostUpdate.dart';
import 'package:app_tuddo_gramado/screens/webscreens/InAppView.dart';
import 'package:app_tuddo_gramado/services/firebase_messaging_service.dart';
import 'package:app_tuddo_gramado/services/login_wordpress.dart';
import 'package:app_tuddo_gramado/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/screens/home/AHomeScreen.dart';
import 'package:app_tuddo_gramado/screens/patrocinadores/patrocinadores_page.dart';
import 'package:app_tuddo_gramado/screens/profile/profile_page.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';

class BottomNavigation extends StatefulWidget {
  //int selectedIndex;

  const BottomNavigation({
    super.key,
    //this.selectedIndex = 0,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<List<Widget>> _widgetOptions = [];

  final PatrocinadoresStore controllerPatrocinador = PatrocinadoresStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    initializeFirebaseMessaging();
    checkNotifications();
  }

  IFuncoesPHP funcoes = IFuncoesPHP(
    client: HttpClient(),
  );

  initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false)
        .initialize();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false)
        .checkForNotifications();
  }

  APIService apiService = APIService();

  cadastrousuario(Usuario usuario) async {
    List<String> split = usuario.nome.split(' ');
    String primeiroNome = split[0] == '' ? '' : split[0].toUpperCase();
    String segundoNome = split.length <= 1
        ? ''
        : split[1] == ''
            ? ''
            : split[1].toUpperCase();

    CustomerModel model = CustomerModel(
      email: usuario.email,
      displayName: usuario.nome,
      firstName: primeiroNome,
      lastName: segundoNome,
      password: usuario.uid,
      roles: [''],
    );

    //await apiService.getIdTG(Config.tokenURLTG, usuario.email, usuario.uid);

    await apiService.criandonovousuarioTuddoGramado(model);

    await apiService.criandonovousuarioTransfer(model);

    await apiService.criandonovousuarioTuddoDobro(model);
  }

  late InAppWebViewController webView;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    Usuario usuario = Provider.of<UsuarioProvider>(context).getUsuario;
    Routa routa = Provider.of<ControlNav>(context).getrouta;
    cadastrousuario(usuario);
    int routaCategoriaPatrocinador =
        Provider.of<ControlNav>(context).getIdPatrocinador;
    Patrocinadores ptEscolhido = routa.page == 2 &&
            (routa.index == 2 || routa.index == 3 || routa.index == 4)
        ? Provider.of<ControlNav>(context).getPatrocinador
        : Patrocinadores(
            id: 0,
            idCategoria: [],
            nome: '',
            imagemMaster: '',
            imagemPrincipal: '',
            imagemBusca: '',
            galeria: [],
            isFavorite: false,
            isBannerInicial: false,
            isMostrarSite: false,
          );

    String idPost = routa.page == 3 && routa.index == 2
        ? Provider.of<ControlNav>(context).getidpost
        : "";

    SVPostModel post = routa.page == 3 && routa.index == 3
        ? Provider.of<ControlNav>(context).getpost
        : SVPostModel(idPost: '', idUsuario: '');

    String linkurl = Provider.of<ControlNav>(context).urllinksubcribe;
    String linkurlcategoria =
        Provider.of<ControlNav>(context).getLinkPatrocinador;

    _widgetOptions = [
      //home - page 0
      [
        // 0
        WillPopScope(
          onWillPop: () async {
            /*setState(() {
              widget.selectedIndex = 0;
            });*/
            return false;
          },
          child: AHomeScreen(
            usuario: usuario,
          ),
        ),
        // 1
        InAppView(
          url: "https://site.tuddogramado.com.br/previsao-do-tempo",
          page: 0,
          index: 0,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 0,
                ),
          ),*/
        ),
        // 2
        InAppView(
          page: 0,
          index: 0,
          url: "https://site.tuddogramado.com.br/my-wishlist/",
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 0,
                ),
          ),*/
        ),
        // 3
        InAppView(
          url: "https://transfer.tuddogramado.com.br/",
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          page: 0,
          index: 0,
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 0,
                ),
          ),*/
        ),
        // 4
        InAppView(
          url: "https://tuddogramado.com.br",
          page: 0,
          index: 0,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 0,
                ),
          ),*/
        ),
        // 5
        InAppView(
          url: "https://tuddogramado.com.br/venda-mais-com-tuddo-em-dobro/",
          page: 0,
          index: 0,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 0,
                ),
          ),*/
        ),
        // 6 - top ofertas
        InAppView(
          url: "https://site.tuddogramado.com.br/busca-top-ofertas/",
          page: 0,
          index: 0,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 0,
                ),
          ),*/
        ),
      ],
      // tuddo em dobro // 1
      [
        InAppView(
          url: 'https://site.tuddogramado.com.br/tuddo-em-dobro/',
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          page: 0,
          index: 0,
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 0,
                ),
          ),*/
        ),
      ],
      // patrocinadores // 2
      [
        // 0
        WillPopScope(
          onWillPop: () async {
            /*setState(() {
              widget.selectedIndex = 0;
            });*/
            Provider.of<ControlNav>(context, listen: false).updateIndex(
              0,
              0,
            );
            return false;
          },
          child: NewPatrocinadoresScreen(
            usuario: usuario,
          ),
        ),
        // 1
        WillPopScope(
          onWillPop: () async {
            Provider.of<ControlNav>(context, listen: false).updateIndex(
              2,
              0,
            );
            return false;
          },
          child: PatrocinadoresScreen(
            idCategoria: routaCategoriaPatrocinador,
            usuario: usuario,
            index: 2,
          ),
        ),
        // 2
        WillPopScope(
          onWillPop: () async {
            Provider.of<ControlNav>(context, listen: false).updateIndex(
              2,
              0,
            );
            return false;
          },
          child: PatrocinadoresDetailPage(
            patrocinador: ptEscolhido,
            /*routa: MaterialPageRoute(
              builder: (context) => const BottomNavigation(
                  //selectedIndex: 0,
                  ),
            ),*/
          ),
        ),
        // 3 - route diferente
        WillPopScope(
          onWillPop: () async {
            Provider.of<ControlNav>(context, listen: false).updateIndex(
              2,
              1,
            );
            return false;
          },
          child: PatrocinadoresDetailPage(
            patrocinador: ptEscolhido,
            /*routa: MaterialPageRoute(
              builder: (context) => NewPatrocinadoresScreen(
                usuario: usuario,
              ),
            ),*/
          ),
        ),
        // 4 - rota de voltar p o inicio
        WillPopScope(
          onWillPop: () async {
            Provider.of<ControlNav>(context, listen: false).updateIndex(
              0,
              0,
            );
            return false;
          },
          child: PatrocinadoresDetailPage(
            patrocinador: ptEscolhido,
            /*routa: MaterialPageRoute(
              builder: (context) => NewPatrocinadoresScreen(
                usuario: usuario,
              ),
            ),*/
          ),
        ),
        // 5
        InAppView(
          url: linkurlcategoria,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          page: 2,
          index: 4,
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 0,
                ),
          ),*/
        ),
      ],
      // rede social // 3
      [
        // 0
        WillPopScope(
          onWillPop: () async {
            Provider.of<ControlNav>(context, listen: false).updateIndex(0, 0);
            return false;
          },
          child: const SVHomeFragment(),
        ),
        // 1
        WillPopScope(
          onWillPop: () async {
            Provider.of<ControlNav>(context, listen: false).updateIndex(3, 0);
            return false;
          },
          child: SVPostAdd(
            usuario: usuario,
          ),
        ),
        // 2
        WillPopScope(
          onWillPop: () async {
            Provider.of<ControlNav>(context, listen: false).updateIndex(3, 0);
            return false;
          },
          child: SVCommentScreen(
            usuario: usuario,
            idPost: idPost,
          ),
        ),
        // 3
        WillPopScope(
          onWillPop: () async {
            Provider.of<ControlNav>(context, listen: false).updateIndex(3, 0);
            return false;
          },
          child: SVPostEdit(
            usuario: usuario,
            post: post,
          ),
        ),
      ],
      // profile // 4
      [
        // 0
        WillPopScope(
          onWillPop: () async {
            /*setState(() {
              widget.selectedIndex = 0;
            });*/
            Provider.of<ControlNav>(context, listen: false).updateIndex(
              0,
              0,
            );
            return false;
          },
          child: ProfilePage(
            usuario: usuario,
          ),
        ),
        // 1 - Suporte
        InAppView(
          url: "https://www.google.com/",
          page: 4,
          index: 0,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 4,
                ),
          ),*/
        ),
        // 2 - favorite
        InAppView(
          url: "https://site.tuddogramado.com.br/my-wishlist/",
          page: 4,
          index: 0,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 4,
                ),
          ),*/
        ),
        // 3 -
        InAppView(
          url:
              "https://site.tuddogramado.com.br/member-account/?vendor=mybookings",
          page: 4,
          index: 0,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 4,
                ),
          ),*/
        ),
        // 4 - editar dados
        WillPopScope(
          onWillPop: () async {
            /*setState(() {
              widget.selectedIndex = 0;
            });*/
            Provider.of<ControlNav>(context, listen: false).updateIndex(
              4,
              0,
            );
            return false;
          },
          child: EditProfilePage(
            index: 4,
            usuario: usuario,
          ),
        ),
        // 5 - inscrições
        WillPopScope(
          onWillPop: () async {
            /*setState(() {
              widget.selectedIndex = 0;
            });*/
            Provider.of<ControlNav>(context, listen: false).updateIndex(
              4,
              0,
            );
            return false;
          },
          child: SubscribePage(),
        ),
        // 6
        InAppView(
          url: linkurl,
          page: 4,
          index: 5,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 4,
                ),
          ),*/
        ),
        // 7
        InAppView(
          url: "https://site.tuddogramado.com.br/area-afiliado-2/",
          page: 4,
          index: 0,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 4,
                ),
          ),*/
        ),
        // 8
        InAppView(
          url: "https://transfer.tuddogramado.com.br/oferta-tuddo-em-dobro/",
          page: 4,
          index: 0,
          data: {
            "usuario": usuario.email,
            "senha": usuario.uid,
          },
          /*routa: MaterialPageRoute(
            builder: (context) => const BottomNavigation(
                //selectedIndex: 4,
                ),
          ),*/
        ),
      ],
    ];
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // canvasColor: scaffoldColor,
          canvasColor: color00,
        ),
        child: BottomNavigationBar(
          elevation: 20,
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 35,
                child: SvgPicture.asset(
                  'assets/icones/home.svg',
                  color: routa.page == 0 ? primaryColor : white,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icones/cup.png",
                width: 35,
                height: 35,
                color: routa.page == 1 ? primaryColor : white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: routa.page == 2 ? primaryColor : white,
                size: 35,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icones/direcao.png",
                width: 33,
                height: 33,
                color: routa.page == 3 ? primaryColor : white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 35,
                child: SvgPicture.asset(
                  'assets/icones/profile.svg',
                  color: routa.page == 4 ? primaryColor : white,
                ),
              ),
              label: '',
            ),
          ],
          onTap: (int index) {
            Provider.of<ControlNav>(context, listen: false)
                .updateIndex(index, 0);
            //setState(() => widget.selectedIndex = index);
          },
          currentIndex: routa.page,
          //currentIndex: widget.selectedIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: color94,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      body: Stack(
        children: [
          LoginWordPress(
            usuario: usuario,
          ),
          _widgetOptions[routa.page].elementAt(routa.index),
        ],
      ),
    );
  }
}
