// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:ui';

import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import 'package:flutter_svg/svg.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/providers/riverpod_provider.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_client.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_kitchen.dart';
import 'package:order_receiving/utilities/base/my_message.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:order_receiving/utilities/utility_class.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import '../assets/app_assets.dart';
import '../providers/app_provider.dart';
import 'package:pdf_render/pdf_render.dart' as render;

class NewTab extends rv.ConsumerStatefulWidget {
  const NewTab({super.key});

  @override
  rv.ConsumerState<NewTab> createState() => _NewTabState();
}

class _NewTabState extends rv.ConsumerState<NewTab> {

//  late int minutess;
  UserModel userModel = UserModel.getInstance();
  //Timer? timer;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  bool clientPrinted=false;
  bool kitchenPrinted=false;
  OrderModel? autoOrderDataNew;
  bool autoPrintFailed=false; 
 
  @override
  void initState() {
    getData();
      Future.microtask(() {
      ref.read(scanPrintersNotifierProvider.notifier).initilaizee();
       ref.read(scanPrintersNotifierProvider.notifier).scanForPrinters(context);
      //  minutess=Provider.of<AppProvider>(context, listen: false).time1 ?? 20;
      });
        if(AppProvider.autoPrinting==true){
      // debugPrint("autoPrintOrder is ${AppProvider.autoPrintOrder!.orderData.orderId}");
      for(OrderModel o in Provider.of<AppProvider>(context,listen: false).processingOrdersList){
        if(AppProvider.autoOrderUuis==o.orderData.orderUuid){
          autoOrderDataNew=o;
        }
      }
     debugPrint("autoPrintig true");
    //  if(autoOrderDataNew!=null){
    //  debugPrint("autoOrderData is ${autoOrderDataNew!.orderData.orderId}");
    //     //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Printing order receipts!")));
       
    //  Future.delayed(Duration(seconds: (10)),(){
    //     //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Printing in progress.....")));
    //    autoPrint(autoOrderDataNew!); ///
    //  });
    //   // runFunction(context);
    // }
    }else{
      debugPrint("autoOrderData is null");
    }
    super.initState();
  }

    Map<String,dynamic> kitchenData={};
      String kitchenReceiptPath = "";
  String receiptType="Client Receipt";

    void autoPrint(OrderModel autoOrderData,int minutess) async{
      print("Acceptance time is  ${autoOrderData.orderData.acceptedAt}");
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Acceptance time is  ${autoOrderData.orderData.acceptedAt}")));
      Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Printing receipts for #${autoOrderData.orderData.orderId}")));
    UtilityClass.showLoadingDialog(context);
     debugPrint("inside autoPrint function");
    Future.delayed(Duration(seconds: 5),()async{
      await autoPrintClient(autoOrderData,minutess);  
    });

///// testing  //////
  //       if(autoPrintFailed==false){
  //     Future.delayed(Duration(seconds: 4),()async{
  //   kitchenData= (await SharedPreferenceManager.getInstance().getReceiptData("KitchenEssentials"))!;
  //   if(kitchenData!={} && kitchenData!=null){
  //     debugPrint("kitchen sharedPreferences Data is $kitchenData");
  //      if (kitchenData != null){ 
  //       receiptType="Kitchen Receipt";
  //       try{
  //     kitchenReceiptPath = await getReceiptData(kitchenData, autoOrderData);
  //     if(kitchenReceiptPath=="" || kitchenReceiptPath==null){
  //         if(autoPrintFailed==false){
  //           debugPrint("error 1");
  //       autoPrintFailed=true;
  //     UtilityClass.dismissLoading(context);
  //     endDecision(autoOrderData);
  //      return;
  //      }
  //     }
  //      }catch(e){
  //     debugPrint("error in getting kitchenReceiptPath is $e");
  //       if(autoPrintFailed==false){
  //         debugPrint("error 2");
  //       autoPrintFailed=true;
  //     UtilityClass.dismissLoading(context);
  //     endDecision(autoOrderData);
  //      return;
  //       }
  //   }}
  //   if(autoPrintFailed==false){
  //    await autoPrintKitchen(autoOrderData);  
  //   }
   
  //   }  

  //   Future.delayed(Duration(seconds: 4),()async{

  //       AppProvider.autoPrinting=false; 
  //      debugPrint("autoPrinting value after printing ${AppProvider.autoPrinting}");
  //     // UtilityClass.dismissLoading(context);
  //   });
  //  });}

   ////testing /////
  }

