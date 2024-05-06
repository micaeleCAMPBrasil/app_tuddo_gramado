// ignore_for_file: deprecated_member_use

import 'package:app_tuddo_gramado/screens/webscreens/WebViewScreen.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/constant.dart';
import '../../utils/widgets.dart';

// ignore: must_be_immutable
class SubscribePage extends StatelessWidget {
  int index;

  SubscribePage({
    super.key,
    this.index = 4,
  });

  @override
  Widget build(BuildContext context) {
    List allowsList = [
      'Você ganha em dobro',
      'Vende mais',
      'Aumenta seu faturamento',
      'É visto por milhares de pessoas todos os dias',
    ];
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(
              selectedIndex: index,
            ),
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: MyAppBar(
            backgroundColor: color00,
            title: 'Faça Parte',
            leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigation(
                      selectedIndex: index,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSpace15,
                Links(
                  link: 'https://dobro.tuddogramado.com.br/planos/',
                  title: 'Assine',
                  subtitle: '12 meses',
                  description: 'R\$ 197,00',
                ),
                heightSpace10,
                Links(
                  link: 'https://tuddogramado.com.br/affiliate-area/',
                  title: 'Seja Afiliado',
                  subtitle: 'Venda para sua audiência',
                  description: 'Faça Parte',
                ),
                heightSpace10,
                Links(
                  link:
                      'https://tuddogramado.com.br/venda-mais-com-tuddo-em-dobro/',
                  title: 'Tuddo em Dobro',
                  subtitle: 'Venda Mais',
                  description: 'Faça Parte',
                ),
                heightSpace10,
                Links(
                  link:
                      'https://tuddogramado.com.br/seja-motorista-parceiro-da-tuddo-gramado/',
                  title: 'Seja Motorista',
                  subtitle: 'Parceiro de Transfer',
                  description: 'Faça Parte',
                ),
                heightSpace10,
                Links(
                  link: 'https://tuddogramado.com.br/account/new-post/',
                  title: 'Aluguel por Temporada',
                  subtitle: 'Cadastre seu Imovél',
                  description: 'Faça Parte',
                ),
                heightSpace20,
                Text('Na Tuddo Gramado', style: whiteSemiBold20),
                heightSpace10,
                ...allowsList.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          child: Image.asset('assets/icones/checkCircle.png'),
                        ),
                        widthSpace15,
                        AutoSizeText(
                          e,
                          maxLines: 2,
                          style: color94Regular16,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Links extends StatelessWidget {
  String link, title, subtitle, description;
  Links({
    super.key,
    required this.link,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(
              url: link,
              index: 4,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                image: AssetImage('assets/image/subscribe.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    black.withOpacity(.25),
                    black.withOpacity(.25),
                  ]),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: whiteBold16,
                          ),
                          widthSpace10,
                          AutoSizeText(
                            subtitle,
                            style: whiteSemiBold20,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      description,
                      style: whiteSemiBold18,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
