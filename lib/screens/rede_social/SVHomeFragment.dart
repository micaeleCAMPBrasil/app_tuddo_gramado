// ignore_for_file: file_names, deprecated_member_use

import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/stores/control_nav.dart';
import 'package:app_tuddo_gramado/screens/rede_social/components/SVPostComponent.dart';
//import 'package:app_tuddo_gramado/utils/bottom_navigation.dart';
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
    Usuario usuario = Provider.of<UsuarioProvider>(context, listen: false).getUsuario;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: color00,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: whiteColor,
          onPressed: () {
            Provider.of<ControlNav>(context, listen: false).updateIndex(0, 0);
          },
        ),
        title: Text(
          'Dicas e Roteiros',
          style: whiteBold18,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 23,
              color: color94,
            ),
            onPressed: () async {
              Provider.of<ControlNav>(context, listen: false).updateIndex(3, 1);
            },
          ),
          widthSpace10,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*heightSpace15,
            SVStoryComponent(),*/
            heightSpace10,
            SVPostComponent(usuario: usuario),
            // SVProfilePostsComponent(), meus posts
            heightSpace15,
          ],
        ),
      ),
    );
  }
}
