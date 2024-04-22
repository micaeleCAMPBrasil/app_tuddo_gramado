// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/helper/ui_helper.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';

import '../../utils/constant.dart';
import '../../utils/widgets.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  Usuario usuario;
  final String uid, nome, email, telefone;

  RegisterPage({
    super.key,
    required this.usuario,
    required this.uid,
    this.nome = 'Seu Nome',
    this.email = '',
    this.telefone = '',
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> mykey = GlobalKey<FormState>();
  TextEditingController uidController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  final UsuarioStore storeUser = UsuarioStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  List<Usuario> listUsuarios = [];

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    getToken();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          _loading = true;
        });
      },
    );

    getUsersData();
    setState(() {
      uidController = TextEditingController(text: widget.uid);
      nomeController = TextEditingController(text: widget.nome);

      emailController = TextEditingController(text: widget.email);
      telefoneController = TextEditingController(text: widget.telefone);
    });
  }

  String tokenAlert = '';

  getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() {
      tokenAlert = token!;
    });

    debugPrint('=======================================');
    debugPrint('TOKEN UPLOAD INFORMAÇÕES: $token');
    debugPrint('=======================================');
  }

  getUsersData() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      await storeUser.getAll();
      setState(() {
        listUsuarios = storeUser.list.value;
      });
      pause ? null : checkUserName();
    });
  }

  bool check = false;
  bool pause = false;

  checkUserName() async {
    List<String> split = widget.nome.split(' ');
    String primeiroNome = split[0] == '' ? 'user' : split[0].toLowerCase();
    String segundoNome = split[1] == '' ? 'name' : split[1].toLowerCase();

    String userName = '$primeiroNome-$segundoNome';

    List usernamesbase =
        listUsuarios.where((element) => element.username == userName).toList();

    setState(() {
      check = usernamesbase.isEmpty ? false : true;
    });

    gerandoUserName(userName);
  }

  gerandoUserName(String userName) async {
    // se tiver vazio não precisa fazer nada = false
    // se tiver dados iguais precisar mudar = true
    String numerodetelefone = widget.telefone;

    if (check) {
      int count = numerodetelefone.length;
      //int count = .length;

      if (count == 0) {
        int n1 = Random().nextInt(9);
        int n2 = Random().nextInt(9);
        int n3 = Random().nextInt(9);
        int n4 = Random().nextInt(9);

        String numeros =
            n1.toString() + n2.toString() + n3.toString() + n4.toString();

        setState(() {
          userNameController.text = "$userName-$numeros";
        });
      } else {
        String n1 = numerodetelefone[count - 1];
        String n2 = numerodetelefone[count - 2];
        String n3 = numerodetelefone[count - 3];
        String n4 = numerodetelefone[count - 4];

        String numeros = n1 + n2 + n3 + n4;

        setState(() {
          userNameController.text = "$userName-$numeros";
        });
      }
    } else {
      setState(() {
        userNameController.text = userName;
      });
    }
    setState(() {
      pause = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: _loading
          ? Scaffold(
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text('Seja Bem-Vindo!', style: whiteBold22),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                /*decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(""),
              fit: BoxFit.fill,
            ),
          ),*/
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                      child: Form(
                        key: mykey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PrimaryTextfield(
                              lableText: 'Nome',
                              controller: nomeController,
                            ),
                            heightSpace20,
                            PrimaryTextfield(
                              lableText: '@Usuário',
                              controller: userNameController,
                            ),
                            heightSpace20,
                            PrimaryTextfield(
                              lableText: 'E-mail',
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                            ),
                            heightSpace20,
                            PrimaryTextfieldTelefone(
                              lableText: 'Telefone',
                              keyboardType: TextInputType.phone,
                              controller: telefoneController,
                              textInputAction: TextInputAction.go,
                            ),
                            heightSpace40,
                            PrimaryButton(
                              text: 'Continuar',
                              onTap: () {
                                if (mykey.currentState!.validate()) {
                                  setState(() {
                                    widget.usuario.uid = widget.uid;
                                    widget.usuario.nome = nomeController.text;
                                    widget.usuario.username =
                                        userNameController.text;
                                    widget.usuario.email = emailController.text;
                                    widget.usuario.telefone =
                                        telefoneController.text;
                                    widget.usuario.tokenAlert = tokenAlert;
                                  });

                                  storeUser.update(widget.usuario);

                                  Provider.of<UsuarioProvider>(context,
                                          listen: false)
                                      .updateUsuario(widget.usuario);

                                  bool resposta = storeUser.isEditable.value;
                                  if (resposta) {
                                    UiHelper.showLoadingDialog(
                                        context, 'Aguarde...');
                                    Timer(
                                      const Duration(seconds: 1),
                                      () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BottomNavigation(
                                              selectedIndex: 0,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    debugPrint(
                                        'Erro Update Informações - ${storeUser.erro.value}');
                                    /*ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        storeUser.erro.value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );*/
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