 ///autoPrint function for client receipt
 Future<void> autoPrintClient(OrderModel autoOrderData,int minutess)async{
  print("autoPrintClient Acceptance time is  ${autoOrderData.orderData.acceptedAt}");
       final scanPrinterNotif = ref.watch(scanPrintersNotifierProvider); // for variables

  String clientReceiptPath="";
  await SharedPreferenceManager.getInstance().getReceiptData("MerchantReceipt").then((val) async{
  clientReceiptPath=  await getReceiptData(val!, autoOrderData);  
   receiptType="Client Receipt";
      //// debugPrint for client start
    String printerClientLogId=Uuid().v1();
    StackTrace? stack;
       // bugsnag.notify("clientReceiptPath is $clientReceiptPath", stack);
    debugPrint("clientReceiptPath is $clientReceiptPath");
    if(clientReceiptPath==null || clientReceiptPath=="") {
      if(autoPrintFailed==false){
       
        StackTrace? stack;
       // bugsnag.notify("autoPrint error 3", stack);
         if(mounted){
               UtilityClass.dismissLoading(context);
           }
        debugPrint("error 3");
        autoPrintFailed=true;
        // if(mounted){   //caused crash
        // UtilityClass.dismissLoading(context);
        // }
      endDecision(autoOrderData,minutess);
      return;
     }
    }
      if(scanPrinterNotif['selectedClientWifiPrinterIp']['ip']=="" && scanPrinterNotif['bluetoothClientPrinterConnected']==null){
           MyMessage.showFailedMessage("No Client Printer Connected ", context);
              if(autoPrintFailed==false){
                StackTrace? stack;
                 // bugsnag.notify("autoPrint error 4", stack);

                   debugPrint("error 4");
                    autoPrintFailed=true;
                     if(mounted){
                       UtilityClass.dismissLoading(context);
                         }
                         endDecision(autoOrderData,minutess);
                           return;
                            }

                              }else{
                                debugPrint("selectedWifiPrinterIp is: ${scanPrinterNotif['selectedClientWifiPrinterIp']['ip']} ,bluetoothClientPrinterConnected is ${scanPrinterNotif['bluetoothClientPrinterConnected']?.name}");
                              String printerType="";
                              if(scanPrinterNotif['bluetoothClientPrinterConnected']!=null && scanPrinterNotif['selectedClientWifiPrinterIp']['ip']==""){
                                printerType="Bluetooth";
                              }else if(scanPrinterNotif['bluetoothClientPrinterConnected']==null && scanPrinterNotif['selectedClientWifiPrinterIp']['ip'] !=""){
                                printerType="Wifi";
                              }
                              debugPrint("printerLogId is printing $printerClientLogId");
                              Provider.of<AppProvider>(context,listen: false).printerLogs(userModel.authToken!, autoOrderData, printerType, "printing", clientReceiptPath,printerClientLogId,"client").then((status) async{
                                    
      if(scanPrinterNotif['selectedClientWifiPrinterIp']['ip'] !=""){
        
      bool clientPrintedlocal = await  printReceiptWifi(scanPrinterNotif['selectedClientWifiPrinterIp']['ip']!, clientReceiptPath,printerClientLogId,false,autoOrderData,AppProvider.portDefaultClientPrinter);
      clientPrinted=clientPrintedlocal;
      if(clientPrintedlocal==false){
      MyMessage.showFailedMessage("Client Printer Disconnected", context);
      Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "failed",printerClientLogId);
       if(autoPrintFailed==false){
               StackTrace? stack;
       // bugsnag.notify("autoPrint error 5", stack);

        debugPrint("error 5");
        autoPrintFailed=true;
        if(mounted){
        UtilityClass.dismissLoading(context); 
        }
        endDecision(autoOrderData,minutess);
        return;
       }
     }

     }else if( scanPrinterNotif['bluetoothClientPrinterConnected']!=null){
      debugPrint("after bluetoothClientPrinterConnected!=null");
     clientPrinted= await Provider.of<AppProvider>(context,listen: false).bluetoothPrintChannel(scanPrinterNotif['bluetoothClientPrinterConnected']!.address!, clientReceiptPath, userModel.authToken!, printerClientLogId,context,false).then((onValue){
      debugPrint("onValue value is $onValue");
      if(onValue== false){
              StackTrace? stack;
       // bugsnag.notify("autoPrint error 11", stack);

        debugPrint("error 11");
        autoPrintFailed=true;
        if(mounted){
         UtilityClass.dismissLoading(context); 
        }
        endDecision(autoOrderData,minutess); 
        return false;
       }else{
        return true;
       }
      });
     if(autoPrintFailed==true){
      return;
     }
      
   /*await bluetoothPrint.connect(bluetoothClientPrinterConnected!);
     Future.delayed(Duration(seconds: 3),()async{
     bool connected=  (await bluetoothPrint.isConnected)!;

     Future.delayed(Duration(seconds: 3),(){
      if(connected==true){
       printReceiptBluetooth(bluetoothClientPrinterConnected!,printerClientLogId,clientLineText,false);
      }
    });
   }); */

      }
    }).then((onValue){
              /// ///// call kitchen autoPrint -----
  Future.delayed(Duration(seconds: 6),()async{
       debugPrint("Client receipt completed printing $clientPrinted");
    if(autoPrintFailed==false && clientPrinted==true){   

    kitchenData= (await SharedPreferenceManager.getInstance().getReceiptData("KitchenEssentials"))!;
    if(kitchenData!={} && kitchenData!=null){
      debugPrint("kitchen sharedPreferences Data is $kitchenData");
       if (kitchenData != null){ 
        receiptType="Kitchen Receipt";
        try{
      kitchenReceiptPath = await getReceiptData(kitchenData, autoOrderData);
      if(kitchenReceiptPath=="" || kitchenReceiptPath==null){
          if(autoPrintFailed==false){  
          StackTrace? stack;
        // bugsnag.notify("autoPrint error 6", stack);

            debugPrint("error 6");
            autoPrintFailed=true;
            if(mounted){
            UtilityClass.dismissLoading(context);
            }
            endDecision(autoOrderData,minutess);
            return;
       }
      }
       }catch(e){
      debugPrint("error in getting kitchenReceiptPath is $e");
        if(autoPrintFailed==false){
             StackTrace? stack;
       // bugsnag.notify("autoPrint error 7", stack);

        debugPrint("error 7");
        autoPrintFailed=true;
        if(mounted){
        UtilityClass.dismissLoading(context);
        }
        endDecision(autoOrderData,minutess);
       return;
      }
    }}
    if(autoPrintFailed==false){
     await autoPrintKitchen(autoOrderData,minutess);  
    }
   }  
    Future.delayed(Duration(seconds: 4),()async{
        AppProvider.autoPrinting=false; 
       debugPrint("autoPrinting value after printing ${AppProvider.autoPrinting}");
      // UtilityClass.dismissLoading(context);
    });
   }
  });
    });

   }
   /// debugPrint fri cleint end

  });


 }


