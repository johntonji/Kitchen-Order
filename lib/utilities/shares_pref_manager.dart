import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SharedPreferenceManager {

  late SharedPreferenceManager instance;
  SharedPreferenceManager.getInstance();

  static String username = "username";
  static String authToken = "user_token";
  static String userUniqueId = "user_uuid";
  static String userFirstName = "first_name";
  static String userLastName = "last_name";
  static String userPhoneNumber = "contact_number";
  static String userAvatar = "avatar";
  static String userAddress = "address";
  static String userMerchantId = "merchantId";
  static String logo = "logo";

  static String printersWifi = "printersWifi";
  static String alertDuration="alertDuration";

Future<void> saveAlertDuration(int duration) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(alertDuration, duration.toString());
}

Future<int> getAlertDuration()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String duration= prefs.getString(alertDuration)!;
   return  int.parse(duration);
}

//printers data
Future<void> savePrinterList(List<Map<String, String>> printerList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Convert List<Map<String, String>> to JSON String
  String jsonString = jsonEncode(printerList);
  await prefs.setString(printersWifi, jsonString);
}

Future<List<Map<String, String>>> getPrinterList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Get the JSON String from SharedPreferences
  String? jsonString = prefs.getString(printersWifi);

  if (jsonString == null) {
    debugPrint("No printers found in storage.");
    return [];
  }
  // Convert JSON String back to List<Map<String, String>>
  List<dynamic> jsonList = jsonDecode(jsonString);
  List<Map<String, String>> printerList = jsonList.map((e) => Map<String, String>.from(e)).toList();
  return printerList;
}
   clearPrinters() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(printersWifi);
  }

////userdata

  void saveUserData(UserModel userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    prefs.setString(username, userModel.username ?? "");
    prefs.setString(authToken, userModel.authToken ?? "");
    prefs.setString(userUniqueId, userModel.userUuid ?? "");
    prefs.setString(userFirstName, userModel.firstName ?? "");
    prefs.setString(userLastName, userModel.lastName ?? "");
    prefs.setString(userPhoneNumber, userModel.contactNumber ?? "");
    prefs.setString(userAvatar, userModel.avatar ?? "");
    prefs.setString(userAddress, userModel.address ?? "");
    prefs.setString(userMerchantId, userModel.merchantId ?? "");

   Response response = await get(Uri.parse(userModel.logo!));
  // 68d415a6-3faf-11f0-8119-6045bdeee9b0@thumbnail.png
  // 43b9f3b8-fbd0-11ee-b44a-7c1e520be675.jpeg
// ".com/${userModel.path}/${userModel.logo}"

  if(response.statusCode == 200){
    print("response of getting image is ${response.body}");
    saveImage(response.bodyBytes);
  }else{ 
    debugPrint("error unable to save logo ${response.body}");
  }
    // prefs.setString(logo, userModel.logo ?? "");
  }

static Future<bool> saveImage(List<int> imageBytes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    return   prefs.setString(logo, base64Image );
    // prefs.setString("image", base64Image);
  }

  static Future<Image> getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Uint8List bytes = base64Decode(prefs.getString("image")!);
    return Image.memory(bytes);
  }

  Future<UserModel> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      return UserModel(
        username: prefs.getString(username),
        authToken: prefs.getString(authToken),
        userUuid: prefs.getString(userUniqueId),
        firstName: prefs.getString(userFirstName),
        lastName: prefs.getString(userLastName),
        contactNumber: prefs.getString(userPhoneNumber),
        avatar: prefs.getString(userAvatar),
        address: prefs.getString(userAddress),
        merchantId: prefs.getString(userMerchantId),
        logo: prefs.getString(logo),
        // wifiPrinters: prefs.getStringList(wifiPrinters)
      );
    }catch(exception){
      return UserModel.getInstance();
    }
  }

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(authToken) ?? "";
  }



  Future<String> clearAllPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(authToken);
    prefs.remove(userUniqueId);
    prefs.remove(userFirstName);
    prefs.remove(userLastName);
    prefs.remove(userPhoneNumber);
    prefs.remove(userAvatar);
    prefs.remove(userAddress);
    prefs.remove(userMerchantId);
    prefs.remove(logo);
    prefs.remove("ReceiptTemplateList");
    prefs.remove("processedOrderList");
    prefs.remove("newOrderList");

    return "Cleared";
  }



  ///////////// save reciept templates

