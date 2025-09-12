import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/ui/printing/editable_template/demo_pdf_client.dart';
import 'package:order_receiving/ui/reciept/view_image_receipt.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';

class RecieptComponentsClient extends StatefulWidget {
 String logo;
 Map<String,dynamic> recieptDataMap;
 String address;
 String phone;
   RecieptComponentsClient( {super.key ,required this.recieptDataMap,required this.address,required this.logo,required this.phone});

  @override
  State<RecieptComponentsClient> createState() => _RecieptComponentsClientState();
}

class _RecieptComponentsClientState extends State<RecieptComponentsClient> {
  // String receiptTemplateName = "eatsBeeRec1";

  bool enabled = true;
 List<Map<String, dynamic>> data2 = [];

 List<Map<String, dynamic>> data = [
    {"Preview Options": false},
    {"Ticket holder space": false},
    {"Merchant Contact Details": true},
    {"Payment method": true},
    {"Time": true},
    {"Delivery/Pickup": true},
    {"Order details": true},
    {"Client Info": true},
    {"Items": true},
    {"Is Paid": true},
    {"Your info box 1": false},
    {"Your info box 2": false},
    {"Client confirmation": true}
  ];

  List<int> fontSizes = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
  List<String> previewOrdersList = ["Pickup","Delivery"];
  String previewOrdersVal = "Pickup";

  List<String> premiseTypeList = [
    "Dine-in",
    "Room service",
    "Seat delivery",
    "Suite delivery",
    "Sunbeds",
  ];
  String premiseTypeVal = "Dine-in";
  String premiseTypeFinalVal = "Table Number";
  TextEditingController otherTextController = TextEditingController();

  List<String> previewTimesList = ["now", "Later"];
  String previewTimesVal = "now";

  List<String> previewPaymentsList = ["COD", "Card"];
  String previewPaymentsVal = "COD";

  List<int> blankLinesList = [1, 2, 3, 4];
  int blankLinesVal = 1;

  InfoBox1Model infoBox1Model=InfoBox1Model.empty;
  InfoBox2Model infoBox2Model=InfoBox2Model.empty;
  PaymentMethodModel paymentMethodModel = PaymentMethodModel.empty;
  OrderDetailsModel orderDetailsModel = OrderDetailsModel.empty;
  DirectionModel directionModel = DirectionModel.empty;
  ClientInfoModel clientInfoModel = ClientInfoModel.empty;
  ItemsModel itemsModel = ItemsModel.empty;
  ContactDetailsModel contactDetailsModel = ContactDetailsModel.empty;
  ClientConfirmationModel clientConfirmationModel = ClientConfirmationModel.empty;

  int timeTitleSize = 11;
  int clientCommentSize = 10;
  int isPaidTitleSize = 12;
  int orderOnlineTitleSize = 13;
 List<Map<String, dynamic>> dataToSaveList=[];
  List<String> finalCompList = [];
  Map<String, dynamic>? recieptMap;

  Map<int, String> finalCompListMap = {};

  TextEditingController recieptNameController = TextEditingController();

  TextEditingController box1TitleController = TextEditingController();
  TextEditingController box1TextController = TextEditingController();

  TextEditingController box2TitleController = TextEditingController();
  TextEditingController box2TextController = TextEditingController();
  getActiveComponents() async {
    finalCompList.clear();
    dataToSaveList.clear();
    for (final item in (widget.recieptDataMap.isNotEmpty && widget.recieptDataMap!=null)?data2 :data) {
      dataToSaveList.add(item);
      if (item.values.first == true) {
        finalCompList.add(item.keys.first);
      }
    }
  }
 

