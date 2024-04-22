import 'package:app_tuddo_gramado/data/models/patrocinadores.dart';

class PatrocinadoresStore {
  static List<Patrocinadores> getPatrocinadores = [
    Patrocinadores(
      id: 1,
      nome: 'Alimentos Júnior',
      logo: 'https://ibb.co/hszG0rb',
      descricao:
          'Nós, da Alimentos Júnior Consultoria, transformamos vidas, sabendo que é possível realizar sonhos, gerando oportunidades para um legado de impacto.',
      imagemBG: 'assets/image/p1.jpeg',
      isFavorite: true,
      linkWebSite:
          'https://alimentosjunior.com.br/?gad_source=1&gclid=CjwKCAjwrIixBhBbEiwACEqDJaqxdAmRRQ9PrM5TDMg6vNTADDjfqf_nzmzxsGuDMjHH2bZT0dk3zhoCMEAQAvD_BwE',
      linkEndereco:
          'https://www.google.com.br/maps/place/DTA+UFV/@-20.7610811,-42.8679205,17z/data=!4m10!1m2!2m1!1sDepartamento+de+Tecnologia+de+Alimentos+II+-+Campus+Universit%C3%A1rio+UFV,+Vi%C3%A7osa+-+MG!3m6!1s0xa367f798cb50c3:0xcc6d3cafb0288cd0!8m2!3d-20.761184!4d-42.8656758!15sClREZXBhcnRhbWVudG8gZGUgVGVjbm9sb2dpYSBkZSBBbGltZW50b3MgSUkgLSBDYW1wdXMgVW5pdmVyc2l0w6FyaW8gVUZWLCBWacOnb3NhIC0gTUeSAQp1bml2ZXJzaXR54AEA!16s%2Fg%2F120w3kyh?entry=ttu',
      linkInstagram: 'https://www.instagram.com/alimentos.junior/',
      galeria: [
        GaleriaPatrocinador(
          idPatrocinador: 1,
          img: 'https://i.ibb.co/nwJ3fpC/img3.png',
        ),
        GaleriaPatrocinador(
          idPatrocinador: 1,
          img: 'https://i.ibb.co/zZLYpP4/img2.jpg',
        ),
        GaleriaPatrocinador(
          idPatrocinador: 1,
          img: 'https://i.ibb.co/64JnqR6/img1.jpg',
        ),
      ],
    ),
    Patrocinadores(
      id: 2,
      nome: 'Patrocinador 2',
      logo: '',
      imagemBG: 'assets/image/p2.jpeg',
      isFavorite: false,
      linkEndereco:
          'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
      linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
      galeria: [],
    ),
    Patrocinadores(
      id: 3,
      nome: 'Patrocinador 3',
      logo: '',
      imagemBG: 'assets/image/p3.png',
      isFavorite: false,
      linkEndereco:
          'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
      linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
      galeria: [],
    ),
    Patrocinadores(
      id: 2,
      nome: 'Patrocinador 2',
      logo: '',
      imagemBG: 'assets/image/p2.jpeg',
      isFavorite: false,
      linkEndereco:
          'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
      linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
      galeria: [],
    ),
    Patrocinadores(
      id: 1,
      nome: 'Patrocinador 1',
      logo: '',
      imagemBG: 'assets/image/p1.jpeg',
      isFavorite: true,
      linkEndereco:
          'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
      linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
      galeria: [],
    ),
    Patrocinadores(
      id: 3,
      nome: 'Patrocinador 3',
      logo: '',
      imagemBG: 'assets/image/p3.png',
      isFavorite: false,
      linkEndereco:
          'https://www.google.com/maps/place/R.+Francisco+Holanda+Oliveira+-+Novo+Maranguape+II,+Maranguape+-+CE,+61944-110/@-3.8794918,-38.676094,17z/data=!3m1!4b1!4m6!3m5!1s0x7c0acbcfe019cef:0xb70070bb5e1bc615!8m2!3d-3.8794972!4d-38.6712231!16s%2Fg%2F1ymvt7p4n?entry=ttu',
      linkInstagram: 'https://www.instagram.com/micaele.sales.ribeiro/',
      galeria: [],
    ),
  ];
}