Future<void> autoPrintKitchen(OrderModel autoOrderData,int minutess) async {
  final scanPrinterNotif = ref.watch(scanPrintersNotifierProvider); // for variables

  debugPrint("Start printing kitchen receipt------------------------------------------------------");

    if (kitchenData == null) {
      debugPrint("Error: KitchenEssentials is NULL!");
      MyMessage.showFailedMessage("No receipt data found for Kitchen Essentials", context);
      return;
    }

    debugPrint("KitchenEssentials value is $kitchenData"); // Debug log
    String printerKitchenLogId = Uuid().v1();
    debugPrint("kitchenReceiptPath is $kitchenReceiptPath");

    if (scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]== "" && scanPrinterNotif['bluetoothKitchenPrinterConnected'] == null) {
      debugPrint("No printer connected");
      MyMessage.showFailedMessage("No Kitchen Receipt Printer Connected", context);
        if(autoPrintFailed==false){
        StackTrace? stack;
       // bugsnag.notify("autoPrint error 8", stack);

          debugPrint("error 8");
        autoPrintFailed=true;
        if(mounted){
     UtilityClass.dismissLoading(context);
        }
      endDecision(autoOrderData,minutess);
        }
      return;
    }

    debugPrint("SelectedKitchenWifiPrinterIp: ${scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]}, BluetoothPrinter: ${scanPrinterNotif['bluetoothKitchenPrinterConnected']?.name}");
    String printerType = "";
    if (scanPrinterNotif['bluetoothKitchenPrinterConnected'] != null && scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"] == ""){
      printerType = "Bluetooth";
    } else if (scanPrinterNotif['bluetoothKitchenPrinterConnected'] == null && scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"] != ""){
      printerType = "Wifi";
    }

    debugPrint("printerKitchenLogId is printing $printerKitchenLogId");

    await Provider.of<AppProvider>(context, listen: false).printerLogs(userModel.authToken!, autoOrderData, printerType, "printing", kitchenReceiptPath, printerKitchenLogId,"kitchen")
        .then((status) async {
          debugPrint("kitchennn printers are ${scanPrinterNotif['selectedKitchenWifiPrinterIp']['ip']}  andd  ${scanPrinterNotif['bluetoothKitchenPrinterConnected']}");
        if (scanPrinterNotif['selectedKitchenWifiPrinterIp']['ip'] !="") {
        //  bool isConnected = await connectPrinter(scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]!);
        //  if (isConnected) {
      bool   kitchenPrintedLocal=  await printReceiptWifi(scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]!, kitchenReceiptPath, printerKitchenLogId,false,autoOrderData,AppProvider.portDefaultKitchenPrinter);
        kitchenPrinted=kitchenPrintedLocal;
        if(kitchenPrintedLocal==false){
        //  } else {
          MyMessage.showFailedMessage("Printer Disconnected", context);
            if(autoPrintFailed==false){
        StackTrace? stack;
       // bugsnag.notify("autoPrint error 9", stack);

         debugPrint("error 9");
          autoPrintFailed=true;
          if(mounted){
           UtilityClass.dismissLoading(context);
          }
           Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "failed",printerKitchenLogId);
          endDecision(autoOrderData,minutess);
          return;
         }
        }
      } else if (scanPrinterNotif['bluetoothKitchenPrinterConnected'] != null){
      kitchenPrinted = await Provider.of<AppProvider>(context,listen: false).bluetoothPrintChannel(scanPrinterNotif['bluetoothKitchenPrinterConnected']!.address!, kitchenReceiptPath, userModel.authToken!, printerKitchenLogId,context,false).then((onValue){
      debugPrint("onValue value is $onValue");
      if(onValue== false){       
        StackTrace? stack;
       // bugsnag.notify("autoPrint error 10", stack);
        debugPrint("error 10");
        autoPrintFailed=true;
        if(mounted){
         UtilityClass.dismissLoading(context); 
        }
        // endDecision(autoOrderData); 
        return false;
       }else{
        return true;
       }
     });
    //   if(autoPrintFailed==true){
    //   return;
    //  }
     /*   await bluetoothPrint.connect(bluetoothClientPrinterConnected!);
     Future.delayed(Duration(seconds: 3),()async{
     bool connected=  (await bluetoothPrint.isConnected)!;

      Future.delayed(Duration(seconds: 3),(){
      if(connected==true){
       printReceiptBluetooth(bluetoothKitchenPrinterConnected!,printerKitchenLogId,kitchenLinetext,false);
      }
      });
     }); */
    }
   });
    debugPrint("Kitchen receipt completed printing $kitchenPrinted");
       endDecision(autoOrderData,minutess);
}



