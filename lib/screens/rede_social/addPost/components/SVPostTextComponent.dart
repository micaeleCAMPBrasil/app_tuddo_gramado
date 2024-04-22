// ignore_for_file: file_names

import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVPostTextComponent extends StatelessWidget {
  const SVPostTextComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: scaffoldColor, borderRadius: radius(12)),
      child: TextField(
        autofocus: false,
        maxLines: 15,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Whats On Your Mind',
          hintStyle: color94SemiBold16,
        ),
      ),
    );
  }
}
