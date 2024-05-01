// ignore_for_file: file_names

class SVCommentModel {
  int id, idPost;
  String uid;
  String? name;
  String? profileImage;
  String? time;
  String? comment;
  int? likeCount;
  bool? isCommentReply;
  bool? like;

  SVCommentModel({
    required this.id,
    required this.idPost,
    required this.uid,
    this.name,
    this.profileImage,
    this.time,
    this.comment,
    this.likeCount,
    this.isCommentReply,
    this.like,
  });
}