import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';

class MyMessage{

  MyMessage.getInstance();

  static showSuccessMessage(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, textAlign: TextAlign.center,),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: AppAssets.successColor,
      ),
    );
  }

  static showFailedMessage(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, textAlign: TextAlign.center,),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: AppAssets.failureColor,
      ),
    );
  }

}