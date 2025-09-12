import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/ui/printing/editable_template/demo_pdf_kitchen.dart';
import 'package:order_receiving/ui/reciept/view_image_receipt.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';

class RecieptComponentsKitchen extends StatefulWidget {

 Map<String,dynamic> recieptDataMap;
   RecieptComponentsKitchen({super.key,required this.recieptDataMap});

  @override
  State<RecieptComponentsKitchen> createState() => _RecieptComponentsKitchenState();
}

class _RecieptComponentsKitchenState extends State<RecieptComponentsKitchen> {
  // String receiptTemplateName = "eatsBeeRec1";
  TextEditingController recieptNameController = TextEditingController();
  bool enabled = true;
 List<Map<String, dynamic>> data2 = [];

 List<Map<String, dynamic>> data = [
    {"Preview Options": false},
    {"Ticket holder space": false},
    {"Header": true},
    {"Order details": true},
    // {"Client Comment": true},
    {"Items": true},
    {"Is Paid": true},
    {"Packaging station quality control": true},
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
    // "other"
  ];
  String premiseTypeVal = "Dine-in";
  String premiseTypeFinalVal = "Table Number";
  TextEditingController otherTextController = TextEditingController();

  List<String> previewTimesList = ["now", "Later"];
  String previewTimesVal = "now";

  List<String> previewPaymentsList = ["COD", "Card"];
  String previewPaymentsVal = "COD";


  // PreviewOptionsModel previewOptionsModel=PreviewOptionsModel.empty;
HeaderModel headerModel=HeaderModel.empty; 

  OrderDetailsModel orderDetailsModel = OrderDetailsModel.empty;
  KitchenItemsModel kitchenItemsModel = KitchenItemsModel.empty;
  ContactDetailsModel contactDetailsModel = ContactDetailsModel.empty;
  PackagingQualityModel packagingQualityModel=PackagingQualityModel.empty;


  int onPermiseSize=12;
  int clientCommentSize = 10;
  int isPaidTitleSize = 12;

  List<int> blankLinesList = [1, 2, 3, 4];
  int blankLinesVal = 1;
 List<Map<String, dynamic>> dataToSaveList=[];
  List<String> finalCompList = [];
  Map<String, dynamic>? recieptMap;

  Map<int, String> finalCompListMap = {};
  getActiveComponents() async {
    finalCompList.clear();
    dataToSaveList.clear();
    for (final item in (widget.recieptDataMap.isNotEmpty && widget.recieptDataMap!=null)?data2: data) {
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
      
       "headerModel" :{
       "typeSize": headerModel.typeSize,
       "fulfillmentSize": headerModel.fulfillmentSize, 
       },

      "orderDetails": {
        "titleSize": orderDetailsModel.titleSize,
        "numberSize": orderDetailsModel.numberSize,
        "placedSize": orderDetailsModel.placedSize,
        "acceptedSize": orderDetailsModel.acceptedSize,
        "fullfilledSize": orderDetailsModel.fullfilledSize
      },

      "kitchenItems": {
        "titleSize": kitchenItemsModel.titleSize,
        "itemsSize": kitchenItemsModel.itemsSize,
        "choicAddonSize": kitchenItemsModel.choicAddonSize,
        "itemCommentSize": kitchenItemsModel.itemCommentSize,

        "addCheckbox": kitchenItemsModel.addCheckbox,
        "showAddonNames": kitchenItemsModel.showAddonNames,
        "showInternalNames": kitchenItemsModel.showInternalNames,
      },
      "contactDetails": {
        "nameSize": contactDetailsModel.nameSize,
        "addressSize": contactDetailsModel.addressSize,
        "phoneSize": contactDetailsModel.phoneSize,
      },
      "packagingQualityModel": {
        "titleSize": packagingQualityModel.titleSize,
        "correctItemsSize": packagingQualityModel.correctItemsSize,
        "allItemsSize": packagingQualityModel.allItemsSize,
        "flyerSize": packagingQualityModel.flyerSize,
      },

      "clientCommentSize": clientCommentSize,
      "isPaidTitleSize": isPaidTitleSize,

      "premiseTypeVal": premiseTypeVal,
      "otherPremiseText": otherTextController.text.trim(),
      "premiseTypeFinalVal": premiseTypeFinalVal,
      "finalCompList": dataToSaveList
    };
    SharedPreferenceManager.getInstance()
        .saveReceiptData(recieptMap, "KitchenEssentials");
  }

