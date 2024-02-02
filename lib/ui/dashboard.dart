import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:order_receiving/ui/fisrt_bottom_tab.dart';
import 'package:order_receiving/ui/login.dart';
import 'package:order_receiving/ui/new_tab.dart';
import 'package:order_receiving/ui/preparing_tab.dart';
import 'package:order_receiving/ui/ready_tab.dart';
import 'package:order_receiving/ui/settings.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:provider/provider.dart';

import '../assets/app_assets.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';
import 'all_orders.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  Timer? timer;
  UserModel userModel = UserModel.getInstance();

  int selectedTab = 0;
  int selectedBottom = 1;
  bool _availableCheck = true;
  bool _tomorrowCheck = false;
  bool _customCheck = false;
  bool _undeterminedCheck = false;

  String pauseDate = "";

  List<Widget> tabs = [
    const NewTab(),
    const PreparingTab(),
    const ReadyTab()
  ];

  @override
  void initState() {
    getData();
  }

  void getData() {
    SharedPreferenceManager.getInstance().getUserData().then((data) {
      userModel = data;
      Provider.of<AppProvider>(context, listen: false).newOrders(data.authToken!).then((value) {
        Provider.of<AppProvider>(context, listen: false).processingOrders(data.authToken!).then((value) {
          Provider.of<AppProvider>(context, listen: false).readyOrders(data.authToken!).then((value) {
            timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => Provider.of<AppProvider>(context, listen: false).autoNewOrders(data.authToken!));
            timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => Provider.of<AppProvider>(context, listen: false).autoProcessingOrders(data.authToken!));
            timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => Provider.of<AppProvider>(context, listen: false).autoReadyOrders(data.authToken!));
          });
        });
      });
    });
  }

  updateState() {
    Navigator.of(context).pop();
    setState(() {});
  }

  void modelSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppAssets.whiteColor,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 6,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppAssets.textLightGrayColor.withOpacity(0.5)
                  ),
                ),
                CheckboxListTile(
                  title: const Text("AVAILABLE", style: TextStyle(fontSize: 14,), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  value: _availableCheck,
                  activeColor: AppAssets.primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  onChanged: (newValue) {
                    setState(() {
                      if(!newValue!){
                        return;
                      }
                      _availableCheck = newValue;
                      _tomorrowCheck = false;
                      _customCheck = false;
                      _undeterminedCheck = false;
                    });
                    updateState();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text("UNTIL TOMORROW", style: TextStyle(fontSize: 14,), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  value: _tomorrowCheck,
                  activeColor: AppAssets.primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  onChanged: (newValue) {
                    setState(() {
                      if(!newValue!){
                        return;
                      }
                      _tomorrowCheck = newValue!;
                      _availableCheck = false;
                      _customCheck = false;
                      _undeterminedCheck = false;
                    });
                    updateState();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text("UNTIL CUSTOM DATE", style: TextStyle(fontSize: 14,), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  value: _customCheck,
                  activeColor: AppAssets.primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  onChanged: (newValue) {
                    if(!newValue!){
                      return;
                    }
                    BottomPicker.date(
                      title:  "Set your Date",
                      titlePadding: const EdgeInsets.only(bottom: 10),
                      titleAlignment: CrossAxisAlignment.center,
                      buttonWidth: 100,
                      buttonPadding: 10,
                      description: "Your order receiving process will be pause until your selected date",
                      descriptionStyle:  TextStyle(
                          fontSize:  14,
                          fontFamily: AppAssets.nunitoMedium,
                          color:  AppAssets.textLightGrayColor
                      ),
                      titleStyle:  TextStyle(
                          fontSize:  16,
                          fontFamily: AppAssets.nunitoBold,
                          color:  AppAssets.primaryColor
                      ),
                      pickerTextStyle:  TextStyle(
                          fontSize:  16,
                          fontFamily: AppAssets.nunitoBold,
                          color:  AppAssets.primaryColor
                      ),
                      closeIconSize: 30,
                      closeIconColor: AppAssets.redColor,
                      minDateTime: DateTime.now(),
                      onSubmit: (index) {
                        pauseDate = DateFormat("yyyy-mm-dd").format(index);
                        setState(() {
                          _customCheck = newValue;
                          _availableCheck = false;
                          _tomorrowCheck = false;
                          _undeterminedCheck = false;
                        });
                        updateState();
                      },
                    ).show(context);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text("UNDETERMINED", style: TextStyle(fontSize: 14,), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  value: _undeterminedCheck,
                  activeColor: AppAssets.primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  onChanged: (newValue) {
                    setState(() {
                      if(!newValue!){
                        return;
                      }
                      _undeterminedCheck = newValue!;
                      _availableCheck = false;
                      _tomorrowCheck = false;
                      _customCheck = false;
                    });
                    updateState();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, isChild) {
      return SafeArea(child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFFF5F5F5),
          child: Column(
            children: [
              //const SizedBox(height: 20,),
              Container(
                color: AppAssets.whiteColor,
                height: 66,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.appLogo, width: 30, height: 30,),
                      const SizedBox(width: 10,),
                      Expanded(child: Text("Orders", style: TextStyle(fontSize: 20, fontFamily: AppAssets.nunitoBold,), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            modelSheet();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        _availableCheck ? "ACTIVE" :
                                        _tomorrowCheck ? "PAUSED UNTIL TOMORROW" :
                                        _undeterminedCheck ? "PAUSED" :
                                        "PAUSED UNTIL ${DateFormat("dd MMM, yy").format(DateFormat("yyyy-mm-dd").parse(pauseDate))}",
                                        style: TextStyle(fontSize: _availableCheck || _undeterminedCheck ?  12 : 9, fontFamily: AppAssets.nunitoBold, color: _availableCheck ? AppAssets.successColor : AppAssets.pausedColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ),
                                  ),
                                  const SizedBox(width: 4,),
                                  Icon(MdiIcons.chevronDown, color: _availableCheck ? AppAssets.successColor : AppAssets.pausedColor, size: 20,)
                                ],
                              ),
                              Container(
                                height: 6,
                                margin: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: _availableCheck ? AppAssets.greenColor : AppAssets.pausedColor
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      /*GestureDetector(
                      onTap: () {
                        SharedPreferenceManager.getInstance().clearAllPreferences().then((value) {
                          if(value == "Cleared"){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                          }
                        });
                      },child: Icon(MdiIcons.logout)),*/
                    ],
                  ),
                ),
              ),
              //const SizedBox(height: 20,),
              Visibility(
                visible: _availableCheck && selectedBottom == 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 46,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppAssets.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 0;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: selectedTab == 0 ? AppAssets.leftTabSelectedDecoration : AppAssets.leftTabUnSelectedDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("NEW", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: selectedTab == 0 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor),),
                                Visibility(
                                  visible: provider.newOrdersList.isNotEmpty,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: const CircleAvatar(
                                        backgroundColor: AppAssets.redColor,
                                        radius: 3,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6,),
                                SvgPicture.asset(AppAssets.bagIcon, colorFilter: ColorFilter.mode(selectedTab == 0 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor, BlendMode.srcIn), height: 17, width: 17,)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 1;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: selectedTab == 1 ? AppAssets.centerTabSelectedDecoration : AppAssets.centerTabUnSelectedDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("PREPARING", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: selectedTab == 1 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor),),
                                const SizedBox(width: 6,),
                                SvgPicture.asset(AppAssets.preparingIcon, colorFilter: ColorFilter.mode(selectedTab == 1 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor, BlendMode.srcIn), height: 17, width: 17,)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 2;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: selectedTab == 2 ? AppAssets.rightTabSelectedDecoration : AppAssets.rightTabUnSelectedDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("READY", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: selectedTab == 2 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor),),
                                const SizedBox(width: 6,),
                                SvgPicture.asset(AppAssets.vanIcon, colorFilter: ColorFilter.mode(selectedTab == 2 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor, BlendMode.srcIn), height: 17, width: 17,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _availableCheck && selectedBottom == 1 ?
                tabs[selectedTab] :
                selectedBottom == 2 ?
                const Settings() :
                selectedBottom == 0 ?
                const FirstBottomTab() :
                const AllOrders(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            color: AppAssets.whiteColor,
            border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedBottom = 0;
                    });
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        selectedBottom  == 0 ? Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color: AppAssets.whiteColor,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(color: AppAssets.widgetGrayColor.withOpacity(0.4), blurRadius: 10)
                              ]
                          ),
                          child: Center(child: Icon(MdiIcons.clockOutline, size: 36, color: AppAssets.primaryColor,)),
                        ) : SizedBox(width: 70,
                            height: 70, child: Center(child: Icon(MdiIcons.clockOutline, size: 36, color: AppAssets.textLightGrayColor,))),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedBottom = 1;
                    });
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        selectedBottom  == 1 ? Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color: AppAssets.whiteColor,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(color: AppAssets.widgetGrayColor.withOpacity(0.4), blurRadius: 10)
                              ]
                          ),
                          child: Center(child: SvgPicture.asset(AppAssets.bagIcon, width: 36, height: 36, color: AppAssets.primaryColor,)),
                        ) : Container(width: 70,
                            height: 70,child: Center(child: SvgPicture.asset(AppAssets.bagIcon, width: 36, height: 36, color: AppAssets.textLightGrayColor,))),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedBottom = 2;
                    });
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        selectedBottom  == 2 ? Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color: AppAssets.whiteColor,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(color: AppAssets.widgetGrayColor.withOpacity(0.4), blurRadius: 10)
                              ]
                          ),
                          child: Center(child: SvgPicture.asset(AppAssets.settingsIcon, width: 36, height: 36, color: AppAssets.primaryColor,)),
                        ) : Container(width: 70,
                            height: 70,child: Center(child: SvgPicture.asset(AppAssets.settingsIcon, width: 36, height: 36, color: AppAssets.textLightGrayColor,))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    });

  }
}
