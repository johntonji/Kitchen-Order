import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

// import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart' as img;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:order_receiving/models/notif_model.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/providers/riverpod_provider.dart';
import 'package:order_receiving/ui/all_notif.dart';
import 'package:order_receiving/ui/fisrt_bottom_tab.dart';
import 'package:order_receiving/ui/new_tab.dart';
import 'package:order_receiving/ui/preparing_tab.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_client.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_kitchen.dart';
import 'package:order_receiving/ui/ready_tab.dart';
import 'package:order_receiving/ui/settings.dart';
import 'package:order_receiving/utilities/base/my_message.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:order_receiving/utilities/utility_class.dart';
import 'package:pdf_render/pdf_render.dart' as render;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../assets/app_assets.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';
import 'all_orders.dart';

class Dashboard extends rv.ConsumerStatefulWidget {
 const Dashboard({super.key});

  @override
  rv.ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends rv.ConsumerState<Dashboard> with WidgetsBindingObserver{

  Timer? timer;
  Timer? timer2;
 int selectedBottom = 1; // made static
  UserModel userModel = UserModel.getInstance();


  Timer? orderingTimer;
Timer? pauseTimer;
Timer? notificationTimer;
Timer? autoOrdersTimer;
Timer? autoProcessingTimer;
Timer? autoReadyTimer;

 int delayTime=0;
  bool _availableCheck = true;
  bool _unavailableCheck = false;
  bool _customCheck = false;

  String pauseDate = "";
  
  List<Widget> tabs = [
    const NewTab(),
    const PreparingTab(),
    const ReadyTab()
  ];
 int minutes = 80;  // pause time
 int selectedTime=0;
 final TextEditingController _reasonController = TextEditingController();
 bool orderPrinted=true;

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addObserver(this);
    getData();
    Future.microtask(() async{
      ref.read(scanPrintersNotifierProvider.notifier).initilaizee();
       ref.read(scanPrintersNotifierProvider.notifier).scanForPrinters(context);
     });


   }
  
 int convMin=0;
 int convhrs=0;

  ///minutes into hrs and minutes
 String convertMinutesToHours(int totalMinutes) {
     convhrs = totalMinutes ~/ 60;
     convMin = totalMinutes % 60;
  if(convhrs==0){
  return '$convMin minutes';
  }
  else{
  return '$convhrs: $convMin hours';
  }
}

void startTimers(String token, String merchantId) {

  orderingTimer?.cancel();
  pauseTimer?.cancel();
  notificationTimer?.cancel();
  autoOrdersTimer?.cancel();
  autoProcessingTimer?.cancel();
  autoReadyTimer?.cancel();

  orderingTimer = Timer.periodic(
    const Duration(seconds: 15),
    (_) => Provider.of<AppProvider>(context, listen: false)
        .getOrderingStatus(token, merchantId, context),
  );

  pauseTimer = Timer.periodic(
    const Duration(seconds: 3),
    (_) => Provider.of<AppProvider>(context, listen: false)
        .getPauseStatusData(token, merchantId),
  );

  notificationTimer = Timer.periodic(
    const Duration(seconds: 10),
    (_) => Provider.of<AppProvider>(context, listen: false)
        .getNotifications(token),
  );
  autoOrdersTimer = Timer.periodic(
    const Duration(seconds: 6),
    (_) => Provider.of<AppProvider>(context, listen: false)
        .autoNewOrders(token,context)
  );
  autoProcessingTimer = Timer.periodic(
    const Duration(seconds: 8),
    (_) => Provider.of<AppProvider>(context, listen: false)
        .autoProcessingOrders(token),
  );

  autoReadyTimer = Timer.periodic(
    const Duration(seconds: 8),
    (_) => Provider.of<AppProvider>(context, listen: false)
        .autoReadyOrders(token),
  );
}



