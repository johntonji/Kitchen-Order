
import 'package:flutter/material.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class FirstBottomTab extends StatefulWidget {
  const FirstBottomTab({super.key});

  @override
  State<FirstBottomTab> createState() => _FirstBottomTabState();
}

class _FirstBottomTabState extends State<FirstBottomTab> {

  int minutes = 10;
  UserModel userModel = UserModel.getInstance();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    SharedPreferenceManager.getInstance().getUserData().then((value) {
      userModel = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("FirstBottomTab called");
    return Consumer<AppProvider>(builder: (context, provider, isChild) {
      return Column(
        children: [
        ],
      );
    });
  }
}