  @override
  void initState() {
    if(widget.recieptDataMap.isNotEmpty && widget.recieptDataMap!=null){
    
     KitchenReceiptSettings receiptSettings=KitchenReceiptSettings.fromJson(widget.recieptDataMap);
     previewOrdersVal=receiptSettings.previewOrdersVal;
     previewTimesVal=receiptSettings.previewTimesVal;
     previewPaymentsVal=receiptSettings.previewPaymentsVal;
     blankLinesVal =receiptSettings.blankLinesVal;
 
     headerModel=receiptSettings.headerModel;
     orderDetailsModel=receiptSettings.orderDetails;
     kitchenItemsModel=receiptSettings.items;
     packagingQualityModel=receiptSettings.packagingQualityModel;

     clientCommentSize=receiptSettings.clientCommentSize;
     isPaidTitleSize=receiptSettings.isPaidTitleSize;

     premiseTypeVal=receiptSettings.premiseTypeVal;
     premiseTypeFinalVal=receiptSettings.premiseTypeFinalVal;
     data2=receiptSettings.finalCompList;

     debugPrint("data2 data implemented");
    }
    // debugPrint("data2 data implemented ${widget.recieptDataMap}");
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
             String filepath=await demoKitchenPdfGenerate(
                  previewOrdersVal,
                  previewTimesVal,
                  previewPaymentsVal,
                  blankLinesVal,
                  
                  headerModel,
                  onPermiseSize,
                  orderDetailsModel,
               
                  kitchenItemsModel,
                  packagingQualityModel,
                 
                  clientCommentSize,
                  isPaidTitleSize,
                
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
        // actions: [
        //   GestureDetector(
        //     onTap: () async {
        //       await getActiveComponents();
        //
        //       debugPrint("final list to show is $finalCompList");
        //       demoKitchenPdfGenerate(
        //           previewOrdersVal,
        //           previewTimesVal,
        //           previewPaymentsVal,
        //           blankLinesVal,
           //       
        //           headerModel,
        //           onPermiseSize,
        //           orderDetailsModel,
         //      
        //           kitchenItemsModel,
        //           packagingQualityModel,
         //        
        //           clientCommentSize,
        //           isPaidTitleSize,
        //        
        //           premiseTypeVal,
        //           otherTextController.text.trim(),
        //           premiseTypeFinalVal,
        //           finalCompList);
        //     },
        //     child: Container(
        //       width: MediaQuery.sizeOf(context).width / 9.9,
        //       height: MediaQuery.sizeOf(context).width / 9.9,
        //       decoration: BoxDecoration(
        //           image: DecorationImage(
        //               image: AssetImage("assets/icons/preview.png"))),
        //     ),
        //   ),
        //   SizedBox(
        //     width: 15,
        //   ),
        //   GestureDetector(
        //       onTap: () async {
        //         saveRecieptPreferences();
        //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Template Saved !')));
        //       },
        //       child: Container(
        //         width: MediaQuery.sizeOf(context).width / 9.9,
        //         height: MediaQuery.sizeOf(context).width / 9.9,
        //         decoration: BoxDecoration(
        //             image: DecorationImage(
        //                 image: AssetImage("assets/icons/save_file.png"))),
        //       )),
        //   SizedBox(
        //     width: 15,
        //   ),
        // ], 
        
        title: Text(
          "Receipt Components",
          style: TextStyle(
              fontSize: 18,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.primaryColor),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                _updateItems(oldIndex, newIndex);
              });
            },
            children: [
              for (final item in (widget.recieptDataMap.isNotEmpty && widget.recieptDataMap!=null)?data2:data)
                ExpansionTile(
                  childrenPadding: EdgeInsets.all(10),
                  key: ValueKey(item.keys.first),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width/2,
                        child: Text(item.keys.first,overflow: TextOverflow.ellipsis,maxLines: 2,
                            style: const TextStyle(fontSize: 17)),
                      ),
                      if (item.keys.first != "Preview Options" && item.keys.first != "Ticket holder space")
                        SizedBox(
                          width: 30,
                          child:  SizedBox(
                          width: 30,
                          child: Switch(
                              activeColor: AppAssets.greenColor,
                              value: item.values.first,
                              onChanged: (bool value) {
                                setState(() {
                                  // if(value==false){
                                  //   finalCompList.remove(item.keys.first);
                                  // }else{
                                  //   finalCompList.add(item.keys.first);
                                  // }
                                  item.update(item.keys.first, (itemValue) {
                                    itemValue = value;
                                    return itemValue;
                                  });
                                });
                              }),
                        ),
                        ),
                    ],
                  ),
                  children: [
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
                          if (premiseTypeVal == "other" &&
                              previewOrdersVal == "On premise")
                            SizedBox(
                              height: 10,
                            ),
                          if (premiseTypeVal == "other" &&
                              previewOrdersVal == "On premise")
                            ListTile(
                              title: Text("other:"),
                              trailing: Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 0.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.only(left: 6, right: 6),
                                  child: TextField(
                                    controller: otherTextController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                  )),
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
                    if (item.keys.first == "Header")
                      Column(
                        children: [
                          ListTile(
                            title: Text("Type:"),
                            trailing: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(left: 6, right: 6),
                              child: DropdownButton(
                                underline: SizedBox(),
                                padding: EdgeInsets.all(5),
                                value: headerModel.typeSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    headerModel.typeSize = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: Text("Delivery Time:"),
                            trailing: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(left: 6, right: 6),
                              child: DropdownButton(
                                underline: SizedBox(),
                                padding: EdgeInsets.all(5),
                                value: headerModel.fulfillmentSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    headerModel.fulfillmentSize =  newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        
                        ],
                      ),
                      if (item.keys.first == "on premise number")
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
                            value: onPermiseSize,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: fontSizes.map((int items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text("${items}px "),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                onPermiseSize = newValue!;
                              });
                            },
                          ),
                        ),
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
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // ListTile(
                          //   title: Text("Fulfillment:"),
                          //   trailing: Container(
                          //     decoration: BoxDecoration(
                          //         border: Border.all(
                          //             color: Colors.black, width: 0.5),
                          //         borderRadius: BorderRadius.circular(10)),
                          //     padding: EdgeInsets.only(left: 6, right: 6),
                          //     child: DropdownButton(
                          //       underline: SizedBox(),
                          //       padding: EdgeInsets.all(5),
                          //       value: orderDetailsModel.fullfilledSize,
                          //       icon: const Icon(Icons.keyboard_arrow_down),
                          //       items: fontSizes.map((int items) {
                          //         return DropdownMenuItem(
                          //           value: items,
                          //           child: Text("${items}px "),
                          //         );
                          //       }).toList(),
                          //       onChanged: (int? newValue) {
                          //         setState(() {
                          //           orderDetailsModel.fullfilledSize =
                          //               newValue!;
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    // if (item.keys.first == "Client Comment")
                    //   ListTile(
                    //     title: Text("Comment:"),
                    //     trailing: Container(
                    //       decoration: BoxDecoration(
                    //           border:
                    //               Border.all(color: Colors.black, width: 0.5),
                    //           borderRadius: BorderRadius.circular(10)),
                    //       padding: EdgeInsets.only(left: 6, right: 6),
                    //       child: DropdownButton(
                    //         underline: SizedBox(),
                    //         padding: EdgeInsets.all(5),
                    //         value: clientCommentSize,
                    //         icon: const Icon(Icons.keyboard_arrow_down),
                    //         items: fontSizes.map((int items) {
                    //           return DropdownMenuItem(
                    //             value: items,
                    //             child: Text("${items}px "),
                    //           );
                    //         }).toList(),
                    //         onChanged: (int? newValue) {
                    //           setState(() {
                    //             clientCommentSize = newValue!;
                    //           });
                    //         },
                    //       ),
                    //     ),
                    //   ),
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
                                value: kitchenItemsModel.titleSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    kitchenItemsModel.titleSize = newValue!;
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
                                value: kitchenItemsModel.itemsSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    kitchenItemsModel.itemsSize = newValue!;
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
                                value: kitchenItemsModel.choicAddonSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    kitchenItemsModel.choicAddonSize = newValue!;
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
                                value: kitchenItemsModel.itemCommentSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    kitchenItemsModel.itemCommentSize = newValue!;
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
                                  "Add Checkbox for quality control:"),
                              value: kitchenItemsModel.addCheckbox,
                              onChanged: (value) {
                                setState(() {
                                  kitchenItemsModel.addCheckbox = value;
                                });
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          CheckboxListTile(
                              title: Text("Show add-ons/sizes names:"),
                              value: kitchenItemsModel.showAddonNames,
                              onChanged: (value) {
                                setState(() {
                                  kitchenItemsModel.showAddonNames = value;
                                });
                              }),
                          //         SizedBox(
                          //   height: 10,
                          // ),
                          // CheckboxListTile(
                          //     title: Text(
                          //         "Show only the internal name, if available:"),
                          //     value: kitchenItemsModel.showInternalNames,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         kitchenItemsModel.showInternalNames = value;
                          //       });
                          //     }),
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
                  
                    if (item.keys.first == "Packaging station quality control")
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
                                value: packagingQualityModel.titleSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    packagingQualityModel.titleSize =
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
                            title: Text("Correct Items:"),
                            trailing: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(left: 6, right: 6),
                              child: DropdownButton(
                                underline: SizedBox(),
                                padding: EdgeInsets.all(5),
                                value: packagingQualityModel.correctItemsSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    packagingQualityModel.correctItemsSize =  newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                             SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: Text("All Items:"),
                            trailing: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(left: 6, right: 6),
                              child: DropdownButton(
                                underline: SizedBox(),
                                padding: EdgeInsets.all(5),
                                value: packagingQualityModel.allItemsSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    packagingQualityModel.allItemsSize =  newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                             SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: Text("Flyer:"),
                            trailing: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(left: 6, right: 6),
                              child: DropdownButton(
                                underline: SizedBox(),
                                padding: EdgeInsets.all(5),
                                value: packagingQualityModel.flyerSize,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fontSizes.map((int items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text("${items}px "),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    packagingQualityModel.flyerSize =  newValue!;
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