  // getData2() async{
  //    SharedPreferenceManager.getInstance().getUserData().then((data) {
  //     userModel = data;
  //     debugPrint("merchant address is ${data.address} and id is ${data.merchantId} and logo is ${data.logo}");
  //     Provider.of<AppProvider>(context, listen: false).newOrders(data.authToken!).then((value) {
  //       Provider.of<AppProvider>(context, listen: false).processingOrders(data.authToken!).then((value) {
  //         Provider.of<AppProvider>(context, listen: false).readyOrders(data.authToken!).then((value) {
  //           // timer = Timer.periodic(const Duration(seconds: 9), (Timer t) => Provider.of<AppProvider>(context, listen: false).autoNewOrders(data.authToken!,context));
  //           timer = Timer.periodic(const Duration(seconds: 8), (Timer t) => Provider.of<AppProvider>(context, listen: false).autoProcessingOrders(data.authToken!));
  //           timer = Timer.periodic(const Duration(seconds: 8), (Timer t) => Provider.of<AppProvider>(context, listen: false).autoReadyOrders(data.authToken!));
  //         });
  //       });
  //     });
  //         Provider.of<AppProvider>(context, listen: false).getNotifications(data.authToken!);
  //         Provider.of<AppProvider>(context, listen: false).getPrinters(data.authToken!,data.merchantId!);
  //         Provider.of<AppProvider>(context,listen: false).getdefaultPrinter(data.authToken!,data.merchantId!,"kitchen");
  //         Provider.of<AppProvider>(context,listen: false).getdefaultPrinter(data.authToken!,data.merchantId!,"client");
  //         Provider.of<AppProvider>(context,listen: false).menu(data.authToken!);
  //         Provider.of<AppProvider>(context,listen: false).connectedProviders(data.authToken!);
  //         Provider.of<AppProvider>(context, listen: false).termsAndConditions(data.authToken!);
  //         Provider.of<AppProvider>(context, listen: false).getPauseStatusData(data.authToken!,data.merchantId!);  ///////// getstatus
  //         Provider.of<AppProvider>(context, listen: false).getTimezone(data.authToken!,data.merchantId!);   // timezone
  //         Provider.of<AppProvider>(context, listen: false).getOrderingStatus(data.authToken!,data.merchantId!,context)
  //         .then((onValue)
  //         {
  //           if(mounted){
  //          setState(() {
  //             AppProvider.availabilityStatus=onValue;
  //           });
  //           }        
  //         debugPrint("ordering status is ${AppProvider.availabilityStatus}");
  //         if(AppProvider.availabilityStatus==false){
  //         debugPrint("inside get ordering status 0");
  //           if(mounted){
  //           setState(() {
  //           _availableCheck=true;
  //           _unavailableCheck=false;
  //           _customCheck=false;
  //           });
  //           }
  //          }
  //         else if(AppProvider.availabilityStatus==true) {
  //         debugPrint("inside get ordering status 1");
  //           if(mounted){
  //         setState(() {
  //           _unavailableCheck=true;
  //           _availableCheck=false;
  //           _customCheck=false;
  //            });
  //           }
  //           }
  //          });     
  //          //status metadata
  //       Provider.of<AppProvider>(context, listen: false).getPauseStatusData(data.authToken!,data.merchantId!)
  //       .then((val)
  //        {
  //         if(AppProvider.availabilityStatus==true){
  //           if(AppProvider.pauseTime!=AppProvider.modifiedAtTime && AppProvider.pauseTime.isNotEmpty){
  //             debugPrint(" IF AppProvider.pauseTime is ${AppProvider.pauseTime}  and AppProvider.modifiedAtTime is ${AppProvider.modifiedAtTime}");
  //           if(mounted){         
  //            setState(() {
  //           _unavailableCheck=false;
  //           _availableCheck=false;
  //           _customCheck=true;
  //            });
  //           }
  //            }else{
  //             debugPrint(" ELSE AppProvider.pauseTime is ${AppProvider.pauseTime}  and AppProvider.modifiedAtTime is ${AppProvider.modifiedAtTime}");
  //           if(mounted){
  //           setState(() {
  //           _unavailableCheck=true;
  //           _availableCheck=false;
  //           _customCheck=false;
  //            });
  //           }
  //            }
  //          debugPrint("inside get ordering status 1");
  //           }
  //         });
  //       // //// timers
  //        timer = Timer.periodic(const Duration(seconds: 15), (Timer t) =>Provider.of<AppProvider>(context, listen: false).getOrderingStatus(data.authToken!,data.merchantId!,context).then((onValue){
  //           if(mounted){
  //        setState(() {
  //             AppProvider.availabilityStatus=onValue;
  //           });
  //           }
  //         debugPrint(" ordering status $onValue");
  //         if(AppProvider.availabilityStatus==false){
  //         debugPrint("inside get ordering status 0");
  //           if(mounted){
  //           setState(() {
  //           _availableCheck=true;
  //           _unavailableCheck=false;
  //           _customCheck=false;
  //           });
  //           }
  //          }
  //         else
  //          if(AppProvider.availabilityStatus==true)
  //          {
  //           if(mounted){
  //         setState(() {
  //           _unavailableCheck=true;
  //           _availableCheck=false;
  //           _customCheck=false;
  //            });
  //           }
  //           }
  //          }));
  //          timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => Provider.of<AppProvider>(context, listen: false).getPauseStatusData(data.authToken!,data.merchantId!).then((val){
  //         if(AppProvider.availabilityStatus==true){
  //           if(AppProvider.pauseTime!=AppProvider.modifiedAtTime  && AppProvider.pauseTime.isNotEmpty){
  //             // debugPrint(" IF AppProvider.pauseTime is ${AppProvider.pauseTime}  and AppProvider.modifiedAtTime is ${AppProvider.modifiedAtTime}");
  //           if(mounted){
  //            setState(() {
  //           _unavailableCheck=false;
  //           _availableCheck=false;
  //           _customCheck=true;
  //            });
  //           }
  //            }else{
  //             // debugPrint(" ELSE AppProvider.pauseTime is ${AppProvider.pauseTime}  and AppProvider.modifiedAtTime is ${AppProvider.modifiedAtTime}");
  //           if(mounted){
  //         setState(() {
  //           _unavailableCheck=true;
  //           _availableCheck=false;
  //           _customCheck=false;
  //            });
  //           }
  //           }
  //         // debugPrint("inside get ordering status 1");
  //         }
  //       }) 
  //       );
  //        timer2= Timer.periodic(const Duration(seconds: 10), (Timer t) =>Provider.of<AppProvider>(context, listen: false).getNotifications(data.authToken!));
  //      });
  
     
  //     }

Future<void> getData() async {
  final data = await SharedPreferenceManager.getInstance().getUserData();
    AppProvider.ordercancelletionTimer= data.merchantOrderRejectMins ?? 0;
  if (!mounted) return;

      userModel = data;

  final provider = Provider.of<AppProvider>(context, listen: false);

  await provider.newOrders(data.authToken!);
  await provider.processingOrders(data.authToken!);
  await provider.readyOrders(data.authToken!);

  provider.getNotifications(data.authToken!);
  provider.getPrinters(data.authToken!, data.merchantId!);
  provider.menu(data.authToken!);
  provider.connectedProviders(data.authToken!);
  provider.termsAndConditions(data.authToken!);
  provider.getTimezone(data.authToken!, data.merchantId!);

  startTimers(data.authToken!, data.merchantId!);

  /////
          Provider.of<AppProvider>(context, listen: false).getOrderingStatus(data.authToken!,data.merchantId!,context)
          .then((onValue)
          {
            if(mounted){
            setState(() {
              AppProvider.availabilityStatus=onValue;
            });
            }
          debugPrint(" ordering status is ${AppProvider.availabilityStatus}");
          if(AppProvider.availabilityStatus==false){
          debugPrint("inside get ordering status 0");
            if(mounted){
            setState(() {
            _availableCheck=true;
            _unavailableCheck=false;
            _customCheck=false;
            });
            }
           }
          else if(AppProvider.availabilityStatus==true) {
          debugPrint("inside get ordering status 1");
            if(mounted){
          setState(() {
            _unavailableCheck=true;
            _availableCheck=false;
            _customCheck=false;
             });
            }
            }
           });
      
           //status metadata
        Provider.of<AppProvider>(context, listen: false).getPauseStatusData(data.authToken!,data.merchantId!)
        // .asStream().listen((val)  
        .then((val)
         {
          if(AppProvider.availabilityStatus==true){
            if(AppProvider.pauseTime!=AppProvider.modifiedAtTime && AppProvider.pauseTime.isNotEmpty){
              debugPrint(" IF AppProvider.pauseTime is ${AppProvider.pauseTime}  and AppProvider.modifiedAtTime is ${AppProvider.modifiedAtTime}");
            if(mounted){
             setState(() {
            _unavailableCheck=false;
            _availableCheck=false;
            _customCheck=true;
             });
            }
             }else{
              debugPrint(" ELSE AppProvider.pauseTime is ${AppProvider.pauseTime}  and AppProvider.modifiedAtTime is ${AppProvider.modifiedAtTime}");
            if(mounted){
            setState(() {
            _unavailableCheck=true;
            _availableCheck=false;
            _customCheck=false;
             });
            }
             }
           debugPrint("inside get ordering status 1");
            }
          });
        // //// timers
         timer = Timer.periodic(const Duration(seconds: 6), (Timer t) =>Provider.of<AppProvider>(context, listen: false).getOrderingStatus(data.authToken!,data.merchantId!,context).then((onValue) async{
        //  setState(() {   ///TODO :new
              AppProvider.availabilityStatus=onValue;
            // });
          debugPrint(" ordering status $onValue");
          if(AppProvider.availabilityStatus==false){
          debugPrint("inside get ordering status 0");
            if(mounted){
            setState(() {
            _availableCheck=true;
            _unavailableCheck=false;
            _customCheck=false;
            });
            }
           }
          else
           if(AppProvider.availabilityStatus==true)
           {
            if(mounted){
          setState(() {
            _unavailableCheck=true;
            _availableCheck=false;
            _customCheck=false;
             });
            }
            }

            if(AppProvider.autoAcceptStatus==true){
            List<OrderModel> orderList= await SharedPreferenceManager.getInstance().getNewOrderList();
            print("orderList for autoPrint is $orderList autoPrinted value is $orderPrinted");
            if(orderList.isNotEmpty){
            for(OrderModel order in orderList){
                print("orderList order  is ${order.orderData.orderId} and its isPrinted is ${order.orderData.isPrinted}");
                if(order.orderData.isPrinted=="0"){
                  if(orderPrinted==true){  
                    // setState(() {
                     orderPrinted=false;
                    // });
                   order.orderData.acceptedAt=AppProvider.getCurrentTime().toString();
                   autoPrint(order);
                  // });
                  SharedPreferenceManager.getInstance().removeFromNewOrderList(order.orderData.orderUuid).then((onValue){
                  print("removed #${order.orderData.orderId}");
                }); 
               }
              }else if(order.orderData.isPrinted=="1"){
                  SharedPreferenceManager.getInstance().removeFromNewOrderList(order.orderData.orderUuid);

              }
            }
            } 
           }
           }));
           timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => Provider.of<AppProvider>(context, listen: false).getPauseStatusData(data.authToken!,data.merchantId!).then((val){
          if(AppProvider.availabilityStatus==true){
            if(AppProvider.pauseTime!=AppProvider.modifiedAtTime  && AppProvider.pauseTime.isNotEmpty){
              // debugPrint(" IF AppProvider.pauseTime is ${AppProvider.pauseTime}  and AppProvider.modifiedAtTime is ${AppProvider.modifiedAtTime}");
            if(mounted){
             setState(() {
            _unavailableCheck=false;
            _availableCheck=false;
            _customCheck=true;
             });
            }
             }else{
              // debugPrint(" ELSE AppProvider.pauseTime is ${AppProvider.pauseTime}  and AppProvider.modifiedAtTime is ${AppProvider.modifiedAtTime}");
            if(mounted){
          setState(() {
            _unavailableCheck=true;
            _availableCheck=false;
            _customCheck=false;
             });
            }
            }
          // debugPrint("inside get ordering status 1");
          }
        }) 
        );
         timer2= Timer.periodic(const Duration(seconds: 10), (Timer t) =>Provider.of<AppProvider>(context, listen: false).getNotifications(data.authToken!));
       
  
}

