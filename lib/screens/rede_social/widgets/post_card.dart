import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constant.dart';

class PostCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDoubleTap;

  const PostCard({super.key, required this.child, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: radius(12),
          color: color00,
        ),
        child: child,
      ),
    );
  }
}
