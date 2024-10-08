import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
import 'package:image_picker/image_picker.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  const PrimaryButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: blackBold18,
        ),
      ),
    );
  }
}

class PrimaryTextfieldTelefone extends StatelessWidget {
  final String? hintText;
  final bool? obsecureText;
  final TextEditingController controller;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String lableText;
  final String? prefixText;

  const PrimaryTextfieldTelefone({
    super.key,
    required this.lableText,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.maxLength,
    required this.controller,
    this.obsecureText,
    this.hintText,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText ?? false,
      cursorColor: primaryColor,
      scrollPadding: EdgeInsets.zero,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: whiteMedium16,
      maxLength: maxLength,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Digite um telefone válido';
        } else if (value.length < 10) {
          return 'Digite um telefone válido';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: whiteMedium16,
        prefixText: prefixText,
        counterText: '',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color94,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color94,
          ),
        ),
        labelText: lableText,
        labelStyle: color94Regular15,
      ),
    );
  }
}

class PrimaryTextfieldCodigo extends StatelessWidget {
  final String? hintText;
  final bool? obsecureText;
  final TextEditingController controller;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String lableText;
  final String? prefixText;

  const PrimaryTextfieldCodigo({
    super.key,
    required this.lableText,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.maxLength,
    required this.controller,
    this.obsecureText,
    this.hintText,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      controller: controller,
      obscureText: obsecureText ?? false,
      cursorColor: scaffoldColor,
      scrollPadding: EdgeInsets.zero,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: whiteMedium16,
      maxLength: maxLength,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Código Inválido';
        } else if (value.length < 6) {
          return 'Código Inválido';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: whiteMedium16,
        prefixText: prefixText,
        counterText: '',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color94,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color94,
          ),
        ),
        labelText: lableText,
        labelStyle: color94Regular15,
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final List<Widget>? actions;
  final bool? centerTitle;
  final String? title;
  final Widget? leading;

  const MyAppBar({
    super.key,
    this.title = '',
    this.centerTitle = false,
    this.titleStyle,
    this.actions,
    this.backgroundColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: backgroundColor ?? transparent,
      elevation: 0,
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      title: centerTitle == false
          ? Align(
              alignment: Localizations.localeOf(context) == const Locale('ar')
                  ? const Alignment(1.2, 0)
                  : const Alignment(-1.2, 0),
              child: AutoSizeText(
                title.toString(),
                style: titleStyle ?? whiteBold22,
                maxLines: 1,
              ),
            )
          : AutoSizeText(
              title.toString(),
              style: titleStyle ?? whiteBold22,
              maxLines: 1,
            ),
    );
  }
}

class PrimaryTextfield extends StatelessWidget {
  final String? hintText;
  final bool? obsecureText;
  final TextEditingController? controller;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String lableText;

  const PrimaryTextfield({
    super.key,
    required this.lableText,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.maxLength,
    this.controller,
    this.obsecureText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecureText ?? false,
      cursorColor: primaryColor,
      scrollPadding: EdgeInsets.zero,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: whiteMedium16,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: whiteMedium16,
        counterText: '',
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color94)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color94)),
        labelText: lableText,
        labelStyle: color94Regular15,
      ),
    );
  }
}

Future<File> svGetImageSource() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.camera);
  return File(pickedImage!.path);
}

String formatarNome(String nome) {
  final nomeDividido = nome.split(' ');
  String pNome = "";
  String sNome = "";

  if (nomeDividido.isEmpty) {
  } else if (nomeDividido.length == 1) {
    pNome = nomeDividido[0];
  } else {
    pNome = nomeDividido[0];
    sNome = nomeDividido[1];
  }
  String nomeFormatado = '$pNome $sNome';
  return nomeFormatado;
}
