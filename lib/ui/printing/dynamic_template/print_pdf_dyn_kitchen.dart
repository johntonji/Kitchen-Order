import 'dart:typed_data';
import 'package:order_receiving/main.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_client.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;


// Future<void> openPdfFile(String filePath) async {
//   final result = await OpenFilex.open(filePath);
//   print("Open result: ${result.message}");
// }

Future<String> dynKitchenPdfGenerate(
    OrderModel orderModal,

    String previewOrdersVal,
    String previewTimesVal,
    String previewPaymentsVal,
    int blankLinesVal,
    HeaderModel headerModel,
    int onPremiseSize,
    OrderDetailsModel orderDetailsModel,
    KitchenItemsModel kitchenItemsModel,
    PackagingQualityModel packagingQualityModel,
    int clientCommentSize,
    int isPaidTitleSize,

    String premiseTypeVal,
    String otherPremise, String premiseTypeFinalVal,
    List<String> finalCompList) async {
      print("accepted at time in kitchen pdf is ${orderModal.orderData.acceptedAt}");
      print("component list in function is $finalCompList");
  try {
    final pdf = pw.Document();
  //comment
  final ByteData commentImageData = await rootBundle.load('assets/icons/comment.png');
  final Uint8List commentImageBytes = commentImageData.buffer.asUint8List();
  final pw.ImageProvider commentImage = pw.MemoryImage(commentImageBytes);

     //unchecked
  final ByteData uncheckedImageData = await rootBundle.load('assets/icons/unchecked.png');
  final Uint8List uncheckedImageBytes = uncheckedImageData.buffer.asUint8List();
  final pw.ImageProvider uncheckedImage = pw.MemoryImage(uncheckedImageBytes); 
  
     //unchecked
  final ByteData checkedImageData = await rootBundle.load('assets/icons/checked.png');
  final Uint8List checkedImageBytes = checkedImageData.buffer.asUint8List();
  final pw.ImageProvider checkedImage = pw.MemoryImage(checkedImageBytes);  


    // Add receipt content
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // 80mm receipt size
        build: (pw.Context context) {
          return pw.Column(
            children: List.generate(finalCompList.length, (finalIndex){
        return  pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
            
            if(finalIndex==0)
            pw.ListView(children: List.generate(blankLinesVal, (j){
             return pw.SizedBox(height: 15);
            })),

      if(finalCompList[finalIndex]=="Header")
            pw.Column(
              children: [
        pw.Row(children: [
         pw.Text(
        (orderModal.orderData.paymentCode!=null)? (orderModal.orderData.paymentCode!.toUpperCase()=="TSYS") ?"CARD" : orderModal.orderData.paymentCode!.toUpperCase(): previewPaymentsVal ,
          style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: headerModel.typeSize!.toDouble()),
        ),
        ]),
       
         pw.SizedBox(height: 3),
        pw.Divider(),
         pw.SizedBox(height: 3),
       
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
          pw.Expanded(child: 
          pw.Text("Exp. ${orderModal.orderData.serviceCode.firstToUpper()}:", style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: headerModel.fulfillmentSize?.toDouble()))),
          pw.Text( (orderModal.orderData.whentoDeliver == "schedule") 
                 ? "${formatDate(orderModal.orderData.deliveryDate)} "
                //  at ${orderModal.orderData.deliveryTime}"
               :  (orderModal.orderData.deliveryTime.trim()!="") 
                ? addMinutesToTime(orderModal.orderData.acceptedAt!, timeToMinutes(orderModal.orderData.deliveryTime))
                :  "",
                // formatDateTime(orderModal.orderData.acceptedAt ?? ""), 
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: headerModel.fulfillmentSize?.toDouble())),
          ]
        ),
        pw.SizedBox(height: 3),
        pw.Divider(),
        pw.SizedBox(height: 18),
          ]
         ),

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
                            pw.Text((orderModal.orderData.acceptedAt!=null && orderModal.orderData.acceptedAt!="") 
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
    
                if (finalCompList[finalIndex] == "Items")
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Items:',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: kitchenItemsModel.titleSize!.toDouble())),
                        pw.ListView(
                            children:
                                List.generate(orderModal.items.length, (index) {
                          return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                  Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children:[
                                         pw.Text(
                                        "${orderModal.items[index].qty}X ${normalizeText(orderModal.items[index].itemName)}",
                                        style: pw.TextStyle(
                                            fontSize: kitchenItemsModel.itemsSize!
                                                .toDouble())),
                                          
                                          if(orderModal.items[index].price.sizeName!=null && orderModal.items[index].price.sizeName!="")
                                                 pw.Text(
                                        "(${normalizeText(orderModal.items[index].price.sizeName!)})",
                                        style: pw.TextStyle(
                                            fontSize: kitchenItemsModel.itemsSize!
                                                .toDouble())),
                                      ]
                                      ),
                                    if(kitchenItemsModel.addCheckbox==true)
                                    pw.Image(uncheckedImage, width:kitchenItemsModel.itemsSize!.toDouble()+8, height: kitchenItemsModel.itemsSize!.toDouble()+8), 

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
                                       if(kitchenItemsModel.showAddonNames==true) 
                                       if(addons.addonItems!=null && addons.addonItems!.isNotEmpty)
                                       if(addons.addonItems![0].pizzaPortionSectionId==null || addons.addonItems![0].pizzaPortionSectionId=="")
                                          pw.Text('- ${normalizeText(addons.subcategoryName!)}:',
                                            style: pw.TextStyle(
                                                fontSize: kitchenItemsModel.choicAddonSize!
                                                    .toDouble(),
                                                fontItalic:
                                                    Font.timesItalic())),
                                                                      ListView(
  children: groupAddonsByPortion(addons.addonItems!).entries.map((entry) {
    final portionId = entry.key;
    final items = entry.value;

    String portionTitle = "";

    if (portionId == "1") {
      portionTitle = "   - Whole Portion";
    } else if (portionId == "2") {
      portionTitle = "   - Left Portion";
    } else if (portionId == "3") {
      portionTitle = "   - Right Portion";
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [

        ///  Print Portion Title Only Once
        if (portionId != "no_portion")
          pw.Text(
            portionTitle,
            style: pw.TextStyle(
              fontSize: kitchenItemsModel.itemCommentSize!.toDouble(),
              fontItalic: Font.timesItalic(),
            ),
          ),

        ///  Print Items Under That Portion
        ...items.map((itemAddonItem) {
          return pw.Row(
            children: [

              pw.Text("      ${normalizeText(itemAddonItem.subItemName!)}",
                  style: pw.TextStyle(
                    fontSize: kitchenItemsModel.itemCommentSize!.toDouble(),
                    fontItalic: Font.timesItalic(),
                  )),

             
            ],
          );
        }).toList(),
      ],
    );
  }).toList(),
)
                                 
                                  //          ListView(
                                  //     children :  List.generate(
                                  //         addons.addonItems!
                                  //             .length, (i) {
                                     
                                  //  final itemAddonItem = addons.addonItems![i];
                                  //  return  pw.Row(children: [
                                  //   (!itemAddonItem.subItemName!.contains(":"))
                                  //   ? Text("  * ")
                                  //   : Text(" "),
                                  //     // if (kitchenItemsModel.showAddonNames == true)
                                      
                                  //       // pw.Text('${addons.subcategoryName}:',
                                  //       //     style: pw.TextStyle(
                                  //       //         fontSize: kitchenItemsModel.choicAddonSize!
                                  //       //             .toDouble(),
                                  //       //         fontItalic:
                                  //       //             Font.timesItalic())),
                                  //     (itemAddonItem.pizzaSizeName!=null && itemAddonItem.pizzaSizeName!="")
                                  //     ? pw.Column(
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: [
                                  //         pw.Text(
                                  //         "${normalizeText(itemAddonItem.pizzaSizeName!)} portion",
                                  //         style: pw.TextStyle(
                                  //             fontSize: kitchenItemsModel
                                  //                 .itemCommentSize!
                                  //                 .toDouble(),
                                  //             fontItalic: Font.timesItalic())),
                                  //             pw.Text(
                                  //         " -${normalizeText(itemAddonItem.subItemName!)}",
                                  //         style: pw.TextStyle(
                                  //             fontSize: kitchenItemsModel
                                  //                 .itemCommentSize!
                                  //                 .toDouble(),
                                  //             fontItalic: Font.timesItalic()))
                                  //       ]
                                  //     )
                                  //     : pw.Text(
                                  //        normalizeText(itemAddonItem.subItemName!),
                                  //         style: pw.TextStyle(
                                  //             fontSize: kitchenItemsModel
                                  //                 .itemCommentSize!
                                  //                 .toDouble(),
                                  //             fontItalic: Font.timesItalic())),
                                  //   ]);
                                  //    })
                                  // )
                                 
                                      ]
                                    ) ;
                                  })
                                  ),
                              
                                if (orderModal
                                            .items[index].specialInstructions !=
                                        null &&
                                    orderModal
                                            .items[index].specialInstructions !=
                                        "")
                                  pw.Row(
                                    children: [
                                      pw.Image(commentImage,
                                          width: 10, height: 10),

                                      pw.SizedBox(width: 5),
                                      pw.Text(
                                          orderModal.items[index]
                                              .specialInstructions!,
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: kitchenItemsModel
                                                  .itemCommentSize!
                                                  .toDouble())),       
                                      ],
                                    ),
                              SizedBox(height: 3)
                              ]);
                        })),
                              SizedBox(height: 10)
                        
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
                       
                      ] ),

     if(finalCompList[finalIndex]=="Packaging station quality control")
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
              pw.SizedBox(height: 10),
              pw.Text('Packaging station quality control:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize:  packagingQualityModel.titleSize!.toDouble())),
              pw.SizedBox(height: 10),
                 pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text('Correct Items',style: pw.TextStyle(fontSize: packagingQualityModel.correctItemsSize!.toDouble())),
             pw.Image(uncheckedImage, width: packagingQualityModel.correctItemsSize!.toDouble()+8, height: packagingQualityModel.correctItemsSize!.toDouble()+8), 
                ],
              ),  
               pw.SizedBox(height: 10),
                 pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text('All Items',style: pw.TextStyle(fontSize: packagingQualityModel.allItemsSize!.toDouble())),
             pw.Image(uncheckedImage, width: packagingQualityModel.allItemsSize!.toDouble()+8, height: packagingQualityModel.allItemsSize!.toDouble()+8), 
                ],
              ),
               pw.SizedBox(height: 10),
                 pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text('Flyer',style: pw.TextStyle(fontSize:  packagingQualityModel.flyerSize!.toDouble())),
             pw.Image(uncheckedImage, width: packagingQualityModel.flyerSize!.toDouble()+8, height: packagingQualityModel.flyerSize!.toDouble()+8), 
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text(' Signature:...................................................',style: pw.TextStyle(fontSize:  packagingQualityModel.flyerSize!.toDouble())),
                pw.SizedBox(height: 80),
              ]
              ),
            ],
          );
           })
          );
        },
      ),
    );

    // Save PDF to file
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = "${directory.path}/eatsBeeKitchenReceipt.pdf";
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the PDF
    // openPdfFile(filePath);
     
    print("PDF saved successfully at: $filePath");
     return filePath;
  } catch (e) {
    print("Error generating PDF: $e");
     return "";
  }
}