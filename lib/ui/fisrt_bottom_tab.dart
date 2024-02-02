import 'dart:async';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:order_receiving/utilities/utility_class.dart';
import 'package:provider/provider.dart';

import '../assets/app_assets.dart';
import '../providers/app_provider.dart';

class FirstBottomTab extends StatefulWidget {
  const FirstBottomTab({Key? key}) : super(key: key);

  @override
  State<FirstBottomTab> createState() => _FirstBottomTabState();
}

class _FirstBottomTabState extends State<FirstBottomTab> {

  int minutes = 10;
  UserModel userModel = UserModel.getInstance();

  @override
  void initState() {
    getData();
  }

  void getData() {
    SharedPreferenceManager.getInstance().getUserData().then((value) {
      userModel = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, isChild) {
      return Column(
        children: [

        ],
      );
    });
  }
}
