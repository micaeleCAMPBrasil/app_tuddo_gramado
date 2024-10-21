// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SVPostAdd extends StatefulWidget {
  Usuario usuario;
  SVPostAdd({super.key, required this.usuario});

  @override
  State<SVPostAdd> createState() => _SVPostAddState();
}

class _SVPostAddState extends State<SVPostAdd> {
  bool delay = true;
  bool loading = false;

  File? _image;
  final picker = ImagePicker();

  String? base64Image;
  File? tmpFile;

  Future getImageCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        tmpFile = File(pickedFile.path);
        base64Image = base64Encode(_image!.readAsBytesSync());
      });
      uploadImageFile();
    } else {}
  }

  Future getImageGaleria() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        tmpFile = File(pickedFile.path);
        base64Image = base64Encode(_image!.readAsBytesSync());
      });
      uploadImageFile();
    } else {}
  }

  postPost(String imagem, String texto) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('kk:mm').format(now);

    FirebaseFirestore.instance.collection("User Post").add({
      'idUsuario': widget.usuario.uid,
      'postImage': imagem,
      'description': texto,
      'TimeStamp': Timestamp.now(),
      'data': formattedDate,
      'time': formattedTime,
      'likes': [],
      'totalComentario': 0,
    });

    //await storePost.addPost(widget.usuario, texto, imagem);

    Provider.of<ControlNav>(context, listen: false).updateIndex(3, 0);
    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavigation(
          selectedIndex: 3,
        ),
      ),
    );*/
  }

  GlobalKey<FormState> mykey = GlobalKey<FormState>();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  String imgURL = '';

  final PublicacaoStore storePost = PublicacaoStore(
    repository: IFuncoesPHP(
      client: HttpClient(),
    ),
  );

  //final imgBBkey = '4cd0e929ee9db86448e68f47e4a33931';

  Dio dio = Dio();

  void uploadImageFile() async {
    String url = "https://www.tuddo.org/upload_img.php";

    try {
      /*String fileName = _image!.path.split('/').last;

      FormData data = FormData.fromMap({
        "key": imgBBkey,
        "image": await MultipartFile.fromFile(
          _image!.path,
          filename: fileName,
        ),
      });

      Dio dio = Dio();
      dio.post("https://api.imgbb.com/1/upload", data: data).then((response) {
        var data = response.data;

        debugPrint('Função - ${data['data']['url']}');

        setState(() {
          imgURL = data['data']['url'];
        });

        // ignore: invalid_return_type_for_catch_error
      }).catchError((error) => debugPrint(error.toString()));
      // ignore: empty_catches*/

      String fileName = tmpFile!.path.split('/').last;

      http.post(Uri.parse(url), body: {
        "image": base64Image,
        "name": fileName,
        "pasta": 'posts/',
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: color00,
        iconTheme: IconThemeData(color: color94),
        title: Text(
          '',
          style: whiteBold18,
        ),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Provider.of<ControlNav>(context, listen: false).updateIndex(3, 0);
            /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SVHomeFragment(),
              ),
            );*/
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: radius(12),
                color: color00,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            widget.usuario.photo == ''
                                ? Image.asset(
                                    'assets/image/nopicture.png',
                                    height: 56,
                                    width: 56,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(12)
                                : Image(
                                    image: CachedNetworkImageProvider(
                                      widget.usuario.photo,
                                    ),
                                    height: 56,
                                    width: 56,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).cornerRadiusWithClipRRect(12),
                            /*Image.network(
                                    widget.usuario.photo,
                                    height: 56,
                                    width: 56,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(12),*/
                            widthSpace10,
                            Text(
                              formatarNome(widget.usuario.nome),
                              style: whiteSemiBold18,
                            ),
                            widthSpace5,
                            Image.asset(
                              'assets/social/ic_TickSquare.png',
                              height: 14,
                              width: 14,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  heightSpace15,
                  _image == null
                      ? Image.asset(
                          'assets/social/no-camera.png',
                          height: 300,
                          width: context.width() - 32,
                          color: whiteColor,
                        ).cornerRadiusWithClipRRect(12).center()
                      : Image.file(
                          _image!,
                          height: 300,
                          width: context.width() - 32,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRect(12).center(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Image.asset(
                              'assets/icones/camera.png',
                              height: 20,
                              width: 22,
                              fit: BoxFit.cover,
                            ),
                            onPressed: () async {
                              await getImageCamera();
                            },
                          ),
                          GestureDetector(
                            onTap: () async {
                              await getImageGaleria();
                            },
                            child: Image.asset(
                              'assets/icones/gallery.png',
                              height: 22,
                              width: 22,
                              fit: BoxFit.cover,
                            ),
                          ),
                          widthSpace10,
                        ],
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                  const Divider(indent: 16, endIndent: 16, height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: color00,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widthSpace15,
                        Container(
                          height: 48,
                          width: 48,
                          color: primaryColor,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ).cornerRadiusWithClipRRect(8),
                        widthSpace5,
                        SizedBox(
                          width: context.width() * 0.5,
                          child: Form(
                            key: mykey,
                            child: AppTextField(
                              controller: _descriptionTextController,
                              textFieldType: TextFieldType.MULTILINE,
                              textStyle: whiteRegular14,
                              decoration: InputDecoration(
                                hintText: 'Digite...',
                                hintStyle: whiteRegular14,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Você não digitou nada!';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (mykey.currentState!.validate()) {
                              postPost(
                                imgURL == ''
                                    ? ''
                                    : "https://www.tuddo.org/$imgURL",
                                _descriptionTextController.text,
                              );
                            }
                          },
                          child: Text(
                            'Postar',
                            style: whiteRegular12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /*Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: radius(12),
              ),
              child: Column(
                children: [
                  Image.file(
                    width: context.width() - 32,
                    height: 300,
                    widget.image,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: color00,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widthSpace15,
                        widget.usuario.photo == ''
                            ? Image.asset(
                                'assets/image/nopicture.png',
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(8)
                            : Image.network(
                                widget.usuario.photo,
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(8),
                        widthSpace5,
                        SizedBox(
                          width: context.width() * 0.5,
                          child: Form(
                            key: mykey,
                            child: AppTextField(
                              controller: _descriptionTextController,
                              textFieldType: TextFieldType.MULTILINE,
                              textStyle: whiteRegular14,
                              decoration: InputDecoration(
                                hintText: 'Digite...',
                                hintStyle: whiteRegular14,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Você não digitou nada!';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (mykey.currentState!.validate()) {
                              uploadImageFile(widget.image,
                                  _descriptionTextController.text);
                            }
                          },
                          child: Text(
                            'Postar',
                            style: whiteRegular12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