void endDecision(OrderModel autoOrderData,int minutess){

  // all receipt prints
  if(clientPrinted == true && kitchenPrinted == true && autoPrintFailed==false) {
      Provider.of<AppProvider>(context, listen: false)
          .acceptOrder(userModel.authToken!, autoOrderData.orderData.orderUuid,
              autoOrderData.orderData.deliveryDate, getTimeString(minutess))
          .then((status) {
        if (status.isSuccess) {
          //
          Provider.of<AppProvider>(context, listen: false).printStatusUpdate(userModel.authToken!, autoOrderData.orderData.orderUuid, "1"); //update printed status
          SharedPreferenceManager.getInstance().addToProcessedOrderList(autoOrderData);  //add order to processed list 
         //
          Navigator.of(context).pop();
          UtilityClass.showSuccessDialog(
              context, "Order Status", status.message);
        } else {
          Navigator.of(context).pop();
          UtilityClass.showFailedDialog(context, "Failed", status.message);
        }
      });
    }
    //only client printed
    else if(clientPrinted==true && kitchenPrinted==false && autoPrintFailed==true){
   
          partiallyPrintedDialog(autoOrderData,minutess);
           Provider.of<AppProvider>(context, listen: false)
          .acceptOrder(userModel.authToken!, autoOrderData.orderData.orderUuid,
              autoOrderData.orderData.deliveryDate, getTimeString(minutess))
          .then((status) {
        if (!status.isSuccess) {
          UtilityClass.showFailedDialog(context, "Failed", status.message);
        }
      });
    }   
    else{
      allprintFailedDialog(autoOrderData,minutess);
    }
 }

