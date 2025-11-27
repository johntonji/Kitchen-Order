

import 'dart:io';
import 'dart:ui';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import 'package:order_receiving/providers/riverpod_provider.dart';
import 'package:order_receiving/ui/reciept/view_image_receipt.dart';
import 'package:pdf_render/pdf_render.dart' as render;
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/printer_modal.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_client.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_kitchen.dart';
import 'package:order_receiving/utilities/base/my_message.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../assets/app_assets.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';
import '../utilities/shares_pref_manager.dart';
import '../utilities/utility_class.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as blu;


class PreparingTab extends rv.ConsumerStatefulWidget {
  const PreparingTab({super.key});

  @override
  rv.ConsumerState<PreparingTab> createState() => _PreparingTabState();
}

class _PreparingTabState extends rv.ConsumerState<PreparingTab> {
  final ScrollController _scrollController = ScrollController();
  List<LineText> kitchenLinetext=[];
  List<LineText> clientLineText=[];

  List<String> templates=["Client Receipt","Kitchen Receipt"];
  String receiptType="Client Receipt";
  int minutes = 10;
  UserModel userModel = UserModel.getInstance();
  bool isPrinting=false;
  String availabilityText="fetching Printer ...";

  void getData() {
    SharedPreferenceManager.getInstance().getUserData().then((value) {
      userModel = value;
    });
  }

  //printers
  String tips = 'no device connect';
  bool loading =true;
  bool devCon =false;
  OrderModel? autoOrderData;
  String kitchenReceiptPath = "";



  @override
  void initState(){
    super.initState();
      getData();
     Future.microtask(() {
      ref.read(scanPrintersNotifierProvider.notifier).initilaizee();
       ref.read(scanPrintersNotifierProvider.notifier).scanForPrinters(context);
      });
       Future.delayed(Duration(seconds: 5),(){
       if (mounted) {
        setState(() {
         loading =false;
        });
       }
      }
     );
  }
  


  void LoadingDialog(){
    showDialog(context: context,
    builder: (BuildContext context) {  
      return AlertDialog(
              shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: const EdgeInsets.all(0),
              elevation: 6,    
      );
    });
  }
  

/* wifi fun start */
 Future<bool> connectPrinter(String printerIp) async {
    final profile = await CapabilityProfile.load();
    
    final printer = NetworkPrinter(PaperSize.mm80, profile);
  
    PosPrintResult result ;
  try{
      result= await printer.connect(printerIp, port: 9100);   /// PORT 9100
      }catch(e){
        debugPrint("exception in wifi printer port 9100 $e");
        try{
          result= await printer.connect(printerIp, port: 9101);   ///PORT 9101
        }catch(e){
         debugPrint("exception in wifi printer port 9101 $e");
          result=PosPrintResult.timeout;
         }
        }
       if(result== PosPrintResult.success){
         return true;
       }
       else{
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not add printer Ip $printerIp ')));
         isPrinting=false;
         return false;
       }
  }

  /// Send ESC/POS command to get the printer name
  Future<String> getPrinterName(String ip) async {
    try {
      Socket socket = await Socket.connect(ip, 9100, timeout: Duration(seconds: 2));
      // ESC/POS Command: GS I 0x01 (Request Printer Name)
      List<int> command = [0x1D, 0x49, 0x01];
      socket.add(command);
      await socket.flush();
      
      List<int> response = [];
      socket.listen((data) {
        response.addAll(data);
      });

      await Future.delayed(Duration(seconds: 1));
      socket.destroy();

      if (response.isNotEmpty) {
         return response.toString();
      }
    } catch (e) {
      debugPrint("Error getting printer name: $e");
    }
    return "Unknown Printer";
  }


void getWifiPrinters() {
  final scanPrinterNotif = ref.watch(scanPrintersNotifierProvider); // for variables

  debugPrint("inside getWifiPrinters");
       List<PrinterModal> p=[];
       p= Provider.of<AppProvider>(context, listen: false).addedPrinterList;
      
     debugPrint("data in p is $p");
  for(PrinterModal j in p){
    for(Map<String,String>  i in scanPrinterNotif['foundPrinters']){
     if(j.ipAddress==i["ip"]){
       scanPrinterNotif['savedPrinters'].add(j);
     }else{
    if (mounted){
      setState(() {
          i["name"]=j.printerName!;
      });}
     }
    }
  }
      connectPrinters();        /// connect printers//////
  }
/* wifi fun end */

