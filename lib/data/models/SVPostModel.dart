// ignore_for_file: file_names

class SVPostModel {
  String? name;
  String? profileImage;
  String? postImage;
  String? time;
  String? description;
  int? commentCount;
  bool? like;

  SVPostModel(
      {this.name,
      this.profileImage,
      this.postImage,
      this.time,
      this.description,
      this.commentCount,
      this.like});
}

List<SVPostModel> getPosts() {
  List<SVPostModel> list = [];

  list.add(
    SVPostModel(
      name: 'Manny',
      profileImage: 'assets/social/face_3.png',
      time: '4m',
      postImage: 'assets/social/postImage.png',
      description:
          'The great thing about reaching the top of the mountain is realising that there’s space for more than one person.',
      commentCount: 0,
      like: false,
    ),
  );
  list.add(
    SVPostModel(
      name: 'Isabelle',
      profileImage: 'assets/social/face_4.png',
      time: '4m',
      postImage: 'assets/social/postImage.png',
      commentCount: 0,
      like: false,
    ),
  );
  list.add(
    SVPostModel(
      name: 'Jenny Wilson',
      profileImage: 'assets/social/face_5.png',
      time: '4m',
      postImage: 'assets/social/postImage.png',
      description: 'Making memories that last a lifetime ',
      commentCount: 0,
      like: false,
    ),
  );

  return list;
}
