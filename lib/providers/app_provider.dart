import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/main.dart';
import 'package:order_receiving/models/app_versions_model.dart';
import 'package:order_receiving/models/menu_model2.dart';
import 'package:order_receiving/models/notif_model.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/printer_modal.dart';
import 'package:order_receiving/models/provider_model.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/utilities/base/my_message.dart';

import 'package:order_receiving/utilities/shares_pref_manager.dart';
import '../repositories/app_repo.dart';
import '../utilities/base/api_response.dart';
import '../utilities/base/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

class AppProvider with ChangeNotifier{
  // static AppVersion latestAppVersion = AppVersion(
  //   id: "",
  //   installedCount: 0,
  //   approvalStatus: "",
  //   appFile: "",
  //   appIcon: "",
  //   versionCode: "",
  //   buildNumber: "",
  //   sizeInMb: 0,
  //   hashString: "",
  //   releaseName: "",
  //   releaseComments: "",
  //   releaseTrack: "",
  //   createdOn: DateTime.now(),
  //   updatedOn: DateTime.now(),
  //   minSdkVersion: "",
  //   targetSdkVersion: "",
  //   isDefault: false,
  //   isEnabled: false,
  //   application: ""
  // );
  
  static String currentAppVersion="";
  static int versionUpdateFlag=0;
  String localdeviceId="";

  AppRepo appRepo;
  AppProvider({required this.appRepo});
  bool progress = false;
  bool newProgress = false;
  bool processingProgress = false;
  bool printerProgress=false;
  bool readyProgress = false;
  bool allProgress = false;
  late int? time1;
  
  String printerUuid ="00001101-0000-1000-8000-00805F9B34FB";
 List<PrinterModal> addedPrinterList=[];
  List<OrderModel> newOrdersList = [];
  List<OrderModel> processingOrdersList = [];
  List<OrderModel> readyOrdersList = [];
  List<OrderModel> allOrdersList = [];
  List<MenuModel2>  restrauntMenu=[];
  List<NotifModel>  notiList=[];
  List<ProviderModel> connectedProvidersList=[];
  static String termsCondition="";
  static String pivacyPolicy="";
  static bool availabilityStatus=false;

  static bool faSetup=false;
  static bool faEnabled=false;
  static var uuid;
  static bool ringBell=true;
  static String latestNewOrderNo="";
//default 
  static String defaultClientPrinterIp="";
  static String defaultKitchenPrinterIp="";
  static String portDefaultClientPrinter="";  //NEW
  
 static String defaultClientPrinterID="";
 static String defaultKitchenPrinterID="";
 static String portDefaultKitchenPrinter="";  //NEW
 static int ordercancelletionTimer=0;
 static int notifCount=0;

  static bool autoAcceptStatus=false;
  static int alertDuration=20;
  bool newLogin=false;

  static int selectedTab = 0;
  static bool autoPrinting=false;
  static String autoOrderUuis="";
  
  static String pauseTime="";
  static String modifiedAtTime="";

  static String timezone="";
  static String restaurantName="";

// remove port from ip
static String removePort(String ipWithPort) {
  return ipWithPort.replaceAll(RegExp(r':\d+$'), '');
 }

static String? getPort(String ipWithPort) {
  var parts = ipWithPort.split(':');
  return parts.length > 1 ? parts[1] : null;
 }


  final MethodChannel _channel = const MethodChannel('com.vk.bluetoothprinter');  ////
 
 Future<bool> bluetoothPrintChannel(String printerAddr,String filePath ,String userToken,String printerLogId,BuildContext context,bool isDialog) async{
  String printReceipt="";
  bool a=true;
    try{
     printReceipt= await _channel.invokeMethod("printPdf",{"mac": printerAddr,"path":filePath,"UUID_SPP":printerUuid}).then((onValue){
      debugPrint("bluetoothPrintChannel valuee is $onValue");
      return onValue;
    });
     debugPrint("printReceipt is is $printReceipt");
     if(printReceipt!= "Printed successfully"){
      try{
        if (context.mounted && isDialog) {
        MyMessage.showSuccessMessage("Printing successful", context);
        }
       }catch(e){
        debugPrint("error in showing success dialog : $e");
      }
       await updatePrinterLogs(userToken, "failed", printerLogId);
      return false;
     }
    }catch(e){
      try{
        if (context.mounted) {
        MyMessage.showFailedMessage("Printing Failed", context);
        }
      }catch(e){
        debugPrint("error in showing failed dialog : $e");
      }
     await updatePrinterLogs(userToken, "failed", printerLogId);
     debugPrint("exception in method channel $e");
     return false;
    }
   
   String status="";
   Future.delayed(Duration(seconds: 4),()async{
    debugPrint("printReceipt value is $printReceipt");
    if (printReceipt=="Printed successfully"){
      try{
        if (context.mounted && isDialog) {
        MyMessage.showSuccessMessage("Printing successful", context);
        }
       }catch(e){
        debugPrint("error in showing success dialog : $e");
      }
      status="success";
      a=true;
    }
    else{
      if (context.mounted) {
       MyMessage.showFailedMessage("Printing Failed", context);
      }
      status="failed";
      a=false;
    }
   await updatePrinterLogs(userToken, status, printerLogId);
  });
  if(isDialog==true){
   return false;
  }else{
    return a;
  }
 }

 ///// print for star printer
  Future<bool> starPrintChannel(String printerAddrs,String filePath ,String userToken,String printerLogId,BuildContext context,bool isDialog) async{
  bool printReceipt=false;
  bool boolValue=true;
    try{
      try{
     printReceipt= await _channel.invokeMethod("printPdfWithStar",{
      // "context": context,
      "identifier":printerAddrs,"pdfPath":filePath}).then((onValue){
      debugPrint("starPrintChannel valuee is $onValue");
         StackTrace? stack;
       // bugsnag.notify("star return is $onValue", stack);
      return onValue;
     });
      }catch(e,stack){
       // bugsnag.notify("error in starPrintChannel method channel $e", stack);
      }
     debugPrint("printReceipt is is $printReceipt");
     if(printReceipt!= true){
      try{
        if (context.mounted && isDialog) {
        MyMessage.showFailedMessage("Printing Failed !", context);
        }
       }catch(e,stack){
        // bugsnag.notify("{starPrintChannel} error in showing success dialog $e", stack);
        debugPrint("error in showing success dialog : $e");
      }
       await updatePrinterLogs(userToken, "failed", printerLogId);
       return false;
     }
    }catch(e,stack){
        // bugsnag.notify("{starPrintChannel} error in showing success dialog $e", stack);
      try{
        if (context.mounted) {
        MyMessage.showFailedMessage("Printing Failed", context);
        }
      }catch(e){
        debugPrint("error in showing failed dialog : $e");
      }
     await updatePrinterLogs(userToken, "failed", printerLogId);
      debugPrint("exception in method channel $e");
      return false;
    }
   
   String status="";
   Future.delayed(Duration(seconds: 4),()async{
    debugPrint("printReceipt value is $printReceipt");
    if (printReceipt==true){
      try{
        if (context.mounted && isDialog) {
        MyMessage.showSuccessMessage("Printing successful", context);
        }
       }catch(e){
        debugPrint("error in showing success dialog : $e");
      }
      status="success";
      boolValue=true;
    }
    else{
      if (context.mounted) {
       MyMessage.showFailedMessage("Printing Failed", context);
      }
      status="failed";
      boolValue=false;
    }
   await updatePrinterLogs(userToken, status, printerLogId);
  });
  if(isDialog==true){
   return false;
  }else{
    StackTrace? stack;
   // bugsnag.notify("boolvalue return is $boolValue", stack);
    return boolValue;
  }
 }
 