  String printStatus="";

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext contextt) { 
      return Consumer<AppProvider>(builder: (context, provider, isChild) {
                for(PrinterModal i in provider.addedPrinterList){
                   apiAddedIp.add(i.ipAddress!);
             }
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
          controller:_scrollController,
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
                                Text("Order #${order.orderData.orderId}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                                Text(order.orderData.deliveryTime, style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                                    Text("Order #${order.orderData.orderId}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                                    Text(order.orderData.deliveryTime, style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                                  Text("${order.customer.firstName} ${order.customer.lastName} ", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                                            child: Align(alignment: Alignment.centerLeft, child: Text(item.itemName, style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,)),
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
                                                            Expanded(child: Align(alignment: Alignment.center, child: Text("${formatToTwoDecimals(itemAddonItem.prettyAddonsTotal)}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,))),
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
                        //  Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //      Text(
                        //       // (order.orderData.taxType!=null) ?'${order.orderData.taxType!} tax':
                        //       "Tax",
                        //          style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14, color: AppAssets.widgetGrayColor),),
                        //      Text((order.orderData.taxTotal!=null) ?'\$ ${double.parse(order.orderData.taxTotal.toString()).toStringAsFixed(2)}' : '\$ 0.00',
                        //            style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 14), ),
                        //     ],
                        //   ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: IconButton(
                                  onPressed: (){
                                  printReceiptDialog(contextt,order);
                                
                                }, icon: Icon(Icons.print_outlined,size:  MediaQuery.sizeOf(context).width/9.5,)),
                              ),
                          
                              GestureDetector(
                                onTap: () {
                                  
                                  UtilityClass.showLoadingDialog(context);
                                  provider.readyForPickupOrder(userModel.authToken!, order.orderData.orderUuid).then((status) {
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
                                  child: Center(child: Text("READY FOR PICKUP ..", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
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
                    if(index == (provider.processingOrdersList.length-1))
                    SizedBox(height: 50,)
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
   } );
  }

// to connect the printers if their i[ matches the default IP]
 void connectPrinters(){
  final scanPrinterNotif = ref.watch(scanPrintersNotifierProvider); // for variables

  debugPrint("default client is ${AppProvider.defaultClientPrinterIp} , default kitchen is ${AppProvider.defaultKitchenPrinterIp}");
      //bluetooth devices
    scanPrinterNotif['bluetooth'].getBondedDevices().then((devices){
       for (blu.BluetoothDevice i in devices){
        if(i.address==AppProvider.defaultClientPrinterIp || i.address==AppProvider.defaultKitchenPrinterIp){
         //client
          if(i.address==AppProvider.defaultClientPrinterIp){
           scanPrinterNotif['bluetoothClientPrinterConnected']=i;
           scanPrinterNotif['selectedClientWifiPrinterIp']['ip']="";
          }
          //kitchen
          if(i.address==AppProvider.defaultKitchenPrinterIp){
           scanPrinterNotif['bluetoothKitchenPrinterConnected']=i;
           scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]="";
           scanPrinterNotif['selectedKitchenWifiPrinterIp']["name"]="";
          } // break; //imp
         }
        }
     });
     //wifi
   for(PrinterModal p in scanPrinterNotif['savedPrinters']){
    if(p.ipAddress== AppProvider.defaultClientPrinterIp || p.ipAddress== AppProvider.defaultKitchenPrinterIp){
       //client
       if(p.ipAddress== AppProvider.defaultClientPrinterIp){
         scanPrinterNotif['selectedClientWifiPrinterIp']['ip']=p.ipAddress!;
         scanPrinterNotif['selectedClientWifiPrinterIp']["name"]=p.printerName!;
         scanPrinterNotif['bluetoothClientPrinterConnected']=null;
       }
        //kitchen
       if(p.ipAddress== AppProvider.defaultKitchenPrinterIp){
         scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]=p.ipAddress!;
         scanPrinterNotif['selectedKitchenWifiPrinterIp']["name"]=p.printerName!;

         scanPrinterNotif['bluetoothKitchenPrinterConnected']=null;
       }
       debugPrint("wifi printers are client : ${scanPrinterNotif['selectedClientWifiPrinterIp']['ip']} ,kitchen : ${scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]}");
      //  break; ///
    }
   }
 }


 printReceiptDialog(BuildContext context1, OrderModel order) {
  final scanPrinterNotif = ref.watch(scanPrintersNotifierProvider); // for variables
    Future.delayed(Duration(seconds: 6),(){
     availabilityText="Printer Not available!";
     });
   connectPrinters();
   String printerLogId=Uuid().v1();
  String savedFilePath="";
    showDialog(
      context: context1,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Consumer<AppProvider>(builder: (context, provider, isChild) {
         return StatefulBuilder(
                builder: (context, setState) {
              return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: const EdgeInsets.all(0),
              elevation: 6,
              scrollable: true,
              backgroundColor: AppAssets.whiteColor,
              content: (isPrinting==true)
             ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: const BoxDecoration(
                  color: AppAssets.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
               ),
                child: Center(child: CircularProgressIndicator(),)
              )
             : Column(
              mainAxisSize: MainAxisSize.min,
               children: [
                  Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.close ,color: Colors.grey,))
                  ],
                ),
                 Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                    decoration: const BoxDecoration(
                      color: AppAssets.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Order #${order.orderData.orderId}",
                            style: TextStyle(
                              fontWeight:FontWeight.bold,
                                fontSize: AppAssets.dimen_16,
                                fontFamily: AppAssets.nunitoMedium,
                                color: AppAssets.textDarkGrayColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                           ),
                        ),
                        SizedBox(height: 20,),
                    
                   Text("Select Receipt ",style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                           Container(
                            width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: receiptType,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: templates.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items,style:TextStyle(fontFamily: AppAssets.nunitoRegular)),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                       if (mounted){
                                         setState(() {
                                          receiptType = newValue!;
                                        });}
                                      },
                                    ),
                                  ),
                                
                      SizedBox(height: 20),
                    if(receiptType=="Client Receipt")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                 (scanPrinterNotif['selectedClientWifiPrinterIp']['ip']=="" && scanPrinterNotif['bluetoothClientPrinterConnected']==null) 
                 ?  Text(availabilityText ,style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold))
                 : (scanPrinterNotif['selectedClientWifiPrinterIp']['ip'] !="" &&  scanPrinterNotif['bluetoothClientPrinterConnected']==null) 
                      ? Text( "Selected Printer : ${scanPrinterNotif['selectedClientWifiPrinterIp']['name']}" ,style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold))
                      : ( scanPrinterNotif['bluetoothClientPrinterConnected']!=null && scanPrinterNotif['selectedClientWifiPrinterIp']['ip']=="")
                           ? Text("Selected Printer : ${scanPrinterNotif['bluetoothClientPrinterConnected']!.name}" ,style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold))
                           : Text(availabilityText,style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold)),
                           
                           SizedBox(height: 10,),
                      ],
                    ),
                  if(receiptType=="Kitchen Receipt")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                 (scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]=="" && scanPrinterNotif['bluetoothKitchenPrinterConnected']==null) 
                 ?  Text(availabilityText ,style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold))
                 :  (scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]!="" &&  scanPrinterNotif['bluetoothKitchenPrinterConnected']==null) 
                      ? Text( "Selected Printer : ${scanPrinterNotif['selectedKitchenWifiPrinterIp']["name"]}" ,style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold))
                      : (scanPrinterNotif['bluetoothKitchenPrinterConnected']!=null && scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]=="")
                           ? Text("Selected Printer : ${scanPrinterNotif['bluetoothKitchenPrinterConnected']!.name}" ,style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold))
                           : Text(availabilityText,style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold)),
                           SizedBox(height: 10,),
                     ],
                    ),
                       SizedBox(
                          height: 30,
                        ),
                        FutureBuilder(
                                    future: SharedPreferenceManager.getInstance().getReceiptData((receiptType=="Client Receipt") ?"MerchantReceipt" : "KitchenEssentials"),
                                    builder: (context, recieptSnapshot) {
                                      return  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                                 OutlinedButton(
                               style: ButtonStyle(
                                        foregroundColor:
                                            WidgetStatePropertyAll(Colors.black)),
                            onPressed: () async {
                             savedFilePath = await getReceiptData(recieptSnapshot.data!,order);
                              
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>  ViewImageReceipt(filePath: savedFilePath,)));
                              },
                               child: Text("View",style: TextStyle(fontFamily: AppAssets.nunitoRegular),)),
                                  
                                  ////debugPrint button
                                  GestureDetector(
                                    onTap:
                                    (receiptType=="Client Receipt") 
                                    ? (scanPrinterNotif['selectedClientWifiPrinterIp']['ip']=="" && scanPrinterNotif['bluetoothClientPrinterConnected']==null) 
                                      ? (){}
                                      : ()async{
                                      try{
                                       savedFilePath=  await  getReceiptData(recieptSnapshot.data!,order);
                                       debugPrint("successful $receiptType");
                                      }catch(e){
                                        debugPrint("error for kitchen is  $e // $receiptType");
                                      }
                                  
                                  debugPrint("savedFilePath is $savedFilePath");
                                  if(scanPrinterNotif['selectedClientWifiPrinterIp']['ip']=="" && scanPrinterNotif['bluetoothClientPrinterConnected']==null){
                                    debugPrint("no printer connected client");
                                    MyMessage.showFailedMessage("No Printer Connected", context);
                                    }else{
                                    debugPrint("selectedWifiPrinterIp issss: ${scanPrinterNotif['selectedClientWifiPrinterIp']['ip']} ,bluetoothClientPrinterConnected is ${scanPrinterNotif['bluetoothClientPrinterConnected']?.name ?? ""}");
                                    
                                    isPrinting=true;
                                String printerType="";
                                  if(scanPrinterNotif['bluetoothClientPrinterConnected']!=null && scanPrinterNotif['selectedClientWifiPrinterIp']['ip']==""){
                                    printerType="Bluetooth";
                                  }else if(scanPrinterNotif['bluetoothClientPrinterConnected']==null && scanPrinterNotif['selectedClientWifiPrinterIp']['ip'] !=""){
                                    printerType="Wifi";
                                  }
                                  debugPrint("printerLogId is printing $printerLogId");
                                    provider.printerLogs(userModel.authToken!, order, printerType, "printing", savedFilePath,printerLogId,"client").then((status) async{
                                        
                           if(scanPrinterNotif['selectedClientWifiPrinterIp']['ip']!=""){
                     
                               printReceiptWifi(scanPrinterNotif['selectedClientWifiPrinterIp']['ip']!, savedFilePath,printerLogId,true,AppProvider.portDefaultClientPrinter,context1);
             
                             }else if( scanPrinterNotif['bluetoothClientPrinterConnected']!=null){
                             isPrinting=   await  provider.bluetoothPrintChannel(scanPrinterNotif['bluetoothClientPrinterConnected']!.address!, savedFilePath, userModel.authToken!, printerLogId,context1,true)
                             .then((onValue){
                                  if(onValue == false){
                                      try {
                                        Navigator.pop(context1);
                                        } catch (e, s) {
                                          debugPrint("Navigator.pop failed: $e\n$s");
                                         }
                                     return false;
                                   }else{
                                  debugPrint("onValue inside else $onValue");
                                     return true;
                                   }
                                });
                             /*  debugPrint("after scanPrinterNotif['bluetoothClientPrinterConnected']!=null");
                 
                           await bluetoothPrint.connect(scanPrinterNotif['bluetoothClientPrinterConnected']!);
                           Future.delayed(Duration(seconds: 3),()async{
                           bool connected=  (await bluetoothPrint.isConnected)!;
                 
                           Future.delayed(Duration(seconds: 3),(){
                           if(connected==true){
                           printReceiptBluetooth(scanPrinterNotif['bluetoothClientPrinterConnected']!,printerLogId,clientLineText,true);
                           }
                        });
                       }); */
                       }else{
                         debugPrint("printReceiptWifi hello");
                       }
                      });
                     }
                              
                                  }
                                  //////////////// kitchen Receipt
                                  : (scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]=="" && scanPrinterNotif['bluetoothKitchenPrinterConnected']==null) 
                                      ? (){}
                                      : ()async{
                                      try{
                                       savedFilePath=  await  getReceiptData(recieptSnapshot.data!,order);
                                       debugPrint("successful $receiptType");
                                      }catch(e){
                                        debugPrint("error for kitchen is  $e // $receiptType");
                                      }
                                  
                                  debugPrint("savedFilePath is $savedFilePath");
                                  if(scanPrinterNotif['selectedKitchenWifiPrinterIp']=="" && scanPrinterNotif['bluetoothKitchenPrinterConnected']==null){
                                    debugPrint("no printer connected Kitchen");
                                    MyMessage.showFailedMessage("No Printer Connected", context);
                                    }else{
                                    debugPrint("selectedWifiPrinterIp issss: ${scanPrinterNotif['selectedKitchenWifiPrinterIp']} ,scanPrinterNotif['bluetoothKitchenPrinterConnected'] is ${scanPrinterNotif['bluetoothKitchenPrinterConnected']?.name ?? ""}");
                                    isPrinting=true;
                                String printerType="";
                                  if(scanPrinterNotif['bluetoothKitchenPrinterConnected']!=null && scanPrinterNotif['selectedKitchenWifiPrinterIp']['ip']==""){
                                    printerType="Bluetooth";
                                  }else if(scanPrinterNotif['bluetoothKitchenPrinterConnected']==null && scanPrinterNotif['selectedKitchenWifiPrinterIp']['ip'] !=""){
                                    printerType="Wifi";
                                  }
                                  debugPrint("printerLogId is printing $printerLogId");
                                    provider.printerLogs(userModel.authToken!, order, printerType, "printing", savedFilePath,printerLogId,"kitchen").then((status) async{
                                        
                           if(scanPrinterNotif['selectedKitchenWifiPrinterIp']['ip']!=""){
                              try{
                         printReceiptWifi(scanPrinterNotif['selectedKitchenWifiPrinterIp']['ip']!, savedFilePath,printerLogId,true,AppProvider.portDefaultKitchenPrinter,context1);    
                           
                      }catch(e){
                  debugPrint("could not debugPrint kitchen error $e");
                   Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "failed",printerLogId);
                   isPrinting=false;
                             }
                             }else
                              if( scanPrinterNotif['bluetoothKitchenPrinterConnected']!=null){
                            isPrinting= await  provider.bluetoothPrintChannel(scanPrinterNotif['bluetoothKitchenPrinterConnected'].address, savedFilePath, userModel.authToken!, printerLogId,context1,true)
                            .then((onValue){
                                  if(onValue == false){
                                      try {
                                        Navigator.pop(context1);
                                        } catch (e, s) {
                                          debugPrint("Navigator.pop failed: $e\n$s");
                                         }
                                     return false;
                                   }else{
                                  debugPrint("onValue inside else $onValue");
                                     return true;
                                   }
                                });
                        }else{
                         debugPrint("printReceiptWifi hello");
                       }
                      
                       });
                     }
                         },
                                  child: (receiptType=="Client Receipt")
                                  ? Container(
                                      height: 36,
                                      padding: const EdgeInsets.only(left: 16, right: 16),
                                      decoration: BoxDecoration(
                                        color:(scanPrinterNotif['selectedClientWifiPrinterIp']['ip']=="" && scanPrinterNotif['bluetoothClientPrinterConnected']==null) ?AppAssets.widgetGrayColor :AppAssets.purpleColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(child: Text("Print", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                    )
                                  :  Container(
                                      height: 36,
                                      padding: const EdgeInsets.only(left: 16, right: 16),
                                      decoration: BoxDecoration(
                                        color:(scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]=="" && scanPrinterNotif['bluetoothKitchenPrinterConnected']==null) ?AppAssets.widgetGrayColor :AppAssets.purpleColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(child: Text("Print", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                    )
                                  ),
                                ],
                        );
                        }
                      ),
                      ],
                    ),
                  ),
               ],
             ),
            );
           }
          );
      });
      },
    ).then((_){
   if (mounted){
     setState(() {
      receiptType="Client Receipt";
    });}
    });
  }