  saveRecieptPreferences() async {
    getActiveComponents();

    debugPrint("[saveRecieptPreferences] finalCompListMap is $finalCompListMap");
    Map<String, dynamic> recieptMap = {
      "previewOrdersVal": previewOrdersVal,
      "previewTimesVal": previewTimesVal,
      "previewPaymentsVal": previewPaymentsVal,
      "blankLinesVal": blankLinesVal,

      //models
       "infoBox1Model":{
       "titleSize":infoBox1Model.titleSize,
       "textSize":infoBox1Model.textSize,
       "title":box1TitleController.text,
       "text":box1TextController.text,
       },
        "infoBox2Model":{
       "titleSize":infoBox2Model.titleSize,
       "textSize":infoBox2Model.textSize,
       "title":box2TitleController.text,
       "text":box2TextController.text,
       },

      "paymentMethod": {
        "titleSize": paymentMethodModel.titleSize,
        "cardDetailsSize": paymentMethodModel.cardDetailsSize,
        "showCardDetails": paymentMethodModel.showCardDetails
      },
      "orderDetails": {
        "titleSize": orderDetailsModel.titleSize,
        "numberSize": orderDetailsModel.numberSize,
        "placedSize": orderDetailsModel.placedSize,
        "acceptedSize": orderDetailsModel.acceptedSize,
        "fullfilledSize": orderDetailsModel.fullfilledSize
      },
      "direction": {
        "titleSize": directionModel.titleSize,
        "addressSize": directionModel.addressSize,
        "addressInfoSize": directionModel.addressInfoSize,
        "showOR": directionModel.showOR
      },
      "clientInfo": {
        "titleSize": clientInfoModel.titleSize,
        "firstSize": clientInfoModel.firstSize,
        "lastSize": clientInfoModel.lastSize,
        "emailSize": clientInfoModel.emailSize,
        "phoneSize": clientInfoModel.phoneSize,
        "showEmail": clientInfoModel.showEmail,
      },
      "items": {
        "titleSize": itemsModel.titleSize,
        "itemsSize": itemsModel.itemsSize,
        "choicAddonSize": itemsModel.choicAddonSize,
        "itemCommentSize": itemsModel.itemCommentSize,
        "feesSize": itemsModel.feesSize,
        "totalSize": itemsModel.totalSize,
        "showAddonFees": itemsModel.showAddonFees,
        "showAddonNames": itemsModel.showAddonNames,
      },
      "contactDetails": {
        "nameSize": contactDetailsModel.nameSize,
        "addressSize": contactDetailsModel.addressSize,
        "phoneSize": contactDetailsModel.phoneSize,
      },
      "clientConfirmation": {
        "titleSize": clientConfirmationModel.titleSize,
        "textSize": clientConfirmationModel.textSize,
      },

      "timeTitleSize": timeTitleSize,
      "clientCommentSize": clientCommentSize,
      "isPaidTitleSize": isPaidTitleSize,
      "orderOnlineTitleSize": orderOnlineTitleSize,

      "premiseTypeVal": premiseTypeVal,
      "otherPremiseText": otherTextController.text.trim(),
      "premiseTypeFinalVal": premiseTypeFinalVal,
      "finalCompList": dataToSaveList
    };
    SharedPreferenceManager.getInstance()
        .saveReceiptData(recieptMap,"MerchantReceipt");
  }