 Future<List<dynamic>>  getWifiPrintersWithName() async{
    List<dynamic> wifiPrinterList=[];
  try{
     wifiPrinterList= await _channel.invokeMethod("discoverPrinters");
     debugPrint("[getWifiPrintersWithName] list of wifi prinetrs is $wifiPrinterList");
   }catch(e){
    debugPrint("[getWifiPrintersWithName] exception in discoverPrinters method channel $e");
   }
  return wifiPrinterList;
 }

  Future<ResponseModel> userLogin(String username, String password)async{
    progressStart();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.userLogin(username, password);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        debugPrint("[userLogin] parsedResponse outside is $parsedResponse");
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
        debugPrint("[userLogin] parsedResponse inside is $parsedResponse");
          faEnabled= parsedResponse["details"]["user_data"]["2fa_enabled"];
          uuid=parsedResponse["details"]["user_data"]["user_uuid"];
          if(faEnabled==false){
            UserModel userModel = UserModel(
              username: username,
              authToken: parsedResponse["details"]["user_token"],
              userUuid: parsedResponse["details"]["user_data"]["user_uuid"],
              firstName: parsedResponse["details"]["user_data"]["first_name"],
              lastName: parsedResponse["details"]["user_data"]["last_name"],
              emailAddress: parsedResponse["details"]["user_data"]["email_address"],
              contactNumber: parsedResponse["details"]["user_data"]["contact_number"],
              avatar: parsedResponse["details"]["user_data"]["avatar"],
              address: parsedResponse["details"]["user_data"]["address"],
              merchantId: parsedResponse["details"]["payload"]["merchant_id"],
              logo: parsedResponse["details"]["user_data"]["logo"],
              path: parsedResponse["details"]["user_data"]["path"],
              merchantOrderRejectMins: parsedResponse["details"]["user_data"]["merchant_order_reject_mins"],
              restaurantName: parsedResponse["details"]["payload"]["restaurant_name"]
          );
          newLogin=true;
          autoAcceptStatus=parsedResponse["details"]["payload"]["merchant_auto_accept_order"];
          SharedPreferenceManager.getInstance().saveUserData(userModel);
          }
          responseModel = ResponseModel(true, parsedResponse["msg"] ??"");
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"] ?? "");
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      progressReset();
      return responseModel;
    }catch(exception){
      debugPrint("[userLogin] exception in login is $exception");
      responseModel = ResponseModel(false, "Something went wrong");
      progressReset();
      return responseModel;
    }
  }


  //Refresh login data
  Future<ResponseModel> getProfile(String token)async{
    progressStart();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.getProfile(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        debugPrint("[getProfile] parsedResponse outside is $parsedResponse");
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
        debugPrint("[getProfile] parsedResponse inside is $parsedResponse");
          faEnabled= parsedResponse["details"]["user_data"]["2fa_enabled"];
          uuid=parsedResponse["details"]["user_data"]["user_uuid"];
          if(faEnabled==false){
            UserModel userModel = UserModel(
              // username: username,
              authToken: parsedResponse["details"]["user_token"],
              userUuid: parsedResponse["details"]["user_data"]["user_uuid"],
              firstName: parsedResponse["details"]["user_data"]["first_name"],
              lastName: parsedResponse["details"]["user_data"]["last_name"],
              emailAddress: parsedResponse["details"]["user_data"]["email_address"],
              contactNumber: parsedResponse["details"]["user_data"]["contact_number"],
              avatar: parsedResponse["details"]["user_data"]["avatar"],
              address: parsedResponse["details"]["user_data"]["address"],
              merchantId: parsedResponse["details"]["payload"]["merchant_id"],
              logo: parsedResponse["details"]["user_data"]["logo"],
              path: parsedResponse["details"]["user_data"]["path"],
              merchantOrderRejectMins: parsedResponse["details"]["user_data"]["merchant_order_reject_mins"],
              restaurantName: parsedResponse["details"]["payload"]["restaurant_name"]
          );
          // newLogin=true;
          autoAcceptStatus=parsedResponse["details"]["payload"]["merchant_auto_accept_order"];
          SharedPreferenceManager.getInstance().saveUserData(userModel);
          }
          responseModel = ResponseModel(true, parsedResponse["msg"] ??"");
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"] ?? "");
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      progressReset();
      return responseModel;
    }catch(exception){
      debugPrint("[getProfile] exception in getProfile is $exception");
      responseModel = ResponseModel(false, "Something went wrong");
      progressReset();
      return responseModel;
    }
  }


 
 //terms and conditions
   Future<ResponseModel> termsAndConditions(String token)async{

    progressStart();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.termsAndConditions(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
         debugPrint("[termsData] is outside $parsedResponse");
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1|| parsedResponse["code"] == 2){
         debugPrint("[termsData] is inside $parsedResponse");

         termsCondition=  parsedResponse["details"]["restaurant_agreement_url"];

          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }

      } else {
          debugPrint("[termsData] something went wrong");
        responseModel = ResponseModel(false, "Something went wrong");
      }

      progressReset();
      return responseModel;
    }catch(exception){
        debugPrint("[termsData] is exception $exception");
      responseModel = ResponseModel(false, "Something went wrong");
      progressReset();
      return responseModel;
    }
  }

/// menu
   Future<ResponseModel> menu(String token)async{
    UserModel userModel =UserModel.getInstance();
      userModel= await  SharedPreferenceManager.getInstance().getUserData();
   restrauntMenu.clear();
    progressStart();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.getMenuItems(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
         debugPrint("[menu] is outside $parsedResponse");
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1|| parsedResponse["code"] == 2){
           debugPrint("[menu] is inside $parsedResponse");
         try{           
         parsedResponse["details"]["menus"].forEach((element) {
             MenuModel2 model = MenuModel2.fromJson(element);
             restrauntMenu.add(model);
           });
           }catch(e){
              debugPrint("[menu] could not add $e");
            }
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }
      progressReset();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      progressReset();
      return responseModel;
    }
  }


