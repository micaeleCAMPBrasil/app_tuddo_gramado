import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/screens/login/ALoginScreen.dart';
import 'package:app_tuddo_gramado/services/auth_service.dart';

import '../utils/constant.dart';

class UiHelper {
  static void showLogOutDialog(
    BuildContext context,
  ) {
    AlertDialog logoutDialog = AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Text(
                'Sair',
                style: whiteSemiBold20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
              width: MediaQuery.of(context).size.width,
              height: 130,
              decoration: const BoxDecoration(
                color: appTextColorPrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tem certeza que deseja sair?',
                    style: whiteRegular16,
                  ),
                  heightSpace15,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: primaryBold18,
                        ),
                      ),
                      widthSpace20,
                      GestureDetector(
                        onTap: () {
                          AuthService.logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ALoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sair',
                          style: primaryBold18,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => logoutDialog);
  }

  static void showLoadingDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: primaryColor),
              heightSpace20,
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: appTextColorPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}