void allprintFailedDialog(OrderModel autoOrderData ,int minutess){
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return 
         AlertDialog(
          actions: [
            SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                     autoPrintFailed=false;
                    UtilityClass.showLoadingDialog(context);
                  Provider.of<AppProvider>(context, listen: false)
                     .acceptOrder(userModel.authToken!, autoOrderData.orderData.orderUuid,
                    autoOrderData.orderData.deliveryDate, getTimeString(minutess))
                            .then((status) {
                              if(mounted){
                          UtilityClass.dismissLoading(context);
                              }
                          if (status.isSuccess) {
                            Navigator.of(context).pop();
                            UtilityClass.showSuccessDialog(context, "Order Status", status.message);
                          } else {
                            Navigator.of(context).pop();
                            UtilityClass.showFailedDialog(context, "Failed", status.message);
                          }
                        });
                      },child: Container(     height: 40,
                                                    margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                                                    padding: const EdgeInsets.only(left: 16, right: 16),
                                                    decoration: BoxDecoration(
                                                      color: AppAssets.greenColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Center(child: Text("ACCEPT ORDER", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                                  ),
                  ),
                  SizedBox(height: 10,),
                    OutlinedButton(
                         style: ButtonStyle(
                         foregroundColor: WidgetStatePropertyAll(Colors.black)),
                         onPressed: () async {
                          autoPrintFailed=false;
                            Navigator.pop(context);
                          },
                          child: Text("close",style: TextStyle(fontFamily: AppAssets.nunitoRegular),)),
                ],
              ),
            ),
           
              ],
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: const EdgeInsets.all(0),
              elevation: 6,
              scrollable: true,
              backgroundColor: AppAssets.whiteColor,
              content: 
              Container(
                width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 30),
                decoration: const BoxDecoration(
                  color: AppAssets.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
               ),
                child:  Column(
                children: [
                     Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                     autoPrintFailed=false;
                      Navigator.pop(context);
                    }, icon: Icon(Icons.close ,color: Colors.grey,))
                  ],
                ),
                Text("Printing Failed", style: TextStyle(fontSize: AppAssets.dimen_16, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textDarkGrayColor),),
                const SizedBox(height: 30,),
                    Text("You can still print receipts in preparing tab. Do you want to accept order #${autoOrderData.orderData.orderId} ?",textAlign: TextAlign.center, style: TextStyle(fontSize: AppAssets.dimen_16, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textDarkGrayColor))
               ],
             ),)
              );
      },
    );
  
}