// update menu Items availability
   Future<ResponseModel> updateMenuItemAvailability(String token, String itemUuid, String availability)async{
    ResponseModel responseModel;
    print("[updateMenuItemAvailability] itemUuid is $itemUuid, availability is $availability");
    try {
      ApiResponse apiResponse = await appRepo.updateMenuTemAvailability(token, itemUuid,availability );
       
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        print("[updateMenuItemAvailability] response is ${apiResponse.response!.body}");
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
          ///// change availability in local list
          // for(int i=0;i<restrauntMenu.length;i++){
          //   if(restrauntMenu[i].itemUuid == itemUuid){
          //     restrauntMenu[i].available = availability;
          //     break;
          //   }
          // }
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
       }
      }else {
        responseModel = ResponseModel(false, "Something went wrong");
      }
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }

  /// New Orders
 Future<ResponseModel> newOrders(String token) async {
  newProgress = true;
  newOrdersList.clear();
  notifyListeners();

  try {
    ApiResponse apiResponse = await appRepo.newOrders(token);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {

      final parsedResponse =
          jsonDecode(apiResponse.response!.body);

      debugPrint("[newOrders] response: $parsedResponse");

      if (parsedResponse["code"] == 200 ||
          parsedResponse["code"] == 2 ||
          parsedResponse["code"] == 1) {

        final data = parsedResponse["details"]?["data"];

        if (data is List) {
          for (var element in data) {
            try {
              OrderModel model =
                  OrderModel.fromJson(element);

              ///  SAFE TIME PARSING
              final completionTime =
                  model.orderCompletionTime;

              if (completionTime != null &&
                  completionTime.isNotEmpty &&
                  completionTime != "null") {
                try {
                  DateTime date =
                      DateTime.parse(completionTime);

                  time1 =
                      date.millisecondsSinceEpoch;

                  debugPrint(
                      "time1 in newOrders is $time1");
                } catch (e) {
                  debugPrint(
                      "Invalid date format: $completionTime");
                }
              }

              newOrdersList.add(model);
            } catch (e) {
              debugPrint(
                  "[newOrders] parsing error: $e");
            }
          }
        }

        debugPrint(
            "Total new orders: ${newOrdersList.length}");

        newProgress = false;
        notifyToProvider();
        return ResponseModel(
            true, parsedResponse["msg"]);
      } else {
        newProgress = false;
        notifyToProvider();
        return ResponseModel(
            false, parsedResponse["msg"]);
      }
    } else {
      newProgress = false;
      notifyToProvider();
      return ResponseModel(
          false, "Something went wrong");
    }
  } catch (exception) {
    debugPrint("[newOrders] error: $exception");

    newProgress = false;
    notifyToProvider();
    return ResponseModel(
        false, "Something went wrong");
  }
}
  // Future<ResponseModel> newOrders(String token)async{
  //   newProgress = true;
  //   newOrdersList.clear();
  //   notifyListeners();
  //   ResponseModel responseModel;
  //   try {
  //     ApiResponse apiResponse = await appRepo.newOrders(token);
  //     if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //       var parsedResponse =jsonDecode(apiResponse.response!.body);
  //      debugPrint("[newOrders] outside  are $parsedResponse");
  //       if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2|| parsedResponse["code"] == 1){
  //         debugPrint("[newOrders] inside  are $parsedResponse");
  //         newOrdersList.clear();
  //         parsedResponse["details"]["data"].forEach((element) {
  //           time1=int.parse(OrderModel.fromJson(element).orderCompletionTime!);
  //           print("time1 in newOrders is $time1");
  //           OrderModel model = OrderModel.fromJson(element);

  //           newOrdersList.add(model);
  //         });

  //         debugPrint("______: ${newOrdersList.length}");

  //         responseModel = ResponseModel(true, parsedResponse["msg"]);
  //       }else{
  //         responseModel = ResponseModel(false, parsedResponse["msg"]);
  //       }

  //     } else {
  //       responseModel = ResponseModel(false, "Something went wrong");
  //     }

  //     newProgress = false;
  //     notifyToProvider();
  //     return responseModel;
  //   }catch(exception){
  //    debugPrint("[newOrders] error is  $exception");
  //     responseModel = ResponseModel(false, "Something went wrong");
  //     newProgress = false;
  //     notifyToProvider();
  //     return responseModel;
  //   }
  // }

static Timer? soundStopTimer;

