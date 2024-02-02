import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../assets/app_assets.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class UtilityClass {

  static String convertTextIntoStars(String text) {
    List<String> list = [];

    var stars = StringBuffer();

    for(int i=0; i<text.length; i++){
      list.add("*");
    }

    list.forEach((item){
      stars.write(item);
    });

    return stars.toString();
  }

  static showSuccessDialog(BuildContext context, String title, String message){
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      dismissDirection: DismissDirection.down,
      duration: const Duration(seconds: 3),
      content: AwesomeSnackbarContent(
        title: title,
        titleFontSize: 18,
        message: message,
        messageFontSize: 14,
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showFailedDialog(BuildContext context, String title, String message){
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      dismissDirection: DismissDirection.down,
      duration: const Duration(seconds: 3),
      content: AwesomeSnackbarContent(
        title: title,
        titleFontSize: 18,
        message: message,
        messageFontSize: 14,
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(0),
          elevation: 6,
          scrollable: true,
          insetPadding: const EdgeInsets.symmetric(horizontal: 120),
          backgroundColor: AppAssets.whiteColor,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: const BoxDecoration(
                color: AppAssets.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Column(
              children: [
                const SpinKitDualRing(color: AppAssets.textDarkGrayColor),
                const SizedBox(height: 30,),
                Text("Loading", style: TextStyle(fontSize: AppAssets.dimen_16, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textDarkGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text("Please Wait ...", style: TextStyle(fontSize: AppAssets.dimen_18, fontFamily: AppAssets.nunitoRegular, color: AppAssets.textDarkGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,)
              ],
            ),
          ),
        );
      },
    );
  }

  static dismissLoading(BuildContext context){
    Navigator.of(context).pop();
  }

  static closeScreen(BuildContext context){
    Navigator.of(context).pop();
  }

  static String getInitials(String text) => text.isNotEmpty
      ? text.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';
}