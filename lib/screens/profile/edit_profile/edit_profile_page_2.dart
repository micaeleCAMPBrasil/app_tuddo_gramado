// ignore_for_file: deprecated_member_use, use_build_context_synchronously, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
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

  Uint8List? _image;

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    debugPrint('No image selected');
  }

  void selectImage(bool opc) async {
    if (opc) {
      Uint8List img = await pickImage(ImageSource.camera);
      setState(() {
        _image = img;
      });
    } else {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        _image = img;
      });
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
                                    selectImage(false);
                                  } else if (e['title'] == 'Câmera') {
                                    selectImage(true);
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

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(String fileName, Uint8List file) async {
    Reference ref = _storage.ref().child(fileName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    debugPrint("O link url é: $downloadUrl");

    return downloadUrl;
  }

  Future<String> editarUsuarios(
      {required Usuario usuario,
      required String name,
      required Uint8List file}) async {
    debugPrint("chamando a função");

    String resp = "Some error Ocurred";

    try {
      String imageUrl = await uploadImage(name, file);
      await _firestore.collection('user').add({
        'uid': usuario.uid,
        'nome': usuario.nome,
        'username': usuario.username,
        'email': usuario.email,
        'telefone': usuario.telefone,
        'photo': imageUrl,
      });

      setState(() {
        widget.usuario.photo = imageUrl;
      });

      /*storeUser.update(
        usuario.uid,
        usuario.nome,
        usuario.username,
        usuario.email,
        usuario.telefone,
        usuario.photo,
      );*/

      resp = 'Sucess';
    } catch (err) {
      resp = err.toString();
    }

    return resp;
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
                  onTap: () async {
                    debugPrint("A foto do usuário é ${widget.usuario.photo}");

                    setState(() {
                      widget.usuario.nome = _nameController.text;
                      widget.usuario.username = _userNameController.text;
                      widget.usuario.email = _emailController.text;
                      widget.usuario.telefone = _phoneNumberController.text;
                    });
                    String nomeImg = '${widget.usuario.uid}.jpg';

                    editarUsuarios(
                      usuario: widget.usuario,
                      name: nomeImg,
                      file: _image!,
                    );

                    /*Provider.of<UsuarioProvider>(context, listen: false)
                        .updateUsuario(widget.usuario);

                    UiHelper.showLoadingDialog(context, 'Aguarde...');

                    Future.delayed(
                      const Duration(seconds: 5),
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigation(
                              selectedIndex: 4,
                              usuario: widget.usuario,
                            ),
                          ),
                        );
                      },
                    );*/
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
                  child: _image != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(
                            _image!,
                          ),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            "assets/image/nopicture.png",
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