void playSoundForDuration() async {
  try {
    soundStopTimer?.cancel();
    await player.stop();

    print("Starting ringing sound for 15 seconds...");
    await player.setLoopMode(LoopMode.one);
    await player.seek(Duration.zero);
    await player.play();

    // soundStopTimer = Timer(const Duration(seconds: 15), () async {
    //   print("Stopping sound after 15 seconds");
    //   if (ringBell) {
    //     await player.stop();
    //     await player.setLoopMode(LoopMode.off);
    //     ringBell = false;
    //     latestNewOrderNo = "";
    //   }
    // });

  } catch (e) {
    debugPrint('Error in playSoundForDuration(): $e');
  }
}
  
  Future<ResponseModel> autoNewOrders(String token,BuildContext context)async{
    // print("currentTime in tz is ${getCurrentTime()}");
    debugPrint("auto called");
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.newOrders(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2|| parsedResponse["code"] == 1){
          if(parsedResponse["msg"].contains("No results")){
            print(" msg is no result");
            newOrdersList.clear();
          }
          List<String> responseOrderIds = [];  //add order Ids in the list
          parsedResponse["details"]["data"].forEach((element) {
            responseOrderIds.add(OrderModel.fromJson(element).orderData.orderId); /// add order Ids into the list
            
            OrderModel model = OrderModel.fromJson(element);
            int index = newOrdersList.indexWhere((item) => item.orderData.orderId == model.orderData.orderId);
           if(-1 == index){
              newOrdersList.add(OrderModel.fromJson(element));
              time1=int.parse(OrderModel.fromJson(element).orderCompletionTime!);
               print("time1 in autoNewOrders is $time1");
              debugPrint("ring called on ${OrderModel.fromJson(element).orderData.orderId}");
              latestNewOrderNo =OrderModel.fromJson(element).orderData.orderId;
               try{
                if (autoAcceptStatus == true ) {
                   ringBell = true;
                   playSoundForDuration();
                 }else{
                print("current time in timezone is ${getCurrentTime().minute}   latest order ${model.orderData.orderId} time  is ${ DateTime.parse(model.orderData.dateCreated!).minute}");
                 if(DateTime.parse(model.orderData.dateCreated!).minute== getCurrentTime().minute 
                  && DateTime.parse(model.orderData.dateCreated!).day== getCurrentTime().day  
                  && DateTime.parse(model.orderData.dateCreated!).month== getCurrentTime().month 
                  && DateTime.parse(model.orderData.dateCreated!).hour== getCurrentTime().hour){
                  ringBell = true;
                  player.play();
               }
                 } 
                 }catch(e,stack){
                  // bugsnag.notify("error in playing sound is $e", stack);
                 }
           ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.white,
    elevation: 6,
    margin: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Icon(Icons.notifications_active, color: AppAssets.greenColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "New order received #${model.orderData.orderId}",
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 5),
        ),
        );
           try{ 
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: int.parse(model.orderData.orderId),
                  channelKey: 'basic_channel',
                  actionType: ActionType.Default,
                  title: 'New Order!',
                  body: 'You have a new order with the order No: ${model.orderData.orderId}',
                   payload: {
                     'screen': 'notifications'
                   },
                )
            ).then((onValue){
              if(autoAcceptStatus==true){
                 soundStopTimer = Timer(Duration(seconds: alertDuration+2), () async {
                print("Stopping sound after alert seconds");
                 if (ringBell) {
                  await player.stop();
                  await player.setLoopMode(LoopMode.off);
                  ringBell = false;
                  latestNewOrderNo = "";
                }
              });}
            });
             StackTrace? stack;
            // bugsnag.notify("no error notif recieved", stack);
            }catch(e,stack){
             // bugsnag.notify("1 error in getting notification is $e", stack);
            }
            }
          });
        
         // ends here
         newOrdersList.removeWhere((item) => !responseOrderIds.contains(item.orderData.orderId));  // remove order which are not in the response

          debugPrint("______: ${newOrdersList.length}");
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }
            if(autoAcceptStatus==false){
              if(latestNewOrderNo== newOrdersList.last.orderData.orderId){
              debugPrint("App ringbell value is $ringBell");
                  if(ringBell==false){
                     player.stop();
                     ringBell=true;
                     latestNewOrderNo="";
                  }else{
                  debugPrint("playing new order sound");
                   await player.stop();
                   await player.seek(Duration.zero);
                   await player.play();
                  }
            }
        }
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }

  // /// Processing Orders
  Future<ResponseModel> processingOrders(String token)async{
    processingProgress = true;
    processingOrdersList.clear();
    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.processingOrders(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        debugPrint("[processingOrders] outside  are $parsedResponse");

        // newOrders(token);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2|| parsedResponse["code"] == 1){
        debugPrint("[processingOrders] inside  are $parsedResponse");
        // debugPrint("[processingOrders]  customer data is ${parsedResponse["details"]["data"][6]["customer"]}");
        
         processingOrdersList.clear();
          parsedResponse["details"]["data"].forEach((element) {
            try{
            processingOrdersList.add(OrderModel.fromJson(element));
            }
            catch(e){
              debugPrint("[processingOrders] could not add $e");
            }
          });
          ///
           if(newLogin==true){
            SharedPreferenceManager.getInstance().saveProcessedOrderList(processingOrdersList);
           }else{
            SharedPreferenceManager.getInstance().saveNewOrderList(processingOrdersList);
           }
          ///
          debugPrint("______: ${processingOrdersList.length}");
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }

      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }
      processingProgress = false;
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      processingProgress = false;
      notifyToProvider();
      return responseModel;
    }
  }

  Future<ResponseModel> autoProcessingOrders(String token)async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.processingOrders(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2|| parsedResponse["code"] == 1){
          parsedResponse["details"]["data"].forEach((element) {
            OrderModel model = OrderModel.fromJson(element);
            int index = processingOrdersList.indexWhere((item) => item.orderData.orderId == model.orderData.orderId);
            if(-1 == index){
              processingOrdersList.add(OrderModel.fromJson(element));
              // SharedPreferenceManager.getInstance().saveNewOrderList([OrderModel.fromJson(element)]);
              if(autoAcceptStatus==true){
              SharedPreferenceManager.getInstance().addSingleOrderToNewOrderList(OrderModel.fromJson(element));
              }else{
              SharedPreferenceManager.getInstance().addToProcessedOrderList(OrderModel.fromJson(element));
              }
            }
          });

          debugPrint("______: ${processingOrdersList.length}");

          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }

  /// Processing Orders
  Future<ResponseModel> readyOrders(String token)async{
    readyProgress = true;
    readyOrdersList.clear();
    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.readyOrders(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
     
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2|| parsedResponse["code"] == 1){
              debugPrint("[readyOrders] orders inside are  $parsedResponse");
          parsedResponse["details"]["data"].forEach((element) {
            readyOrdersList.add(OrderModel.fromJson(element));
          });

          debugPrint("______: ${readyOrdersList.length}");

          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }

      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      readyProgress = false;
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      readyProgress = false;
      notifyToProvider();
      return responseModel;
    }
  }
  Future<ResponseModel> autoReadyOrders(String token)async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.readyOrders(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2|| parsedResponse["code"] == 1){
          parsedResponse["details"]["data"].forEach((element) {
            OrderModel model = OrderModel.fromJson(element);
            int index = readyOrdersList.indexWhere((item) => item.orderData.orderId == model.orderData.orderId);
            if(-1 == index){
              readyOrdersList.add(OrderModel.fromJson(element));
            }
          });

          debugPrint("______: ${readyOrdersList.length}");
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }

      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// All Orders
  Future<ResponseModel> allOrders(String orderStatus, String orderFilter)async{
    allProgress = true;
    allOrdersList.clear();
    notifyListeners();
    ResponseModel responseModel;

    int comparisonDays = "LAST 7 DAYS" == orderFilter ? 7 : "YESTERDAY" == orderFilter ? 1 : 30;

    try {
      if("ALL ORDERS" == orderStatus){
        allOrdersList.addAll(newOrdersList);
        allOrdersList.addAll(processingOrdersList);
        allOrdersList.addAll(readyOrdersList);
      }
      else if("DELIVERY" == orderStatus){
        allOrdersList.addAll(processingOrdersList);
      }else{
        allOrdersList.addAll(readyOrdersList);
      }

      if(allOrdersList.isNotEmpty){
        allOrdersList.sort((a, b) => a.orderData.orderId.compareTo(b.orderData.orderId));
      }
      allOrdersList = allOrdersList.where((item) => daysBetween(DateTime.parse(item.orderData.dateCreated!), DateTime.now()) <= comparisonDays ).toList();

      allProgress = false;
      notifyToProvider();
      return responseModel = ResponseModel(allOrdersList.isNotEmpty, allOrdersList.isNotEmpty ? "Order Fetched Successfully" : "Something went wrong");

    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      allProgress = false;
      notifyToProvider();
      return responseModel;
    }
  }
 /// Accept Orders
  Future<ResponseModel> acceptOrder(String token, String orderUUID, String date, String time,bool providerFlag,String? deliveryBy)async{
    print("provider ID 6 is $deliveryBy");
    ResponseModel responseModel;
    print("[acceptOrderr] orderUUID is $orderUUID, date is $date, time is $time");
    try {
      ApiResponse apiResponse = await appRepo.acceptOrder(token, orderUUID, date, time,providerFlag,deliveryBy);
       
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        print("[acceptOrderr] response is ${apiResponse.response!.body}");
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2){
          responseModel = ResponseModel(true, parsedResponse["msg"]);

          // pre
          newOrdersList.removeWhere((item) => item.orderData.orderUuid == orderUUID);
          // if(orderUUID==latestNewOrderNo){
          //   ringBell=false;
          // }

          // newOrdersList.clear();

          // await newOrders(token).then((value) async{

          processingOrdersList.clear();
          await processingOrders(token).then((v){
          // // auto debugPrint order
          debugPrint("inside after processing order");
          autoOrderUuis=orderUUID;
          selectedTab=1; 
         }
        );
          // });

       }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
       }
      }else {
        responseModel = ResponseModel(false, "Something went wrong");
      }
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }


Future<ResponseModel> cancelOrder(String token, String orderUUID, String amount, String reason, String status, String requestFrom) async {
  ResponseModel responseModel;
  try {
    ApiResponse apiResponse = await appRepo.cancelOrder(token, orderUUID, amount, reason, status);
    debugPrint("[cancelOrder] response code is ${apiResponse.response!.statusCode}");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var parsedResponse = jsonDecode(apiResponse.response!.body);
      debugPrint("[cancelOrder] parsed body is $parsedResponse");

      /// Convert `msg` to String to avoid `_Map<String, dynamic>` error
      var message = parsedResponse["msg"].toString();

      if (parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2) {
        responseModel = ResponseModel(true, message);
        debugPrint("[cancelOrder] Success: $message");

        try {
          newOrdersList.removeWhere((item) => item.orderData.orderUuid == orderUUID);
          newOrdersList.clear();
          newOrders(token);

          debugPrint("[cancelOrder] Order removed successfully");
        } catch (e) {
          debugPrint("[cancelOrder] Unable to remove order: $e");
        }

        if (requestFrom == "new") {
          newOrders(token);
        } else if (requestFrom == "preparing") {
          processingOrders(token);
        } else {
          readyOrders(token);
        }
      } else {
        debugPrint("[cancelOrder] API error inside");
        responseModel = ResponseModel(false, message);
      }
    } else {
      debugPrint("[cancelOrder] API error outside");
      responseModel = ResponseModel(false, "Something went wrong");
    }

    notifyToProvider();
    return responseModel;
  } catch (exception) {
    debugPrint("[cancelOrder] Exception: $exception");
    responseModel = ResponseModel(false, "Something went wrong");
    notifyToProvider();
    return responseModel;
  }
}

  /// Ready For Pickup Orders
  Future<ResponseModel> readyForPickupOrder(String token, String orderUUID)async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.readyForPickupOrder(token, orderUUID);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
          processingOrdersList.removeWhere((item) => item.orderData.orderUuid == orderUUID);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }

  /// Complete Orders
  Future<ResponseModel> completeOrder(String token, String orderUUID)async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.completeOrder(token, orderUUID);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
          readyOrdersList.removeWhere((item) => item.orderData.orderUuid == orderUUID);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }

   ///add Printer logs
  Future<ResponseModel> printerLogs( String token,
      OrderModel orderModel,
      String printerType,
      String status,
      String filePath,
      String jobId,
      String receiptType )async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.printerLogs(token, orderModel, printerType, status, filePath,jobId,receiptType);
       debugPrint("[PrinterLogs] apiResponse is ${apiResponse.response!.body}");
 
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
       }else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }

  //update printer logs
  Future<ResponseModel> updatePrinterLogs( String token,
      String status,
      String printerLogId)async{
      ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.updatePrinterLogs(token, status, printerLogId);
       debugPrint("[updatePrinterLogs] apiResponse is ${apiResponse.response!.body}");
 
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      notifyToProvider();
      return responseModel;
     }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }


