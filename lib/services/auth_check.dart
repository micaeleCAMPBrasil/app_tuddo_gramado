import 'package:app_tuddo_gramado/data/php/api_service.dart';
import 'package:app_tuddo_gramado/screens/inicio/AWalkThroughScreen.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/services/auth_service.dart';

class CheckUserLoggedInOrNot extends StatefulWidget {
  const CheckUserLoggedInOrNot({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckUserLoggedInOrNotState createState() => _CheckUserLoggedInOrNotState();
}

class _CheckUserLoggedInOrNotState extends State<CheckUserLoggedInOrNot> {
  final UsuarioStore storeUser = UsuarioStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  late APIService apiService;
  bool jalogou = false;

  @override
  void initState() {
    apiService = APIService();

    AuthService.isLoggedIn().then((value) async {
      setState(() {
        jalogou = value;
      });

      if (value) {
        User userFire = AuthService.gerarUserFirebase();

        debugPrint('UID - ${userFire.uid}');

        await storeUser.getUID(userFire.uid);
        //await storeUser.getUID(userFire.uid);

        Usuario usuario = storeUser.state.value;

        //final token = await FirebaseMessaging.instance.getToken();
        debugPrint('NOMESS - ${usuario.nome}');

        if (usuario.nome == '') {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const AWalkThroughScreen(),
            ),
          );
        } else {
          /*storeUser.repository.loginwordpress(usuario);*/

          /*WPJsonAPI.instance.initWith(baseUrl: "https://tuddogramado.com.br/");
          WPUserLoginResponse newLogin = await WPJsonAPI.instance.api(
            (request) => request.wpLogin(
              email: usuario.email,
              password: usuario.uid,
              authType: WPAuthType.WpEmail,
            ),
          );*/

          // ignore: use_build_context_synchronously
          Provider.of<UsuarioProvider>(context, listen: false)
              .updateUsuario(usuario);

          debugPrint('UID - ${usuario.uid}');
          /*CustomerModel model = CustomerModel(
            email: usuario.email,
            displayName: usuario.nome,
            firstName: usuario.nome,
            lastName: usuario.nome,
            password: usuario.uid,
          );*/

          // await apiService.updaterole();

          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigation(),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AWalkThroughScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
