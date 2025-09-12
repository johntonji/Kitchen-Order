import 'dart:convert';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/printer_modal.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../utilities/base/api_response.dart';
import '../utilities/ip_configurations.dart';
//import 'dart:developer';

class AppRepo{
  /// Login API
  Future<ApiResponse> userLogin(String username, String password)async{
    ApiResponse apiResponse;
    var data = jsonEncode({"username":username,"password":password});

    var response = await http.post(Uri.parse("https://fooduat.eatsbee.com//backoffice/apibackendmobile/login"),
        /*headers: {
          'Authorization': 'Bearer ${userModel.authToken}',
        }*/
        body: data
    );

    //log("Index number is: ");
    
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      debugPrint("response body is ${response.body}");
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      debugPrint("response status code is ${response.statusCode} ");

      return apiResponse;
    }
  }

 
 

// menu fetching Api
Future<ApiResponse> getMenuItems(String token) async {
  ApiResponse apiResponse;
  try {
    var response = await http.get(
      Uri.parse(IPConfigurations.menuItems),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      apiResponse = ApiResponse.withSuccess(response);
    } else {
      apiResponse = ApiResponse.withError("Error: ${response.statusCode}");
    }
  } catch (e) {
    apiResponse = ApiResponse.withError("Exception: $e");
  }

  return apiResponse;
}

  
  /// Terms and Conditions Fetching API
  Future<ApiResponse> termsAndConditions(String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse(IPConfigurations.getTermsConditions),
        headers: {
          'Authorization': 'Bearer $token',
        }
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  /// New Order Fetching API
  Future<ApiResponse> newOrders(String token)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse(IPConfigurations.getNewOrders),
        headers: {
          'Authorization': 'Bearer $token',
        }
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  

  /// Processing Order Fetching API
  Future<ApiResponse> processingOrders(String token)async{
    ApiResponse apiResponse;

    var response = await http.get(Uri.parse(IPConfigurations.getProcessingOrders),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':'application/json'
        }
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      //serverIp
      
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  /// Ready Order Fetching API
  Future<ApiResponse> readyOrders(String token)async{
    ApiResponse apiResponse;

    var response = await http.get(Uri.parse(IPConfigurations.getReadyOrders),
        headers: {
          'Authorization': 'Bearer $token',
        }
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  /// Accept Order API
  Future<ApiResponse> acceptOrder(String token, String orderUUID, String date, String time)async{
    ApiResponse apiResponse;
    print("[acceptOrder] delivery time for $orderUUID is $time abd date is $date");
    var data = jsonEncode({
      "order_uuid" : orderUUID,
      "delivery_date" : date,
      "delivery_time" : "$time:00"
    });

    var response = await http.post(Uri.parse(IPConfigurations.acceptOrders),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':'application/json'
        },
        body: data
    ).then((value) {
      print("[acceptOrder]  apiRepo then response is ${value.body}");
      return value;
    });

    //debugPrint("Index Respo Data: "+data.toString());
    //debugPrint("Index Respo: "+response.body.toString());
    //var api=ApiResponse(response,null,null);
    //debugPrint("Index Respo V2: "+api.toString());
    print("[acceptOrder]  apiRepo response is ${response.body}");
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      print("[acceptOrder]  apiRepo error is ${apiResponse.response!.body}");
      return apiResponse;
    }
  }

  /// Cancel Order API
  Future<ApiResponse> cancelOrder(String token, String orderUUID, String amount, String reason, String status)async{
    ApiResponse apiResponse;

    var data = jsonEncode({
      "order_uuid" : orderUUID,
      "amount" : amount,
      "reason" : reason,
      "status" : status
    });

    var response = await http.post(Uri.parse(IPConfigurations.cancelOrders),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  /// Ready for Pickup Order API
  Future<ApiResponse> readyForPickupOrder(String token, String orderUUID)async{
    ApiResponse apiResponse;

    var data = jsonEncode({
      "order_uuid" : orderUUID
    });

    var response = await http.post(Uri.parse(IPConfigurations.readyForPickupOrders),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':'application/json'
        },
        body: data
    );
    //debugPrint('Ready'+response.toString());
    //log("Index number is: ");
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  /// Complete Order API
  Future<ApiResponse> completeOrder(String token, String orderUUID)async{
    ApiResponse apiResponse;

    var data = jsonEncode({
      "order_uuid" : orderUUID
    });

    var response = await http.post(Uri.parse(IPConfigurations.completeOrders),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

//add priter logs
Future<ApiResponse> printerLogs(
    String token,
    OrderModel orderModel,
    String printerType,
    String status,
    String filePath,
    String jobId,
    String receiptType) async {
  ApiResponse apiResponse;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse("https://fooduat.eatsbee.com/backoffice/apibackendmobile/print_logs_store"),
  );

  // Add headers
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Content-Type': 'multipart/form-data', 
  });

// vinay@eatsbee/Vny123##
  // Add JSON fields
  request.fields['order_id'] = orderModel.orderData.orderId;
  request.fields['merchant_id'] = orderModel.orderData.merchantId;
  request.fields['printer_type'] = printerType;
  request.fields['status'] = status;
  request.fields['job_id'] = jobId;
  request.fields['receipt_type'] = receiptType;
  if(receiptType=="kitchen"){
  request.fields['printer_number'] = AppProvider.defaultKitchenPrinterID;
  }
  if(receiptType=="client"){
  request.fields['printer_number'] = AppProvider.defaultClientPrinterID;
  }


  // Attach the file
  if (filePath.isNotEmpty) {
    var file = await http.MultipartFile.fromPath('file', filePath);
    request.files.add(file);
  }

  // Send request
  var response = await request.send();

  // Read response
  var responseData = await http.Response.fromStream(response);
  debugPrint("[PrinterLogs] response data is ${responseData.body} and ${responseData.statusCode}");

  if (response.statusCode == 200) {
    debugPrint("[PrinterLogs] Success: ${responseData.body}");
    return ApiResponse(responseData, null, null);
  } else {
    debugPrint("[PrinterLogs] Error: ${responseData.body}");
    return ApiResponse.withError("Error: ${responseData.statusCode}");
  }
}


///update printer logs
Future<ApiResponse> updatePrinterLogs(
    String token,
    String status,
    String printerLogId) async {
  ApiResponse apiResponse;

    var data = jsonEncode({
    "job_id":printerLogId,
    "status":status,
   });

    var response = await http.post(Uri.parse(IPConfigurations.updateLogs),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
}



////////////////// add Printers
    Future<ApiResponse> addPrinters(String token, PrinterModal printerModal)async{
    ApiResponse apiResponse;

    var data = jsonEncode({
      "merchant_id": printerModal.merchantId,
      "printer_name": printerModal.printerName,
      "printer_model": printerModal.printerType,
      "device_uuid": printerModal.deviceUuid,
      "auto_print": printerModal.autoPrint,
      "service_id": printerModal.serviceId,
      "characteristics": "",
      "ip_address": printerModal.ipAddress
    });

    var response = await http.post(Uri.parse("https://fooduat.eatsbee.com/backoffice/apibackendmobile/print_store"),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    debugPrint("[addPrinters]   response is ${response.body}");

    if(response.body.isNotEmpty){
    debugPrint("[addPrinters] in app_repo ,response.body is $response");
      
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
    debugPrint("[addPrinters] in app_repo error");
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  /// get printers
  Future<ApiResponse> getPrinters(String token,String merchantId)async{
    ApiResponse apiResponse;
    var response = await http.get( Uri.parse("${IPConfigurations.getPrinters}?merchant_id=$merchantId"),

    // var response = await http.get( Uri.parse(IPConfigurations.getPrinters),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':'application/json'
        }
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  //delete printer data
  Future<ApiResponse> deletePrinter(String token, String printerId,String printerName)async{
    ApiResponse apiResponse;
    var data = jsonEncode({
    "action":"delete",
    "printer_id":printerId,
     "printer_name":printerName
   });

    var response = await http.post(Uri.parse(IPConfigurations.delUpPrinter),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

    //delete/update printer data
  Future<ApiResponse> updatePrinter(String token, PrinterModal printerModal)async{
    ApiResponse apiResponse;
    var data = jsonEncode({
    "action":"update",
    "printer_id":printerModal.printerId,
     "printer_name":printerModal.printerName
   });

    var response = await http.post(Uri.parse(IPConfigurations.delUpPrinter),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  ///update  ordering status to available
Future<ApiResponse> updateOrderingStatus(
    String token,
    String merchantId,
    bool accepting) async {
  ApiResponse apiResponse;

    var data = jsonEncode({
    "merchant_id":merchantId,
    "accepting_order": "true",
   });

    var response = await http.post(Uri.parse(IPConfigurations.availabilityStatus),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
}

///pause ordering (unavailable)
Future<ApiResponse> updateOrderingStatusUnAval(
    String token,
    String merchantId,
   String reason ) async {
  ApiResponse apiResponse;

    var data = jsonEncode({
    "merchant_id":merchantId,
    "accepting_order":"false",
    "reason":reason
   });

    var response = await http.post(Uri.parse(IPConfigurations.availabilityStatus),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
}

///pause ordering (unavailable till)
    Future<ApiResponse> pauseOrderingStatus(
    String token,
    String merchantId,
    int pauseHrs,
    int pauseMins,
    String reason,
    String delayTime
    ) async {
  ApiResponse apiResponse;
    var data = jsonEncode({
    "merchant_id": merchantId,
    "pause_hours": "$pauseHrs",
    "pause_minutes": "$pauseMins",
    "reason": reason,
    "time_delay": delayTime
 });
 
 debugPrint("recieved values are merchantId $merchantId,pauseHrs $pauseHrs ,pauseMins $pauseMins ,reason $reason ,delayTime $delayTime");
    var response = await http.post(Uri.parse(IPConfigurations.pauseOrderStatus),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
}

  /// get ordering status
  Future<ApiResponse> getOrderingStatus(String token,String merchantId)async{
    ApiResponse apiResponse;
    var response = await http.get( Uri.parse("${IPConfigurations.getOrderingStatus}?merchant_id=$merchantId"),

    // var response = await http.get( Uri.parse(IPConfigurations.getPrinters),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':'application/json'
        }
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }
////////////////
  /// get ordering status
  Future<ApiResponse> getPauseStatusData(String token,String merchantId)async{
    ApiResponse apiResponse;
    var response = await http.get( Uri.parse("${IPConfigurations.getPauseStatusData}?merchant_id=$merchantId"),

    // var response = await http.get( Uri.parse(IPConfigurations.getPrinters),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':'application/json'
        }
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
     }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }



// get default printer
    Future<ApiResponse> getdefaultPrinter(String token,String merchantId,String receiptType)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse("${IPConfigurations.getDefaultPrinter}?merchant_id=$merchantId&type=$receiptType"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':'application/json'
        }
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

//set default printer
  Future<ApiResponse> setDefaultPrinter(
    String token,
    String merchantId,
    String printerId,
    String receiptType) async {
  ApiResponse apiResponse;

    var data = jsonEncode({
    "merchant_id":merchantId,
    "printer_id":printerId,
    "type":receiptType
   });

    var response = await http.post(Uri.parse(IPConfigurations.setDefaultPrinter),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
}


 // getTimezone
 Future<ApiResponse> getTimeZone(String token,String merchantId)async{
    ApiResponse apiResponse;
    var response = await http.get(Uri.parse("${IPConfigurations.getTimezone}?merchant_id=$merchantId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':'application/json'
        }
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

//verify 2fa code
  Future<ApiResponse> verify2Fa(String uuid, String code)async{
    ApiResponse apiResponse;
    debugPrint("uuid in repo is $uuid  and code is $code");
    var data = jsonEncode({"user_uuid":uuid,"code":code});

    var response = await http.post(Uri.parse(IPConfigurations.verify2fa),
        /*headers: {
          'Authorization': 'Bearer ${userModel.authToken}',
        }*/
        body: data
    );

    //log("Index number is: ");
    
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      debugPrint("response body is ${response.body}");
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      debugPrint("response status code is ${response.statusCode} ");

      return apiResponse;
    }
  }

////get notifications
// menu fetching Api
Future<ApiResponse> getNotifications(String token) async {
  ApiResponse apiResponse;
  try {
    var response = await http.get(
      Uri.parse(IPConfigurations.getNotifi),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      apiResponse = ApiResponse.withSuccess(response);
    } else {
      apiResponse = ApiResponse.withError("Error: ${response.statusCode}");
    }
  } catch (e) {
    apiResponse = ApiResponse.withError("Exception: $e");
  }

  return apiResponse;
}

//delete notif
  Future<ApiResponse> deleteNotif(String token)async{
    ApiResponse apiResponse;
    var response = await http.post(Uri.parse(IPConfigurations.clearNotif),
        headers: {
          'Authorization': 'Bearer $token',
        },
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
  }

  //read notification
  Future<ApiResponse> readNotif(String notiUuid ,String authToken)async{
    ApiResponse apiResponse;
  
    var data = jsonEncode({"notification_uuid":notiUuid});

    var response = await http.post(Uri.parse(IPConfigurations.readNotif),
       headers: {
          'Authorization': 'Bearer $authToken',
        },
        body: data
    );

    //log("Index number is: ");
    
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      debugPrint("response body is ${response.body}");
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      debugPrint("response status code is ${response.statusCode} ");

      return apiResponse;
    }
  }


  ///update order print status
Future<ApiResponse> printStatusUpdate(
    String token,
    String orderUUId,
    String isPrint) async {
  ApiResponse apiResponse;

    var data = jsonEncode({
    "order_uuid":orderUUId,
    "is_print":isPrint,
   });

    var response = await http.post(Uri.parse(IPConfigurations.printStatusUpdate),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data
    );
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
      return apiResponse;
    }
}
}