import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:order_receiving/main.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_client.dart';
import 'package:provider/provider.dart';

import '../assets/app_assets.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';
import '../utilities/shares_pref_manager.dart';
import '../utilities/utility_class.dart';

class ReadyTab extends StatefulWidget {
  const ReadyTab({super.key});

  @override
  State<ReadyTab> createState() => _ReadyTabState();
}

class _ReadyTabState extends State<ReadyTab> {
  int minutes = 10;
  UserModel userModel = UserModel.getInstance();
  //Timer? timer;

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, isChild) {

      if(provider.readyProgress){
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
              SizedBox(height: 6,),
              Text("Please wait!\nWe are checking ready orders", textAlign: TextAlign.center,),
            ],
          ),
        );
      }

      return provider.readyOrdersList.isNotEmpty?
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: provider.readyOrdersList.length,
        itemBuilder: (context, index) {
          final order = provider.readyOrdersList[index];
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
                            child: SvgPicture.asset(AppAssets.vanIcon, colorFilter: ColorFilter.mode(AppAssets.tabBorderColor, BlendMode.srcIn), height: 20, width: 20,),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order #${order.orderData.orderId}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              Row(
                                children: [
                                  SvgPicture.asset(AppAssets.busyIcon, colorFilter: ColorFilter.mode(AppAssets.widgetGrayColor, BlendMode.srcIn), height: 12, width: 12,),
                                  const SizedBox(width: 4,),
                                  Text("Delivering...", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: AppAssets.dimen_12, color: AppAssets.widgetGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ],
                          )),
                          const SizedBox(width: 12,),
                          (order.orderData.paymentStatus=="paid")
                          ? Row(
                            children: [
                              Text("\$ ${double.parse(order.orderData.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.greenColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              const SizedBox(width: 3,),
                              Text("Paid", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.greenColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              const SizedBox(width: 4,),
                              SvgPicture.asset(AppAssets.tickIcon, colorFilter: ColorFilter.mode(AppAssets.greenColor, BlendMode.srcIn), height: 12, width: 12,),
                            ],
                          )
                          :Row(
                                children: [
                                  Text("\$ ${double.parse(order.orderData.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 3,),
                                  Text("Unpaid", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 4,),
                                ],
                              ) ,
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
                                child: SvgPicture.asset(AppAssets.vanIcon, colorFilter: ColorFilter.mode(AppAssets.tabBorderColor, BlendMode.srcIn), height: 20, width: 20,),
                              ),
                              const SizedBox(width: 12,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order #${order.orderData.orderId}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppAssets.busyIcon, colorFilter: ColorFilter.mode(AppAssets.widgetGrayColor, BlendMode.srcIn), height: 12, width: 12,),
                                      const SizedBox(width: 4,),
                                      Text("Delivering...", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: AppAssets.dimen_12, color: AppAssets.widgetGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                ],
                              )),
                              const SizedBox(width: 12,),
                              (order.orderData.paymentStatus=="paid")
                              ? Row(
                                children: [
                                  Text("\$ ${double.parse(order.orderData.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.greenColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 3,),
                                  Text("Paid", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.greenColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 4,),
                                  SvgPicture.asset(AppAssets.tickIcon, colorFilter: ColorFilter.mode(AppAssets.greenColor, BlendMode.srcIn), height: 12, width: 12,),
                                ],
                              )
                              :Row(
                                children: [
                                  Text("\$ ${double.parse(order.orderData.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 3,),
                                  Text("Unpaid", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  const SizedBox(width: 4,),
                                ],
                              ) ,
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
                                      Text(order.orderData.orderId, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text("PLACED ON: ", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                      Expanded(child: Text(formatDateTime2(order.orderData.dateCreated.toString()), style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9), maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("${order.customer.firstName} ${order.customer.lastName}", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.phoneIcon, colorFilter: ColorFilter.mode(AppAssets.widgetGrayColor, BlendMode.srcIn), height: 14, width: 14,),
                                    const SizedBox(width: 6),
                                    Text(order.customer.contactPhone, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.emailIcon, colorFilter: ColorFilter.mode(AppAssets.widgetGrayColor, BlendMode.srcIn), height: 14, width: 14,),
                                    const SizedBox(width: 6),
                                    Text(order.customer.emailAddress, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 9, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                              itemCount: order.items.length,
                              itemBuilder: (context, index) {
                                final item = order.items[index];
                                List<Addons> addonItemLocal=[];
                                if(item.addons!=null){
                                  addonItemLocal=item.addons!;
                                }
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Align(alignment: Alignment.centerLeft, child: Text(item.itemName, style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 10), )),
                                                if(item.price.sizeName!=null && item.price.sizeName!="")
                                                Align(alignment: Alignment.centerLeft, child: Text("(${item.price.sizeName!})", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 10))),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(child: Align(alignment: Alignment.center, child: Text(item.qty, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                          const SizedBox(width: 10),
                                          Expanded(child: Align(alignment: Alignment.center, child: Text("\$ ${formatToTwoDecimals(item.price.total)}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: addonItemLocal.isNotEmpty,
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
  itemCount: addonItemLocal.length,
  itemBuilder: (context, index) {

    final itemAddon = addonItemLocal[index];

    final groupedAddons =
        provider.groupAddonsByPortion(itemAddon.addonItems ?? []);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupedAddons.entries.map((entry) {

          final portionId = entry.key;
          final items = entry.value;
          String? shownSubCat;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ///  Show Portion Title
              if (portionId != "no_portion")
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    provider.getPortionName(portionId),
                    style: TextStyle(
                      fontFamily: AppAssets.nunitoRegular,
                      fontSize: 10,
                    ),
                  ),
                ),

              ///  Show Items Under Portion
              ...items.map((itemAddonItem) {
                 final isFirst =
                  shownSubCat != itemAddonItem.subcatName;

                     if (isFirst) {
                 shownSubCat = itemAddonItem.subcatName;
                 }
                return Row(
                  children: [

                     Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: 
                        ( portionId != "no_portion")
                        ? Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Text(
                               "-${itemAddonItem.subItemName}",

                              //  "   - ${itemAddonItem.subItemName}",
                            style: TextStyle(
                              fontFamily: AppAssets.nunitoRegular,
                              fontSize: 10,
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isFirst)
                             Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                             itemAddonItem.subcatName ?? "",
                              style: TextStyle(
                             fontFamily: AppAssets.nunitoRegular,
                               fontSize: 10,
                             ),
                          ),
                          
                         ),
                           (itemAddonItem.isSubModifier=="1")
                        ? Container(
                          margin: const EdgeInsets.only(left: 18),
                          child: Text(
                               "- ${itemAddonItem.subItemName}",

                              //  "   - ${itemAddonItem.subItemName}",
                            style: TextStyle(
                              fontFamily: AppAssets.nunitoRegular,
                              fontSize: 10,
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            ),
                        )
                        : Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                               "-${itemAddonItem.subItemName}",
                              //  " -${itemAddonItem.subItemName}",
                            style: TextStyle(
                              fontFamily: AppAssets.nunitoRegular,
                              fontSize: 10,
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                           ),
                        )
                          ],)
                      ),
                    ),

                 

                    const SizedBox(width: 10),

                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${itemAddonItem.qty}",
                          style: TextStyle(
                            fontFamily: AppAssets.nunitoMedium,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          itemAddonItem.prettyAddonsTotal ?? "",
                          style: TextStyle(
                            fontFamily: AppAssets.nunitoMedium,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),

              const SizedBox(height: 6),
            ],
          );
        }).toList(),
      ),
    );
  },
),
                                       
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
                         if((order.extraDetails?.hasDiscount==true && order.extraDetails!=null ))
                       Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text( order.extraDetails?.discountName ?? "Discount", 
                                style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14, color: AppAssets.widgetGrayColor),),
                            Text((order.extraDetails?.discountAmount != null && order.extraDetails?.discountAmount != "") ? '\$ (${formatToTwoDecimals(order.extraDetails?.discountAmount)})' : '\$ (0.00)',
                                style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14),),
                          ],
                        ),
                           if((order.tip!=null && order.tip!="" && order.tip!="0"))
                            Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text( "Tip",
                                style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14, color: AppAssets.widgetGrayColor),),
                            Text((order.tip!=null && order.tip!="") ? '\$ ${formatToTwoDecimals(order.tip.toString())}' : '\$ 0.00',
                                style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14),),
                          ],
                        ),
                      if(order.allTaxesUse.isNotEmpty && order.allTaxesUse !=null)
                       ListView.builder(
                         shrinkWrap: true,
                         physics: const NeverScrollableScrollPhysics(),
                         itemCount: order.allTaxesUse.length,
                        itemBuilder: (BuildContext context, int index) {
                          final taxItem=order.allTaxesUse[index];
                           return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Text( 
                                // (order.orderData.taxType!=null) ?'${order.orderData.taxType!} tax':
                                  (taxItem.taxName!.isNotEmpty) 
                                  ? taxItem.taxName!
                                  : "Tax",
                                   style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14, color: AppAssets.widgetGrayColor),),
                                   Text((taxItem.taxRateCalculated!=null) ?'\$ ${double.parse(taxItem.taxRateCalculated!.toString()).toStringAsFixed(2)}' : '\$ 0.00',
                                   style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14), ),
                              ],
                            );
                         }
                       ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text("Sub total", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14, color: AppAssets.widgetGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Align(alignment: Alignment.centerRight, child: Text("\$ ${double.parse(order.orderData.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                UtilityClass.showLoadingDialog(context);
                                provider.completeOrder(userModel.authToken!, order.orderData.orderUuid).then((status) {
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
                                child: Center(child: Text("COMPLETE ORDER", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
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
                  if(index == (provider.readyOrdersList.length-1))
                  SizedBox(height: 50,)
                ],
              ),
            ),
          );
        },) :
      const Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Text("Oops!\nThere are no ready orders", textAlign: TextAlign.center,),
        ),
      );
    });
  }
}