Future<void> addToReceiptList(String newReceipt) async {
  debugPrint("[addToReceipList] name is $newReceipt");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Get the existing list (if available)
  String? jsonString = prefs.getString('ReceiptTemplateList');
  
  List<String> receiptList = [];
  
  if (jsonString != null) {
    // Decode existing JSON to List
    receiptList = List<String>.from(jsonDecode(jsonString));
  }
  
  // Add the new printer
  if (!receiptList.contains(newReceipt)) {  // Avoid duplicates
    receiptList.add(newReceipt);
  }
  
  // Save the updated list back to SharedPreferences
  try{
    await prefs.setString('ReceiptTemplateList', jsonEncode(receiptList));
    debugPrint("[addToReceipList] saved successfully");
  }catch(e){
    debugPrint("[addToReceipList] could not save: $e");
  }
}

Future<List<String>> getReceiptTemplateList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  String? jsonString = prefs.getString('ReceiptTemplateList');
  
  if (jsonString != null) {
    return List<String>.from(jsonDecode(jsonString));
  }
  return []; // Return an empty list if no data exists
}

Future<void> deleteFromReceiptList(String newReceipt) async {
  debugPrint("[addToReceipList] name is $newReceipt");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Get the existing list (if available)
  String? jsonString = prefs.getString('ReceiptTemplateList');
  
  List<String> receiptList = [];
  
  if (jsonString != null) {
    // Decode existing JSON to List
    receiptList = List<String>.from(jsonDecode(jsonString));
  }
  
  // remove receipt name 
  if (receiptList.contains(newReceipt)) {  // Avoid duplicates
    receiptList.remove(newReceipt);
    prefs.remove(newReceipt);   // remove receipt data
  }
  
  // Save the updated list back to SharedPreferences
  try{
  await prefs.setString('ReceiptTemplateList', jsonEncode(receiptList));
  debugPrint("[addToReceipList] saved successfully");
 }
catch(e){
  debugPrint("[addToReceipList] could not save: $e");
}
}

///
  Future<void> saveReceiptData(Map<String, dynamic> recieptMap,String receiptName) async {
    debugPrint("[saveReceiptData] name is $receiptName");
    addToReceiptList(receiptName);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  String jsonString = jsonEncode(recieptMap);
  try{
  await prefs.setString(receiptName, jsonString);
  debugPrint("[saveReceiptData] saved successfully");

  }catch(e){
  debugPrint("[saveReceiptData] could not save $e");

  }
}

Future<Map<String, dynamic>?> getReceiptData(String receiptName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Get the JSON string from SharedPreferences
  String? jsonString = prefs.getString(receiptName);
  
  if (jsonString != null) {
    // Convert the JSON string back to a Map
    return jsonDecode(jsonString);
  }
  return null; // Return null if no data exists
}

  ////fun for auto accept order autoPrint
///saved processed orders in ready orders list 
Future<void> saveProcessedOrderList(List<OrderModel> orderList) async {
  final prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(orderList.map((model) => model.toJson()).toList());
  await prefs.setString('processedOrderList', jsonString).then((onValue){
    print("[saveProcessedOrderList] called");
  });
 }

// Future<void> addToProcessedOrderList(OrderModel newItem) async {
//   final prefs = await SharedPreferences.getInstance();
//   String? jsonString = prefs.getString('processedOrderList');

//   if (jsonString != null) {
//     List<dynamic> jsonList = jsonDecode(jsonString);
//     // print("[getProcessedOrderList] called ,list is ${jsonList.map((json) => OrderModel.fromJson(json)).toList()}");
//     List<OrderModel> orderList= jsonList.map((json) => OrderModel.fromJson(json)).toList();
//     orderList.add(newItem);
//   }
//  }

