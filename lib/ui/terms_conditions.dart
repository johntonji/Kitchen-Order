import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
 late WebViewController controller;

 @override
  void initState() {

  debugPrint("terms and conditions link is ${AppProvider.termsCondition}");
     if(AppProvider.termsCondition!=""){
      controller = WebViewController()
      ..loadRequest(
        Uri.parse(AppProvider.termsCondition.trim()),
      );
   } 
  // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms And Conditions',
          style: TextStyle(
              fontSize: 18,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.primaryColor),
        ),
      ),
      body:(AppProvider.termsCondition=="")
       ? Center(
        child: Text("LOADING FAILED ...."),
       )
       : WebViewWidget(controller: controller),
    );
  }

}