//addPrinter
  Future<ResponseModel> addPrinters(String token, PrinterModal printerModal)async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.addPrinters(token ,printerModal);
       debugPrint("[addPrinters] apiResponse is ${apiResponse.response!.body}");
 
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
      //  debugPrint("[addPrinters] outside is ${parsedResponse.body}");

        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2){
        //  debugPrint("[addPrinters] inside is ${parsedResponse.body}");

          responseModel = ResponseModel(true, parsedResponse["msg"]);
        
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }
      notifyToProvider();
      return responseModel;
    }catch(exception){
      debugPrint("[addPrinters] exception ina adding printer is $exception");
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }

  ///get Printers
   Future<ResponseModel> getPrinters(String token,String merchantId)async{
    printerProgress = true;
    addedPrinterList.clear();
    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.getPrinters(token,merchantId);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        debugPrint("[addedPrinterList] outside  are $parsedResponse");

        // newOrders(token);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
        debugPrint("[addedPrinterList] inside  are $parsedResponse");

          parsedResponse["details"].forEach((element) {
            try{
            addedPrinterList.add(PrinterModal.fromJson(element));
            }
            catch(e){
              debugPrint("[addedPrinterList] could not get $e");
            }
          });
          debugPrint("______: ${addedPrinterList.length}");

          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }

      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      printerProgress = false;
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      printerProgress = false;
      notifyToProvider();
      return responseModel;
    }
  }

//Delete Printer
Future<ResponseModel> deletePrinter(String token, String printerIp ,String printerId,String printerName) async {
  ResponseModel responseModel;
  try {
    ApiResponse apiResponse = await appRepo.deletePrinter(token,printerId,printerName );
    debugPrint("[deletePrinter] response code is ${apiResponse.response!.statusCode}");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var parsedResponse = jsonDecode(apiResponse.response!.body);
      debugPrint("[deletePrinter] parsed body is $parsedResponse");

      /// Convert `msg` to String to avoid `_Map<String, dynamic>` error
      var message = parsedResponse["msg"].toString();

      if (parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1) {
        responseModel = ResponseModel(true, message);
        debugPrint("[deletePrinter] Success: $message");

        try {
          addedPrinterList.removeWhere((printer) => printer.ipAddress == printerIp);
          debugPrint("[deletePrinter] Order removed successfully");
        } catch (e) {
          debugPrint("[deletePrinter] Unable to remove order: $e");
        }
    
      } else {
        debugPrint("[deletePrinter] API error inside");
        responseModel = ResponseModel(false, message);
      }
    } else {
      debugPrint("[deletePrinter] API error outside");
      responseModel = ResponseModel(false, "Something went wrong");
    }

    notifyToProvider();
    return responseModel;
  } catch (exception) {
    debugPrint("[deletePrinter] Exception: $exception");
    responseModel = ResponseModel(false, "Something went wrong");
    notifyToProvider();
    return responseModel;
  }
}

///update printer
//Delete Printer
Future<ResponseModel> updatePrinter(String token, PrinterModal printerModal) async {
  ResponseModel responseModel;
  try {
    ApiResponse apiResponse = await appRepo.updatePrinter(token,printerModal);
    debugPrint("[updatePrinter] response code is ${apiResponse.response!.statusCode}");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var parsedResponse = jsonDecode(apiResponse.response!.body);
      debugPrint("[updatePrinter] parsed body is $parsedResponse");

      /// Convert `msg` to String to avoid `_Map<String, dynamic>` error
      var message = parsedResponse["msg"].toString();

      if (parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1) {
        responseModel = ResponseModel(true, message);
        debugPrint("[updatePrinter] Success: $message");

        // try {
        //   getPrinters(token, )
        // } catch (e) {
        //   debugPrint("[updatePrinter] Unable to remove order: $e");
        // }
    
      } else {
        debugPrint("[updatePrinter] API error inside");
        responseModel = ResponseModel(false, message);
      }
    } else {
      debugPrint("[updatePrinter] API error outside");
      responseModel = ResponseModel(false, "Something went wrong");
    }

    notifyToProvider();
    return responseModel;
  } catch (exception) {
    debugPrint("[updatePrinter] Exception: $exception");
    responseModel = ResponseModel(false, "Something went wrong");
    notifyToProvider();
    return responseModel;
  }
}


/// update availabilitystatuss
Future<ResponseModel> updateOrderingStatus(String token,String merchantId,bool accepting ) async {
  ResponseModel responseModel;
  try {
    ApiResponse apiResponse = await appRepo.updateOrderingStatus(token, merchantId, accepting);
    debugPrint("[updateOrderingStatus] response code is ${apiResponse.response!.statusCode}");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var parsedResponse = jsonDecode(apiResponse.response!.body);
      debugPrint("[updateOrderingStatus] parsed body is $parsedResponse");

      /// Convert `msg` to String to avoid `_Map<String, dynamic>` error
      var message = parsedResponse["msg"].toString();

      if (parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2) {
        responseModel = ResponseModel(true, message);
        debugPrint("[updateOrderingStatus] Success: $message");
      } else {
        debugPrint("[updateOrderingStatus] API error inside");
        responseModel = ResponseModel(false, message);
      }
    } else {
      debugPrint("[updateOrderingStatus] API error outside");
      responseModel = ResponseModel(false, "Something went wrong");
    }

    notifyToProvider();
    return responseModel;
  } catch (exception) {
    debugPrint("[updateOrderingStatus] Exception: $exception");
    responseModel = ResponseModel(false, "Something went wrong");
    notifyToProvider();
    return responseModel;
  }
}

//unavailable
Future<ResponseModel> updateOrderingStatusUnAval(String token,String merchantId,String reason) async {
  ResponseModel responseModel;
  try {
    ApiResponse apiResponse = await appRepo.updateOrderingStatusUnAval(token, merchantId, reason);
    debugPrint("[updateOrderingStatusUnAval] response code is ${apiResponse.response!.statusCode}");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var parsedResponse = jsonDecode(apiResponse.response!.body);
      debugPrint("[updateOrderingStatusUnAval] parsed body is $parsedResponse");

      /// Convert `msg` to String to avoid `_Map<String, dynamic>` error
      var message = parsedResponse["msg"].toString();

      if (parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2) {
        responseModel = ResponseModel(true, message);
        debugPrint("[updateOrderingStatusUnAval] Success: $message");
      } else {
        debugPrint("[updateOrderingStatusUnAval] API error inside");
        responseModel = ResponseModel(false, message);
      }
    } else {
      debugPrint("[updateOrderingStatusUnAval] API error outside");
      responseModel = ResponseModel(false, "Something went wrong");
    }

    notifyToProvider();
    return responseModel;
  } catch (exception) {
    debugPrint("[updateOrderingStatusUnAval] Exception: $exception");
    responseModel = ResponseModel(false, "Something went wrong");
    notifyToProvider();
    return responseModel;
  }
}