Future<void> addToProcessedOrderList(OrderModel newOrder) async {
  final prefs = await SharedPreferences.getInstance();

  // Get existing orders
  String? jsonString = prefs.getString('processedOrderList');
  List<OrderModel> existingOrders = [];

  if (jsonString != null) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    existingOrders = jsonList.map((e) => OrderModel.fromJson(e)).toList();
  }

  // Check for duplicates before adding
  bool alreadyExists = existingOrders.any((order) => order.orderData.orderId == newOrder.orderData.orderId);

  if (!alreadyExists) {
    existingOrders.add(newOrder);

    // Save updated list
    String updatedJson = jsonEncode(existingOrders.map((e) => e.toJson()).toList());
    await prefs.setString('processedOrderList', updatedJson);

    debugPrint("[addToProcessedOrderList] Added order #${newOrder.orderData.orderId}");
  } else {
    debugPrint("[addToProcessedOrderList] Order already exists: #${newOrder.orderData.orderId}");
  }
}

Future<void> printListsValues()async{
  List<String> idList1=[];
  List<String> idList2=[];
    final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('processedOrderList');
   if (jsonString != null) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    // print("[getNewOrderList] called ,list is ${jsonList.map((json) => OrderModel.fromJson(json)).toList()}");
   List<OrderModel> m=  jsonList.map((json) => OrderModel.fromJson(json)).toList();
   for(OrderModel o in m){
    idList1.add(o.orderData.orderId);
   }
  print("[sharedPref] processedOrderList is $idList1");

  }

    String? jsonString2 = prefs.getString('newOrderList');
      if (jsonString2 != null) {
    List<dynamic> jsonList = jsonDecode(jsonString2);
    // print("[getNewOrderList] called ,list is ${jsonList.map((json) => OrderModel.fromJson(json)).toList()}");
   List<OrderModel> m=  jsonList.map((json) => OrderModel.fromJson(json)).toList();
   for(OrderModel o in m){
    idList2.add(o.orderData.orderId);
   }
    print("[sharedPref] newOrderList is $idList2");
  }
}

/// get it 
 Future<List<OrderModel>> getProcessedOrderList() async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('processedOrderList');

  if (jsonString != null) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    print("[getProcessedOrderList] called ,list is ${jsonList.map((json) => OrderModel.fromJson(json)).toList()}");
    return jsonList.map((json) => OrderModel.fromJson(json)).toList();
  }
  return [];
}

//save newly autoaccepted orders
Future<void> saveNewOrderList(List<OrderModel> orderList) async {
  print("[saveNewOrderList] called for #${orderList.first.orderData.orderId}");
  
  final prefs = await SharedPreferences.getInstance();
  List<OrderModel> processedList = await getProcessedOrderList();

  // Collect all processed order IDs for quick lookup
  final processedIds = processedList.map((p) => p.orderData.orderId).toSet();

  // Remove all orders from orderList that are already processed
  orderList.removeWhere((order) => processedIds.contains(order.orderData.orderId));

  print("Remaining orders: ${orderList.map((o) => o.orderData.orderId).toList()}");

  // Save filtered list to SharedPreferences
  String jsonString = jsonEncode(orderList.map((model) => model.toJson()).toList());
  await prefs.setString('newOrderList', jsonString);
}

/* Future<void> saveNewOrderList(List<OrderModel> orderList) async {

  print("[saveNewOrderList] called for #${orderList.first.orderData.orderId}");
  final prefs = await SharedPreferences.getInstance();
  List<OrderModel> processedList = await getProcessedOrderList();
    for(OrderModel order in orderList){
      for(OrderModel processed in processedList){
       if( processed.orderData.orderId==order.orderData.orderId){
        print("removed order ${order.orderData.orderId}");
        orderList.remove(order);
       }
    }
  }
  String jsonString = jsonEncode(orderList.map((model) => model.toJson()).toList());
  await prefs.setString('newOrderList', jsonString);
 } */

