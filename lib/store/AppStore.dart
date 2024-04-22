// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';
part 'AppStore.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool isDarkModeOn = false;

  @observable
  bool isHover = false;

  @observable
  Color? iconColor;

  @observable
  Color? backgroundColor;

  @observable
  Color? appBarColor;

  @observable
  Color? scaffoldBackground;

  @observable
  Color? backgroundSecondaryColor;

  @observable
  Color? appColorPrimaryLightColor;

  @observable
  Color? iconSecondaryColor;

  @observable
  Color? textPrimaryColor;

  @observable
  Color? textSecondaryColor;

  @action
  Future<void> toggleDarkMode({bool? value}) async {
    isDarkModeOn = value ?? !isDarkModeOn;

    if (isDarkModeOn) {
      scaffoldBackground = scaffoldColor;

      appBarColor = color00;
      backgroundColor = Colors.white;
      backgroundSecondaryColor = Colors.white;
      appColorPrimaryLightColor = color22;

      iconColor = primaryColor;
      iconSecondaryColor = starColor;

      textPrimaryColor = whiteColor;
      textSecondaryColor = Colors.white54;

      textPrimaryColorGlobal = whiteColor;
      textSecondaryColorGlobal = Colors.white54;
      shadowColorGlobal = color94;
    } else {
      scaffoldBackground = scaffoldLightColor;

      appBarColor = Colors.white;
      backgroundColor = Colors.black;
      backgroundSecondaryColor = appSecondaryBackgroundColor;
      appColorPrimaryLightColor = appColorPrimaryLight;

      iconColor = primaryColor;
      iconSecondaryColor = starColor;

      textPrimaryColor = appTextColorPrimary;
      textSecondaryColor = appTextColorSecondary;

      textPrimaryColorGlobal = appTextColorPrimary;
      textSecondaryColorGlobal = appTextColorSecondary;
      shadowColorGlobal = appShadowColor;
    }
    setStatusBarColor(scaffoldBackground!);

    setValue(isDarkModeOnPref, isDarkModeOn);
  }

  @action
  void toggleHover({bool value = false}) => isHover = value;
}


// flutter packages pub run build_runner build --delete-conflicting-outputs

