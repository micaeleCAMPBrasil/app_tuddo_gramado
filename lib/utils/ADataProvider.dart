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
    subtitle:
        'Compre um prato, uma diária, um ingresso ou uma experiência e ganhe outra na hora.',
    image: 'assets/image/3.png',
    progress: 0.33,
  ),
  AWalkThroughModel(
    heading: 'Tuddo Gramado',
    title: 'Transfer',
    subtitle:
        'Aeroporto x Gramado \nEscolha apenas um trecho ou garanta sua reserva para ida e volta com antecedência para Gramado, Canela ou cidades vizinhas.',
    image: 'assets/image/2.png',
    progress: 0.66,
  ),
  AWalkThroughModel(
    heading: 'Tuddo Gramado',
    title: 'Aluguel por Temporada',
    subtitle:
        'Garanta sua hospedagem com os melhores preços direto com os anfitriões.',
    image: 'assets/image/1.png',
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
