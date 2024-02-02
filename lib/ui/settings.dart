import 'dart:async';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/ui/bluetooth/scan_devices.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:order_receiving/utilities/utility_class.dart';
import 'package:provider/provider.dart';

import '../assets/app_assets.dart';
import '../providers/app_provider.dart';
import 'login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

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
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text("AVAILABILITY", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: AppAssets.primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.symmetric(horizontal: AppAssets.dimen_12),
              child: ExpandableNotifier(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expandable(
                      collapsed: ExpandableButton(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppAssets.tabBackgroundColor,
                              radius: 22,
                              child: SvgPicture.asset(AppAssets.bagIcon, colorFilter: ColorFilter.mode(AppAssets.textDarkGrayColor, BlendMode.srcIn), height: 20, width: 20,),
                            ),
                            const SizedBox(width: 12,),
                            Expanded(
                              child: Text("Menu Items", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ),
                            const SizedBox(width: 12,),
                            Icon(MdiIcons.plus, color: AppAssets.textDarkGrayColor, size: 20,),
                          ],
                        ),
                      ),
                      expanded: Column(
                        children: [
                          ExpandableButton(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppAssets.tabBackgroundColor,
                                  radius: 22,
                                  child: SvgPicture.asset(AppAssets.bagIcon, colorFilter: ColorFilter.mode(AppAssets.textDarkGrayColor, BlendMode.srcIn), height: 20, width: 20,),
                                ),
                                const SizedBox(width: 12,),
                                Expanded(
                                  child: Text("Menu Items", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ),
                                const SizedBox(width: 12,),
                                Icon(MdiIcons.minus, color: AppAssets.textDarkGrayColor, size: 20,),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: AppAssets.dimen_12),
                                      child: Text("CATEGORIES", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 13, color: AppAssets.textLightGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ),
                                    const SizedBox(height: 6),
                                    ListView.builder(
                                      itemCount: 4,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index){
                                        return Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          color: Color(0xFFF5F5F5),
                                          padding: const EdgeInsets.symmetric(horizontal: AppAssets.dimen_12),
                                          child: ExpandableNotifier(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expandable(
                                                  collapsed: ExpandableButton(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text("Pizza", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_14), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                        ),
                                                        const SizedBox(width: 12,),
                                                        Icon(MdiIcons.plus, color: AppAssets.textDarkGrayColor, size: 20,),
                                                      ],
                                                    ),
                                                  ),
                                                  expanded: Column(
                                                    children: [
                                                      ExpandableButton(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text("Pizza", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                            ),
                                                            const SizedBox(width: 12,),
                                                            Icon(MdiIcons.minus, color: AppAssets.textDarkGrayColor, size: 20,),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                ListView.builder(
                                                                    itemCount: 2,
                                                                    shrinkWrap: true,
                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                    itemBuilder: (context, index){
                                                                      return Container(
                                                                        margin: const EdgeInsets.only(top: 10, bottom: 10,),
                                                                        color: Color(0xFFF5F5F5),
                                                                        padding: const EdgeInsets.only(left: AppAssets.dimen_12),
                                                                        child: Row(
                                                                          children: [
                                                                            Text("Pizza Margherita", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_14), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                                            Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                                              margin: const EdgeInsets.symmetric(horizontal: 6),
                                                                              decoration: BoxDecoration(
                                                                                color: AppAssets.successColor.withOpacity(0.2),
                                                                                borderRadius: BorderRadius.circular(20),
                                                                              ),
                                                                              child: Text("Available", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 10, color: AppAssets.successColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                                            ),
                                                                            const Expanded(child: SizedBox(width: 12,)),
                                                                            Icon(MdiIcons.dotsVertical, color: AppAssets.textDarkGrayColor, size: 20,),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Divider(
                                                  height: 1,
                                                  color: AppAssets.widgetGrayColor.withOpacity(0.3),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppAssets.widgetGrayColor.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppAssets.tabBackgroundColor,
                    radius: 22,
                    child: Icon(MdiIcons.archivePlusOutline, color: AppAssets.textNormalGrayColor, size: 20,),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: Text("Choices & addons", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text("SETTINGS", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: AppAssets.primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScanDevices()));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppAssets.tabBackgroundColor,
                      radius: 22,
                      child: Icon(MdiIcons.printerOutline, color: AppAssets.textNormalGrayColor, size: 20,),
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Text("Auto-print orders", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text("ACCOUNT", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: AppAssets.primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppAssets.tabBackgroundColor,
                    radius: 22,
                    child: Icon(MdiIcons.accountOutline, color: AppAssets.textNormalGrayColor, size: 20,),                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: Text("Profile", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                height: 1,
                color: AppAssets.widgetGrayColor.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppAssets.tabBackgroundColor,
                    radius: 22,
                    child: Icon(MdiIcons.web, color: AppAssets.textNormalGrayColor, size: 20,),                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: Text("Language", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                height: 1,
                color: AppAssets.widgetGrayColor.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppAssets.tabBackgroundColor,
                    radius: 22,
                    child: Icon(MdiIcons.informationOutline, color: AppAssets.textNormalGrayColor, size: 20,),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: Text("Terms and conditions", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                SharedPreferenceManager.getInstance().clearAllPreferences().then((value) {
                  if(value == "Cleared"){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                  }
                });
              },
              child: Container(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppAssets.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppAssets.tabBackgroundColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                      ),
                      child: Icon(MdiIcons.logout, size: 20,),
                    ),
                    const SizedBox(width: 12,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Logout from current session", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                      ],
                    )),
                    const SizedBox(width: 12,),
                    CircleAvatar(
                      backgroundColor: AppAssets.transparentColor,
                      radius: 22,
                      child: Icon(MdiIcons.chevronRight, size: 30,),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),

          ],
        ),
      );
    });
  }
}