@override
void dispose() {
  orderingTimer?.cancel();
  pauseTimer?.cancel();
  notificationTimer?.cancel();
  autoOrdersTimer?.cancel();
  autoProcessingTimer?.cancel();
  autoReadyTimer?.cancel();
  timer?.cancel();
  timer2?.cancel();
  WidgetsBinding.instance.removeObserver(this);
  super.dispose();
}

  

/////// autoPrint
 Map<String,dynamic> kitchenData={};
 String kitchenReceiptPath = "";
 bool kitchenPrinted=false;
 String receiptType="Client Receipt";
 bool autoPrintFailed=false;
 bool clientPrinted=false;

void autoPrint(OrderModel autoOrderData) async{
   print("Acceptance time is autoaccept ${autoOrderData.orderData.acceptedAt}");
//  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Accpted at time is ${autoOrderData.orderData.acceptedAt}")));
  
Future.delayed(Duration(seconds: 10),(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Printing receipts for #${autoOrderData.orderData.orderId}")));
     debugPrint("inside autoPrint function for #${autoOrderData.orderData.orderId}");
    Future.delayed(Duration(seconds: 5),()async{
      await autoPrintClient(autoOrderData);  
    });
  });
 }

Future<void> autoPrintClient(OrderModel autoOrderData)async{
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
        debugPrint("error 3");
        autoPrintFailed=true;
        orderPrinted=true;
        return;
      }
    }
      if(scanPrinterNotif['selectedClientWifiPrinterIp']['ip']=="" && scanPrinterNotif['bluetoothClientPrinterConnected']==null){
           MyMessage.showFailedMessage("No Client Printer Connected ", context);
              if(autoPrintFailed==false){
                StackTrace? stack;
                 // bugsnag.notify("autoPrint error 4", stack);
                   debugPrint("error 4 for #${autoOrderData.orderData.orderId}");
                    autoPrintFailed=true;
                     orderPrinted=true;
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
        orderPrinted=true;

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
        orderPrinted=true;
        
        return false;
       }else{
        return true;
       }
      });
     if(autoPrintFailed==true){
      return;
     }

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
         orderPrinted=true;
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
        orderPrinted=true;

       return;
      }
    }}
    if(autoPrintFailed==false){
     await autoPrintKitchen(autoOrderData);  
    }
   }  
    Future.delayed(Duration(seconds: 4),()async{
        AppProvider.autoPrinting=false; 
       debugPrint("autoPrinting value after printing ${AppProvider.autoPrinting}");
    });
   }
  });
    });

   }
   /// debugPrint fri cleint end

  });


 }


