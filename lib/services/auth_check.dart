import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/screens/login/ALoginScreen.dart';
import 'package:app_tuddo_gramado/services/auth_service.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';

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

  @override
  void initState() {
    AuthService.isLoggedIn().then((value) async {
      if (value) {
        User userFire = AuthService.gerarUserFirebase();
        await storeUser.getUID(userFire.uid);
        Usuario usuario = storeUser.state.value;

        // ignore: use_build_context_synchronously
        Provider.of<UsuarioProvider>(context, listen: false)
            .updateUsuario(usuario);

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ALoginScreen(),
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
