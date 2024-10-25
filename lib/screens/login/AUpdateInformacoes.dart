// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:app_tuddo_gramado/data/php/api_service.dart';
import 'package:app_tuddo_gramado/services/auth_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/helper/ui_helper.dart';

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

  late APIService apiService;

  String mensagemalerta = 'Aguarde...';

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

    apiService = APIService();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          _loading = true;
        });
      },
    );

    //getUsersData();
    setState(() {
      uidController = TextEditingController(text: widget.uid);
      emailController = TextEditingController(text: widget.email);
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
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  /*decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/image/login_register_bg.png"),
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
                                onTap: () async {
                                  if (mykey.currentState!.validate()) {
                                    UiHelper.showLoadingDialog(
                                        context, mensagemalerta);

                                    setState(() {
                                      widget.usuario.uid = widget.uid;
                                      widget.usuario.nome =
                                          nomeController.text.toUpperCase();
                                      widget.usuario.username =
                                          userNameController.text;
                                      widget.usuario.email =
                                          emailController.text;
                                      widget.usuario.telefone =
                                          telefoneController.text;
                                      widget.usuario.tokenAlert = tokenAlert;
                                    });

                                    storeUser.update(widget.usuario);

                                    Provider.of<UsuarioProvider>(context,
                                            listen: false)
                                        .updateUsuario(widget.usuario);

                                    List<String> split =
                                        widget.usuario.nome.split(' ');
                                    String primeiroNome =
                                        split[0].toString() == ''
                                            ? ''
                                            : split[0].toUpperCase();

                                    String segundoNome = split.length <= 1
                                        ? ''
                                        : split[1].toString() == ''
                                            ? ''
                                            : split[1].toUpperCase();

                                    CustomerModel model = CustomerModel(
                                      email: widget.usuario.email,
                                      displayName: widget.usuario.nome,
                                      firstName: primeiroNome,
                                      lastName: segundoNome,
                                      password: widget.usuario.uid,
                                      roles: ['subscriber'],
                                    );

                                    await apiService
                                        .criandonovousuarioTuddoGramado(model);

                                    await apiService
                                        .criandonovousuarioTuddoDobro(model);

                                    await apiService
                                        .criandonovousuarioTransfer(model);

                                    debugPrint('check cadastro - $check');

                                    setState(() {
                                      mensagemalerta = 'Sucesso!';
                                    });

                                    Timer(
                                      const Duration(seconds: 2),
                                      () async {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CheckUserLoggedInOrNot(),
                                          ),
                                        );
                                      },
                                    );

                                    /*apiService
                                        .createCustomer(widget.usuario, model)
                                        .then((ret) {
                                      /*apiService
                                        .createCustomer(widget.usuario, model)
                                        .then((ret) {*/
                                      //if (storeUser.isLoading.value) {
                                      setState(() {
                                        isApiCallProcess = false;
                                      });
                                      UiHelper.showLoadingDialog(
                                        context,
                                        'Sucesso...',
                                      );
                                      Timer(
                                        const Duration(seconds: 1),
                                        () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CheckUserLoggedInOrNot(),
                                            ),
                                          );
                                        },
                                      );*/
                                    //});
                                    /*} else {
                                      debugPrint('Erro Cadastro WordPress');
                                      Timer(
                                        const Duration(seconds: 1),
                                        () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ALoginScreen(),
                                            ),
                                          );
                                        },
                                      );
                                    }*/
                                    //});
                                    /*UiHelper.showLoadingDialog(
                                          context, 'Aguarde...');*/
                                    /*} else {
                                      debugPrint(
                                          'Erro Update Informações - ${storeUser.erro.value}');
                                    }*/
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