///////// api Printers
List<String> apiAddedIp=[];

 Future<String> getReceiptData(Map<String, dynamic> receiptData ,OrderModel order) async{
      List<String> finalCompList=[];
      String filePath="";
 if(receiptType=="Client Receipt"){
      ClientReceiptSettings receiptSettings =ClientReceiptSettings.fromJson(receiptData);
      String previewOrdersVal = receiptSettings.previewOrdersVal;
      String previewTimesVal = receiptSettings.previewTimesVal;
      String previewPaymentsVal = receiptSettings.previewPaymentsVal;
      int blankLinesVal = receiptSettings.blankLinesVal;

      ////
      InfoBox1Model infoBox1Model = receiptSettings.infoBox1Model;
      InfoBox2Model infoBox2Model = receiptSettings.infoBox2Model;

      PaymentMethodModel paymentMethodModel = receiptSettings.paymentMethod;
      OrderDetailsModel orderDetailsModel = receiptSettings.orderDetails;
      DirectionModel directionModel = receiptSettings.direction;
      ClientInfoModel clientInfoModel = receiptSettings.clientInfo;
      ItemsModel itemsModel = receiptSettings.items;
      ContactDetailsModel contactDetailsModel = receiptSettings.contactDetails;
      ClientConfirmationModel clientConfirmationModel = receiptSettings.clientConfirmation;

      int timeTitleSize = receiptSettings.timeTitleSize;
      int clientCommentSize = receiptSettings.clientCommentSize;
      int isPaidTitleSize = receiptSettings.isPaidTitleSize;
      int orderOnlineTitleSize = receiptSettings.orderOnlineTitleSize;

      String otherPremise = receiptSettings.otherPremiseText;
      String premiseTypeVal = receiptSettings.premiseTypeVal;
      String premiseTypeFinalVal = receiptSettings.premiseTypeFinalVal;

       for (final item in receiptSettings.finalCompList) {
              if (item.values.first == true) {
                     finalCompList.add(item.keys.first);
                  }
         }

   filePath=  await    dynClientPdfGenerate(order, previewOrdersVal, previewTimesVal, previewPaymentsVal, blankLinesVal, infoBox1Model, infoBox2Model, paymentMethodModel, orderDetailsModel, directionModel, clientInfoModel, itemsModel, contactDetailsModel, clientConfirmationModel, timeTitleSize, clientCommentSize, isPaidTitleSize, orderOnlineTitleSize, premiseTypeVal, otherPremise, premiseTypeFinalVal, finalCompList);
 }else if(receiptType=="Kitchen Receipt"){
  KitchenReceiptSettings? receiptSettings;
     try {
      receiptSettings=KitchenReceiptSettings.fromJson(receiptData);
      }catch(e){
       debugPrint("error in receiptSettings is $e" );
      }

  if(receiptSettings!=null)
  {    
  debugPrint("getting receiptSettings $receiptSettings");
   String  previewOrdersVal=receiptSettings.previewOrdersVal;
   String previewTimesVal=receiptSettings.previewTimesVal;
   String  previewPaymentsVal=receiptSettings.previewPaymentsVal;
   int blankLinesVal =receiptSettings.blankLinesVal;
 
   HeaderModel headerModel=receiptSettings.headerModel;
   OrderDetailsModel  orderDetailsModel=receiptSettings.orderDetails;
   KitchenItemsModel  kitchenItemsModel=receiptSettings.items;
   PackagingQualityModel  packagingQualityModel=receiptSettings.packagingQualityModel;

    String otherPremise=receiptSettings.otherPremiseText;
    int onPremiseSize=receiptSettings.onPermiseSize ?? 11;
    int clientCommentSize=receiptSettings.clientCommentSize;
    int isPaidTitleSize=receiptSettings.isPaidTitleSize;

    String premiseTypeVal=receiptSettings.premiseTypeVal;
    String premiseTypeFinalVal=receiptSettings.premiseTypeFinalVal;
       for (final item in receiptSettings.finalCompList) {
              if (item.values.first == true) {
                     finalCompList.add(item.keys.first);
                 }
    }
    debugPrint("got receiptSettings ");

         
  filePath=  await  dynKitchenPdfGenerate(order, previewOrdersVal, previewTimesVal, previewPaymentsVal, blankLinesVal, headerModel, onPremiseSize, orderDetailsModel, kitchenItemsModel, packagingQualityModel, clientCommentSize, isPaidTitleSize, premiseTypeVal, otherPremise, premiseTypeFinalVal, finalCompList);
  debugPrint("kitchen filepath isss $filePath");
 
  }else{
  debugPrint("receiptSettings is null ");
 }
 }
  debugPrint("inside getReceiptData $receiptData ///// $receiptType //// $filePath ");
   return filePath;              
 }


