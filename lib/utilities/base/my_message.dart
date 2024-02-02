import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../assets/app_assets.dart';

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