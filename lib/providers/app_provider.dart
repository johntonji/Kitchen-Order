import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import '../repositories/app_repo.dart';
import '../utilities/base/api_response.dart';
import '../utilities/base/response_model.dart';

class AppProvider with ChangeNotifier{
  AppRepo appRepo;
  AppProvider({required this.appRepo});
  bool progress = false;
  bool newProgress = false;
  bool processingProgress = false;
  bool readyProgress = false;
  bool allProgress = false;

  List<OrderModel> newOrdersList = [];
  List<OrderModel> processingOrdersList = [];
  List<OrderModel> readyOrdersList = [];
  List<OrderModel> allOrdersList = [];

  Future<ResponseModel> userLogin(String username, String password)async{
    progressStart();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.userLogin(username, password);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 2){
          UserModel userModel = UserModel(
              authToken: parsedResponse["details"]["user_token"],
              userUuid: parsedResponse["details"]["user_data"]["user_uuid"],
              firstName: parsedResponse["details"]["user_data"]["first_name"],
              lastName: parsedResponse["details"]["user_data"]["last_name"],
              emailAddress: parsedResponse["details"]["user_data"]["email_address"],
              contactNumber: parsedResponse["details"]["user_data"]["contact_number"],
              avatar: parsedResponse["details"]["user_data"]["avatar"]
          );
          SharedPreferenceManager.getInstance().saveUserData(userModel);
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

  /// New Orders
  Future<ResponseModel> newOrders(String token)async{
    newProgress = true;
    newOrdersList.clear();
    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.newOrders(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          parsedResponse["details"]["data"].forEach((element) {
            OrderModel model = OrderModel.fromJson(element);
            newOrdersList.add(model);
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: int.parse(model.orderData!.orderId!),
                  channelKey: 'basic_channel',
                  actionType: ActionType.Default,
                  title: 'New Order!',
                  body: 'You have a new order with the order No: ${model.orderData!.orderId}',
                )
            );
          });

          print("______: ${newOrdersList.length}");

          responseModel = ResponseModel(true, parsedResponse["msg"]);
        }else{
          responseModel = ResponseModel(false, parsedResponse["msg"]);
        }

      } else {
        responseModel = ResponseModel(false, "Something went wrong");
      }

      newProgress = false;
      notifyToProvider();
      return responseModel;
    }catch(exception){
      responseModel = ResponseModel(false, "Something went wrong");
      newProgress = false;
      notifyToProvider();
      return responseModel;
    }
  }
  Future<ResponseModel> autoNewOrders(String token)async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.newOrders(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          parsedResponse["details"]["data"].forEach((element) {
            OrderModel model = OrderModel.fromJson(element);
            int index = newOrdersList.indexWhere((item) => item.orderData!.orderId == model.orderData!.orderId);
            if(-1 == index){
              newOrdersList.add(OrderModel.fromJson(element));
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: int.parse(model.orderData!.orderId!),
                    channelKey: 'basic_channel',
                    actionType: ActionType.Default,
                    title: 'New Order!',
                    body: 'You have a new order with the order No: ${model.orderData!.orderId}',
                  )
              );
            }
          });

          print("______: ${newOrdersList.length}");

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
  Future<ResponseModel> processingOrders(String token)async{
    processingProgress = true;
    processingOrdersList.clear();
    notifyListeners();
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.processingOrders(token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          parsedResponse["details"]["data"].forEach((element) {
            processingOrdersList.add(OrderModel.fromJson(element));
          });

          print("______: ${processingOrdersList.length}");

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
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          parsedResponse["details"]["data"].forEach((element) {
            OrderModel model = OrderModel.fromJson(element);
            int index = processingOrdersList.indexWhere((item) => item.orderData!.orderId == model.orderData!.orderId);
            if(-1 == index){
              processingOrdersList.add(OrderModel.fromJson(element));
            }
          });

          print("______: ${processingOrdersList.length}");

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
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          parsedResponse["details"]["data"].forEach((element) {
            readyOrdersList.add(OrderModel.fromJson(element));
          });

          print("______: ${readyOrdersList.length}");

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
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          parsedResponse["details"]["data"].forEach((element) {
            OrderModel model = OrderModel.fromJson(element);
            int index = readyOrdersList.indexWhere((item) => item.orderData!.orderId == model.orderData!.orderId);
            if(-1 == index){
              readyOrdersList.add(OrderModel.fromJson(element));
            }
          });

          print("______: ${readyOrdersList.length}");

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
        allOrdersList.sort((a, b) => a.orderData!.orderId!.compareTo(b.orderData!.orderId!));
      }
      allOrdersList = allOrdersList.where((item) => daysBetween(DateTime.parse(item.orderData!.dateCreated!), DateTime.now()) <= comparisonDays ).toList();

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
  Future<ResponseModel> acceptOrder(String token, String orderUUID, String date, String time)async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.acceptOrder(token, orderUUID, date, time);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
          newOrdersList.removeWhere((item) => item.orderData!.orderUuid == orderUUID);
          processingOrders(token);
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

  /// Cancel Orders
  Future<ResponseModel> cancelOrder(String token, String orderUUID, String amount, String reason, String status, String requestFrom)async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.cancelOrder(token, orderUUID, amount, reason, status);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        print(parsedResponse);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
          newOrdersList.removeWhere((item) => item.orderData!.orderUuid == orderUUID);
          if(requestFrom == "new"){
            newOrders(token);
          }else if(requestFrom == "preparing"){
            processingOrders(token);
          } else{
            readyOrders(token);
          }
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

  /// Ready For Pickup Orders
  Future<ResponseModel> readyForPickupOrder(String token, String orderUUID)async{
    ResponseModel responseModel;
    try {
      ApiResponse apiResponse = await appRepo.readyForPickupOrder(token, orderUUID);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var parsedResponse = jsonDecode(apiResponse.response!.body);
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
          processingOrdersList.removeWhere((item) => item.orderData!.orderUuid == orderUUID);
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
        if(parsedResponse["code"] == 200 || parsedResponse["code"] == 1){
          responseModel = ResponseModel(true, parsedResponse["msg"]);
          readyOrdersList.removeWhere((item) => item.orderData!.orderUuid == orderUUID);
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