Future<void> autoPrintKitchen(OrderModel autoOrderData) async {
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
        orderPrinted=true;

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

      bool   kitchenPrintedLocal=  await printReceiptWifi(scanPrinterNotif['selectedKitchenWifiPrinterIp']["ip"]!, kitchenReceiptPath, printerKitchenLogId,false,autoOrderData,AppProvider.portDefaultKitchenPrinter);
        kitchenPrinted=kitchenPrintedLocal;
        if(kitchenPrintedLocal==false){
          MyMessage.showFailedMessage("Printer Disconnected", context);
            if(autoPrintFailed==false){
        StackTrace? stack;
       // bugsnag.notify("autoPrint error 9", stack);

         debugPrint("error 9");
          autoPrintFailed=true;
          orderPrinted=true;
          
           Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "failed",printerKitchenLogId);

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
        orderPrinted=true;

        return false;
       }else{
        return true;
       }
     });
    }
   });
    debugPrint("Kitchen receipt completed printing $kitchenPrinted");
        if(clientPrinted == true && kitchenPrinted == true && autoPrintFailed==false) {
      Provider.of<AppProvider>(context, listen: false)
      .printStatusUpdate(userModel.authToken!, autoOrderData.orderData.orderUuid, "1")
          .then((status) {
        if (status.isSuccess) {
          UtilityClass.showSuccessDialog(
              context, "Order #${autoOrderData.orderData.orderId}", status.message);
        } else {
          UtilityClass.showFailedDialog(context, "Failed", status.message);
        }
        orderPrinted=true;
        receiptType="Client Receipt";
      });
        
    }
}

