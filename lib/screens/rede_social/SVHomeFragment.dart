// ignore_for_file: file_names, deprecated_member_use

import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVHomeDrawerComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVPostComponent.dart';
import 'package:app_tuddo_gramado/screens/rede_social/screens/SVPostAdd.dart';
import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SVHomeFragment extends StatefulWidget {
  const SVHomeFragment({super.key});

  @override
  State<SVHomeFragment> createState() => _SVHomeFragmentState();
}

class _SVHomeFragmentState extends State<SVHomeFragment> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(scaffoldColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario =
        Provider.of<UsuarioProvider>(context, listen: false).getUsuario;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(
              selectedIndex: 0,
            ),
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          backgroundColor: color00,
          elevation: 0,
          /*leading: IconButton(
            icon: Image.asset(
              'assets/icones/ic_More.png',
              width: 18,
              height: 18,
              fit: BoxFit.cover,
              color: color94,
            ),
            onPressed: () {
              //scaffoldKey.currentState?.openDrawer();
            },
          ),*/
          title: Text(
            'Dicas e Roteiros',
            style: whiteBold18,
          ),
          actions: [
            IconButton(
              icon: /*Image.asset(
                'assets/icones/ic_Camera.png',
                width: 24,
                height: 22,
                fit: BoxFit.fill,
                color: color94,
              ),*/
                  Icon(
                Icons.add_a_photo,
                size: 23,
                color: color94,
              ),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SVPostAdd(
                      usuario: usuario,
                    ),
                  ),
                );
              },
            ),
            widthSpace10,
          ],
        ),
        drawer: Drawer(
          backgroundColor: context.cardColor,
          child: const SVHomeDrawerComponent(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /*heightSpace15,
              SVStoryComponent(),*/
              heightSpace10,
              SVPostComponent(
                usuario: usuario,
              ),
              // SVProfilePostsComponent(), meus posts
              heightSpace15,
            ],
          ),
        ),
      ),
    );
  }
}