  @override
  void initState() {
    if(widget.recieptDataMap.isNotEmpty && widget.recieptDataMap!=null){
     ClientReceiptSettings receiptSettings=ClientReceiptSettings.fromJson(widget.recieptDataMap);
     previewOrdersVal=receiptSettings.previewOrdersVal;
     previewTimesVal=receiptSettings.previewTimesVal;
     previewPaymentsVal=receiptSettings.previewPaymentsVal;
     blankLinesVal=receiptSettings.blankLinesVal;
   
    infoBox1Model=receiptSettings.infoBox1Model;
    infoBox2Model=receiptSettings.infoBox2Model;

    box1TitleController.text=infoBox1Model.title!;
    box2TitleController.text=infoBox2Model.title!;

    box1TextController.text=infoBox1Model.text!;
    box2TextController.text=infoBox2Model.text!;
    
     paymentMethodModel=receiptSettings.paymentMethod;
     orderDetailsModel=receiptSettings.orderDetails;
     directionModel=receiptSettings.direction;
     clientInfoModel=receiptSettings.clientInfo;
     itemsModel=receiptSettings.items;
     contactDetailsModel=receiptSettings.contactDetails;
     clientConfirmationModel=receiptSettings.clientConfirmation;

     timeTitleSize=receiptSettings.timeTitleSize;
     clientCommentSize=receiptSettings.clientCommentSize;
     isPaidTitleSize=receiptSettings.isPaidTitleSize;
     orderOnlineTitleSize=receiptSettings.orderOnlineTitleSize;

     premiseTypeVal=receiptSettings.premiseTypeVal;
     premiseTypeFinalVal=receiptSettings.premiseTypeFinalVal;
     data2=receiptSettings.finalCompList;
  
   debugPrint("data2 implemented");
    }else{
   debugPrint("data implemented");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(microseconds: 200));
    return Scaffold(
      floatingActionButton:   Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width/1.2,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.amber)),
                    onPressed: () async{
                         await saveRecieptPreferences();
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Template Saved !')));
                     
                         await getActiveComponents();

              debugPrint("final list to show is $finalCompList");
      String filepath=await  demoClientPdfGenerate(
                  widget.phone,
                  widget.logo,
                  widget.address,
                  previewOrdersVal,
                  previewTimesVal,
                  previewPaymentsVal,
                  blankLinesVal,
                  ///
                  InfoBox1Model(titleSize: infoBox1Model.titleSize, textSize: infoBox1Model.textSize, title: box1TitleController.text, text: box1TextController.text),
                  InfoBox2Model(titleSize: infoBox2Model.titleSize, textSize: infoBox2Model.textSize, title: box2TitleController.text, text: box2TextController.text),
                  
                  paymentMethodModel,
                  orderDetailsModel,
                  directionModel,
                  clientInfoModel,
                  itemsModel,
                  contactDetailsModel,
                  clientConfirmationModel,
                  timeTitleSize,
                  clientCommentSize,
                  isPaidTitleSize,
                  orderOnlineTitleSize,
                  premiseTypeVal,
                  otherTextController.text.trim(),
                  premiseTypeFinalVal,
                  finalCompList);

                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewImageReceipt(filePath: filepath)));
                 },
                    child: Text("SAVE & PREVIEW".toUpperCase() ,style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppAssets.nunitoBold,
                      color: AppAssets.whiteColor))),
              ),
            ),
      appBar: AppBar(
        title: Text(
          "Receipt Components",
          style: TextStyle(
              fontSize: 18,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.primaryColor),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            children: [
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      _updateItems(oldIndex, newIndex);
                    });
                  },
                  children: [
                    for (final item in (widget.recieptDataMap.isNotEmpty && widget.recieptDataMap!=null) ?data2 :data)
                      ExpansionTile(
                        childrenPadding: EdgeInsets.all(10),
                        key: ValueKey(item.keys.first),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.keys.first,
                                style: const TextStyle(fontSize: 17)),
                            if (item.keys.first != "Preview Options" &&
                                item.keys.first != "Ticket holder space")
                              SizedBox(
                                width: 30,
                                child: Switch(
                                    activeColor: AppAssets.greenColor,
                                    value: item.values.first,
                                    onChanged: (value) {
                                      setState(() {
                                        item.update(item.keys.first, (itemValue) {
                                          itemValue = value;
                                          return itemValue;
                                        });
                                      });
                                    }),
                              ),
                          ],
                        ),
                        children: [
                 if(item.keys.first=="Your info box 2")
                      Column(
                              children: [
                                ListTile(
                                  title: Text("Title:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: infoBox2Model.titleSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          infoBox2Model.titleSize =
                                              newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Text:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: infoBox2Model.textSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          infoBox2Model.textSize =  newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                
                                 Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                        ),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          obscureText: false,  
                          controller: box2TitleController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Title",
                            labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                            floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                          ),
                          cursorColor: AppAssets.widgetGrayColor,
                          style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                        onEditingComplete: (){
                          setState(() {
                          infoBox2Model.title=box2TitleController.text.trim();
                          });
                        },
                        ),
                      ),SizedBox(height: 15,),
                        Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                        ),
                        child: TextField(
                          maxLines: 4,
                          maxLength: 200,
                          keyboardType: TextInputType.text,
                          obscureText: false,  
                          controller: box2TextController,
                          decoration: InputDecoration(
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            border: InputBorder.none,
                            labelText: "Text",
                            labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                            floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                          ),
                          cursorColor: AppAssets.widgetGrayColor,
                          style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                          onEditingComplete: (){
                          setState(() {
                          infoBox2Model.text=box2TextController.text.trim();
                          });
                        },
                        ),
                      ),
                              ],
                            ),
                
                             if(item.keys.first=="Your info box 1")
                      Column(
                              children: [
                                ListTile(
                                  title: Text("Title:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: infoBox1Model.titleSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          infoBox1Model.titleSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Text:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: infoBox1Model.textSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          infoBox1Model.textSize =  newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                
                                 Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                        ),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          obscureText: false,  
                          controller: box1TitleController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Title",
                            labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                            floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                          ),
                          cursorColor: AppAssets.widgetGrayColor,
                          style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                           onEditingComplete: (){
                          setState(() {
                          infoBox1Model.title=box1TitleController.text.trim();
                          });
                        },
                        ),
                      ),SizedBox(height: 15,),
                        Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                        ),
                        child: TextField(
                          maxLines: 4,
                          maxLength: 200,
                          keyboardType: TextInputType.text,
                          obscureText: false,  
                          controller: box1TextController,
                          decoration: InputDecoration(
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            border: InputBorder.none,
                            labelText: "Text",
                            labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                            floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                          ),
                          cursorColor: AppAssets.widgetGrayColor,
                          style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                         onEditingComplete: (){
                          setState(() {
                          infoBox1Model.text=box1TextController.text.trim();
                          });
                        },
                        ),
                      ),
                              ],
                            ),
                          if (item.keys.first == "Preview Options")
                            Column(
                              children: [
                                ListTile(
                                  title: Text("Orders:"),
                                  trailing: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: previewOrdersVal,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: previewOrdersList.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          previewOrdersVal = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                if (previewOrdersVal == "On premise")
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (previewOrdersVal == "On premise")
                                  ListTile(
                                    title: Text("On premise type:"),
                                    trailing: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 0.5),
                                          borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.only(left: 6, right: 6),
                                      child: DropdownButton(
                                        underline: SizedBox(),
                                        padding: EdgeInsets.all(5),
                                        value: premiseTypeVal,
                                        icon: const Icon(Icons.keyboard_arrow_down),
                                        items: premiseTypeList.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(
                                              items,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            premiseTypeVal = newValue!;
                                            if (premiseTypeVal == "Dine-in") {
                                              premiseTypeFinalVal = "Table Number";
                                            } else if (premiseTypeVal ==
                                                "Room service") {
                                              premiseTypeFinalVal = "Room Number";
                                            } else if (premiseTypeVal ==
                                                "Seat delivery") {
                                              premiseTypeFinalVal = "Seat Number";
                                            } else if (premiseTypeVal ==
                                                "Suite delivery") {
                                              premiseTypeFinalVal = "Suite Number";
                                            } else if (premiseTypeVal == "Sunbeds") {
                                              premiseTypeFinalVal = "Sunbed Number";
                                            } else if (premiseTypeVal == "other") {
                                              premiseTypeFinalVal =
                                                  otherTextController.text.trim();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Times:"),
                                  trailing: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: previewTimesVal,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: previewTimesList.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("$items "),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          previewTimesVal = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Payments:"),
                                  trailing: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: previewPaymentsVal,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: previewPaymentsList.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("$items "),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          previewPaymentsVal = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (item.keys.first == "Ticket holder space")
                            ListTile(
                              title: Text("Blank Lines:"),
                              trailing: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.black, width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(left: 6, right: 6),
                                child: DropdownButton(
                                  underline: SizedBox(),
                                  padding: EdgeInsets.all(5),
                                  value: blankLinesVal,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: blankLinesList.map((int items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text("$items  "),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      blankLinesVal = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          if (item.keys.first == "Payment method")
                            Column(
                              children: [
                                ListTile(
                                  title: Text("Title:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: paymentMethodModel.titleSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          paymentMethodModel.titleSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Card Details:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: paymentMethodModel.cardDetailsSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          paymentMethodModel.cardDetailsSize =
                                              newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CheckboxListTile(
                                    title: Text("Show CardDetails(Online Payments)"),
                                    value: paymentMethodModel.showCardDetails,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentMethodModel.showCardDetails = value;
                                      });
                                    })
                              ],
                            ),
                          if (item.keys.first == "Time")
                            ListTile(
                              title: Text("Title:"),
                              trailing: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.black, width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(left: 6, right: 6),
                                child: DropdownButton(
                                  underline: SizedBox(),
                                  padding: EdgeInsets.all(5),
                                  value: timeTitleSize,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: fontSizes.map((int items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text("${items}px "),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      timeTitleSize = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          if (item.keys.first == "Delivery/Pickup")
                            Column(
                              children: [
                                ListTile(
                                  title: Text("Title:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: directionModel.titleSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          directionModel.titleSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Address:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: directionModel.addressSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px"),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          directionModel.addressSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (item.keys.first == "Client Info")
                            Column(
                              children: [
                                ListTile(
                                  title: Text("Title:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: clientInfoModel.titleSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          clientInfoModel.titleSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("First Name:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: clientInfoModel.firstSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          clientInfoModel.firstSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Last Name:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: clientInfoModel.lastSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          clientInfoModel.lastSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Email:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: clientInfoModel.emailSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          clientInfoModel.emailSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Phone:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: clientInfoModel.phoneSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          clientInfoModel.phoneSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CheckboxListTile(
                                    title: Text("Show Client Email"),
                                    value: clientInfoModel.showEmail,
                                    onChanged: (value) {
                                      setState(() {
                                        clientInfoModel.showEmail = value;
                                      });
                                    })
                              ],
                            ),
                          if (item.keys.first == "Order details")
                            Column(
                              children: [
                                ListTile(
                                  title: Text("Title:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: orderDetailsModel.titleSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          orderDetailsModel.titleSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Number:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: orderDetailsModel.numberSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          orderDetailsModel.numberSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Placed:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: orderDetailsModel.placedSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          orderDetailsModel.placedSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Accepted:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: orderDetailsModel.acceptedSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          orderDetailsModel.acceptedSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (item.keys.first == "Items")
                            Column(
                              children: [
                                ListTile(
                                  title: Text("Title:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: itemsModel.titleSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          itemsModel.titleSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Items:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: itemsModel.itemsSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          itemsModel.itemsSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Choices & Addons:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: itemsModel.choicAddonSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          itemsModel.choicAddonSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Item Comment:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: itemsModel.itemCommentSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          itemsModel.itemCommentSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Fees & Taxes:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: itemsModel.feesSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          itemsModel.feesSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Total:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: itemsModel.totalSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          itemsModel.totalSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CheckboxListTile(
                                    title: Text(
                                        "Show Additional fees for add-ons/sizes:"),
                                    value: itemsModel.showAddonFees,
                                    onChanged: (value) {
                                      setState(() {
                                        itemsModel.showAddonFees = value;
                                      });
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                                CheckboxListTile(
                                    title: Text("Show add-ons/sizes names:"),
                                    value: itemsModel.showAddonNames,
                                    onChanged: (value) {
                                      setState(() {
                                        itemsModel.showAddonNames = value;
                                      });
                                    })
                              ],
                            ),
                          if (item.keys.first == "Is Paid")
                            ListTile(
                              title: Text("Title:"),
                              trailing: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.black, width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(left: 6, right: 6),
                                child: DropdownButton(
                                  underline: SizedBox(),
                                  padding: EdgeInsets.all(5),
                                  value: isPaidTitleSize,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: fontSizes.map((int items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text("${items}px "),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      isPaidTitleSize = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                         
                          if (item.keys.first == "Merchant Contact Details")
                            Column(
                              children: [
                                ListTile(
                                  title: Text("Address:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: contactDetailsModel.addressSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          contactDetailsModel.addressSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Phone:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: contactDetailsModel.phoneSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          contactDetailsModel.phoneSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          if (item.keys.first == "Client confirmation")
                            Column(
                              children: [
                                ListTile(
                                  title: Text("Title:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: clientConfirmationModel.titleSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          clientConfirmationModel.titleSize =
                                              newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Text("Text:"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      padding: EdgeInsets.all(5),
                                      value: clientConfirmationModel.textSize,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: fontSizes.map((int items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text("${items}px "),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          clientConfirmationModel.textSize =  newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      )
                  ],
                ),
              ),
           SizedBox(height: 50,)
            ],
          )),
    );
  }

  void _updateItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
if(widget.recieptDataMap.isNotEmpty && widget.recieptDataMap!=null){
      final item = data2.removeAt(oldIndex);
    data2.insert(newIndex, item);
}else{
    final item = data.removeAt(oldIndex);
    data.insert(newIndex, item);
}
  }
}