///
  updateState() {
    Navigator.of(context).pop();
            if(mounted){
    setState(() {});
            }
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

                        UtilityClass.showLoadingDialog(context); 
                        Provider.of<AppProvider>(context, listen: false).updateOrderingStatus(userModel.authToken!,userModel.merchantId!, true).then((val){
                        UtilityClass.dismissLoading(context);
                        if(val.isSuccess){
                          UtilityClass.showSuccessDialog(context, "Status Updated", "");
                        _availableCheck = newValue;
                        _unavailableCheck = false;
                        _customCheck = false;
                          updateState();
                        }else{
                          UtilityClass.showFailedDialog(context, "Failed", val.message);
                        }
                      });
                    });
                  
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text("UNAVAILABLE", style: TextStyle(fontSize: 14,), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  value: _unavailableCheck,
                  activeColor: AppAssets.primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  onChanged: (newValue) {
                    setState(() {
                      if(!newValue!){
                        return;
                      }
                      delayTime=0;
                       Navigator.pop(context);
                      pauseReason(newValue,false);
                      ///updating status
                     
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: const Text("UNAVAILABLE TILL", style: TextStyle(fontSize: 14,), maxLines: 1, overflow: TextOverflow.ellipsis,),
                  value: _customCheck,
                  activeColor: AppAssets.primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  onChanged: (newValue) {
                    if(!newValue!){
                      return;
                    }
                    Navigator.pop(context);
                  selectFromTime(newValue);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 30),
                if(_customCheck==true &&AppProvider.pauseTime!="" && AppProvider.pauseTime!=null)
                Text("Next Available : ${formatDateTime(AppProvider.pauseTime)}",style: TextStyle(fontFamily: AppAssets.nunitoBold,color: AppAssets.greenColor),)
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("App resumed");
      ref.watch(scanPrintersNotifierProvider.notifier).initilaizee();
      ref.watch(scanPrintersNotifierProvider.notifier).scanForPrinters(context);
      
      if(AppProvider.latestNewOrderNo!=""){
        AppProvider.ringBell=false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, isChild) {
      return SafeArea(child: 
         Scaffold(
        body: RefreshIndicator(
          onRefresh: () {  
           return getData();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFFF5F5F5),
            child: Column(
              children: [
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
                                          _availableCheck ? "ACTIVE" : "UNAVAILABLE",
                                          style: TextStyle(fontSize:   12 , fontFamily: AppAssets.nunitoBold, color: _availableCheck ? AppAssets.successColor : AppAssets.pausedColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                        SizedBox(width: 20,),
                        IconButton(onPressed: (){
                          notiDialog();
                        }, icon: Stack(
                          clipBehavior: Clip.none,
                            children: [
                            
                               Image( 
                                image: AssetImage("assets/icons/bell.png"),
                                width: MediaQuery.sizeOf(context).width/9.8,
                                height: MediaQuery.sizeOf(context).width/9.8,
                                color:  AppAssets.primaryColor,),
                                  Positioned(
                                    top: -5,
                                    right: 0,
                                    child: Container(
                                     padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape:BoxShape.circle,
                                      color: Colors.green
                                    ),
                                    child: Center(
                                    child: Text(AppProvider.notifCount.toString(),style: TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.bold),),
                                    ), ),
                                  ),
                                ]
                               )),
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
                Visibility(
                  visible:  selectedBottom == 1,
                  // _availableCheck && selectedBottom == 1,
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
                               AppProvider.selectedTab = 0;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: AppProvider.selectedTab == 0 ? AppAssets.leftTabSelectedDecoration : AppAssets.leftTabUnSelectedDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("NEW", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: AppProvider.selectedTab == 0 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor),),
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
                                  SvgPicture.asset(AppAssets.bagIcon, colorFilter: ColorFilter.mode(AppProvider.selectedTab == 0 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor, BlendMode.srcIn), height: 17, width: 17,)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                AppProvider.selectedTab = 1;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: AppProvider.selectedTab == 1 ? AppAssets.centerTabSelectedDecoration : AppAssets.centerTabUnSelectedDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("PREPARING", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: AppProvider.selectedTab == 1 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor),),
                                  const SizedBox(width: 6,),
                                  SvgPicture.asset(AppAssets.preparingIcon, colorFilter: ColorFilter.mode(AppProvider.selectedTab == 1 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor, BlendMode.srcIn), height: 17, width: 17,)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                AppProvider.selectedTab = 2;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: AppProvider.selectedTab == 2 ? AppAssets.rightTabSelectedDecoration : AppAssets.rightTabUnSelectedDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("READY", style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 13, color: AppProvider.selectedTab == 2 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor),),
                                  const SizedBox(width: 6,),
                                  SvgPicture.asset(AppAssets.vanIcon, colorFilter: ColorFilter.mode(AppProvider.selectedTab == 2 ? AppAssets.tabBorderColor : AppAssets.textLightWhiteColor, BlendMode.srcIn), height: 17, width: 17,)
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
                  child:selectedBottom == 1 ?
                  //  _availableCheck && selectedBottom == 1 ?
                  tabs[AppProvider.selectedTab] :
                  selectedBottom == 2 ?
                  const Settings() :
                  // selectedBottom == 0 ?
                  // const AllOrders():
                  const FirstBottomTab() 
          
                ),
              ],
            ),
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
              // Expanded(
              //   child: GestureDetector(
              //     onTap: (){
              //       setState(() {
              //         selectedBottom = 0;
              //       });
              //     },
              //     child: Center(
              //       child: Stack(
              //         children: [
              //           selectedBottom  == 0 ? Container(
              //             width: 70,
              //             height: 70,
              //             decoration: BoxDecoration(
              //                 color: AppAssets.whiteColor,
              //                 borderRadius: BorderRadius.circular(40),
              //                 boxShadow: [
              //                   BoxShadow(color: AppAssets.widgetGrayColor.withOpacity(0.4), blurRadius: 10)
              //                 ]
              //             ),
              //             child: Center(child: Icon(MdiIcons.clockOutline, size: 36, color: AppAssets.primaryColor,)),
              //           ) : SizedBox(width: 70,
              //               height: 70, child: Center(child: Icon(MdiIcons.clockOutline, size: 36, color: AppAssets.textLightGrayColor,))),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

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
                        ) : SizedBox(width: 70,
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
                        ) : SizedBox(width: 70,
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
 void selectCustomTime(bool newValue){
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
                                          Text('Pause Time', style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 20, color: AppAssets.blackColor),),
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
                                                child: Text("${convertMinutesToHours(minutes)}.", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 16, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
                                              delayTime=minutes;
                                              Navigator.pop(context);
                                              pauseReason(newValue,true);
                                              },
                                            child: Container(
                                              height: 40,
                                              margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                                              padding: const EdgeInsets.only(left: 16, right: 16),
                                              decoration: BoxDecoration(
                                                color: AppAssets.greenColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(child: Text("PAUSE ORDERS", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                            ),
                                          ),
                                          const SizedBox(height: 80),
                                        ],
                                      );
                                    });
                                  },
                                );
  }

