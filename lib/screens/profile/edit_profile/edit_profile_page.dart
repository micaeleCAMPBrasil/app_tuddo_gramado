// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:app_tuddo_gramado/helper/ui_helper.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
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

  final UsuarioStore storeUser = UsuarioStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  ImagePicker picker = ImagePicker();

  XFile? images;

  Future pickGalleryImage(BuildContext context) async {
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      images = pickedFile;
      // ignore: use_build_context_synchronously
      uploadImage(context);
    }
  }

  Future pickCameraImage(BuildContext context) async {
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedFile != null) {
      images = pickedFile;
      // ignore: use_build_context_synchronously
      uploadImage(context);
    }
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
                                    pickGalleryImage(context);
                                  } else if (e['title'] == 'Câmera') {
                                    pickCameraImage(context);
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

  void uploadImage(BuildContext context) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImagens = referenceRoot.child('user_images');

    Reference referenceImageToUpload = referenceDirImagens
        .child('profileImage${widget.usuario.uid}-${images!.name}');

    try {
      await referenceImageToUpload.putFile(File(images!.path));
      final newUrl = await referenceImageToUpload.getDownloadURL();
      setState(() {
        widget.usuario.photo = newUrl;
      });
      debugPrint("A foto do usuário é ${widget.usuario.photo}");
      // ignore: use_build_context_synchronously
      Provider.of<UsuarioProvider>(context, listen: false)
          .updateUsuario(widget.usuario);
      // ignore: empty_catches
    } catch (erro) {}
  }

  void editarUsuario(Usuario usuario, BuildContext context) {
    storeUser.update(
      usuario,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(
              selectedIndex: 4,
            ),
          ),
        );
        return true;
      },
      child: Scaffold(
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
                    debugPrint("A foto do usuário é ${widget.usuario.photo}");
                    setState(() {
                      widget.usuario.nome = _nameController.text;
                      widget.usuario.username = _userNameController.text;
                      widget.usuario.email = _emailController.text;
                      widget.usuario.telefone = _phoneNumberController.text;
                    });

                    Provider.of<UsuarioProvider>(context, listen: false)
                        .updateUsuario(widget.usuario);

                    editarUsuario(widget.usuario, context);

                    UiHelper.showLoadingDialog(context, 'Aguarde...');

                    Future.delayed(
                      const Duration(seconds: 5),
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigation(
                              selectedIndex: 4,
                            ),
                          ),
                        );
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigation(
                      selectedIndex: widget.index,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.arrow_left_rounded),
            ),
          ),
        ),
        body: bodyMethod(context, widget.usuario),
      ),
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
                          ? usuario.photo == ''
                              ? Image.asset(
                                  "assets/image/nopicture.png",
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  usuario.photo,
                                  fit: BoxFit.fill,
                                )
                          : Image.file(
                              File(images!.path),
                              fit: BoxFit.fill,
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
