class Modalidade {
  int? id, parent;
  String? nome, descricao;
  Images? image;

  Modalidade({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.image,
    required this.parent,
  });

  Modalidade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['title']['rendered'];
    descricao = json['descricao'];
    parent = json['parent'];
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
  }
}

class Images {
  String url = '';

  Images({required this.url});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['src'];
  }
}