Future<img.Image?> convertPdfToImage(String filePath) async {
  final doc = await render.PdfDocument.openFile(filePath);
  final page = await doc.getPage(1);

// Get page size
final pageWidth = page.width;
final pageHeight = page.height;

// Set the target debugPrint width (576px for 80mm paper)
final targetWidth = 576;

// Maintain aspect ratio
final aspectRatio = pageHeight / pageWidth;
final targetHeight = (targetWidth * aspectRatio).round();

final pageImage = await page.render(
  width: targetWidth,
  height: targetHeight,
);

  final uiImage = await pageImage.createImageDetached();
  final byteData = await uiImage.toByteData(format: ImageByteFormat.png);

  if (byteData == null) return null;

  final pngBytes = byteData.buffer.asUint8List();
  final decodedImage = img.decodeImage(pngBytes);

  pageImage.dispose();
  // page.dispose(); // Don’t forget this

  return decodedImage;
}

Future<void> printImage(Uint8List imageBytes, String printerIp,String printerLogId) async {
  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(PaperSize.mm80, profile);
  final result = await printer.connect(printerIp, port: 9100);

  if (result == PosPrintResult.success) {
    final image = img.decodeImage(imageBytes);
    if (image != null) {
      printer.image(image);
      printer.feed(2);
      printer.cut();
    }
    printer.disconnect();
    MyMessage.showSuccessMessage("Reciept Printed",context);
    debugPrint("wifi printing complete");
   } else {
    debugPrint('Print failed: $result');
       MyMessage.showFailedMessage("Printer Disconnected", context);
       Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "failed",printerLogId);
       isPrinting=false;
  }
}

  // function to debugPrint [wifi]
