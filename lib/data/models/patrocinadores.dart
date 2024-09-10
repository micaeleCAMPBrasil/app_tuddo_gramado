import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Patrocinadores {
  int id, idCategoria;
  String nome,
      descricao,
      logo,
      imagemBG,
      linkWebSite,
      linkInstagram,
      linkFacebook,
      linkEndereco;
  bool isFavorite, isBannerInicial, isMostrarSite;

  List<GaleriaPatrocinador> galeria;

  Patrocinadores({
    required this.id,
    required this.idCategoria,
    required this.nome,
    required this.logo,
    required this.imagemBG,
    required this.galeria,
    required this.isFavorite,
    required this.isBannerInicial,
    required this.isMostrarSite,
    this.descricao = '',
    this.linkWebSite = '',
    this.linkInstagram = '',
    this.linkFacebook = '',
    this.linkEndereco = '',
  });

  @override
  String toString() =>
      'Patrocinadores(id: $id, idCategoria: $idCategoria, nome: $nome, logo: $logo, imagemBG: $imagemBG, descricao: $descricao, linkWebSite: $linkWebSite, linkInstagram: $linkInstagram, linkFacebook: $linkFacebook, linkEndereco: $linkEndereco, isFavorite: $isFavorite, galeria: $galeria)';

  @override
  bool operator ==(covariant Patrocinadores other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idCategoria == idCategoria &&
        other.nome == nome &&
        other.descricao == descricao &&
        other.logo == logo &&
        other.imagemBG == imagemBG &&
        other.linkWebSite == linkWebSite &&
        other.linkInstagram == linkInstagram &&
        other.linkFacebook == linkFacebook &&
        other.linkEndereco == linkEndereco &&
        other.isFavorite == isFavorite &&
        listEquals(other.galeria, galeria);
  }

  @override
  int get hashCode =>
      id.hashCode ^
      idCategoria.hashCode ^
      nome.hashCode ^
      logo.hashCode ^
      imagemBG.hashCode ^
      descricao.hashCode ^
      linkWebSite.hashCode ^
      linkInstagram.hashCode ^
      linkFacebook.hashCode ^
      linkEndereco.hashCode ^
      isFavorite.hashCode ^
      galeria.hashCode;

  Patrocinadores copyWith({
    int? id,
    int? idCategoria,
    String? nome,
    String? logo,
    String? imagemBG,
    String? descricao,
    String? linkWebSite,
    String? linkInstagram,
    String? linkFacebook,
    String? linkEndereco,
    bool? isFavorite,
    bool? isMostrarSite,
    bool? isBannerInicial,
    List<GaleriaPatrocinador>? galeria,
  }) {
    return Patrocinadores(
      id: id ?? this.id,
      idCategoria: idCategoria ?? this.idCategoria,
      nome: nome ?? this.nome,
      logo: logo ?? this.logo,
      imagemBG: imagemBG ?? this.imagemBG,
      descricao: descricao ?? this.descricao,
      linkWebSite: linkWebSite ?? this.linkWebSite,
      linkInstagram: linkInstagram ?? this.linkInstagram,
      linkFacebook: linkFacebook ?? this.linkFacebook,
      linkEndereco: linkEndereco ?? this.linkEndereco,
      isFavorite: isFavorite ?? this.isFavorite,
      isBannerInicial: isBannerInicial ?? this.isBannerInicial,
      isMostrarSite: isMostrarSite ?? this.isMostrarSite,
      galeria: galeria ?? this.galeria,
    );
  }
}

class GaleriaPatrocinador {
  int idPatrocinador;
  String img, link;
  GaleriaPatrocinador({
    required this.idPatrocinador,
    this.img = '',
    this.link = '',
  });
}
