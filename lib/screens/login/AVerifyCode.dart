// ignore_for_file: library_private_types_in_public_api, file_names
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/helper/ui_helper.dart';
import 'package:app_tuddo_gramado/screens/login/AUpdateInformacoes.dart';
import 'package:app_tuddo_gramado/services/auth_service.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';

// ignore: must_be_immutable
class AVerifyCode extends StatefulWidget {
  String telefone;

  AVerifyCode({super.key, required this.telefone});

  @override
  _AVerifyCodeState createState() => _AVerifyCodeState();
}

class _AVerifyCodeState extends State<AVerifyCode> {
  var viewPassword = true;

  GlobalKey<FormState> mykey = GlobalKey<FormState>();
  final TextEditingController _optController = TextEditingController();

  final UsuarioStore storeUser = UsuarioStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: white,
          ),
        ),
        title: Text(
          'Verificação',
          style: whiteBold22,
        ),
      ),
      body: Container(
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
                  Row(
                    children: [
                      Text(
                        'Quase logado!',
                        style: whiteMedium20,
                      ),
                    ],
                  ),
                  heightSpace20,
                  Text(
                    'Digite o código de verificação de 4 dígitos. Acabamos de te enviar para\n +55 ${widget.telefone}',
                    style: whiteRegular16,
                    textAlign: TextAlign.justify,
                  ),
                  Form(
                    key: mykey,
                    child: PrimaryTextfieldCodigo(
                      hintText: 'Digite o código de verificação',
                      lableText: 'Digite o código de verificação',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 6,
                      controller: _optController,
                    ),
                  ),
                  heightSpace40,
                  PrimaryButton(
                    text: 'Verificar',
                    onTap: () {
                      if (mykey.currentState!.validate()) {
                        AuthService.loginWithOtp(otp: _optController.text).then(
                          (value) {
                            User user = AuthService.gerarUserFirebase();
                            String uid = user.uid;
                            String? telefone = user.phoneNumber;

                            storeUser.getUID(uid);

                            Usuario usuarioBase = storeUser.state.value;
                            if (value == "Sucess") {
                              UiHelper.showLoadingDialog(context, 'Aguarde...');

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
                                          telefone: telefone!,
                                          usuario: usuarioBase,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                Timer(
                                  const Duration(seconds: 1),
                                  () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BottomNavigation(),
                                      ),
                                    );
                                  },
                                );
                              }
                            } else {
                              debugPrint('Erro Verificação Code - $value');

                              /*ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: primaryColor,
                                ),
                              );*/
                            }
                          },
                        );
                      }
                    },
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