// only one from client or kitchen receipt printed
void partiallyPrintedDialog(OrderModel autoOrderData ,int minutess){
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return 
         AlertDialog(
          actions: [
            SizedBox(
              child: OutlinedButton(
                   style: ButtonStyle(
                   foregroundColor: WidgetStatePropertyAll(Colors.black)),
                   onPressed: () async {
                    autoPrintFailed=false;
                      Navigator.pop(context);
                    },
                    child: Text("close",style: TextStyle(fontFamily: AppAssets.nunitoRegular),)),
            ),
           
              ],
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: const EdgeInsets.all(0),
              elevation: 6,
              scrollable: true,
              backgroundColor: AppAssets.whiteColor,
              content: 
              Container(
                width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 30),
                decoration: const BoxDecoration(
                  color: AppAssets.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
               ),
                child:  Column(
                children: [
                     Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                     autoPrintFailed=false;
                      Navigator.pop(context);
                    }, icon: Icon(Icons.close ,color: Colors.grey,))
                  ],
                ),
               
                Text("Printing Status", style: TextStyle(fontSize: AppAssets.dimen_18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textDarkGrayColor),),
                     const SizedBox(height: 30,),
                  Row( 
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                                      Text("Client Receipt Print :",textAlign: TextAlign.center, style: TextStyle(fontSize: AppAssets.dimen_16,fontWeight: FontWeight.bold, fontFamily: AppAssets.nunitoMedium, color: AppAssets.widgetGrayColor)),
                                      (clientPrinted==false)
                                      ?Icon(Icons.close ,color: Colors.red,size: 20,)
                                      : Icon(Icons.done ,color: Colors.green,size: 20,)],),
                                       const SizedBox(height: 10,),
                                        Row( 
                                    mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                      Text("Kitchen Receipt Print :",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: AppAssets.dimen_16, fontFamily: AppAssets.nunitoMedium, color: AppAssets.widgetGrayColor)),
                                      (kitchenPrinted==false)
                                      ? Icon(Icons.close ,color: Colors.red,size: 20,)
                                      : Icon(Icons.done ,color: Colors.green,size: 20,)],),
                     const SizedBox(height: 30,),
                    Text("Order #${autoOrderData.orderData.orderId} has been accepted. You can still print receipts in preparing tab.",textAlign: TextAlign.center, style: TextStyle(fontSize: AppAssets.dimen_16, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textDarkGrayColor))
               ],
             ),)
              );
      },
    );
  
}


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
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('printer Ip $printerIp connected successfully')));
         return true;
       }
      else{
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not add printer Ip $printerIp ')));
        return false;
       }
  }
 