// pause ordersing status
Future<ResponseModel> pauseOrderingStatus(String token,String merchantId,int pauseHrs,int pauseMins,String reason, String delayTime) async {
  debugPrint("[pauseOrderingStatus] token and merchant id is $token ---- $merchantId");
  ResponseModel responseModel;
  try {
    ApiResponse apiResponse = await appRepo.pauseOrderingStatus(token, merchantId, pauseHrs, pauseMins, reason, delayTime);
    debugPrint("[pauseOrderingStatus] response code is ${apiResponse.response!.statusCode}");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var parsedResponse = jsonDecode(apiResponse.response!.body);
      debugPrint("[pauseOrderingStatus] parsed body is $parsedResponse");

      /// Convert `msg` to String to avoid `_Map<String, dynamic>` error
      var message = parsedResponse["msg"].toString();

      if (parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2) {
        responseModel = ResponseModel(true, message);
        debugPrint("[pauseOrderingStatus] Success: $message");
        if(delayTime=="0"){
          updateOrderingStatus(token, merchantId, false);
        }
      } else {
        debugPrint("[pauseOrderingStatus] API error inside");
        responseModel = ResponseModel(false, message);
      }
    } else {
      debugPrint("[pauseOrderingStatus] API error outside");
      responseModel = ResponseModel(false, "Something went wrong");
    }

    notifyToProvider();
    return responseModel;
  } catch (exception) {
    debugPrint("[pauseOrderingStatus] Exception: $exception");
    responseModel = ResponseModel(false, "Something went wrong");
    notifyToProvider();
    return responseModel;
  }
}



  ///get ordering status
   Future<bool> getOrderingStatus(String token,String merchantId,BuildContext context)async{
    // printerProgress = true;
    bool status=false;
    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.getOrderingStatus(token,merchantId);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        // debugPrint("[getOrderingStatus] outside  are $parsedResponse");

        // newOrders(token);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
        debugPrint("[getOrderingStatus] inside  are $parsedResponse");
        /////
          availabilityStatus = parsedResponse["details"]["pause_status"]; 
          status=parsedResponse["details"]["pause_status"];
          autoAcceptStatus=parsedResponse["details"]["merchant_auto_accept_order"];
          timezone=parsedResponse["details"]["merchant_timezone"];  ////

          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
          // Text("timezone is ${parsedResponse["details"]["merchant_timezone"]} and var is $timezone"),));
          
          // debugPrint(" parsedResponse[details][pause_status] id ${parsedResponse["details"]["pause_status"]} ");
          debugPrint("______: ${addedPrinterList.length}");
          responseModel = ResponseModel(true, parsedResponse["msg"]);
          status=parsedResponse["details"]["pause_status"];
          autoAcceptStatus=parsedResponse["details"]["merchant_auto_accept_order"];

        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
          status=parsedResponse["details"]["pause_status"];
          autoAcceptStatus=parsedResponse["details"]["merchant_auto_accept_order"];

        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
        status=availabilityStatus;
      }

      printerProgress = false;
      notifyToProvider();
      return status;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      printerProgress = false;
      notifyToProvider();
      return status;
    }
  }

    ///get ordering status
   Future<ResponseModel> getPauseStatusData(String token,String merchantId)async{ 
    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.getPauseStatusData(token,merchantId);
      //  debugPrint("[getPauseStatusData] outside  are ${apiResponse.response!.request}");
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        // debugPrint("[getPauseStatusData] outside  are $parsedResponse");
         
        // newOrders(token);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
          pauseTime=parsedResponse["details"]["pause_time"] ?? "";
          modifiedAtTime=parsedResponse["details"]["modified_at"] ??"";

          if(parsedResponse["details"]["accepting_order"]==true){
            availabilityStatus=false;
          }

        debugPrint("[getPauseStatusData] inside  are $parsedResponse");
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }

      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      printerProgress = false;
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      printerProgress = false;
      notifyToProvider();
      return responseModel;
    }
  }

  //get default printer
     Future<ResponseModel> getdefaultPrinter(String token,String merchantId,String receiptType)async{

    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.getdefaultPrinter(token,merchantId,receiptType);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        debugPrint("defaultPrinterIp for outside  are $parsedResponse");

        // newOrders(token);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
        debugPrint("[getdefaultPrinter] inside  are $parsedResponse");
        /////
         if(receiptType=="kitchen"){
          defaultKitchenPrinterIp =  removePort(parsedResponse["details"]["printer_ip"]); 
          portDefaultKitchenPrinter=getPort(parsedResponse["details"]["printer_ip"])!;
          defaultKitchenPrinterID =parsedResponse["details"]['printer_id'];  ///TODO: check this
         
          // defaultClientPrinterID =parsedResponse["details"]['printer_id'];   ///TODO: check this client in kitchen used
         }
          if(receiptType=="client"){
          defaultClientPrinterIp =  removePort(parsedResponse["details"]["printer_ip"]); 
          portDefaultClientPrinter=getPort(parsedResponse["details"]["printer_ip"])!;
          defaultClientPrinterID =parsedResponse["details"]['printer_id'];   ///TODO: check this client in kitchen used
         
          // defaultKitchenPrinterID =parsedResponse["details"]['printer_id'];  ///TODO: check this
         }

          debugPrint(" defaultPrinterIp for $receiptType is  ${parsedResponse["details"]["printer_ip"]}");
          debugPrint("______: ${addedPrinterList.length}");
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }

      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      printerProgress = false;
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      printerProgress = false;
      notifyToProvider();
      return responseModel;
    }
  }

  /// set default printer
Future<ResponseModel> setDefaultPrinter(String token,String merchantId,String printerId,String receiptType ) async {
  ResponseModel responseModel;
  try {
    ApiResponse apiResponse = await appRepo.setDefaultPrinter(token, merchantId, printerId,receiptType);
    debugPrint("[setDefaultPrinter] response code is ${apiResponse.response!.statusCode}");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var parsedResponse = jsonDecode(apiResponse.response!.body);
      debugPrint("[setDefaultPrinter] parsed body is $parsedResponse");

      /// Convert `msg` to String to avoid `_Map<String, dynamic>` error
      var message = parsedResponse["msg"].toString();

      if (parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1) {
        responseModel = ResponseModel(true, message);
        debugPrint("[setDefaultPrinter] Success: $message");
      } else {
        debugPrint("[setDefaultPrinter] API error inside");
        responseModel = ResponseModel(false, message);
      }
    } else {
      debugPrint("[setDefaultPrinter] API error outside");
      responseModel = ResponseModel(false, "Something went wrong");
    }

    notifyToProvider();
    return responseModel;
  } catch (exception) {
    debugPrint("[setDefaultPrinter] Exception: $exception");
    responseModel = ResponseModel(false, "Something went wrong");
    notifyToProvider();
    return responseModel;
  }
}


// get Timezone
   Future<ResponseModel> getTimezone(String token,String merchantId)async{
    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.getTimeZone(token,merchantId);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        debugPrint("[getTimezone] outside  are $parsedResponse");

        // newOrders(token);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
        debugPrint("[getTimezone] inside  are $parsedResponse");
          timezone= parsedResponse["details"]["timezone"];
        debugPrint("[getTimezone] timezone is ${parsedResponse["details"]["timezone"]}");

      
          debugPrint("______: ${addedPrinterList.length}");
          responseModel = ResponseModel(true, parsedResponse["msg"]);
 
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);

        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      printerProgress = false;
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      printerProgress = false;
      notifyToProvider();
      return responseModel;
    }
  }

