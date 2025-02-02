import 'package:flutter/material.dart';

import '../../utils/constant.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onTap;

  const GoogleButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/appetit/google.png',
              width: 45,
              height: 45,
            ),
            Text(
              'Login com Google',
              style: blackMedium16,
            ),
          ],
        ),
      ),
    );
  }
}
