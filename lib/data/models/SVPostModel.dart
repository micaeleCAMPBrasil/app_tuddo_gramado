// ignore_for_file: file_names
import 'package:app_tuddo_gramado/data/models/usuario.dart';

class SVPostModel {
  String idPost;
  String idUsuario;
  String? name;
  String? profileImage;
  String? postImage;
  String? time;
  String? description;
  int? commentCount;
  bool? like;
  int? likeCount;
  List<Usuario>? usuarioQCurtiram;

  SVPostModel({
    required this.idPost,
    required this.idUsuario,
    this.name,
    this.profileImage,
    this.postImage,
    this.time,
    this.description,
    this.commentCount,
    this.like,
    this.likeCount,
    this.usuarioQCurtiram,
  });
}