Future<void> addSingleOrderToNewOrderList(OrderModel newOrder) async {
  final prefs = await SharedPreferences.getInstance();

  // Get existing orders
  String? jsonString = prefs.getString('newOrderList');
  List<OrderModel> existingOrders = [];

  if (jsonString != null) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    existingOrders = jsonList.map((e) => OrderModel.fromJson(e)).toList();
  }

  // Check for duplicates before adding
  bool alreadyExists = existingOrders.any((order) => order.orderData.orderId == newOrder.orderData.orderId);

  if (!alreadyExists) {
    existingOrders.add(newOrder);

    // Save updated list
    String updatedJson = jsonEncode(existingOrders.map((e) => e.toJson()).toList());
    await prefs.setString('newOrderList', updatedJson);

    debugPrint("[addSingleOrderToNewOrderList] Added order #${newOrder.orderData.orderId}");
  } else {
    debugPrint("[addSingleOrderToNewOrderList] Order already exists: #${newOrder.orderData.orderId}");
  }
}


//get them 
 Future<List<OrderModel>> getNewOrderList() async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('newOrderList');

  if (jsonString != null) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    print("[getNewOrderList] called ,list is ${jsonList.map((json) => OrderModel.fromJson(json)).toList()}");
    return jsonList.map((json) => OrderModel.fromJson(json)).toList();
  }
  return [];
}

//  Future<void> removeFromNewOrderList(String orderUuid) async {
//   final prefs = await SharedPreferences.getInstance();
//   String? jsonString = prefs.getString('newOrderList');

//   if (jsonString != null) {
//     List<dynamic> jsonList = jsonDecode(jsonString);  // getcurrent saved List 
//      jsonList.removeWhere((item) => item.orderData.orderUuid == orderUuid); //remove item form list
//      prefs.remove('newOrderList');  //remove from shared pref

//     String jsonString2 = jsonEncode(jsonList.map((model) => model.toJson()).toList()); 
//     await prefs.setString('newOrderList', jsonString2);  // save new list in shared prefs
//   }
// }

Future<void> removeFromNewOrderList(String orderUuid) async {
  final prefs = await SharedPreferences.getInstance();

  // Step 1: Load and decode newOrderList
  String? jsonString = prefs.getString('newOrderList');
  if (jsonString == null) return;

  List<dynamic> jsonList = jsonDecode(jsonString);
  List<OrderModel> newOrderList =
      jsonList.map((item) => OrderModel.fromJson(item)).toList();

  // Step 2: Find the item to move
OrderModel? itemToMove;
try {
  itemToMove = newOrderList.firstWhere(
    (item) => item.orderData.orderUuid == orderUuid,
  );
} catch (e) {
  itemToMove = null;
}

  if (itemToMove != null) {
    // Step 3: Remove it from newOrderList
    newOrderList.removeWhere((item) => item.orderData.orderUuid == orderUuid);

    // Step 4: Load and decode processedOrderList (if it exists)
    String? processedJson = prefs.getString('processedOrderList');
    List<OrderModel> processedOrderList = [];

    if (processedJson != null) {
      List<dynamic> processedJsonList = jsonDecode(processedJson);
      processedOrderList =
          processedJsonList.map((item) => OrderModel.fromJson(item)).toList();
    }

    // Step 5: Add the removed item to processed list
    processedOrderList.add(itemToMove);

    // Step 6: Save updated newOrderList
    String updatedNewJson =
        jsonEncode(newOrderList.map((model) => model.toJson()).toList());
    await prefs.setString('newOrderList', updatedNewJson);

    // Step 7: Save updated processedOrderList
    String updatedProcessedJson =
        jsonEncode(processedOrderList.map((model) => model.toJson()).toList());
    await prefs.setString('processedOrderList', updatedProcessedJson);

    debugPrint("[removeFromNewOrderList] Moved $orderUuid to processedOrderList");
  } else {
    debugPrint("[removeFromNewOrderList] Order not found: $orderUuid");
  }
}


}