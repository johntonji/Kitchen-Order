import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/utilities/utility_class.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../utilities/shares_pref_manager.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(AppAssets.dimen_20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50, child: Image.asset(AppAssets.appLogo),),
                const SizedBox(height: 10,),
                Text("Administrator Login", style: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoBold,), maxLines: 1, overflow: TextOverflow.ellipsis,),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    controller: _userNameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Username",
                      labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                      floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                    ),
                    cursorColor: AppAssets.widgetGrayColor,
                    style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                      floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                    ),
                    cursorColor: AppAssets.widgetGrayColor,
                    style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(_userNameController.text.isEmpty){
                      UtilityClass.showFailedDialog(context, "Data Missing", "The Username field is required");
                      return;
                    }
                    if(_passwordController.text.isEmpty){
                      UtilityClass.showFailedDialog(context, "Data Missing", "The Password field is required");
                      return;
                    }

                    UtilityClass.showLoadingDialog(context);
                    appProvider.userLogin(_userNameController.text, _passwordController.text).then((status) async {
                      UtilityClass.dismissLoading(context);
                      if(status.isSuccess){
                        UtilityClass.showSuccessDialog(context, "Login", status.message);
                        setState(() {
                          _userNameController.text = "";
                          _passwordController.text = "";
                        });

                        await Future.delayed(const Duration(seconds: 3), () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Dashboard()), (route) => false);
                        });
                      }else{
                        UtilityClass.showFailedDialog(context, "Failed", status.message);
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppAssets.greenColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text("Sign in", style: TextStyle(fontSize: 20, fontFamily: AppAssets.nunitoMedium, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

  }
}
