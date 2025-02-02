// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:app_tuddo_gramado/data/models/imgbbResponseModel.dart';
import 'package:app_tuddo_gramado/data/php/api_service.dart';
import 'package:app_tuddo_gramado/data/stores/control_nav.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  int index;
  Usuario usuario;

  EditProfilePage({
    super.key,
    required this.index,
    required this.usuario,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      _nameController = TextEditingController(text: widget.usuario.nome);
      _userNameController =
          TextEditingController(text: widget.usuario.username);
      _emailController = TextEditingController(text: widget.usuario.email);
      _phoneNumberController =
          TextEditingController(text: widget.usuario.telefone);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  APIService apiService = APIService();

  final UsuarioStore storeUser = UsuarioStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  ImagePicker picker = ImagePicker();

  String? base64Image;
  File? tmpFile;

  File? images;

  final imgBBkey = '4cd0e929ee9db86448e68f47e4a33931';

  String txt = '';

  late ImgbbResponseModel imgbbResponse;

  Future pickGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      setState(() {
        images = File(pickedFile.path);
        tmpFile = File(pickedFile.path);
        base64Image = base64Encode(images!.readAsBytesSync());
      });
      uploadImage();
    }
  }

  Future pickCameraImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        images = File(pickedFile.path);
        tmpFile = File(pickedFile.path);
        base64Image = base64Encode(images!.readAsBytesSync());
      });
      uploadImage();
    }
  }

  removerFoto() {
    setState(() {
      images = null;
      widget.usuario.photo = '';
    });
  }

  openChangeProfilePhotoSheet(BuildContext context) {
    List sheetOptions = [
      {'icon': 'assets/icones/camera.png', 'title': 'Câmera'},
      {'icon': 'assets/icones/gallery.png', 'title': 'Galeria'},
      {'icon': 'assets/icones/bin.png', 'title': 'Remover\nFoto'},
    ];
    showModalBottomSheet(
      backgroundColor: color28,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose Option', style: whiteSemiBold20),
              heightSpace15,
              Row(
                children: sheetOptions
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(right: 51),
                        child: SizedBox(
                          height: 103,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (e['title'] == 'Galeria') {
                                    pickGalleryImage();
                                  } else if (e['title'] == 'Câmera') {
                                    pickCameraImage();
                                  } else {
                                    removerFoto();
                                  }
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  backgroundColor: sheetOptions.indexOf(e) == 0
                                      ? const Color(0xff009688)
                                      : sheetOptions.indexOf(e) == 1
                                          ? const Color(0xff00A7F7)
                                          : const Color(0xffDD5A5A),
                                  radius: 25,
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Image.asset(e['icon']),
                                  ),
                                ),
                              ),
                              heightSpace5,
                              Text(
                                e['title'],
                                style: color94Regular16,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              heightSpace20,
            ],
          ),
        );
      },
    );
  }

  String imgURL = '';

  void uploadImage() async {
    String url = "http://imagesapi.tuddo.org/upload_img.php";
    try {
      //String

      String fileName = tmpFile!.path.split('/').last;

      http.post(Uri.parse(url), body: {
        "image": base64Image,
        "name": fileName,
        "pasta": 'users/',
      }).then((value) {
        debugPrint('upload ${value.body}');

        if (mounted) {
          setState(() {
            imgURL = value.body.toString();
          });
        }
      });
    } catch (e) {
      debugPrint("Error");
    }
  }

  void editarUsuario(Usuario usuario) async {
    storeUser.update(
      usuario,
    );

    /*String linktuddogramado = Config.urlTuddo + Config.customerURL;
    await apiService.editandousuariowordpress(
        Config.tokenURLTG, linktuddogramado, usuario);

    String linktuddoemdobro = Config.url + Config.customerURL;
    await apiService.editandousuariowordpress(
        Config.tokenURL, linktuddoemdobro, usuario);

    String linktuddotransfer = Config.urlTuddoTransfer + Config.customerURL;
    await apiService.editandousuariowordpress(
        Config.tokenURLTransfer, linktuddotransfer, usuario);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: PrimaryButton(
                text: 'Salvar',
                onTap: () {
                  //UiHelper.showLoadingDialog(context, 'Aguarda...');
                  Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      debugPrint("IMG URL $imgURL");

                      setState(() {
                        widget.usuario.nome = _nameController.text;
                        widget.usuario.username = _userNameController.text;
                        widget.usuario.email = _emailController.text;
                        widget.usuario.telefone = _phoneNumberController.text;
                        /*widget.usuario.photo = tmpFile == ''
                            ? widget.usuario.photo != ''
                                ? imgURL == ''
                                : widget.usuario.photo
                            : "http://imagesapi.tuddo.org/$imgURL";*/
                        // ignore: unrelated_type_equality_checks
                        widget.usuario.photo = tmpFile == '' || imgURL == ''
                            ? widget.usuario.photo
                            : "http://imagesapi.tuddo.org/$imgURL";
                      });

                      debugPrint("A foto do usuário é ${widget.usuario.photo}");

                      Provider.of<UsuarioProvider>(context, listen: false)
                          .updateUsuario(widget.usuario);

                      editarUsuario(widget.usuario);

                      Provider.of<ControlNav>(context, listen: false)
                          .updateIndex(
                        4,
                        0,
                      );
                      //UiHelper.showLoadingDialog(context, 'Aguarde...');

                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigation(
                            //selectedIndex: 4,
                          ),
                        ),
                      );*/
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(
          backgroundColor: color00,
          title: 'Editar Usuário',
          leading: GestureDetector(
            onTap: () {
              Provider.of<ControlNav>(context, listen: false).updateIndex(
                4,
                0,
              );
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavigation(
                      //selectedIndex: widget.index,
                      ),
                ),
              );*/
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: bodyMethod(context, widget.usuario),
    );
  }

  Widget bodyMethod(BuildContext context, Usuario usuario) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      children: [
        Column(
          children: [
            heightSpace20,
            changeProfilePicMethod(context, usuario),
            heightSpace20,
            PrimaryTextfield(
              controller: _nameController,
              lableText: 'Nome',
            ),
            heightSpace20,
            PrimaryTextfield(
              controller: _userNameController,
              lableText: 'Usuário',
            ),
            heightSpace20,
            PrimaryTextfield(
              controller: _emailController,
              lableText: 'E-mail',
              keyboardType: TextInputType.emailAddress,
            ),
            heightSpace20,
            PrimaryTextfield(
              controller: _phoneNumberController,
              lableText: 'Telefone',
              keyboardType: TextInputType.number,
            ),
            heightSpace20,
          ],
        ),
      ],
    );
  }

  changeProfilePicMethod(BuildContext context, Usuario usuario) {
    return ChangeNotifierProvider(
      create: (_) => UsuarioProvider(),
      child: Consumer<UsuarioProvider>(
        builder: (context, provider, child) {
          return SizedBox(
            width: 110,
            height: 110,
            child: Stack(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    openChangeProfilePhotoSheet(context);
                  },
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: images == null
                          ? usuario.photo == '' ||
                                  usuario.photo ==
                                      'http://imagesapi.tuddo.org/' ||
                                  usuario.photo == 'https://tuddo.org/'
                              ? Image.asset(
                                  "assets/image/nopicture.png",
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  usuario.photo,
                                  fit: BoxFit.cover,
                                )
                          : Image.file(
                              File(images!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 5,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      openChangeProfilePhotoSheet(context);
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: white,
                      child: Icon(
                        Icons.camera_alt,
                        color: primaryColor,
                        size: 17,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
