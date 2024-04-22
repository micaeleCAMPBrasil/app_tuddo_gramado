// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVProfileHeaderComponent extends StatelessWidget {
  const SVProfileHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                'assets/social/image.png',
                width: context.width(),
                height: 130,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRectOnly(
                  topLeft: 12.toInt(), topRight: 12.toInt()),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: radius(18)),
                  child: Image.asset('assets/social/face_5.png',
                          height: 88, width: 88, fit: BoxFit.cover)
                      .cornerRadiusWithClipRRect(12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