selectFromTime(bool newValue){
  List<int> row1=[10,20,30];
  List<int> row2=[40,50, 0];
   showModalBottomSheet<void>( context: context,
                                  backgroundColor: AppAssets.whiteColor,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder: (context, setState) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(height: 50),
                                          Text('Select Pause Time', style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 20, color: AppAssets.blackColor),),
                                          const SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: List.generate(row1.length, (index){
                                              return Expanded(
                                                child: GestureDetector(
                                                  onTap: (){
                                                    delayTime=row1[index];
                                                    Navigator.pop(context);
                                                    pauseReason(newValue,true);
                                                   },
                                                  child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xFFFFFFFF).withOpacity(0.0),
                                                      border: Border.all(color: AppAssets.widgetGrayColor, width: 1),
                                                      borderRadius: BorderRadius.circular(50)
                                                    ),
                                                  child: Text("${row1[index]}min", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 16, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                 ),
                                                ),
                                              );
                                            })
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children:List.generate(row2.length, (index){
                                            return (index==2)
                                            ? Expanded(
                                              child: GestureDetector(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  selectCustomTime(newValue);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xFFFFFFFF).withOpacity(0.0),
                                                      border: Border.all(color: AppAssets.widgetGrayColor, width: 1),
                                                      borderRadius: BorderRadius.circular(50)
                                                    ),
                                                  child: Text("Other", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 16, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                ),
                                              ),
                                            )
                                            : Expanded(
                                              child: GestureDetector(
                                                onTap: (){
                                                  delayTime=row2[index];
                                                Navigator.pop(context);
                                                  pauseReason(newValue, true);
                                                },
                                                child:  
                                                  Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xFFFFFFFF).withOpacity(0.0),
                                                      border: Border.all(color: AppAssets.widgetGrayColor, width: 1),
                                                      borderRadius: BorderRadius.circular(50)
                                                    ),
                                                  child: Text("${row2[index]}min", style: TextStyle(fontFamily: AppAssets.nunitoMedium, fontSize: 16, color: AppAssets.textNormalGrayColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                ),
                                              ),
                                            );
                                          })
                                          ),
                                          const SizedBox(height: 30),
                                    
                                          const SizedBox(height: 80),
                                        ],
                                      );
                                    });
                                  },
                                );
}

 void pauseReason(bool newValue,bool isCust){
      showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: AppAssets.whiteColor,
                                  builder: (BuildContext context) {
                                    return  Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child: StatefulBuilder(builder: (context, setState) {
                                          setState(() {
                                            _reasonController.text = "";
                                          });
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const SizedBox(height: 50),
                                              Text('REASON FOR PAUSING', style: TextStyle(fontFamily: AppAssets.nunitoBold, fontSize: 20, color: AppAssets.blackColor),),
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
                                                  
                                                  if(_reasonController.text.isEmpty){
                                                    UtilityClass.showFailedDialog(context, "Data Missing", "The Reason field is required");
                                                    return;
                                                  }
                                    
                                                  //unavailable
                                                  if(isCust!=true){
                                                   UtilityClass.showLoadingDialog(context); Provider.of<AppProvider>(context, listen: false).updateOrderingStatusUnAval(userModel.authToken!,userModel.merchantId!,_reasonController.text.trim()).then((status) {
                                                    UtilityClass.dismissLoading(context);
                                                    if(status.isSuccess){
                                                    
                                                     _customCheck = false;
                                                    _availableCheck = false;
                                                    _unavailableCheck = newValue;
                                                      
                                                    Provider.of<AppProvider>(context, listen: false).getPauseStatusData(userModel.authToken!,userModel.merchantId!);
                                                      Navigator.of(context).pop();
                                                      UtilityClass.showSuccessDialog(context, "Status Updated", "");
                                                      setState(() {
                                                        _reasonController.text = "";
                                                      });
                                                    }else{
                                                      Navigator.of(context).pop();
                                                      UtilityClass.showFailedDialog(context, "Failed", status.message);
                                                    }
                                                  });
                                                  ///unavailable till
                                                  }else
                                                   if(isCust==true){
                                                    UtilityClass.showLoadingDialog(context); Provider.of<AppProvider>(context, listen: false).pauseOrderingStatus(userModel.authToken!,userModel.merchantId!,convhrs,convMin,_reasonController.text.trim(),delayTime.toString()).then((status) {
                                                    UtilityClass.dismissLoading(context);
                                                    if(status.isSuccess){
                                                    _customCheck = newValue;
                                                    _availableCheck = false;
                                                    _unavailableCheck = false;
                                                   
                                                    Provider.of<AppProvider>(context, listen: false).getPauseStatusData(userModel.authToken!,userModel.merchantId!);
                                                      Navigator.of(context).pop();
                                                      UtilityClass.showSuccessDialog(context, "Status Updated", "");
                                                      setState(() {
                                                        _reasonController.text = "";
                                                      });
                                                    }else{
                                                      Navigator.of(context).pop();
                                                      UtilityClass.showFailedDialog(context, "Failed", status.message);
                                                    }
                                                   });
                                                  }
                                                },
                                                child: Container(
                                                  height: 40,
                                                  margin: const EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 50),
                                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                                  decoration: BoxDecoration(
                                                    color: AppAssets.greenColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                   ),
                                                  child: Center(child: Text("SUBMIT", style: TextStyle(fontSize: 12, fontFamily: AppAssets.nunitoBold, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      );
                                    
                                  },
                                );
                           
                           
                             }
void notiDialog(){
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
      return StatefulBuilder(
           builder: (context, setState) {
             return AlertDialog(
              actions: [
                      Provider.of<AppProvider>(context, listen: false).notiList.isNotEmpty 
                       ?  Center(
                          child: TextButton(
                               style: ButtonStyle(
                               foregroundColor: WidgetStatePropertyAll(Colors.black)),
                               onPressed: () async {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> AllNotif()));
                                },
                                child: Text("View All",style: TextStyle(fontFamily: AppAssets.nunitoRegular),)),
                        )
                        : SizedBox(),
              
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
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      child:  Column(
                      children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                              Positioned(
                                right: -8,
                                top: -5,
                                child: IconButton(
                                  onPressed: (){
                                                   Navigator.pop(context);
                                               }, icon: Icon(Icons.close ,color: Colors.grey,)
                                              ),
                              ),
                        Column(
                          children: [
                            SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Notification", style: TextStyle(fontSize: AppAssets.dimen_16, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textDarkGrayColor),),
                                    SizedBox(width: 10,),
                                     Container(
                                                     padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      shape:BoxShape.circle,
                                                      color: Colors.green
                                                    ),
                                                    child: Center(
                                                    child: Text(AppProvider.notifCount.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                    ), ),
                                  ],
                                ),
                                 Provider.of<AppProvider>(context, listen: false).notiList.isNotEmpty 
                                   ? TextButton(
                                     style: ButtonStyle(
                                     foregroundColor: WidgetStatePropertyAll(Colors.black)),
                                     onPressed: () async {
                                        SharedPreferenceManager.getInstance().getUserData().then((data) {
                                            Provider.of<AppProvider>(context, listen: false).deleteNotif(data.authToken!);
                                           });
                                         setState(() {
                                          AppProvider.notifCount=0;
                                          Provider.of<AppProvider>(context, listen: false).notiList.clear();
                                         });
                                      },
                                      child: Text("Clear All",style: TextStyle(fontFamily: AppAssets.nunitoRegular),))
                                   : SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                   Provider.of<AppProvider>(context, listen: false).notiList.isNotEmpty 
                   ? SizedBox(
                      height: MediaQuery.sizeOf(context).height/3,
                      child: ListView.builder(
                        itemCount: (Provider.of<AppProvider>(context, listen: false).notiList.length <= 5) 
                                   ? Provider.of<AppProvider>(context, listen: false).notiList.length
                                   : 5,
                        itemBuilder: (BuildContext context, int index) {  
                           NotifModel notif=Provider.of<AppProvider>(context, listen: false).notiList[index];
                         return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: NetworkImage(notif.image!),fit: BoxFit.fill)
                            ),
                          ),
                          title: Text(notif.message!,style: TextStyle(fontFamily: AppAssets.nunitoRegular ,fontSize: 14,),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          subtitle: Text(formatDateTime(notif.date!),style: TextStyle(fontFamily: AppAssets.nunitoRegular ,fontSize: 13,),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          );
                         
                      },),
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/no_noti.png",
                        width: MediaQuery.sizeOf(context).width/4.5,
                        height:  MediaQuery.sizeOf(context).width/4.5,
                        ),
                        SizedBox(height: 10,),
                        Text("No Notifications Yet",style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontSize: 15,fontWeight: FontWeight.bold),)
                      ],
                    )
                   ],
                 ),)
                  );
           }
         );
      },
    );
}

 
Future<String> getReceiptData(Map<String, dynamic> receiptData ,OrderModel order) async{
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


 Future<bool> printReceiptWifi(String printerIp,String filePath ,String printerLogId,bool isDialog,OrderModel autoOrderData,String port) async {
 bool success=false;
 final pdfImage = await convertPdfToImage(filePath);
 if (pdfImage != null) {
  final imageBytes = img.encodePng(pdfImage);
  
//TODO : add function for star here
if(port=="9101"){
  try{
  success = await Provider.of<AppProvider>(context,listen: false).starPrintChannel(printerIp, filePath, userModel.authToken!, printerLogId, context, isDialog).then((onValue){
  //  Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "success",printerLogId);  
  // success=true;
  if(isDialog==true){
    Navigator.pop(context);
   }
   return onValue;
  //   if(onValue== false){       
  //       StackTrace? stack;
  //      // bugsnag.notify("autoPrint error in star", stack);
  //       debugPrint("error in star");
  //       // endDecision(autoOrderData); 
  //       return false;
  // }else{
  //       success=true;
  //    }
  });

  }catch(e,stack){
    debugPrint("error in starPrintChannel in prep tab $e");
   // bugsnag.notify("error in starPrintChannel in in prep tab $e", stack);
    
  }
 }else{
   await printImage(Uint8List.fromList(imageBytes), printerIp,autoOrderData,printerLogId).then((onValue){
   Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "success",printerLogId);  
   
  if(isDialog==true){
    Navigator.pop(context);
   }
   success=true;
  });
 }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Printing in progress....."),duration: Duration(seconds: 5),));
 }else{
   MyMessage.showFailedMessage("Printing failed ", context);
   Provider.of<AppProvider>(context,listen: false).updatePrinterLogs(userModel.authToken!, "failed",printerLogId);
}
 return success;
}
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
  PosPrintResult result ;
  try{
   result = await printer.connect(printerIp, port: 9100);
  }catch (e) {
    try{
      result = await printer.connect(printerIp, port: 9101);
    }catch(ee){
      debugPrint("Error connecting to printer: $ee");
      return;
    }
  }

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
}
