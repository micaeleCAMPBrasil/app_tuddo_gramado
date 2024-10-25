// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously
import 'dart:convert';

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
import 'package:image_picker_web/image_picker_web.dart';
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
  String base64Image = '';
  // ignore: prefer_typing_uninitialized_variables
  var _fileBytes;

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

  bool editarImagem = false;

  Future<void> getMultipleImageInfos() async {
    var fileBytes = await ImagePickerWeb.getImageAsBytes();

    if (fileBytes!.isEmpty) {
    } else {
      setState(() {
        editarImagem = !editarImagem;
        _fileBytes = fileBytes;
        base64Image = base64Encode(fileBytes);
      });
      uploadImageFile();
    }
  }

  void uploadImageFile() async {
    String url = "https://www.tuddo.org/upload_img.php";

    try {
      final DateTime now = DateTime.now();
      try {
        //String
        String fileName = '${widget.usuario.uid}-${now.day}:${now.hour}.jpg';

        http.post(Uri.parse(url), body: {
          "image": base64Image,
          "name": fileName,
          "pasta": 'posts/',
        }).then((value) {
          debugPrint('upload ${value.body}');

          setState(() {
            imgURL = value.body.toString();
          });
        });
      } catch (e) {
        debugPrint("Error");
      }
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
                              widget.post.postImage == 'https://www.tuddo.org/'
                          ? Image.asset(
                              'assets/social/no-camera.png',
                              height: 300,
                              width: context.width() - 32,
                              color: whiteColor,
                            ).cornerRadiusWithClipRRect(12).center()
                          : Image(
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
                      : _fileBytes.isEmpty
                          ? Image.asset(
                              'assets/social/no-camera.png',
                              height: 300,
                              width: context.width() - 32,
                              color: whiteColor,
                            ).cornerRadiusWithClipRRect(12).center()
                          : Image(
                              image: MemoryImage(
                                base64Decode(
                                  base64Image.toString(),
                                ),
                              ),
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
                              'assets/icones/gallery.png',
                              height: 20,
                              width: 22,
                              fit: BoxFit.cover,
                            ),
                            onPressed: () {
                              getMultipleImageInfos();
                            },
                          ),
                          /*GestureDetector(
                            onTap: () async {
                              //await getImageGaleria();
                            },
                            child: Image.asset(
                              'assets/icones/camera.png',
                              height: 22,
                              width: 22,
                              fit: BoxFit.cover,
                            ),
                          ),
                          widthSpace10,*/
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
                                    ? "https://www.tuddo.org/$imgURL"
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
