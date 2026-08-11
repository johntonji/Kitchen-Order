import 'dart:typed_data';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:intl/intl.dart';
import 'package:order_receiving/main.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/ui/printing/editable_template/demo_pdf_client.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;


String formatToTwoDecimals(dynamic value) {
  double number;

  if (value is String) {
    number = double.tryParse(value) ?? 0.0;
  } else if (value is num) {
    number = value.toDouble();
  } else {
    throw ArgumentError("Value must be a String or num");
  }

  return number.toStringAsFixed(2);
}

  // to format date
  String formatDateTime(String inputDateTime) {
    print("inside format time is $inputDateTime");
  DateTime dateTime = DateTime.parse(inputDateTime);
  String formattedDate = DateFormat("MMMM d 'at' hh:mm a").format(dateTime);
  return formattedDate;
}
String formatAcceptanceTime(String inputDateTime) {
  print("formatAcceptanceTime is $inputDateTime");
  DateTime dateTime = DateTime.parse(inputDateTime);
  print("parsed datetime (UTC) is $dateTime");
  
  // Convert to local time
  DateTime localDateTime = dateTime.toLocal();
  print("local datetime is $localDateTime");
  
  String formattedDate = DateFormat("MMMM d 'at' hh:mm a").format(localDateTime);
  print("formatted date time is $formattedDate");
  
  return formattedDate;
}

//   String formatDateTime2(String inputDateTime) {
//   DateTime dateTime = DateTime.parse(inputDateTime);
//   String formattedDate = DateFormat("MMMM d yyyy 'at' hh:mm a").format(dateTime);
//   return formattedDate;
// }
String formatDateTime2(String? inputDateTime) {
  if (inputDateTime == null ||
      inputDateTime.isEmpty ||
      inputDateTime == "null") {
    return "";
  }

  try {
    DateTime dateTime = DateTime.parse(inputDateTime);
    return DateFormat("MMMM d yyyy 'at' hh:mm a")
        .format(dateTime);
  } catch (e) {
    return "";
  }
}

String formatDateTimeNoYear(String? inputDateTime) {
  if (inputDateTime == null ||
      inputDateTime.isEmpty ||
      inputDateTime == "null") {
    return "";
  }

  try {
    DateTime dateTime = DateTime.parse(inputDateTime);
    return DateFormat("MMMM d 'at' hh:mm a")
        .format(dateTime);
  } catch (e) {
    return "";
  }
}

  String formatDate(String inputDateTime) {
  DateTime dateTime = DateTime.parse(inputDateTime);
  String formattedDate = DateFormat("MMMM d").format(dateTime);
  return formattedDate;
}

String addMinutesToTime(String timeString, int minutesToAdd) {
  try{
     DateTime dateTime = DateTime.parse(timeString);
  // Add minutes
  DateTime updatedTime = dateTime.add(Duration(minutes: minutesToAdd));
  // Return updated time as string
  return formatDateTime(updatedTime.toString()); // or use format if you want custom format
  }catch(e){
    print("exception in addMinutesToTime is $e");
    return formatDateTime(DateTime.now().toString());
  }
 
}


//format time
// int timeToMinutes(String time) {
//   try{
//   List<String> parts = time.split(":"); // Split "01:10" into ["01", "10"]
//   int hours = int.parse(parts[0]);      // Convert "01" to 1
//   int minutes = int.parse(parts[1]);    // Convert "10" to 10
//   return (hours * 60) + minutes;        // Calculate total minutes
//   }catch(e){
//     print("exception in hours to mins is $e");
//     return 0;
//   }

// }
int timeToMinutes(String time) {
  print("delivery time in this is $time");
  try {
    time = time.trim(); // Remove any leading/trailing whitespace
    List<String> parts = time.split(":");

    if (parts.length < 2) {
      return 0;
    }

    int hours = int.parse(parts[0].trim());
    int minutes = int.parse(parts[1].trim());

  return (hours * 60) + minutes;
  } catch (e) {
    print("exception in hours to mins is $e");
    return 0;
  }
}

///return time as in minutes or hours
String formatMinutesTo(String minutesStr) {
  final int minutes = int.tryParse(minutesStr) ?? 0;

  if (minutes < 60) {
    return '$minutes min';
  }

  final int hours = minutes ~/ 60;
  final int remainingMinutes = minutes % 60;

  if (remainingMinutes == 0) {
    return '$hours hr';
  }

  return '$hours hr $remainingMinutes min';
}

// String formatAddress(String address) {
//   List<String> parts = address.split(', ');

//   if (parts.length < 3) return address; // Return as-is if it's too short

//   String line1 = parts.take(2).join(', '); 
//   String line2 = parts.skip(2).take(2).join(', '); 
//   String line3 = parts.skip(4).join(', ');

//   return "$line1\n$line2\n$line3";
// }
String formatAddress(String address) {
  List<String> parts = address.split(', ').map((p) => p.trim()).toList();

  if (parts.length < 3) return address; // Return as-is if too short

  // Always remove the last part (assumed to be country)
  parts.removeLast();

  String line1 = parts.take(2).join(', ');
  String line2 = parts.skip(2).take(2).join(', ');
  String line3 = parts.skip(4).join(', ');

  // Remove empty lines if any
  return [line1, line2, line3].where((line) => line.isNotEmpty).join('\n');
}


