import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleButton extends StatelessWidget {
  final VoidCallback onTap;

  const AppleButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        heightSpace20,
        // botao para login com apple
        SignInWithAppleButton(
          text: 'Login com Apple',
          onPressed: onTap,
        ),
      ],
    );
  }
}
