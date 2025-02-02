// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:app_tuddo_gramado/data/models/SVPostModel.dart';
import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/data/stores/publicacao_store.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:app_tuddo_gramado/utils/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SVPostEdit extends StatefulWidget {
  SVPostModel post;
  Usuario usuario;
  SVPostEdit({super.key, required this.usuario, required this.post});

  @override
  State<SVPostEdit> createState() => _SVPostEditState();
}

class _SVPostEditState extends State<SVPostEdit> {
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
        editarImagem = true;

        tmpFile = File(pickedFile.path);
        base64Image = base64Encode(_image!.readAsBytesSync());
      });
      uploadImageFile();
    } else {
      setState(() {
        editarImagem = false;
        editarImagem = false;
      });
    }
  }

  Future getImageGaleria() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        editarImagem = true;

        tmpFile = File(pickedFile.path);
        base64Image = base64Encode(_image!.readAsBytesSync());
      });
      uploadImageFile();
    } else {
      setState(() {
        editarImagem = false;
        editarImagem = false;
      });
    }
  }

  postPost(String imagem, String texto) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('kk:mm').format(now);

    DocumentReference postRef = FirebaseFirestore.instance
        .collection('User Post')
        .doc(widget.post.idPost);

    postRef.update({
      'postImage': imagem,
      'description': texto,
      'TimeStamp': Timestamp.now(),
      'data': formattedDate,
      'time': formattedTime,
    });

    Provider.of<ControlNav>(context, listen: false).updateIndex(3, 0);
    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SVHomeFragment(),
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

  bool editarImagem = false;

  void uploadImageFile() async {
    String url = "https://api.tuddo.org/upload_img.php";

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
            imgURL =
                editarImagem ? value.body.toString() : widget.post.postImage!;
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
    setState(() {
      _descriptionTextController.text = widget.post.description!;
    });
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
            /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SVHomeFragment(),
              ),
            );*/

            Provider.of<ControlNav>(context, listen: false).updateIndex(3, 0);
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
                            widget.usuario.photo == '' ||
                                    widget.usuario.photo == 'https://tuddo.org/'
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
                                  ).cornerRadiusWithClipRRect(
                                    12) /*Image.network(
                                    widget.usuario.photo,
                                    height: 56,
                                    width: 56,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(12)*/
                            ,
                            widthSpace10,
                            Text(
                              formatarNome(widget.usuario.nome),
                              style: whiteSemiBold20,
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
                  !editarImagem
                      ? widget.post.postImage == '' ||
                              widget.post.postImage == 'https://api.tuddo.org/'
                          ? Image.asset(
                              'assets/social/no-camera.png',
                              height: 300,
                              width: context.width() - 32,
                              color: whiteColor,
                            ).cornerRadiusWithClipRRect(12).center()
                          : /*Image.network(
                              widget.post.postImage!,
                              height: 300,
                              width: context.width() - 32,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(12).center()*/
                          Image(
                              image: CachedNetworkImageProvider(
                                widget.post.postImage!,
                              ),
                              height: 300,
                              width: context.width() - 32,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).cornerRadiusWithClipRRect(12).center()
                      : _image == null
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
                                editarImagem
                                    ? "https://api.tuddo.org/$imgURL"
                                    : widget.post.postImage!,
                                _descriptionTextController.text,
                              );
                            }
                          },
                          child: Text(
                            'Editar',
                            style: whiteRegular12,
                          ),
                        ),
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