// static DateTime getCurrentTime() {
//   if(timezone!="" && timezone!=null){
//   final location = tz.getLocation(timezone);
//   final now = tz.TZDateTime.now(location);
//   print("current time in $timezone is $now");
//   return now;
//   }else{
//     print("current time is default");
//     return DateTime.now();
//   }
// }
static DateTime getCurrentTime() {
  DateTime now;

  if (timezone != "" && timezone != null) {
    final location = tz.getLocation(timezone);
    now = tz.TZDateTime.now(location);
    print("current time in $timezone is $now");
  } else {
    now = DateTime.now();
    print("current time is default $now");
  }

  // Truncate seconds and microseconds
  return DateTime(now.year, now.month, now.day, now.hour, now.minute);
}


  Future<ResponseModel> verify2fa(String code ,String username)async{
    progressStart();
    ResponseModel responseModel;
    try {
      debugPrint("uuid isss $uuid , code is $code");
      ApiResponse apiResponse = await appRepo.verify2Fa(uuid, code);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        debugPrint("[verify2fa] parsedResponse outside is $parsedResponse");
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
        debugPrint("[verify2fa] parsedResponse inside is $parsedResponse");
         responseModel = ResponseModel(true, parsedResponse["msg"]);
              UserModel userModel = UserModel(
              username: username,
              authToken: parsedResponse["details"]["user_token"],
              userUuid: parsedResponse["details"]["user_data"]["user_uuid"],
              firstName: parsedResponse["details"]["user_data"]["first_name"],
              lastName: parsedResponse["details"]["user_data"]["last_name"],
              emailAddress: parsedResponse["details"]["user_data"]["email_address"],
              contactNumber: parsedResponse["details"]["user_data"]["contact_number"],
              avatar: parsedResponse["details"]["user_data"]["avatar"],
              address: parsedResponse["details"]["user_data"]["address"],
              merchantId: parsedResponse["details"]["payload"]["merchant_id"],
              logo: parsedResponse["details"]["user_data"]["logo"],
          );
          SharedPreferenceManager.getInstance().saveUserData(userModel);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      progressReset();
      return responseModel;
    }catch(exception){
      debugPrint("[verify2fa] exception  is $exception");
      responseModel = ResponseModel(false, "Something went wrong");
      progressReset();
      return responseModel;
    }
  }


  //get notifications
   Future<ResponseModel> getNotifications(String token)async{
    
    progressStart();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.getNotifications(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
           
         if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2){
            //  debugPrint("[getNotifications] inside  is $parsedResponse") ;

         try{  
          notiList.clear();
          notifCount= parsedResponse["details"]["count"] ?? 0;
         parsedResponse["details"]["data"].forEach((element) {
            NotifModel model = NotifModel.fromJson(element);
            notiList.add(model);
           });
           }catch(e){
              debugPrint("[getNotifications] could not add $e");
            }
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false,"Something went wrong");
      }
      progressReset();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      progressReset();
      return responseModel;
    }
  }

  //Delete notif
Future<ResponseModel> deleteNotif(String token) async {
  ResponseModel responseModel;
  try {
    ApiResponse apiResponse = await appRepo.deleteNotif(token);
    debugPrint("[deleteNotif] response code is ${apiResponse.response!.statusCode}");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var parsedResponse = jsonDecode(apiResponse.response!.body);
      debugPrint("[deleteNotif] parsed body is $parsedResponse");

      /// Convert `msg` to String to avoid `_Map<String, dynamic>` error
      var message = parsedResponse["msg"].toString();

      if (parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2) {
        responseModel = ResponseModel(true, message);
        debugPrint("[deleteNotif] Success: $message");

        try {
          notifCount=0;
          notiList.clear();
          debugPrint("[deleteNotif] notif cleared successfully");
        } catch (e) {
          debugPrint("[deleteNotif] Unable to clear notif: $e");
        }
    
      } else {
        debugPrint("[deleteNotif] API error inside");
        responseModel = ResponseModel(false, message);
      }
    } else {
      debugPrint("[deleteNotif] API error outside");
      responseModel = ResponseModel(false, "Something went wrong");
    }

    notifyToProvider();
    return responseModel;
  } catch (exception) {
    debugPrint("[deleteNotif] Exception: $exception");
    responseModel = ResponseModel(false, "Something went wrong");
    notifyToProvider();
    return responseModel;
  }
}

  Future<ResponseModel> readNotif(String notifUuid,String authToken)async{
    notifCount=0;
    progressStart();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.readNotif(notifUuid,authToken);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        debugPrint("[readNotif] parsedResponse outside is $parsedResponse");
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2 ){
        debugPrint("[readNotif] parsedResponse inside is $parsedResponse");
         responseModel = ResponseModel(true, parsedResponse["msg"]);
         notiList.removeWhere((item) => item.notiUuid == notifUuid);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      progressReset();
      return responseModel;
    }catch(exception){
      debugPrint("[readNotif] exception  is $exception");
      responseModel = ResponseModel(false, "Something went wrong");
      progressReset();
      return responseModel;
    }
  }

  Future<ResponseModel> printStatusUpdate( String token,
      String orderUuid,
      String isPrinted)async{
      ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.printStatusUpdate(token, orderUuid, isPrinted);
       debugPrint("[printStatusUpdate] apiResponse is ${apiResponse.response!.body}");
 
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      notifyToProvider();
      return responseModel;
     }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }

 /// Processing Orders
  // Future<ResponseModel> connectedProviders(String token)async{
  //   connectedProvidersList.clear();
  //   notifyListeners();
  //   ResponseModel responseModel;
  //   try {
  //     ApiResponse apiResponse = await appRepo.connectedProviders(token);
  //     if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //       var parsedResponse = jsonDecode(apiResponse.response!.body);
  //       debugPrint("[connectedProviders] outside  are $parsedResponse");
  //       newOrders(token);
  //       if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2|| parsedResponse["code"] == 1){
  //       debugPrint("[connectedProviders] inside  are $parsedResponse");
  //       // debugPrint("[connectedProviders]  customer data is ${parsedResponse["details"]["data"][6]["customer"]}");
  //        connectedProvidersList.clear();
  //         parsedResponse["details"].forEach((element) {
  //           try{
  //           connectedProvidersList.add(ProviderModel.fromJson(element));
  //           debugPrint("[connectedProviders] added successfully");
  //           }
  //           catch(e){
  //             debugPrint("[connectedProviders] could not add $e");
  //           }
  //         });
  //         ///      
  //         ///
  //         debugPrint("______: ${processingOrdersList.length}");
  //         responseModel = ResponseModel(true, parsedResponse["msg"]);
  //       }else{
  //         responseModel = ResponseModel(false, parsedResponse["msg"]);
  //       }
  //     } else {
  //       responseModel = ResponseModel(false, "Something went wrong");
  //     }    
  //     notifyToProvider();
  //     return responseModel;
  //   }catch(exception){
  //     responseModel = ResponseModel(false, "Something went wrong"); 
  //     notifyToProvider();
  //     return responseModel;
  //   }
  // }

