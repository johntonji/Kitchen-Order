import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:order_receiving/models/menu_model2.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/ui/printer/auto_print_orders.dart';
import 'package:order_receiving/ui/profile.dart';
import 'package:order_receiving/ui/reciept/print_template_list.dart';
import 'package:order_receiving/ui/terms_conditions.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
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

  int sec = AppProvider.alertDuration;
  UserModel userModel = UserModel.getInstance();
  bool ismute=false;///

  @override
  void initState() {
    super.initState();
    SharedPreferenceManager.getInstance().getAuthToken().then((token) {
      Provider.of<AppProvider>(context,listen: false).menu(token);
       Provider.of<AppProvider>(context,listen: false).connectedProviders(token);
    });
    getData();
    if(sec==0){
      ismute=true;
    }
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
                            const SizedBox(width: 12),
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
                                      child: Text((provider.restrauntMenu.isEmpty)? "NO ITEM AVAILABLE":"CATEGORIES", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 13, color: AppAssets.textLightGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ),
                                    const SizedBox(height: 6),
                                    ListView.builder(
                                      itemCount: provider.restrauntMenu.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index){
                                        MenuModel2 category =provider.restrauntMenu[index];
                                        
                                        return Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          color: Color(0xFFF5F5F5),
                                          padding: const EdgeInsets.symmetric(horizontal: AppAssets.dimen_12),
                                          child: ExpandableNotifier(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                (category.menus!.isEmpty)
                                                ? Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(category.categoryName!, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_14), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                        ),
                                                      
                                                      ],
                                                    )
                                                : Expandable(
                                                  collapsed: ExpandableButton(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(category.categoryName!, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_14), maxLines: 2, overflow: TextOverflow.ellipsis,),
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
                                                                      child: Text(
                                                                        category.categoryName!,
                                                                        style: TextStyle( fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16),  maxLines:1,overflow:TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 12,
                                                                    ),
                                                                    Icon( MdiIcons.minus, color: AppAssets .textDarkGrayColor,  size: 20,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        ListView.builder(
                                                                            itemCount: category.menus!.length,
                                                                            shrinkWrap: true,
                                                                            physics: const NeverScrollableScrollPhysics(),
                                                                            itemBuilder: (context, index) {
                                                                              bool? isAvailable;
                                                                              isAvailable = categoryItem.available == "1";
                                                                              var categoryItem = category.menus![index];
                                                                              return Container(
                                                                                  margin: const EdgeInsets.only(
                                                                                    top: 10,
                                                                                    bottom: 10,
                                                                                  ),
                                                                                  color: Color(0xFFF5F5F5),
                                                                                  padding: const EdgeInsets.only(left: AppAssets.dimen_12),
                                                                                  child: (categoryItem.subItems!.isEmpty)
                                                                                      ? Row(
                                                                                          children: [
                                                                                            Expanded(
                                                                                              // Prevents overflow
                                                                                              child: Text(
                                                                                                categoryItem.itemName!,
                                                                                                style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_14),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                maxLines: 2, // Ensures single-line truncation
                                                                                              ),
                                                                                            ),
                                                                                           SizedBox(
                                                                                            height: 30,
                                                                                              child: Transform.scale(
                                                                                                scale: 0.7, 
                                                                                                 child:Switch(
                                                                                                 activeColor: AppAssets.greenColor,
                                                                                                 value: isAvailable ?? false,
                                                                                                 onChanged: (bool value) async {
                                                                                                   setState(() {
                                                                                                     isAvailable = value;
                                                                                                   });
                                                                                               
                                                                                                   showDialog(
                                                                                                     context: context,
                                                                                                     barrierDismissible: false,
                                                                                                     builder: (_) => AlertDialog(
                                                                                                      backgroundColor: Colors.transparent,
                                                                                                     
                                                                                                       content: SizedBox(
                                                                                                         height: 50,
                                                                                                         child: Center(child: CircularProgressIndicator(color: AppAssets.purpleColor,)),
                                                                                                       ),
                                                                                                     ),
                                                                                                   );
                                                                                              
                                                                                                   try {
                                                                                                     final token =
                                                                                                         await SharedPreferenceManager.getInstance().getAuthToken();
                                                                                               
                                                                                                     final response = await provider.updateMenuItemAvailability(
                                                                                                       token,
                                                                                                       categoryItem.itemId!,
                                                                                                       (value==true)? "1" : "0",
                                                                                                     );
                                                                                              
                                                                                                     Navigator.pop(context);
                                                                                              
                                                                                                     if (response.isSuccess) {
                                                                                                       // update model AFTER success
                                                                                                       categoryItem.available = value ? "1" : "0";
                                                                                                     } else {
                                                                                                       setState(() => isAvailable = !value);
                                                                                                     }
                                                                                                   } catch (e) {
                                                                                                     Navigator.pop(context);
                                                                                                     setState(() => isAvailable = !value);
                                                                                                   }
                                                                                                 },
                                                                                               )
                                                                                              
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                                                                              margin: const EdgeInsets.symmetric(horizontal: 6),
                                                                                              decoration: BoxDecoration(
                                                                                                color: (categoryItem.available =="1") ? AppAssets.successColor.withOpacity(0.2) : AppAssets.failureColor.withOpacity(0.2),
                                                                                                borderRadius: BorderRadius.circular(20),
                                                                                              ),
                                                                                              child: Text(
                                                                                                (categoryItem.available =="1") ? "Available" : "Unavailable",
                                                                                                style: TextStyle(
                                                                                                  fontFamily: AppAssets.nunitoBold,
                                                                                                  fontSize: 10,
                                                                                                  color: (categoryItem.available =="1") ? AppAssets.successColor : AppAssets.failureColor,
                                                                                                ),
                                                                                                maxLines: 1,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                        :  ExpandableNotifier(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                (category.menus!.isEmpty)
                                                ?   Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(categoryItem.itemName!, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_14), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                        ),
                                                      
                                                      ],
                                                    )
                                                : 
                                                 Expandable(
                                                  collapsed: ExpandableButton(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(categoryItem.itemName!, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_14), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                                        ),
                                                        const SizedBox(width: 12,),
                                                        Icon(MdiIcons.plus, color: AppAssets.textDarkGrayColor, size: 20,),
                                                      ],
                                                    ),
                                                  ),
                                                  expanded: 
                                                Column(
                                                    children: [
                                                      ExpandableButton(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(categoryItem.itemName!, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_14), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                            ),
                                                            const SizedBox(width: 12,),
                                                            Icon(MdiIcons.minus, color: AppAssets.textDarkGrayColor, size: 20,),
                                                          ],
                                                        ),
                                                      ),
                                                       ListView.builder(
                                                                    itemCount: categoryItem.subItems!.length,
                                                                    shrinkWrap: true,
                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                    itemBuilder: (context, index){
                                                                     
                                                                      return Container(
                                                                        margin: const EdgeInsets.only(top: 10, bottom: 10,),
                                                                        color: Color(0xFFF5F5F5),
                                                                        padding: const EdgeInsets.only(left: AppAssets.dimen_12),
                                                                        child:
                                                                       Row(
                                                                          children: [
                                                                            Text(categoryItem.subItems![index].itemName!, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_12), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                                            Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                                              margin: const EdgeInsets.symmetric(horizontal: 6),
                                                                              decoration: BoxDecoration(
                                                                                color: AppAssets.successColor.withOpacity(0.2),
                                                                                borderRadius: BorderRadius.circular(20),
                                                                              ),
                                                                              child:(categoryItem.subItems![index].notForSale==false)
                                                                              ? Text("Available", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 10, color: AppAssets.successColor), maxLines: 1, overflow: TextOverflow.ellipsis,)
                                                                              : Text("Unavailable", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 10, color: AppAssets.failureColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                                               ),
                                                                            const Expanded(child: SizedBox(width: 12,)),
                                                                          ],
                                                                        )
                                                                      );
                                                                    }
                                                       )
                                                    ]
                                                )
                                                 )
                                              ]
                                            )
                                                                        )
                                            

                                                                        /////////////////////////
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text("SETTINGS", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: AppAssets.primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AutoPrintOrders()));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppAssets.tabBackgroundColor,
                      radius: 22,
                      child: Icon(MdiIcons.printerOutline, color: AppAssets.textNormalGrayColor, size: 20,),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text("Auto-print orders", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
              ),
            ),
              const SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ReceiptTemplates(address: userModel.address!, logo: userModel.logo!, phone: userModel.contactNumber!,)));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppAssets.tabBackgroundColor,
                      radius: 22,
                      child: Icon(MdiIcons.receipt, color: AppAssets.textNormalGrayColor, size: 20,),                  ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Text("Printing Template", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          if(AppProvider.autoAcceptStatus==true)
            GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsConditions()));
                ////set time start
                  showModalBottomSheet<void>(
                                  context: context,
                                  backgroundColor: AppAssets.whiteColor,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder: (context, setState) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(height: 50),
                                          Text('Alert Duration', style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 20, color: AppAssets.blackColor),),
                                                                                       SizedBox(width: MediaQuery.sizeOf(context).width/8,),
                                          const SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if(sec > 5 && ismute!=true){
                                                        setState(() {
                                                          sec = sec - 5;
                                                        });
                                                      }
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: AppAssets.widgetGrayColor,
                                                      child: Text("-", style: TextStyle(fontSize: 20, color: AppAssets.whiteColor, fontFamily: AppAssets.nunitoBold),),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                    margin: const EdgeInsets.symmetric(horizontal: 12),
                                                    decoration: BoxDecoration(
                                                        color: const Color(0xFFFFFFFF).withOpacity(0.0),
                                                        border: Border.all(color: AppAssets.widgetGrayColor, width: 1),
                                                        borderRadius: BorderRadius.circular(50)
                                                    ),
                                                    child: Text("$sec sec.", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 16, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if(sec >= 0 && ismute!=true){
                                                        setState(() {
                                                          sec = sec + 5;
                                                        });
                                                      }
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: AppAssets.widgetGrayColor,
                                                      child: Text("+", style: TextStyle(fontSize: 20, color: AppAssets.whiteColor, fontFamily: AppAssets.nunitoBold),),
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   width: 30,
                                                  // ),
                                                ],
                                              ),
                                                     Row(
                                                       children: [
                                                         GestureDetector(
                                                                                                             onTap: () {
                                                         setState(() {
                                                             ismute=!ismute;
                                                             if(ismute==true){
                                                              sec=0;
                                                             }else{
                                                              sec=5;
                                                             }
                                                            });
                                                                                                             },
                                                                                                             child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:ismute ? AppAssets.widgetGrayColor :AppAssets.greenColor,
                                                          child:  Image.asset(ismute ? AppAssets.mute : AppAssets.volume ,width: 20,height: 20)
                                                          
                                                                ),
                                                             ),
                                                       ],
                                                     ),
                                            ],
                                          ),
                                          const SizedBox(height: 30),
                                          GestureDetector(
                                            onTap: () {
                                            AppProvider.alertDuration=sec;
                                            SharedPreferenceManager.getInstance().saveAlertDuration(sec);
                                             Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                                              padding: const EdgeInsets.only(left: 16, right: 16),
                                              decoration: BoxDecoration(
                                                color: AppAssets.greenColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                  child: Text(
                                "SET DURATION",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: AppAssets.nunitoBold,
                                    color: AppAssets.whiteColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
                          ),
                          // const SizedBox(height: 20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     SizedBox(
                          //       width: 30,
                          //       child: SizedBox(
                          //         width: 30,
                          //         child: Switch(
                          //             activeColor: AppAssets.greenColor,
                          //             value: ismute,
                          //             onChanged: (bool value) {
                          //               setState(() {
                          //                 ismute=!ismute;
                          //                 if(ismute==true){
                          //                   sec=0;
                          //                 }else{
                          //                   sec=5;
                          //                 }
                          //                 // item.update(item.keys.first, (itemValue) {
                          //                 //   itemValue = value;
                          //                 //   return itemValue;
                          //                 // });
                          //               });
                          //             }),
                          //       ),
                          //     ),
                          //   SizedBox(
                          //   width: MediaQuery.sizeOf(context).width/2,
                          //   child: Text("Mute Alerts",overflow: TextOverflow.ellipsis,maxLines: 2,
                          //    style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 16, color: AppAssets.blackColor, overflow: TextOverflow.ellipsis,),),
                          //    )
                          //   ],
                          // ),
                          const SizedBox(height: 80),
                        ],
                      );
                    });
                  },
                );

                ///set time end
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppAssets.tabBackgroundColor,
                      radius: 22,
                      child: Icon(
                        MdiIcons.bell,
                        color: AppAssets.textNormalGrayColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        "Alert Duration",
                        style: TextStyle(
                            fontFamily: AppAssets.nunitoMedium,
                            fontSize: AppAssets.dimen_16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
              },
              child: Padding(
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
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsConditions()));
              },
              child: Padding(
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
