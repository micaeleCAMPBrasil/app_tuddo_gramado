// ignore_for_file: file_names

import 'package:nb_utils/nb_utils.dart';

class AWalkThroughModel {
  String? heading;
  String? title;
  String? subtitle;
  String? image;
  double? progress;

  AWalkThroughModel({
    this.heading,
    this.title,
    this.subtitle,
    this.image,
    this.progress,
  });
}

final List<AWalkThroughModel> modal = [
  AWalkThroughModel(
    heading: 'Tuddo Gramado',
    title: 'Tuddo em Dobro',
    subtitle: 'Vou colocar a descrição desse serviço! ',
    image: 'assets/image/p1.jpeg',
    progress: 0.33,
  ),
  AWalkThroughModel(
    heading: 'Tuddo Gramado',
    title: 'Transfer',
    subtitle: 'Vou colocar a descrição desse serviço! ',
    image: 'assets/image/p3.png',
    progress: 0.66,
  ),
  AWalkThroughModel(
    heading: 'Tuddo Gramado',
    title: 'Aluguel por Temporada',
    subtitle: 'Vou colocar a descrição desse serviço! ',
    image: 'assets/image/p2.jpeg',
    progress: 1,
  ),
];

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en-US',
        flag: 'images/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        fullLanguageCode: 'hi-IN',
        flag: 'images/flag/ic_hi.png'),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        fullLanguageCode: 'ar-AR',
        flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(
        id: 4,
        name: 'French',
        languageCode: 'fr',
        fullLanguageCode: 'fr-FR',
        flag: 'images/flag/ic_fr.png'),
  ];
}
