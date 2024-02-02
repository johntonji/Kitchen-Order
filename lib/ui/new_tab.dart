import 'dart:async';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/ui/order_printing/order_printing.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:order_receiving/utilities/utility_class.dart';
import 'package:provider/provider.dart';

import '../assets/app_assets.dart';
import '../providers/app_provider.dart';

class NewTab extends StatefulWidget {
  const NewTab({Key? key}) : super(key: key);

  @override
  State<NewTab> createState() => _NewTabState();
}

class _NewTabState extends State<NewTab> {

  int minutes = 10;
  UserModel userModel = UserModel.getInstance();
  //Timer? timer;

  TextEditingController _amountController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    getData();
  }

  void getData() {
    SharedPreferenceManager.getInstance().getUserData().then((value) {
      userModel = value;
      //Provider.of<AppProvider>(context, listen: false).newOrders(value.authToken!);
      //timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => Provider.of<AppProvider>(context, listen: false).autoNewOrders(value.authToken!));
    });
  }

  @override
  void dispose() {
    //timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, isChild) {

      if(provider.newProgress){
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
              SizedBox(height: 6,),
              Text("Please wait!\nWe are checking new orders", textAlign: TextAlign.center,),
            ],
          ),
        );
      }

      return provider.newOrdersList.isNotEmpty?
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: provider.newOrdersList.length,
        itemBuilder: (context, index) {
          final order = provider.newOrdersList[index];
          return Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                          CircleAvatar(
                            backgroundColor: AppAssets.tabBackgroundColor,
                            radius: 22,
                            child: SvgPicture.asset(AppAssets.bagIcon, colorFilter: ColorFilter.mode(AppAssets.tabBorderColor, BlendMode.srcIn), height: 20, width: 20,),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order #${order.orderData!.orderId}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              Row(
                                children: [
                                  SvgPicture.asset(AppAssets.busyIcon, colorFilter: ColorFilter.mode(AppAssets.widgetGrayColor, BlendMode.srcIn), height: 12, width: 12,),
                                  const SizedBox(width: 4,),
                                  Text("pending...", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: AppAssets.dimen_12, color: AppAssets.widgetGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ],
                          )),
                          const SizedBox(width: 12,),
                          Row(
                            children: [
                              Text("\$ ${double.parse(order.orderData!.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ],
                          ),
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
                                child: SvgPicture.asset(AppAssets.bagIcon, colorFilter: ColorFilter.mode(AppAssets.tabBorderColor, BlendMode.srcIn), height: 20, width: 20,),
                              ),
                              const SizedBox(width: 12,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order #${order.orderData!.orderId}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppAssets.busyIcon, colorFilter: ColorFilter.mode(AppAssets.widgetGrayColor, BlendMode.srcIn), height: 12, width: 12,),
                                      const SizedBox(width: 4,),
                                      Text("pending...", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: AppAssets.dimen_12, color: AppAssets.widgetGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                ],
                              )),
                              const SizedBox(width: 12,),
                              Row(
                                children: [
                                  Text("\$ ${double.parse(order.orderData!.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          height: 1,
                          color: AppAssets.widgetGrayColor.withOpacity(0.3),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order information", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text("ID: ", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      Text("${order.orderData!.orderId}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text("PLACED ON: ", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      Text("${order.orderData!.dateCreated}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("${order.customer!.firstName} ${order.customer!.lastName}", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.phoneIcon, colorFilter: ColorFilter.mode(AppAssets.widgetGrayColor, BlendMode.srcIn), height: 14, width: 14,),
                                    const SizedBox(width: 6),
                                    Text("${order.customer!.contactPhone}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.emailIcon, colorFilter: ColorFilter.mode(AppAssets.widgetGrayColor, BlendMode.srcIn), height: 14, width: 14,),
                                    const SizedBox(width: 6),
                                    Text("${order.customer!.emailAddress}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          height: 1,
                          color: AppAssets.widgetGrayColor.withOpacity(0.3),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text("", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Align(alignment: Alignment.center, child: Text("Qty", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                            const SizedBox(width: 10),
                            Expanded(child: Align(alignment: Alignment.center, child: Text("Price", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: order.items!.length,
                            itemBuilder: (context, index) {
                              final item = order.items![index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Align(alignment: Alignment.centerLeft, child: Text("${item.itemName}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(child: Align(alignment: Alignment.center, child: Text("${item.qty}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                        const SizedBox(width: 10),
                                        Expanded(child: Align(alignment: Alignment.center, child: Text("\$ ${item.price!.total}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                      ],
                                    ),
                                  ),

                                  Visibility(
                                    visible: item.addons!.isNotEmpty,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text("ADD ONS", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 11, color: AppAssets.widgetGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(child: Align(alignment: Alignment.center, child: Text("", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                            const SizedBox(width: 10),
                                            Expanded(child: Align(alignment: Alignment.center, child: Text("", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                          ],
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: item.addons!.length,
                                            itemBuilder: (context, index) {
                                              final itemAddon = item.addons![index];
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: itemAddon.addonItems!.length,
                                                    itemBuilder: (context, index) {
                                                      final itemAddonItem = itemAddon.addonItems![index];
                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Align(alignment: Alignment.centerLeft, child: Text("${itemAddonItem.subItemName}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Expanded(child: Align(alignment: Alignment.center, child: Text("${itemAddonItem.qty}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                                          const SizedBox(width: 10),
                                                          Expanded(child: Align(alignment: Alignment.center, child: Text("${itemAddonItem.prettyAddonsTotal}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                                        ],
                                                      );
                                                    }),
                                              );
                                            }),
                                        const SizedBox(height: 8.0),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: AppAssets.widgetGrayColor.withOpacity(0.2),
                                  ),
                                ],
                              );
                            }),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text("Sub total", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14, color: AppAssets.widgetGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Align(alignment: Alignment.centerRight, child: Text("\$ ${double.parse(order.orderData!.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: AppAssets.whiteColor,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: StatefulBuilder(builder: (context, setState) {
                                        setState(() {
                                          _reasonController.text = "";
                                          _amountController.text = "${order.orderData!.total}";
                                        });
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(height: 50),
                                            Text('Order Cancellation', style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 20, color: AppAssets.blackColor),),
                                            const SizedBox(height: 30),
                                            Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
                                              padding: const EdgeInsets.only(left: 16, right: 16),
                                              decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.05),
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                                              ),
                                              child: TextField(
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                obscureText: false,
                                                controller: _amountController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: "Amount",
                                                  labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                                                  floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                                                ),
                                                cursorColor: AppAssets.widgetGrayColor,
                                                style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
                                              padding: const EdgeInsets.only(left: 16, right: 16),
                                              decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.05),
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                                              ),
                                              child: TextField(
                                                keyboardType: TextInputType.text,
                                                obscureText: false,
                                                controller: _reasonController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: "Reason",
                                                  labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                                                  floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                                                ),
                                                cursorColor: AppAssets.widgetGrayColor,
                                                style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            GestureDetector(
                                              onTap: () {
                                                if(_amountController.text.isEmpty){
                                                  UtilityClass.showFailedDialog(context, "Data Missing", "The Amount field is required");
                                                  Navigator.of(context).pop();
                                                  return;
                                                }
                                                if(_reasonController.text.isEmpty){
                                                  UtilityClass.showFailedDialog(context, "Data Missing", "The Reason field is required");
                                                  Navigator.of(context).pop();
                                                  return;
                                                }

                                                UtilityClass.showLoadingDialog(context);
                                                provider.cancelOrder(userModel.authToken!, order.orderData!.orderUuid!, _amountController.text, _reasonController.text, "canceled", "new").then((status) {
                                                  UtilityClass.dismissLoading(context);
                                                  if(status.isSuccess){
                                                    Navigator.of(context).pop();
                                                    UtilityClass.showSuccessDialog(context, "Order Status", status.message);
                                                    setState(() {
                                                      _amountController.text = "";
                                                      _reasonController.text = "";
                                                    });
                                                  }else{
                                                    Navigator.of(context).pop();
                                                    UtilityClass.showFailedDialog(context, "Failed", status.message);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                margin: const EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 50),
                                                padding: const EdgeInsets.only(left: 16, right: 16),
                                                decoration: BoxDecoration(
                                                  color: AppAssets.redColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Center(child: Text("DECLINE", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 36,
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  color: AppAssets.redColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(child: Text("DECLINE", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
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
                                          Text('Delivery time', style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 20, color: AppAssets.blackColor),),
                                          const SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if(minutes > 0){
                                                    setState(() {
                                                      minutes = minutes - 5;
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
                                                child: Text("$minutes min.", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 16, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if(minutes >= 0){
                                                    setState(() {
                                                      minutes = minutes + 5;
                                                    });
                                                  }
                                                },
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: AppAssets.widgetGrayColor,
                                                  child: Text("+", style: TextStyle(fontSize: 20, color: AppAssets.whiteColor, fontFamily: AppAssets.nunitoBold),),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 30),
                                          GestureDetector(
                                            onTap: () {
                                              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderPrinting(orderModel: order)));
                                              //return;

                                              UtilityClass.showLoadingDialog(context);
                                              provider.acceptOrder(userModel.authToken!, order.orderData!.orderUuid!, order.orderData!.deliveryDate!, getTimeString(minutes)).then((status) {
                                                UtilityClass.dismissLoading(context);
                                                if(status.isSuccess){
                                                  Navigator.of(context).pop();
                                                  UtilityClass.showSuccessDialog(context, "Order Status", status.message);
                                                  setState(() {
                                                    minutes  = 0;
                                                  });
                                                }else{
                                                  Navigator.of(context).pop();
                                                  UtilityClass.showFailedDialog(context, "Failed", status.message);
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                                              padding: const EdgeInsets.only(left: 16, right: 16),
                                              decoration: BoxDecoration(
                                                color: AppAssets.greenColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(child: Text("ACCEPT ORDER", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                            ),
                                          ),
                                          const SizedBox(height: 80),
                                        ],
                                      );
                                    });
                                  },
                                );
                              },
                              child: Container(
                                height: 36,
                                margin: const EdgeInsets.only(top: 20, left: 10),
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  color: AppAssets.greenColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(child: Text("ACCEPT ORDER", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
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
        },) :
      const Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text("Oops!\nThere are no new orders", textAlign: TextAlign.center,),
        ),
      );
    });
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }
}
