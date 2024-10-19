import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utilities/base/api_response.dart';
import '../utilities/ip_configurations.dart';
//import 'dart:developer';

class AppRepo{

  /// Login API
  Future<ApiResponse> userLogin(String username, String password)async{
    ApiResponse apiResponse;

    //var call=IPConfigurations.serverIp;
    //log('serverIp: $call');
    var data = jsonEncode({"username":username,"password":password});

    var response = await http.post(Uri.parse(IPConfigurations.userLogin),
        /*headers: {
          'Authorization': 'Bearer ${userModel.authToken}',
        }*/
        body: data
    );

    //log("Index number is: ");
    
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

    var data = jsonEncode({
      "order_uuid" : orderUUID,
      "delivery_date" : date,
      "delivery_time" : time
    });

    var response = await http.post(Uri.parse(IPConfigurations.acceptOrders),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':'application/json'
        },
        body: data
    );

    //print("Index Respo Data: "+data.toString());
    //print("Index Respo: "+response.body.toString());
    //var api=ApiResponse(response,null,null);
    //print("Index Respo V2: "+api.toString());
    if(response.body.isNotEmpty){
      apiResponse = ApiResponse(response,null,null);
      return apiResponse;
    }else{
      apiResponse = ApiResponse.withError("Error");
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
    //print('Ready'+response.toString());
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
}