String PlaceName(String address) {
  List<String> parts = address.split(', ');
  if (parts.length < 3) return address; 
  String line1 = parts.take(2).join(', '); 
  return "$line1";
}
String removeCountry(String address) {
  List<String> parts = address.split(', ').map((p) => p.trim()).toList();

  if (parts.length <= 1) return address; // nothing to remove

  // Remove last part (assumed to be country)
  parts.removeLast();

  return parts.join(', ');
}



String getLastTwoDigits(String input) {
  // Remove non-digit characters
  String digitsOnly = input.replaceAll(RegExp(r'\D'), '');

  // Check if there are at least two digits
  if (digitsOnly.length < 4) {
    return digitsOnly; // Return whatever is available
  }

  return digitsOnly.substring(digitsOnly.length - 4);
}
Future<String> dynClientPdfGenerate(
    OrderModel orderModal, //order data

    String previewOrdersVal,
    String previewTimesVal,
    String previewPaymentsVal,
    int blankLinesVal,
    InfoBox1Model infoBox1Model,
    InfoBox2Model infoBox2Model,

    PaymentMethodModel paymentMethodModel,
    OrderDetailsModel orderDetailsModel,
    DirectionModel directionModel,
    ClientInfoModel clientInfoModel,
    ItemsModel itemsModel,
    ContactDetailsModel contactDetailsModel,
    ClientConfirmationModel clientConfirmationModel,
    int timeTitleSize,
    int clientCommentSize,
    int isPaidTitleSize,
    int orderOnlineTitleSize,
    String premiseTypeVal,
    String otherPremise,
    String premiseTypeFinalVal,
    List<String> finalCompList) async {
       print("accepted at time in client pdf is ${orderModal.orderData.acceptedAt}");
  print("component list in function is $finalCompList");
  try {
    final pdf = pw.Document();

  print("card details are is ${orderModal.customer.toJson()}");
    // Load the icon image

 UserModel userModel = UserModel.getInstance();
  SharedPreferenceManager.getInstance().getUserData().then((value) {
      userModel = value;
    });
    //comment
    final ByteData commentImageData =
        await rootBundle.load('assets/icons/comment.png');
    final Uint8List commentImageBytes = commentImageData.buffer.asUint8List();
    final pw.ImageProvider commentImage = pw.MemoryImage(commentImageBytes);

    //circularChecked
    final ByteData circularCheckedImageData =
        await rootBundle.load('assets/icons/circular_checked.png');
    final Uint8List circularCheckedImageBytes =
        circularCheckedImageData.buffer.asUint8List();
    final pw.ImageProvider circularCheckedImage =
        pw.MemoryImage(circularCheckedImageBytes);

    //circularUnchecked
    final ByteData circularUncheckedImageData =
        await rootBundle.load('assets/icons/circular_uncheck.png');
    final Uint8List circularUncheckedImageBytes =
        circularUncheckedImageData.buffer.asUint8List();
    final pw.ImageProvider circularUncheckedImage =
        pw.MemoryImage(circularUncheckedImageBytes);

    //unchecked
    final ByteData uncheckedImageData =
        await rootBundle.load('assets/icons/unchecked.png');
    final Uint8List uncheckedImageBytes =
        uncheckedImageData.buffer.asUint8List();
    final pw.ImageProvider uncheckedImage = pw.MemoryImage(uncheckedImageBytes);

    //unchecked
    final ByteData checkedImageData =
        await rootBundle.load('assets/icons/checked.png');
    final Uint8List checkedImageBytes = checkedImageData.buffer.asUint8List();
    final pw.ImageProvider checkedImage = pw.MemoryImage(checkedImageBytes);

  //  print("logo url is ${userModel.logo}");
   Uint8List imageBytes = convertBase64Image(userModel.logo!);
   final pw.ImageProvider logoImage =await getGrayscalePdfImage(imageBytes);  

    // Add receipt content
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // 80mm receipt size
        build: (pw.Context context) {
          return Column(
            children: [
              if(finalCompList.contains("Merchant Contact Details"))
            pw.Image(logoImage, width: 50, height: 70), //here
                 SizedBox(height: 6),
                  if(finalCompList.contains("Merchant Contact Details"))
                 Column(
                  children: [
                     pw.Text(
                          textAlign: TextAlign.center,
                       (AppProvider.restaurantName != null)? AppProvider.restaurantName!: "",
                            style: pw.TextStyle(
                                fontSize:
                                    contactDetailsModel.nameSize!.toDouble())),
                    pw.Text(
                          textAlign: TextAlign.center,
                        
                          (userModel.address!=null) ? formatAddress(userModel.address!): "",
                            style: pw.TextStyle(
                                fontSize:
                                    contactDetailsModel.addressSize!.toDouble())),
                    pw.Text(
                        textAlign: TextAlign.center,
                         (userModel.contactNumber!=null || userModel.contactNumber!="") ?" ${userModel.contactNumber}": "",
                            style: pw.TextStyle(
                                fontSize:
                                    contactDetailsModel.phoneSize!.toDouble())),
                      ]
                     ),

            SizedBox(height: 20),
            pw.Column(
              children: List.generate(finalCompList.length, (finalIndex) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (finalIndex == 0)
                  pw.ListView(
                      children: List.generate(blankLinesVal, (j) {
                    return pw.SizedBox(height: 15);
                  })),
                  
    if(finalCompList[finalIndex]=="Your info box 1")
    pw.Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
         pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          infoBox1Model.title!,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: infoBox1Model.titleSize!.toDouble()),
        ),
        pw.SizedBox(height: 6),
        pw.Container(
          width: 180,
          child: pw.Text(infoBox1Model.text!, style: pw.TextStyle(color: PdfColors.black, fontSize: infoBox1Model.textSize!.toDouble()),maxLines: 6)),
        pw.SizedBox(height: 15),
      ]
     ),
    
    ]),
     if(finalCompList[finalIndex]=="Your info box 2")
    pw.Row (
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          infoBox2Model.title!,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: infoBox2Model.titleSize!.toDouble()),
        ),
        pw.SizedBox(height: 6),
        pw.Container(
          width: 180,
          child: pw.Text(infoBox2Model.text!, style: pw.TextStyle(color: PdfColors.black, fontSize: infoBox2Model.textSize!.toDouble()),maxLines: 6)),
        pw.SizedBox(height: 15),
      ]
     ),
      ]
      ),
      if (finalCompList[finalIndex] == "Payment method")
                  pw.Column(
                    children: [
                    pw.Row(
                      children: [
                         pw.Text(
                       (orderModal.orderData.paymentCode!=null)? (orderModal.orderData.paymentCode!.toUpperCase()=="TSYS") ?"CARD" : orderModal.orderData.paymentCode!.toUpperCase(): previewPaymentsVal
                        ,style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: paymentMethodModel.titleSize!.toDouble()),
                       ),
                      ]
                    ),
                       SizedBox(height: 3),
                    if (paymentMethodModel.showCardDetails == true && ((orderModal.customer.cardType!=null && orderModal.customer.cardType!="") || (orderModal.customer.cardNumber!=null && orderModal.customer.cardNumber!="")))
                      
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            if(orderModal.customer.cardType!=null && orderModal.customer.cardType!="")
                            pw.Text("${orderModal.customer.cardType}",
                                style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: paymentMethodModel
                                        .cardDetailsSize!
                                        .toDouble())),
                            if(orderModal.customer.cardNumber!=null && orderModal.customer.cardNumber!="")
                            pw.Text("ending in ${getLastTwoDigits(orderModal.customer.cardNumber!)}",
                                style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: paymentMethodModel
                                        .cardDetailsSize!
                                        .toDouble())),
                          ],
                        ),
                        pw.Divider(),
                      
                  ]),
                if (finalCompList[finalIndex] == "Time")
                  pw.Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        SizedBox(height: 3),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
              pw.Text(
                    "Exp. ${orderModal.orderData.serviceCode.firstToUpper()} :",
                     style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: timeTitleSize.toDouble())),         
                        if(orderModal.orderData.whentoDeliver == "now")
                        Spacer(),
                       pw.Expanded(child: 
                        pw.Text(
                            (orderModal.orderData.whentoDeliver == "now")
                                ? (orderModal.orderData.orderCompletionTime!="" && orderModal.orderData.orderCompletionTime!=null) ?"now (${formatMinutesTo(orderModal.orderData.orderCompletionTime!)})" :"now (${formatMinutesTo(orderModal.orderCompletionTime!)})"
                                :  (orderModal.orderData.whentoDeliver == "schedule") 
                                 ? "Later(${formatDateTimeNoYear(orderModal.extraDetails?.formattedDeliveryTime ?? orderModal.orderData.deliveryDate)} )"
                                //  at ${orderModal.orderData.deliveryTime})"
                                 : "Later (${addMinutesToTime(orderModal.orderData.acceptedAt!, int.parse(orderModal.orderData.orderCompletionTime ?? orderModal.orderCompletionTime!) 
                                //  timeToMinutes(orderModal.orderData.orderCompletionTime!)
                                 )})",
                                 style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: timeTitleSize.toDouble())),),
                      ],
                    ),
                      SizedBox(height: 3),
                      pw.Divider(),
                    ]
                  ),
                   
                if (finalCompList[finalIndex] == "Delivery/Pickup")
                  pw.Column(
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                             if(orderModal.orderData.serviceCode!="delivery" )
                             pw.Text( "Order Type:", style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: directionModel.titleSize!.toDouble())),
                               if(orderModal.orderData.serviceCode!="delivery" )
                               Spacer(),
                            pw.Text(orderModal.orderData.serviceCode.firstToUpper(),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize:
                                    directionModel.titleSize!.toDouble())),
                           ]),
                           SizedBox(height: 2),
               if(orderModal.orderData.serviceCode=="delivery" && orderModal.orderData.formattedAddress!="")
                 Row(
                  children: [
                    Expanded(child: pw.Text(removeCountry(orderModal.orderData.formattedAddress) ,style: pw.TextStyle(fontSize: directionModel.addressSize!.toDouble())),
                    ) ]
                    ),
                   SizedBox(height: 3),
                     pw.Divider(),
                     SizedBox(height: 15),
                    ]
                  ) ,
                     
                if (finalCompList[finalIndex] == "Order details")
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Order Details:',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize:
                                    orderDetailsModel.titleSize!.toDouble())),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Number:',
                                style: pw.TextStyle(
                                    fontSize: orderDetailsModel.numberSize!
                                        .toDouble())),
                            pw.Text(orderModal.orderData.orderId,
                                style: pw.TextStyle(
                                    fontSize: orderDetailsModel.numberSize!
                                        .toDouble())),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Placed at:',
                                style: pw.TextStyle(
                                    fontSize: orderDetailsModel.placedSize!.toDouble())),
                            pw.Text(formatDateTime(orderModal.orderData.dateCreated!),
                                style: pw.TextStyle(
                                    fontSize: orderDetailsModel.placedSize!
                                        .toDouble())),
                          ],
                        ),
                        
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Accepted at:',
                                style: pw.TextStyle(
                                    fontSize: orderDetailsModel.acceptedSize!
                                        .toDouble())),
                          pw.Text( (orderModal.orderData.acceptedAt!=null && orderModal.orderData.acceptedAt!="") 
                          ?formatAcceptanceTime(orderModal.orderData.acceptedAt!) 
                          : "",
                          // : formatDateTime(orderModal.orderData.dateCreated!),
                                style: pw.TextStyle(
                                    fontSize: orderDetailsModel.acceptedSize!
                                        .toDouble())),
                          ],
                        ),
                       
                        pw.SizedBox(height: 20),
                      ]),
                if (finalCompList[finalIndex] == "Client Info")
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Client Info:',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize:
                                    clientInfoModel.titleSize!.toDouble())),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('First Name:',
                                style: pw.TextStyle(
                                    fontSize:
                                        clientInfoModel.firstSize!.toDouble())),
                            pw.Text(orderModal.customer.firstName,
                                style: pw.TextStyle(
                                    fontSize:
                                        clientInfoModel.firstSize!.toDouble())),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Last Name:',
                                style: pw.TextStyle(
                                    fontSize:
                                        clientInfoModel.lastSize!.toDouble())),
                            pw.Text(orderModal.customer.lastName,
                                style: pw.TextStyle(
                                    fontSize:
                                        clientInfoModel.lastSize!.toDouble())),
                          ],
                        ),
                        if (clientInfoModel.showEmail == true)
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Email:',
                                  style: pw.TextStyle(
                                      fontSize: clientInfoModel.emailSize!
                                          .toDouble())),
                              pw.Text(orderModal.customer.emailAddress,
                                  style: pw.TextStyle(
                                      fontSize: clientInfoModel.emailSize!
                                          .toDouble())),
                            ],
                          ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Phone:',
                                style: pw.TextStyle(
                                    fontSize:
                                        clientInfoModel.phoneSize!.toDouble())),
                            pw.Text(orderModal.customer.contactPhone,
                                style: pw.TextStyle(
                                    fontSize:
                                        clientInfoModel.phoneSize!.toDouble())),
                          ],
                        ),
                        pw.SizedBox(height: 20),
                      ]),
                if (finalCompList[finalIndex] == "Items")
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Items:',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: itemsModel.titleSize!.toDouble())),
                        pw.ListView(
                            children:
                                List.generate(orderModal.items.length, (index) {
                          return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children:[
                                      pw.SizedBox(
                                       width: 150,
                                      child: 
                                         pw.Text(
                                        "${orderModal.items[index].qty}X ${normalizeText(orderModal.items[index].itemName)}",
            // " blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
                                        
                                        style: pw.TextStyle(
                                            fontSize: itemsModel.itemsSize!
                                                .toDouble()))
                                       ),
                                          
                                          if(orderModal.items[index].price.sizeName!=null && orderModal.items[index].price.sizeName!="")
                                                pw.SizedBox(
                                                width: 150,
                                                 child: 
                                                 pw.Text(
                                        "(${normalizeText(orderModal.items[index].price.sizeName!)})",
                                        style: pw.TextStyle(
                                            fontSize: itemsModel.itemsSize!
                                                .toDouble()))
                                                ),
                                      ]
                                      ),
                                   
                                    pw.Text(
                                        '\$${formatToTwoDecimals(orderModal.items[index].price.total)}',
                                        style: pw.TextStyle(
                                            fontSize: itemsModel.itemsSize!
                                                .toDouble())),
                                  ],
                                ),
                                if (orderModal.items[index].addons!.isNotEmpty)
                                  pw.ListView(
                                      children: List.generate(
                                          orderModal.items[index].addons!
                                              .length, (i) {
                                    
                                    Addons addons = orderModal.items[index].addons![i];
                                    List<String> subItems = [];
                                    for (AddonItems subItemName
                                        in addons.addonItems!) {
                                      subItems.add(normalizeText(subItemName.subItemName!));
                                    }
                                    return  
                                     Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      if(addons.subcategoryName!=null && addons.subcategoryName!="")
                                       if(itemsModel.showAddonNames==true)
                                       if(addons.addonItems!=null && addons.addonItems!.isNotEmpty)
                                       if(addons.addonItems![0].pizzaPortionSectionId==null || addons.addonItems![0].pizzaPortionSectionId=="")
                                       pw.SizedBox(
                                     width: 150,
                                     child: 
                                       pw.Text(
                                        '- ${normalizeText(addons.subcategoryName!)}',
                                            style: pw.TextStyle(
                                                fontSize: itemsModel
                                                    .choicAddonSize!
                                                    .toDouble(),
                                                fontItalic:
                                                    Font.timesItalic()))
                                     ),
                                                    ListView(
  children: groupAddonsByPortion(addons.addonItems!).entries.map((entry) {
    final portionId = entry.key;
    final items = entry.value;
     String? shownSubCat;

    String portionTitle = "";

    if (portionId == "1") {
      portionTitle = "- Whole Portion";
    } else if (portionId == "2") {
      portionTitle = "- Left Portion";
    } else if (portionId == "3") {
      portionTitle = "- Right Portion";
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [                                                                                                                                                                                                                                                                                                                                                 

        ///  Print Portion Title Only Once
        if (portionId != "no_portion")
          pw.Text(
            portionTitle,
            style: pw.TextStyle(
              fontSize: itemsModel.itemCommentSize!.toDouble(),
              fontItalic: Font.timesItalic(),
            ),
          ),

        ///  Print Items Under That Portion
        ...items.map((itemAddonItem) {
               final isFirst =
                  shownSubCat != itemAddonItem.subcatName;

                     if (isFirst) {
                 shownSubCat = itemAddonItem.subcatName;
                 }
         return pw.Row(
            children: [
              // if(isFirst)
                (itemAddonItem.isSubModifier=="1")
                        ? pw.Container(
                          margin: EdgeInsets.only(left: 25),
                          width: 150,
                          child: pw.Text(
                            //  "       - ${itemAddonItem.subItemName}",
                             "- ${itemAddonItem.subItemName}",

                          style: TextStyle(
                            fontSize: itemsModel.itemCommentSize!.toDouble(),
                          ),
                          maxLines: 6,
                          // overflow: TextOverflow.ellipsis,
                          )
                        ) : 
                        pw.Container(
                          margin: EdgeInsets.only(left: 14),
                          width: 150,
                          child:  pw.Text(
                            // "      ${normalizeText(itemAddonItem.subItemName!)}",
                            "${normalizeText(itemAddonItem.subItemName!)}",

                  style: pw.TextStyle(
                    fontSize: itemsModel.itemCommentSize!.toDouble(),
                    fontItalic: Font.timesItalic(),
                  ),
                  maxLines: 6),
                        ),
             
            //   pw.SizedBox(
            //     width: 150,
            //     child: pw.Text(
            //  " blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
            //    maxLines: 6,
            //     // "      ${normalizeText(itemAddonItem.subItemName!)}",
            //       style: pw.TextStyle(
            //         fontSize: itemsModel.itemCommentSize!.toDouble(),
            //         fontItalic: Font.timesItalic(),
            //       ))
            //   ),

              if (itemsModel.showAddonFees == true) pw.Spacer(),

              if (itemsModel.showAddonFees == true &&
                  itemAddonItem.price != null)
                pw.Text(
                  '\$${formatToTwoDecimals(itemAddonItem.price!.toDouble())}',
                  style: pw.TextStyle(
                    fontSize: itemsModel.itemCommentSize!.toDouble(),
                    fontItalic: Font.timesItalic(),
                  ),
                ),
            ],
          ) ;
          // return 
        }).toList(),
      ],
    );
  }).toList(),
)
                                  //      ListView(
                                  //     children :  List.generate(
                                  //         addons.addonItems!
                                  //             .length, (j) {
                                  //  final itemAddonItem = addons.addonItems![j];
                                  //  return  pw.Row(children: [
                                  //   (!itemAddonItem.subItemName!.contains(":"))
                                  //      ? (itemAddonItem.pizzaPortionSectionId!=null && itemAddonItem.pizzaPortionSectionId!="")
                                  //   ? Text("   ")
                                  //   : Text("     * ")
                                  //   : Text("    "),
                                  //     // if (itemsModel.showAddonNames == true)
                                  //       // pw.Text('${addons.subcategoryName}:',
                                  //       //     style: pw.TextStyle(
                                  //       //         fontSize: itemsModel
                                  //       //             .choicAddonSize!
                                  //       //             .toDouble(),
                                  //       //         fontItalic:
                                  //       //             Font.timesItalic())),
                                  //       (itemAddonItem.pizzaPortionSectionId!=null && itemAddonItem.pizzaPortionSectionId!="")
                                  //     ? pw.Column(
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: [
                                  //         pw.Text(
                                  //        (itemAddonItem.pizzaPortionSectionId=="1")
                                  //        ? "   - Whole Portion"
                                  //        :(itemAddonItem.pizzaPortionSectionId=="2")
                                  //        ? "   - Left Portion"
                                  //        : "   - Right Portion"
                                  //         ,
                                  //         style: pw.TextStyle(
                                  //             fontSize: itemsModel
                                  //                 .itemCommentSize!
                                  //                 .toDouble(),
                                  //             fontItalic: Font.timesItalic())),
                                  //             pw.Text(
                                  //         "   ${normalizeText(itemAddonItem.subItemName!)}",
                                  //         style: pw.TextStyle(
                                  //             fontSize: itemsModel
                                  //                 .itemCommentSize!
                                  //                 .toDouble(),
                                  //             fontItalic: Font.timesItalic()))
                                  //       ]
                                  //     )
                                  //     : pw.Text(
                                  //         normalizeText(itemAddonItem.subItemName!),
                                  //         style: pw.TextStyle(
                                  //             fontSize: itemsModel
                                  //                 .itemCommentSize!
                                  //                 .toDouble(),
                                  //             fontItalic: Font.timesItalic())),
                                  //     if (itemAddonItem.price != null)
                                  //     Spacer(),
                                  //       if (itemsModel.showAddonFees == true)
                                  //         (
                                  //           itemAddonItem.price!.isNegative == true)
                                  //             ? pw.Text(
                                  //                 '\$${formatToTwoDecimals(itemAddonItem.price!.toDouble())}',
                                  //                 style: pw.TextStyle(
                                  //                     fontSize: itemsModel
                                  //                         .itemCommentSize!
                                  //                         .toDouble(),
                                  //                     fontItalic:
                                  //                         Font.timesItalic()))
                                  //             : pw.Text(
                                  //                 '\$${formatToTwoDecimals(itemAddonItem.price!.toDouble())}',
                                  //                 style: pw.TextStyle(
                                  //                     fontSize: itemsModel
                                  //                         .itemCommentSize!
                                  //                         .toDouble(),
                                  //                     fontItalic:
                                  //                         Font.timesItalic()))
                                  //   ]);
                                  //    })
                                  // )
                                 
                                      ]
                                    );
                                    })
                                  ),
                              
                                  //  if (orderModal
                                  //           .items[index].specialInstructions !=
                                  //       null &&
                                  //   orderModal
                                  //           .items[index].specialInstructions !=
                                  //       "")
                                  // pw.Row(
                                  //   children: [
                                  //     pw.Image(commentImage, width: 10, height: 10),
                                  //     pw.SizedBox(width: 5),
                                  //     pw.Text(
                                  //         orderModal.items[index]
                                  //             .specialInstructions!,
                                  //         style: pw.TextStyle(
                                  //             fontWeight: pw.FontWeight.bold,
                                  //             fontSize: itemsModel
                                  //                 .itemCommentSize!
                                  //                 .toDouble())),
                                  //   ],
                                  // ),
                              ]);
                        })),
                        pw.SizedBox(height: 10),
                        pw.Divider(),
                        pw.SizedBox(height: 15),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Sub-Total',
                                style: pw.TextStyle(
                                    fontSize: itemsModel.feesSize!.toDouble())),
                            pw.Text((orderModal.orderData.subTotal!=null) ?'\$ ${double.parse(orderModal.orderData.subTotal.toString()).toStringAsFixed(2)}': '\$ ${double.parse(orderModal.orderData.total.toString()).toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                    fontSize: itemsModel.feesSize!.toDouble())),
                            ],
                         ),
                        //  if(orderModal.orderData.discountAmount!=null && orderModal.orderData.discountAmount!>0)
                      if(orderModal.allTaxesUse.isNotEmpty && orderModal.allTaxesUse !=null)
                       pw.ListView(
                        
                        //  itemCount: order.allTaxesUse.length,
                        children: List.generate(orderModal.allTaxesUse.length,(index){
                          final taxItem=orderModal.allTaxesUse[index];
                           return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Text( 
                                // (order.orderData.taxType!=null) ?'${order.orderData.taxType!} tax':
                                  (taxItem.taxName!.isNotEmpty) 
                                  ? taxItem.taxName!
                                  : "Tax",
                                   style: pw.TextStyle( fontSize: itemsModel.feesSize!.toDouble()),),
                                   pw.Text((taxItem.taxRateCalculated!=null) ?'\$ ${double.parse(taxItem.taxRateCalculated!.toString()).toStringAsFixed(2)}' : '\$ 0.00',
                                   style: TextStyle(fontSize: itemsModel.feesSize!.toDouble()), ),
                              ],
                            );
                         })
                       ),
                        // pw.Row(
                        //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     pw.Text( 
                        //       // (orderModal.orderData.taxType!=null) ?'${orderModal.orderData.taxType!} tax':
                        //       "Tax",
                        //         style: pw.TextStyle(
                        //             fontSize: itemsModel.feesSize!.toDouble())),
                        //     pw.Text((orderModal.orderData.taxTotal!=null) ?'\$ ${double.parse(orderModal.orderData.taxTotal.toString()).toStringAsFixed(2)}' : '\$ 0.00',
                        //         style: pw.TextStyle(
                        //             fontSize: itemsModel.feesSize!.toDouble())),
                        //   ],
                        // ),
                        
                       
                          pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text( "Tip",
                                style: pw.TextStyle(
                                    fontSize: itemsModel.feesSize!.toDouble())),
                            pw.Text((orderModal.tip!=null && orderModal.tip!="") ?'\$ ${formatToTwoDecimals(orderModal.tip.toString())}' : '\$ 0.00',
                                style: pw.TextStyle(
                                    fontSize: itemsModel.feesSize!.toDouble())),
                          ],
                        ),
                         if((orderModal.extraDetails?.hasDiscount==true))
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text( orderModal.extraDetails?.discountName ?? "Discount",
                                style: pw.TextStyle( 
                                    fontSize: itemsModel.feesSize!.toDouble())),
                            pw.Text((orderModal.extraDetails?.discountAmount != null && orderModal.extraDetails?.discountAmount != "") ? '\$ (${formatToTwoDecimals(orderModal.extraDetails!.discountAmount!)})' : '\$ (0.00)',
                                style: pw.TextStyle(
                                    fontSize: itemsModel.feesSize!.toDouble())),
                          ],
                        ),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total:',
                                style: pw.TextStyle(
                                    fontSize: itemsModel.totalSize!.toDouble(),
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$ ${double.parse(orderModal.orderData.total.toString()).toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                    fontSize: itemsModel.totalSize!.toDouble(),
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                      ]),
                if (finalCompList[finalIndex] == "Is Paid")
                  pw.Column(
                    children: [
                 pw.Divider(),
                           pw.SizedBox(height: 3),
                  pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
                            if (uncheckedImage != null)
                              (orderModal.orderData.paymentStatus=="paid")
                     ?  pw.Image(checkedImage,
                                  width: isPaidTitleSize.toDouble() + 8,
                                  height: isPaidTitleSize.toDouble() + 8)
                     :  pw.Image(uncheckedImage,
                                  width: isPaidTitleSize.toDouble() + 8,
                                  height: isPaidTitleSize.toDouble() + 8),
                             
                            pw.SizedBox(width: 6),
                            pw.Text('Paid',
                                style: pw.TextStyle(
                                    fontSize: isPaidTitleSize.toDouble(),
                                    fontWeight: pw.FontWeight.bold)),
                          ]),
                          pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
                            if (checkedImage != null)
                                     (orderModal.orderData.paymentStatus!="paid")
                     ?  pw.Image(checkedImage,
                                  width: isPaidTitleSize.toDouble() + 8,
                                  height: isPaidTitleSize.toDouble() + 8)
                     :  pw.Image(uncheckedImage,
                                  width: isPaidTitleSize.toDouble() + 8,
                                  height: isPaidTitleSize.toDouble() + 8),
                            pw.SizedBox(width: 6),
                            pw.Text('Not Paid',
                                style: pw.TextStyle(
                                    fontSize: isPaidTitleSize.toDouble(),
                                    fontWeight: pw.FontWeight.bold)),
                          ])
                        ],
                      ),   
                       pw.SizedBox(height: 3),
                       pw.Divider(),
                       ]
                  ),
              
                if (finalCompList[finalIndex] == "Client confirmation")
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // pw.Divider(),
                        pw.Text('Client Confirmation:',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: clientConfirmationModel.titleSize!
                                    .toDouble())),
                        pw.SizedBox(height: 10),
                     
                        // if(orderModal.customer.cardType==null || orderModal.customer.cardType=="" )
                        pw.Text(
                            'I acknowledge reception of order ID ${orderModal.orderData.orderId} from ${PlaceName(userModel.address ?? "")} on ${formatDateTime(orderModal.orderData.dateCreated ?? "")}.',
                            style: pw.TextStyle(
                                fontSize: clientConfirmationModel.textSize!
                                    .toDouble())),
                        pw.SizedBox(height: 5),
                        
                        if (paymentMethodModel.showCardDetails == true && ((orderModal.customer.cardType!=null && orderModal.customer.cardType!="") || (orderModal.customer.cardNumber!=null && orderModal.customer.cardNumber!="")))
                        pw.Text(
                            'I acknowledge ${orderModal.customer.firstName} ${orderModal.customer.lastName}\'s card ending in ${getLastTwoDigits(orderModal.customer.cardNumber!)} was charged with his/her consent.',
                            style: pw.TextStyle(
                                fontSize: clientConfirmationModel.textSize!
                                    .toDouble())),
                          
                      //  if((orderModal.customer.transcationMetaData!=null ) && paymentMethodModel.showCardDetails == true && ((orderModal.customer.cardType!=null && orderModal.customer.cardType!="") || (orderModal.customer.cardNumber!=null && orderModal.customer.cardNumber!="")))
                      //      pw.Text(
                      //       // 'I acknowledge reception of order ID ${orderModal.orderData.orderId} from ${PlaceName(orderModal.restaurantAddress ?? "")} on ${formatDateTime(orderModal.orderData.dateCreated ?? "")}.',
                      //       replaceEscapedNewlines(orderModal.customer.transcationMetaData!.customerReceipt!.trim())
                      //      , style: pw.TextStyle(
                      //           fontSize: clientConfirmationModel.textSize!
                      //               .toDouble())),
                        
                        pw.Column(
                          children: [
                         if(orderModal.customer.transcationMetaData!.cardDetails!.entryMode!=null && orderModal.customer.transcationMetaData!.cardDetails!.entryMode!="")
                          pw.Row(
                          children: [
                           pw.Text('Entry Mode :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text(orderModal.customer.transcationMetaData!.cardDetails!.entryMode!,style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                         ),

                          if(orderModal.customer.transcationMetaData!.cardDetails!.transactionType!=null && orderModal.customer.transcationMetaData!.cardDetails!.transactionType!="")
                          pw.Row(
                          children: [
                           pw.Text('Transaction Type :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text(orderModal.customer.transcationMetaData!.cardDetails!.transactionType!,style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                         ),

                          if(orderModal.customer.transcationMetaData!.cardDetails!.authorization!=null && orderModal.customer.transcationMetaData!.cardDetails!.authorization!="")
                          pw.Row(
                          children: [
                           pw.Text('Authorization :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text(orderModal.customer.transcationMetaData!.cardDetails!.authorization!,style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),
                           if(orderModal.customer.transcationMetaData!.cardDetails!.cardType!=null && orderModal.customer.transcationMetaData!.cardDetails!.cardType!="")
                          pw.Row(
                          children: [
                           pw.Text('Card Type :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text(orderModal.customer.transcationMetaData!.cardDetails!.cardType!,style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),

                           if(orderModal.customer.transcationMetaData!.cardDetails!.card!=null && orderModal.customer.transcationMetaData!.cardDetails!.card!="")
                          pw.Row(
                          children: [
                           pw.Text('Card :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text(orderModal.customer.transcationMetaData!.cardDetails!.card!,style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),

                          if(orderModal.customer.transcationMetaData!.cardDetails!.transactionID!=null && orderModal.customer.transcationMetaData!.cardDetails!.transactionID!="")
                          pw.Row(
                          children: [
                           pw.Text('Transaction ID :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text(orderModal.customer.transcationMetaData!.cardDetails!.transactionID!,style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),

                          if(orderModal.customer.transcationMetaData!.cardDetails!.invoiceNumber!=null && orderModal.customer.transcationMetaData!.cardDetails!.invoiceNumber!="")
                          pw.Row(
                          children: [
                           pw.Text('Invoice Number :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text(orderModal.customer.transcationMetaData!.cardDetails!.invoiceNumber!,style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),

                            if(orderModal.customer.transcationMetaData!.authCode!=null && orderModal.customer.transcationMetaData!.authCode!="")
                           pw.Row(
                          children: [
                           pw.Text('Payment Auth code :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text(orderModal.customer.transcationMetaData!.authCode!,style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                              ]
                            ),


                          if(orderModal.customer.transcationMetaData!.transactionDate!=null && orderModal.customer.transcationMetaData!.transactionDate!="")
                          pw.Row(
                         children: [
                           pw.Text('Transcation Time  :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                          pw.Text(formatAcceptanceTime(orderModal.customer.transcationMetaData!.transactionDate!),style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                         ),
                          
                         ]
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text('My name is:',
                            style: pw.TextStyle(
                                fontSize: clientConfirmationModel.textSize!
                                    .toDouble())),
                        pw.SizedBox(height: 10),
                        pw.Row( children: [
                          if (circularUncheckedImage != null)
                            pw.Image(circularUncheckedImage,
                                width: 10, height: 10),
                          pw.SizedBox(width: 5),
                          pw.Text("${orderModal.customer.firstName} ${orderModal.customer.lastName}",
                              style: pw.TextStyle(
                                  fontSize: clientConfirmationModel.textSize!
                                      .toDouble())),
                        ]),
                        pw.SizedBox(height: 10),
                        pw.Row(children: [
                          if (circularUncheckedImage != null)
                            pw.Image(circularUncheckedImage,
                                width: 10, height: 10),
                          pw.SizedBox(width: 5),
                          pw.Text(
                              '...................................................................',
                              style: pw.TextStyle(fontSize: 9)),
                        ]),
                        pw.SizedBox(height: 5),
                        pw.Text(
                            ' I am authorized to act on behalf of ${orderModal.customer.firstName} ${orderModal.customer.lastName}',
                            style: pw.TextStyle(
                                fontSize: clientConfirmationModel.textSize!
                                    .toDouble())),
                        pw.SizedBox(height: 30),
                        pw.Text(
                            ' Signature:...................................................',
                            style: pw.TextStyle(
                                fontSize: clientConfirmationModel.textSize!
                                    .toDouble())),
                        pw.SizedBox(height: 80),
                      ]),
              ],
            );
          }))
          ]);
        },
      ),
    );


    // Save PDF to file
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = "${directory.path}/eatsBeeClientReceipt.pdf";
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

 
    print("PDF saved successfully at: $filePath");
   print("orderModal.customer.transcationMetaData is ${orderModal.customer.transcationMetaData}");
    return filePath;
  } catch (e,stack) {
  // bugsnag.notify("error in generating client pdf is $e", stack);
    print("Error generating PDF: $e");
    return "";
  }

}
// String replaceEscapedNewlines(String input) {
//   return input.replaceAll(r'\\n', '\n');
// }
String replaceEscapedNewlines(String input) {
  return input.replaceAll(r'\n', '\n');
}

String normalizeText(String text) {
  return text
      .replaceAll(RegExp(r"[’‘]"), "'")
      .replaceAll(RegExp(r'[“”]'), '"')
      .replaceAll('،', ',')   // Arabic comma
      .replaceAll('，', ',')  // Full-width comma
      .replaceAll('\u00A0', ' '); // Non-breaking space
}

Map<String, List<AddonItems>> groupAddonsByPortion(
    List<AddonItems> addonItems) {

  final Map<String, List<AddonItems>> tempMap = {};

  for (var item in addonItems) {
    final key = (item.pizzaPortionSectionId != null &&
            item.pizzaPortionSectionId!.isNotEmpty)
        ? item.pizzaPortionSectionId!
        : "no_portion";

    tempMap.putIfAbsent(key, () => []);
    tempMap[key]!.add(item);
  }

  /// Sort Keys
  final sortedKeys = tempMap.keys.toList()
    ..sort((a, b) {
      if (a == "no_portion") return 1;
      if (b == "no_portion") return -1;
      return int.tryParse(a)?.compareTo(int.tryParse(b) ?? 0) ?? 0;
    });

  final Map<String, List<AddonItems>> sortedMap = {};
  for (var key in sortedKeys) {
    sortedMap[key] = tempMap[key]!;
  }

  return sortedMap;
}