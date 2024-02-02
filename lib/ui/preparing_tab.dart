import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../assets/app_assets.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';
import '../utilities/shares_pref_manager.dart';
import '../utilities/utility_class.dart';
import 'order_printing/order_printing.dart';

class PreparingTab extends StatefulWidget {
  const PreparingTab({Key? key}) : super(key: key);

  @override
  State<PreparingTab> createState() => _PreparingTabState();
}

class _PreparingTabState extends State<PreparingTab> {
  int minutes = 10;
  UserModel userModel = UserModel.getInstance();
  //Timer? timer;

  @override
  void initState() {
    getData();
  }

  void getData() {
    SharedPreferenceManager.getInstance().getUserData().then((value) {
      userModel = value;
      //Provider.of<AppProvider>(context, listen: false).processingOrders(value.authToken!);
      //timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => Provider.of<AppProvider>(context, listen: false).autoProcessingOrders(value.authToken!));
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

      if(provider.processingProgress){
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
              SizedBox(height: 6,),
              Text("Please wait!\nWe are checking preparing orders", textAlign: TextAlign.center,),
            ],
          ),
        );
      }

      return provider.processingOrdersList.isNotEmpty?
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: provider.processingOrdersList.length,
        itemBuilder: (context, index) {
          final order = provider.processingOrdersList[index];
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
                            child: SvgPicture.asset(AppAssets.preparingIcon, colorFilter: ColorFilter.mode(AppAssets.tabBorderColor, BlendMode.srcIn), height: 20, width: 20,),
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
                                  Text("Preparing...", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: AppAssets.dimen_12, color: AppAssets.widgetGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ],
                          )),
                          const SizedBox(width: 12,),
                          Row(
                            children: [
                              Text("${order.orderData!.deliveryTime}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              const SizedBox(width: 4,),
                              SvgPicture.asset(AppAssets.timerIcon, colorFilter: ColorFilter.mode(AppAssets.redColor, BlendMode.srcIn), height: 16, width: 16,),
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
                                child: SvgPicture.asset(AppAssets.preparingIcon, colorFilter: ColorFilter.mode(AppAssets.tabBorderColor, BlendMode.srcIn), height: 20, width: 20,),
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
                                      Text("Preparing...", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: AppAssets.dimen_12, color: AppAssets.widgetGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                ],
                              )),
                              const SizedBox(width: 12,),
                              Row(
                                children: [
                                  Text("${order.orderData!.deliveryTime}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 4,),
                                  SvgPicture.asset(AppAssets.timerIcon, colorFilter: ColorFilter.mode(AppAssets.redColor, BlendMode.srcIn), height: 16, width: 16,),
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
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderPrinting(orderModel: order)));
                                return;

                                UtilityClass.showLoadingDialog(context);
                                provider.readyForPickupOrder(userModel.authToken!, order.orderData!.orderUuid!).then((status) {
                                  UtilityClass.dismissLoading(context);
                                  if(status.isSuccess){
                                    UtilityClass.showSuccessDialog(context, "Order Status", status.message);
                                  }else{
                                    UtilityClass.showFailedDialog(context, "Failed", status.message);
                                  }
                                });
                              },
                              child: Container(
                                height: 36,
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  color: AppAssets.purpleColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(child: Text("READY FOR PICKUP", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
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
          child: Text("Oops!\nThere are no preparing orders", textAlign: TextAlign.center,),
        ),
      );
    });
  }
}
