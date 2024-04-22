class Patrocinadores {
  int id;
  String nome,
      descricao,
      logo,
      imagemBG,
      linkWebSite,
      linkInstagram,
      linkFacebook,
      linkEndereco;
  bool isFavorite;

  List<GaleriaPatrocinador> galeria;

  Patrocinadores({
    required this.id,
    required this.nome,
    required this.logo,
    required this.imagemBG,
    required this.galeria,
    this.descricao = '',
    this.linkWebSite = '',
    this.linkInstagram = '',
    this.linkFacebook = '',
    this.linkEndereco = '',
    this.isFavorite = false,
  });
}

class GaleriaPatrocinador {
  int idPatrocinador;
  String img;
  GaleriaPatrocinador({
    required this.idPatrocinador,
    this.img = '',
  });
}