Future<String> getReceiptData(Map<String, dynamic> receiptData ,OrderModel order) async{
   print("autoPrintClient in  getReceiptData Acceptance time is  ${order.orderData.acceptedAt}");
      List<String> finalCompList=[];
      String filePath="";
    if (receiptType == "Client Receipt") {
      ClientReceiptSettings receiptSettings =
          ClientReceiptSettings.fromJson(receiptData);
      String previewOrdersVal = receiptSettings.previewOrdersVal;
      String previewTimesVal = receiptSettings.previewTimesVal;
      String previewPaymentsVal = receiptSettings.previewPaymentsVal;
      int blankLinesVal = receiptSettings.blankLinesVal;
      InfoBox1Model infoBox1Model = receiptSettings.infoBox1Model;
      InfoBox2Model infoBox2Model = receiptSettings.infoBox2Model;

      PaymentMethodModel paymentMethodModel = receiptSettings.paymentMethod;
      OrderDetailsModel orderDetailsModel = receiptSettings.orderDetails;
      DirectionModel directionModel = receiptSettings.direction;
      ClientInfoModel clientInfoModel = receiptSettings.clientInfo;
      ItemsModel itemsModel = receiptSettings.items;
      ContactDetailsModel contactDetailsModel = receiptSettings.contactDetails;
      ClientConfirmationModel clientConfirmationModel =  receiptSettings.clientConfirmation;

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
   try{
    filePath=  await  dynClientPdfGenerate(order, previewOrdersVal, previewTimesVal, previewPaymentsVal, blankLinesVal, infoBox1Model, infoBox2Model, paymentMethodModel, orderDetailsModel, directionModel, clientInfoModel, itemsModel, contactDetailsModel, clientConfirmationModel, timeTitleSize, clientCommentSize, isPaidTitleSize, orderOnlineTitleSize, premiseTypeVal, otherPremise, premiseTypeFinalVal, finalCompList);
    StackTrace? stack;
     // bugsnag.notify("client Path in fun is $filePath", stack);
   }catch(e,stack){
       // bugsnag.notify("client error is $e", stack);
   }
  }else if(receiptType=="Kitchen Receipt"){
  KitchenReceiptSettings? receiptSettings;
     try {
      receiptSettings=KitchenReceiptSettings.fromJson(receiptData);
      }catch(e){
       debugPrint("error in receiptSettings is $e");
       if(mounted){
           UtilityClass.dismissLoading(context);
       }
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


//// wifi printing

static Future<img.Image?> convertPdfToImage(String filePath) async {
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
  // page.i(); // Don’t forget this

  return decodedImage;
}

static Future<void> printImage(Uint8List imageBytes, String printerIp,OrderModel autoOrderData,String printerLogId) async {
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
   }else {
    debugPrint('Print failed: $result');
  }
}

 Future<bool> printReceiptWifi(String printerIp,String filePath ,String printerLogId,bool isDialog,OrderModel autoOrderData,String port) async {
   print("autoPrintClient in printReceiptWifi Acceptance time is  ${autoOrderData.orderData.acceptedAt}");
 bool success=false;
 final pdfImage = await convertPdfToImage(filePath);
 if (pdfImage != null) {
  final imageBytes = img.encodePng(pdfImage);
  
  ////
  if(port=="9101"){
  try{
 success= await Provider.of<AppProvider>(context,listen: false).starPrintChannel(printerIp, filePath, userModel.authToken!, printerLogId, context, isDialog).then((onValue){
  //  Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "success",printerLogId);  
   StackTrace? stack;
  // bugsnag.notify("starPrintChannel vale in new tan is $onValue", stack);
    if(isDialog==true){
    Navigator.pop(context);
   }

   return onValue;
    //  if(onValue==false){       
    //     StackTrace? stack;
    //    // bugsnag.notify("autoPrint error in star", stack);
    //     debugPrint("error in star");
    //     // endDecision(autoOrderData); 
    //     return false;
    //   }else{
    //     setState(() {
    //     success=true;
    //     });
    //  }
  });

  }catch(e,stack){
    debugPrint("error in starPrintChannel in prep tab $e");
   // bugsnag.notify("error in starPrintChannel in in prep tab $e", stack);
  }

     StackTrace? stack;
    // bugsnag.notify("star success value is $success", stack);
 }else{
  try{
  await printImage(Uint8List.fromList(imageBytes), printerIp,autoOrderData,printerLogId).then((onValue){
   Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "success",printerLogId);  
   
  if(isDialog==true){
    Navigator.pop(context);
   }
   setState(() {
   success=true;
   });
  });
  }catch(e,stack){
    debugPrint("error in printImage [new] in prep tab $e");
   // bugsnag.notify("error in printImage [new] in prep tab $e", stack);
  }
  
     StackTrace? stack;
    // bugsnag.notify("epson success value is $success", stack);
 }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Printing in progress....."),duration: Duration(seconds: 5),));
 }else{
   MyMessage.showFailedMessage("Printing failed ", context);
   Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "failed",printerLogId);
}
 return success;
}

  void getData() {
    SharedPreferenceManager.getInstance().getUserData().then((value) {
      userModel = value;
       });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, isChild) {

      if(provider.newProgress){
        return  PopScope(
          onPopInvoked: (didPop){
            autoPrintFailed=false;
          },
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
                SizedBox(height: 6),
                Text("Please wait!\nWe are checking new orders", textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      }

      return provider.newOrdersList.isNotEmpty?
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: provider.newOrdersList.length,
        itemBuilder: (context, index) {
          final order = provider.newOrdersList[index];
          int minutes=int.parse(order.orderCompletionTime!);
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
                          const SizedBox(width: 12),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order #${order.orderData.orderId}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                              Text("\$ ${double.parse(order.orderData.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                                  Text("Order #${order.orderData.orderId}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: AppAssets.dimen_16), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                                  Text("\$ ${double.parse(order.orderData.total.toString()).toStringAsFixed(2)}", style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 11, color: AppAssets.redColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                                          child: Align(alignment: Alignment.centerLeft, child: Text(item.itemName, style: TextStyle(fontFamily: AppAssets.nunitoRegular, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(child: Align(alignment: Alignment.center, child: Text(item.qty, style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,))),
                                        const SizedBox(width: 10),
                                        Expanded(child: Align(alignment: Alignment.center, child: Text("\$ ${ formatToTwoDecimals(item.price.total)}", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis,))),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                 if(AppProvider.autoAcceptStatus==true){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Orders will be Auto-accepted !")));
                                }else{
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
                                          _amountController.text = formatToTwoDecimals(order.orderData.total);
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
                                                 if(order.orderData.orderId==AppProvider.latestNewOrderNo){
                                                   AppProvider.ringBell=false;
                                                  }
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
                                                provider.cancelOrder(userModel.authToken!, order.orderData.orderUuid, _amountController.text, _reasonController.text, "canceled", "new").then((status) {
                                                  if(mounted){
                                                  UtilityClass.dismissLoading(context);
                                                  }
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
                             
                                }
                              
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
                                if(AppProvider.autoAcceptStatus==true){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Orders will be Auto-accepted !")));
                                }else{
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
                                                  if(minutes > 5){
                                                    setState(() {
                                                      minutes = minutes - 5;
                                                      // minutess=minutes;
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
                                                  // if(minutes >= 5){
                                                    setState(() {
                                                      minutes = minutes + 5;
                                                      // minutess=minutes;

                                                    });
                                                  // }
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
                                              order.orderData.acceptedAt= AppProvider.getCurrentTime().toString();
                                              order.orderData.deliveryTime=getTimeString(minutes);
                                              autoPrintFailed=false;
                                                if(order.orderData.orderId==AppProvider.latestNewOrderNo){
                                                   AppProvider.ringBell=false;
                                                  }
                                              Future.delayed(Duration(seconds: 1),(){
                                                autoPrint(order,minutes);
                                              });

                                              //  autoPrint(order);
                                              // UtilityClass.showLoadingDialog(context);
                                              // provider.acceptOrder(userModel.authToken!, order.orderData.orderUuid, order.orderData.deliveryDate, getTimeString(minutes)).then((status) {
                                              //   // UtilityClass.dismissLoading(context);
                                              //   if(status.isSuccess){
                                              //     Navigator.of(context).pop();
                                              //     UtilityClass.showSuccessDialog(context, "Order Status", status.message);
                                              //     setState(() {
                                              //       minutes  = 0;
                                              //       });
                                              //     }else{
                                              //     Navigator.of(context).pop();
                                              //     UtilityClass.showFailedDialog(context, "Failed", status.message);
                                              //   }
                                              // });
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
                           
                               }
                               
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
                  if(index == (provider.newOrdersList.length-1))
                  SizedBox(height: 50,)
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
    final int minute = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}';
  }
}