Future<void> printReceiptWifi(String printerIp,String filePath ,String printerLogId,bool isDialog,String port,BuildContext context) async {

 final pdfImage = await convertPdfToImage(filePath);
 if (pdfImage != null) {
  final imageBytes = img.encodePng(pdfImage);

//TODO : add function for star here
if(port=="9101"){
  try{
  Provider.of<AppProvider>(context,listen: false).starPrintChannel(printerIp, filePath, userModel.authToken!, printerLogId, context, isDialog).then((onValue){
  //  Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "success",printerLogId);  
   if(isDialog==true){
    isPrinting=false;
    Navigator.pop(context);
   }
  });

  }catch(e,stack){
    debugPrint("error in starPrintChannel in prep tab $e");
   // bugsnag.notify("error in starPrintChannel in in prep tab $e", stack);
    
  }
 }else{
    await printImage(Uint8List.fromList(imageBytes), printerIp,printerLogId).then((onValue){
    Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "success",printerLogId);  
    if(isDialog==true){
    isPrinting=false;
    Navigator.pop(context);
   }
  });
  // if(isPrinting==true){
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Printing in progress....."),duration: Duration(seconds: 5),));
  // }
}

 }else{
   MyMessage.showFailedMessage("Printing failed", context);
   Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "failed",printerLogId);
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not add printer Ip $printerIp ')));
   isPrinting=false;
}
 
}
    

Future<void> printReceiptBluetooth(BluetoothDevice device, String printerLogId, List<LineText> customListText,bool isDialog) async {
  debugPrint("printReceiptBluetooth called");

  if(kitchenLinetext!=[]){
    debugPrint("kitchenLinetext is $kitchenLinetext");
  }

  bool? result=false;
   printStatus = (result == true) ? "success" : "failed";
   debugPrint("printerLogId is updating  $printerLogId");
   debugPrint("debugPrint status in bluetooth printer is 2 $printStatus");
   if(printStatus=="failed"){
    UtilityClass.showFailedDialog(context, "Failed", "Failed to Print");
   }else if(printStatus=="success"){
    UtilityClass.showSuccessDialog(context, "Success", "Receipt Prinited");
   }
  Provider.of<AppProvider>(context, listen: false).updatePrinterLogs(userModel.authToken!, printStatus, printerLogId).then((val){
   if(isDialog==true){
    isPrinting=false;
    Navigator.pop(context);
   }
  });

}


 @override
  void dispose() {
    super.dispose();
  }

}
