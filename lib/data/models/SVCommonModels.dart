// ignore_for_file: file_names

class SVDrawerModel {
  String? title;
  String? image;

  SVDrawerModel({this.image, this.title});
}

List<SVDrawerModel> getDrawerOptions() {
  List<SVDrawerModel> list = [];

  list.add(
      SVDrawerModel(image: 'assets/social/ic_Profile.png', title: 'Profile'));
  list.add(
      SVDrawerModel(image: 'assets/social/ic_2User.png', title: 'Friends'));
  list.add(SVDrawerModel(image: 'assets/social/ic_3User.png', title: 'Groups'));
  list.add(
      SVDrawerModel(image: 'assets/social/ic_Image.png', title: 'Gallery'));
  list.add(
      SVDrawerModel(image: 'assets/social/ic_Document.png', title: 'Forums'));
  list.add(
      SVDrawerModel(image: 'assets/social/ic_Send.png', title: 'Share App'));
  list.add(SVDrawerModel(image: 'assets/social/ic_Star.png', title: 'Rate Us'));
  list.add(
      SVDrawerModel(image: 'assets/social/ic_Logout.png', title: 'Logout'));

  return list;
}
