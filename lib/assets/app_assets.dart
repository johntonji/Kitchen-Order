import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppAssets {

  //Strings
  static const String fullName = "Order Receiving";
  static const String fullNameTwoLines = "Order\nReceiving";

  //App Colors
  static const Color primaryColor = Color(0XFF000000); // black color
  static const Color secondaryColor = Color(0XFFFFFFFF); // white color
  static const Color textLightGrayColor = Color(0XFF919191); // Light Gray color
  static const Color textLightWhiteColor = Color(0xFFC4C4C4); // Light Gray color
  static const Color greenColor = Color(0xFF4FD193); // Green color
  static const Color redColor = Color(0xFFE22C2C); // Red color
  static const Color purpleColor = Color(0xFF4E105F); // Purple color
  static const Color pausedColor = Color(0xFFECB22E); // orange and yellow mix color

  static const Color textDarkGrayColor = Color(0XFF2A2E40); // Grayish color
  static const Color textNormalGrayColor = Color(0XFF545255); // Gray color

  static const Color backgroundColor = Color(0XFFF6F6F6); // Light White color
  static const Color widgetGrayColor = Color(0XFFA0AEC0); // Widget Gray color
  static const Color widgetLightColor = Color(0xfff6f6f6); // Widget Light Gray color
  static const Color tabBackgroundColor = Color(0XFFECEFF2); // Tab Background color
  static const Color tabBorderColor = Color(0XFF313860); // Tab Border color
  static const Color blackColor = Color(0XFF000000); // Black Color
  static const Color whiteColor = Color(0XFFFFFFFF); // White color
  static const Color successColor = Color(0XFF50C13C); // light Green
  static const Color failureColor = Color(0XFFF53700); // light Red
  static const Color transparentColor = Color(0X00FFFFFF); // Transparent

  // Fonts
  static String nunitoBold = "Nunito-Bold";
  static String nunitoLight = "Nunito-Light";
  static String nunitoMedium = "Nunito-Medium";
  static String nunitoRegular = "Nunito-Regular";

  // Icons
  static const String appLogo="assets/icons/app_icon.png";
  static const String honeycombIcon="assets/icons/honeycomb.svg";
  static const String themeIcon="assets/icons/theme.svg";
  //static const String appLogo="assets/icons/eatsbee_logo.png";
  static const String bagIcon="assets/icons/bag.svg";
  static const String preparingIcon="assets/icons/preparing.svg";
  static const String busyIcon="assets/icons/busy.svg";
  static const String timerIcon="assets/icons/timer.svg";
  static const String phoneIcon="assets/icons/phone.svg";
  static const String emailIcon="assets/icons/email.svg";
  static const String vanIcon="assets/icons/van.svg";
  static const String tickIcon="assets/icons/tick.svg";
  static const String settingsIcon="assets/icons/settings_icon.svg";

  //TextStyles
  //TextStyle normalTextStyle = TextStyle(fontSize: 14, color: AppAssets.textColor, fontFamily: AppAssets.ralewayRegular);

  //Json Files
  //static const String prayerTimesJsonFile="assets/jsons/prayer_time_json.json";

  //Box Decorations
  static BoxDecoration leftTabSelectedDecoration = BoxDecoration(
      color: AppAssets.tabBackgroundColor,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12), topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
      border: Border.all(color: AppAssets.tabBorderColor, width: 1)
  );
  static BoxDecoration leftTabUnSelectedDecoration = BoxDecoration(
      color: AppAssets.whiteColor,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12), topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
      border: Border.all(color: AppAssets.textLightWhiteColor, width: 1)
  );
  static BoxDecoration centerTabSelectedDecoration = BoxDecoration(
      color: AppAssets.tabBackgroundColor,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0), topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
      border: Border.all(color: AppAssets.tabBorderColor, width: 1)
  );
  static BoxDecoration centerTabUnSelectedDecoration = BoxDecoration(
      color: AppAssets.whiteColor,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0), topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
      border: Border.all(color: AppAssets.textLightWhiteColor, width: 1)
  );
  static BoxDecoration rightTabSelectedDecoration = BoxDecoration(
      color: AppAssets.tabBackgroundColor,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0), topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      border: Border.all(color: AppAssets.tabBorderColor, width: 1)
  );
  static BoxDecoration rightTabUnSelectedDecoration = BoxDecoration(
      color: AppAssets.whiteColor,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0), topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      border: Border.all(color: AppAssets.textLightWhiteColor, width: 1)
  );

  //For text font sizes
  /**
   * H1 -> 25px
   * H2 -> 19px
   * H3 -> 14px
   * H4 -> 10px
   */

  //Dimensions
  static const double dimen_0 = 0;
  static const double dimen_1 = 1;
  static const double dimen_2 = 2;
  static const double dimen_3 = 3;
  static const double dimen_4 = 4;
  static const double dimen_6 = 6;
  static const double dimen_8 = 8;
  static const double dimen_10 = 10;
  static const double dimen_12 = 12;
  static const double dimen_14 = 14;
  static const double dimen_15 = 15;
  static const double dimen_16 = 16;
  static const double dimen_18 = 18;
  static const double dimen_20 = 20;
  static const double dimen_22 = 22;
  static const double dimen_24 = 24;
  static const double dimen_26 = 26;
  static const double dimen_30 = 30;
  static const double dimen_36 = 36;
  static const double dimen_40 = 40;
  static const double dimen_46 = 46;
  static const double dimen_50 = 50;
  static const double dimen_56 = 56;
  static const double dimen_58 = 58;
  static const double dimen_60 = 60;
  static const double dimen_66 = 66;
  static const double dimen_64 = 64;
  static const double dimen_70 = 70;
  static const double dimen_80 = 80;
  static const double dimen_86 = 86;
  static const double dimen_90 = 90;
  static const double dimen_100 = 100;
  static const double dimen_120 = 120;
  static const double dimen_130 = 130;
  static const double dimen_150 = 150;
}