Future<ResponseModel> connectedProviders(String token) async {
  connectedProvidersList.clear();
  notifyListeners();

  try {
    ApiResponse apiResponse = await appRepo.connectedProviders(token);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var parsedResponse =
          jsonDecode(apiResponse.response!.body);

      debugPrint(
          "[connectedProviders] response: $parsedResponse");

      // newOrders(token);  5/3/2026

      if (parsedResponse["code"] == 200 ||
          parsedResponse["code"] == 2 ||
          parsedResponse["code"] == 1) {

        connectedProvidersList.clear();

        final details = parsedResponse["details"];

        if (details is Map<String, dynamic>) {
          for (var element in details.values) {
            try {
              connectedProvidersList
                  .add(ProviderModel.fromJson(element));
              debugPrint(
                  "[connectedProviders] added successfully");
            } catch (e) {
              debugPrint(
                  "[connectedProviders] parsing error: $e");
            }
          }
        }

        debugPrint(
            "Total providers: ${connectedProvidersList.length}");

        notifyToProvider();
        return ResponseModel(true, parsedResponse["msg"]);
      } else {
        notifyToProvider();
        return ResponseModel(false, parsedResponse["msg"]);
      }
    } else {
      notifyToProvider();
      return ResponseModel(false, "Something went wrong");
    }
  } catch (exception) {
    debugPrint(
        "[connectedProviders] exception: $exception");

    notifyToProvider();
    return ResponseModel(false, "Something went wrong");
  }
}

/*
  Future<ResponseModel> getAppVersions()async{
    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.getAppVersions();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
     
          debugPrint("[getAppVersions] orders inside are  $parsedResponse");
         try{
          final response = AppVersionResponse.fromJson(parsedResponse);
          for (var element in response.results) {
            if(element.releaseName.toUpperCase()=="U"){
              print("currently checking version ${element.versionCode}");
             versionUpdateFlag = compareVersions(element.versionCode, currentAppVersion); 
             if(versionUpdateFlag==1 || versionUpdateFlag==0){
              latestAppVersion=element;
              break;
             }
            }
          }
          }catch(e){
            print("[getAppVersions] error is $e");
          }
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      readyProgress = false;
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      readyProgress = false;
      notifyToProvider();
      return responseModel;
    }
  }

  // to compare which version is latest
  int compareVersions(String v1, String v2) {
  List<int> parts1 = v1.split('.').map(int.parse).toList();
  List<int> parts2 = v2.split('.').map(int.parse).toList();

  int maxLength = parts1.length > parts2.length ? parts1.length : parts2.length;

  for (int i = 0; i < maxLength; i++) {
    int p1 = i < parts1.length ? parts1[i] : 0;
    int p2 = i < parts2.length ? parts2[i] : 0;

    if (p1 > p2) return 1;   // v1 is greater
    if (p1 < p2) return -1;  // v2 is greater
  }

  return 0; // equal
}

/// to update app through esper
Future<void> triggerEsperUpdate(BuildContext context) async {
  // Replace these with your actual credentials
  const String enterpriseId = 'dbcb2aa5-1fdf-4387-8a06-93e8274a2281';
   String deviceId = "0f1c2e26-3c01-4c47-90fa-c5990bb2182c";
  String newVersionId =   latestAppVersion.id;
  const String apiKey = '7CV4PU3eOgcpOYALRgKqhElaiGODW4';

  final url = Uri.parse('https://zsuoy-api.esper.cloud/api/v0/enterprise/$enterpriseId/command/');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "command_type": "DEVICE",
      "devices": [deviceId],
      "command": "INSTALL",
      "command_args": {
        "app_version": newVersionId,
        "package_name": "com.eatsbee.order_receiving"
      }
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print("Update command sent successfully!");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("update successful ${response.body}")));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[getEsperDeviceId] Failed to get device ID: ${response.body}")));

    // print("[triggerEsperUpdate] Failed to trigger update: ${response.body}");
  }
}

//converge device to latest blueprint  // not used yet
Future<void> convergeDevice(String deviceId) async {
  const String enterpriseId = 'dbcb2aa5-1fdf-4387-8a06-93e8274a2281';
  const String apiKey = '7CV4PU3eOgcpOYALRgKqhElaiGODW4';
  const String tenant = 'zsuoy'; // Your tenant name from the URL

  final url = Uri.parse('https://$tenant-api.esper.cloud/api/v0/enterprise/$enterpriseId/command/');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "command_type": "DEVICE",
      "devices": [deviceId],
      "command": "CONVERGE",
      "command_args": {},
      "device_type": "all" 
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print("Converge command sent. Device is now updating to the latest Blueprint.");
  } else {
    print("Converge failed: ${response.body}");
  }
}

/// get device id from esper using serial number
 getEsperDeviceId(String serial,BuildContext context) async {
  final url = Uri.parse('https://zsuoy-api.esper.cloud/api/enterprise/dbcb2aa5-1fdf-4387-8a06-93e8274a2281/device/?serial=$serial');

  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer 7CV4PU3eOgcpOYALRgKqhElaiGODW4'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("[getEsperDeviceId] response data is $data");
    // Esper returns a list; grab the ID from the first result
    if (data['results'].isNotEmpty) {
      localdeviceId= data['results'][0]['id']; 
      print("[getEsperDeviceId]1 decice id is $localdeviceId");
    }
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[getEsperDeviceId]1 decice id is $localdeviceId")));
    print("[getEsperDeviceId]2 decice id is $localdeviceId");
  } else {
    print("[getEsperDeviceId] Failed to get device ID: ${response.body}");
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[getEsperDeviceId] Failed to get device ID: ${response.body}")));
  }

}
*/


  Future<ResponseModel> unsetDefaultprinters( String token,
      String printerId,
      String type)async{
      ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.unsetDefaultPrinter(token, printerId, type);
       debugPrint("[updatePrinterLogs] apiResponse is ${apiResponse.response!.body}");
 
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2 || parsedResponse["code"] == 1){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }
      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      notifyToProvider();
      return responseModel;
     }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      notifyToProvider();
      return responseModel;
    }
  }





Future<ResponseModel> providerStatus(String token,String intgId ,int status) async {
  ResponseModel responseModel;
  try {
    ApiResponse apiResponse = await appRepo.providerStatus(token,intgId, status);
    debugPrint("[providerStatus] response code is ${apiResponse.response!.statusCode}");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var parsedResponse = jsonDecode(apiResponse.response!.body);
      debugPrint("[providerStatus] parsed body is $parsedResponse");

      var message = parsedResponse["msg"].toString();

      if (parsedResponse["code"] == 200 || parsedResponse["code"] == 1 || parsedResponse["code"] == 2) {
        responseModel = ResponseModel(true, message);
        debugPrint("[providerStatus] Success: $message");

      
      } else {
        debugPrint("[providerStatus] API error inside");
        responseModel = ResponseModel(false, message);
      }
    } else {
      debugPrint("[providerStatus] API error outside");
      responseModel = ResponseModel(false, "Something went wrong");
    }

    notifyToProvider();
    return responseModel;
  } catch (exception) {
    debugPrint("[providerStatus] Exception: $exception");
    responseModel = ResponseModel(false, "Something went wrong");
    notifyToProvider();
    return responseModel;
  }
}
Map<String, List<AddonItems>> groupAddonsByPortion(
    List<AddonItems> addonItems) {

  final Map<String, List<AddonItems>> grouped = {};

  for (var item in addonItems) {

    final id = item.pizzaPortionSectionId;
    final key = (id != null && id.trim().isNotEmpty)
        ? id.trim()
        : "no_portion";
    grouped.putIfAbsent(key, () => []);
    grouped[key]!.add(item);
  }

  return grouped;
}

String getPortionName(String id) {
  switch (id) {
    case "1":
      return "Whole Portion";
    case "2":
      return "Left Portion";
    case "3":
      return "Right Portion";
    default:
      return "";
  }
}
  progressReset(){
    progress = false;
    notifyListeners();
  }
  progressStart(){
    progress = true;
    notifyListeners();
  }
  notifyToProvider(){
    notifyListeners();
  }
}
