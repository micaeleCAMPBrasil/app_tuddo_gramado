// ignore_for_file: library_private_types_in_public_api, file_names, deprecated_member_use, use_build_context_synchronously

import 'dart:async';

import 'package:app_tuddo_gramado/data/php/api_service.dart';
import 'package:app_tuddo_gramado/services/auth_check.dart';
import 'package:app_tuddo_gramado/services/logout_wordpress.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/screens/login/AUpdateInformacoes.dart';
import 'package:app_tuddo_gramado/services/auth_service.dart';

import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:provider/provider.dart';

class ALoginScreen extends StatefulWidget {
  const ALoginScreen({super.key});

  @override
  State<ALoginScreen> createState() => _ALoginScreenState();
}

class _ALoginScreenState extends State<ALoginScreen> {
  GlobalKey<FormState> mykey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();

  bool isApiCallProcess = false;
  late APIService apiService;

  final UsuarioStore storeUser = UsuarioStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Login',
            style: whiteBold22,
          ),
        ),
        body: Stack(
          children: [
            const LogOutWordPress(),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/image/login_register_bg.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(
                          'Digite seu e-mail',
                          style: whiteMedium20,
                          maxLines: 1,
                        ),
                        heightSpace10,
                        Form(
                          key: mykey,
                          child: PrimaryTextfield(
                            lableText: 'Digite seu E-mail',
                            hintText: 'Digite seu E-mail',
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            textInputAction: TextInputAction.go,
                          ),
                        ),
                        heightSpace40,
                        PrimaryButton(
                          text: 'Continue',
                          onTap: () async {
                            if (mykey.currentState!.validate()) {
                              //UiHelper.showLoadingDialog(context, 'Aguarde...');

                              await AuthService.signInWithEmail(
                                  _emailTextController.text);

                              User user = AuthService.gerarUserFirebase();
                              String uid = user.uid;
                              String? emailEscolhido = user.email;
                              await storeUser.getUID(uid);

                              Usuario usuarioBase = storeUser.state.value;

                              if (usuarioBase.nome == '' ||
                                  usuarioBase.email == '' ||
                                  usuarioBase.telefone == '') {
                                Timer(
                                  const Duration(seconds: 1),
                                  () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(
                                          uid: uid,
                                          email: emailEscolhido!,
                                          usuario: usuarioBase,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                setState(() {
                                  isApiCallProcess = true;
                                });

                                Provider.of<UsuarioProvider>(context,
                                        listen: false)
                                    .updateUsuario(usuarioBase);

                                Timer(
                                  const Duration(seconds: 1),
                                  () {
                                    /*Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LoginWP(
                                                  usuario: usuarioBase.email,
                                                  senha: usuarioBase.uid,
                                                ),
                                              ),
                                            );*/

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CheckUserLoggedInOrNot(),
                                      ),
                                    );
                                  },
                                );
                              }

                              /*AuthService.signInWithEmail(
                                      _emailTextController.text)
                                  .then(
                                (value) async {
                                  if (value == "Sucess") {
                                    User user = AuthService.gerarUserFirebase();
                                    String uid = user.uid;
                                    String? emailEscolhido = user.email;

                                    await storeUser.getUID(uid);

                                    Usuario usuarioBase = storeUser.state.value;

                                    if (usuarioBase.nome == '' ||
                                        usuarioBase.email == '' ||
                                        usuarioBase.telefone == '') {
                                      Timer(
                                        const Duration(seconds: 1),
                                        () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage(
                                                uid: uid,
                                                email: emailEscolhido!,
                                                usuario: usuarioBase,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      setState(() {
                                        isApiCallProcess = true;
                                      });

                                      Provider.of<UsuarioProvider>(context,
                                              listen: false)
                                          .updateUsuario(usuarioBase);

                                      Timer(
                                        const Duration(seconds: 1),
                                        () {
                                          /*Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LoginWP(
                                                  usuario: usuarioBase.email,
                                                  senha: usuarioBase.uid,
                                                ),
                                              ),
                                            );*/

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CheckUserLoggedInOrNot(),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: primaryColor,
                                      ),
                                    );
                                  }
                                },
                              );*/
                            }
                          },
                        ),
                        heightSpace20,
                        /*Text(
                          'Faça Login usando:',
                          style: whiteRegular15,
                          textAlign: TextAlign.center,
                        ),
                        heightSpace20,*/
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xff4267B2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/image/appetit/fb.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                    widthSpace15,
                                    Text(
                                      'Facebook',
                                      style: whiteMedium16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            widthSpace20,*/
                            /*Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    AuthService.signInWithGoogle().then(
                                  (value) async {
                                    if (value == "Sucess") {
                                      User user =
                                          AuthService.gerarUserFirebase();
                                      String uid = user.uid;
                                      String? emailEscolhido = user.email;

                                      await storeUser.getUID(uid);

                                      Usuario usuarioBase =
                                          storeUser.state.value;

                                      if (usuarioBase.nome == '' ||
                                          usuarioBase.email == '' ||
                                          usuarioBase.telefone == '') {
                                        Timer(
                                          const Duration(seconds: 1),
                                          () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage(
                                                  uid: uid,
                                                  email: emailEscolhido!,
                                                  usuario: usuarioBase,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        setState(() {
                                          isApiCallProcess = true;
                                        });

                                        Provider.of<UsuarioProvider>(context,
                                                listen: false)
                                            .updateUsuario(usuarioBase);

                                        Timer(
                                          const Duration(seconds: 1),
                                          () {
                                            /*Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LoginWP(
                                                  usuario: usuarioBase.email,
                                                  senha: usuarioBase.uid,
                                                ),
                                              ),
                                            );*/

                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CheckUserLoggedInOrNot(),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    } else if (value == "n_cadastrado") {
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            value,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: primaryColor,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/image/appetit/google.png',
                                        width: 45,
                                        height: 45,
                                      ),
                                      widthSpace15,
                                      Text(
                                        'Google',
                                        style: blackMedium16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),*/
                          ],
                        ),*/
                        heightSpace100,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
