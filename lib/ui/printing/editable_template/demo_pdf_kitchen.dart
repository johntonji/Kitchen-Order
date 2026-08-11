import 'package:order_receiving/main.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_client.dart';
import 'package:order_receiving/ui/printing/editable_template/demo_pdf_client.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

Future<String> demoKitchenPdfGenerate(
    String previewOrdersVal,
     String phone,
       String address,
    ContactDetailsModel contactDetailsModel,
    String logo,
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

    InfoBox1Model infoBox1Model,
    InfoBox2Model infoBox2Model,

    String premiseTypeVal,
    String otherPremise, String premiseTypeFinalVal,
    List<String> finalCompList) async {
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

   Uint8List imageBytes = convertBase64Image(logo);
   final pw.ImageProvider logoImage =await getGrayscalePdfImage(imageBytes);  

    // Add receipt content
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // 80mm receipt size
        build: (pw.Context context) {
          return pw.Column(
            children: [
              if(finalCompList.contains("Merchant Contact Details"))
                 pw.Image(logoImage, width: 50, height: 70), 
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
                       (address!=null)? formatAddress(address): "",
                            style: pw.TextStyle(
                                fontSize:
                                    contactDetailsModel.addressSize!.toDouble())),
                    pw.Text(
                        textAlign: TextAlign.center,
                         (phone!=null || phone!="") ?"$phone": "",
                            style: pw.TextStyle(
                                fontSize:
                                    contactDetailsModel.phoneSize!.toDouble())),
                  ]
                 ),
               pw.Column(
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
       (previewPaymentsVal=="COD")? "COD" : "Card",
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
        pw.Text( "Exp. ${previewOrdersVal.firstToUpper()}:", style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: headerModel.fulfillmentSize?.toDouble()))),
        pw.Text("10 March at 08:42AM", style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: headerModel.fulfillmentSize?.toDouble())),
          ]
        ),
         pw.SizedBox(height: 3),
         pw.Divider(),
         pw.SizedBox(height: 15),
              ]
            ),
            pw.Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                            pw.Column(
           crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
                if(finalCompList[finalIndex]=="Your info box 1")
     pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          infoBox1Model.title!,
          textAlign: TextAlign.left,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: infoBox1Model.titleSize!.toDouble()),
        ),
        SizedBox(height: 6),
        pw.Container(
          width: 180,
          child: pw.Text(infoBox1Model.text!, style: pw.TextStyle(color: PdfColors.black, fontSize: infoBox1Model.textSize!.toDouble()),maxLines: 6)),
        SizedBox(height: 15),

      ]
     ),
     if(finalCompList[finalIndex]=="Your info box 2")
     pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          infoBox2Model.title!,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: infoBox2Model.titleSize!.toDouble()),
        ),
        SizedBox(height: 6),
        pw.Container(
          width: 180,
          child:pw.Text(
             infoBox2Model.text!, style: pw.TextStyle(color: PdfColors.black, fontSize: infoBox2Model.textSize!.toDouble()),maxLines: 6) )
       
       , SizedBox(height: 15),
      ]
     ),
          ]
        ),     
    
              ]
            ),
      
        
      
      if(finalCompList[finalIndex]=="Order details")
        pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
        pw.Text('Order Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: orderDetailsModel.titleSize!.toDouble())),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Number:' ,style: pw.TextStyle(fontSize: orderDetailsModel.numberSize!.toDouble())),
                  pw.Text("1",style: pw.TextStyle(fontSize: orderDetailsModel.numberSize!.toDouble())),
                ],
              ),
                pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                 pw.Text('Placed at:',style: pw.TextStyle(fontSize: orderDetailsModel.placedSize!.toDouble())),
                 pw.Text('March 10 at 07:42 AM',style: pw.TextStyle(fontSize: orderDetailsModel.placedSize!.toDouble())),
                ],
              ),
               pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                 pw.Text('Accepted at:',style: pw.TextStyle(fontSize:orderDetailsModel.acceptedSize!.toDouble())),
                 pw.Text('March 10 at 07:42 AM',style: pw.TextStyle(fontSize:orderDetailsModel.acceptedSize!.toDouble())),
                ],
              ),
            pw.SizedBox(height: 20),
               ]
      ),

   if(finalCompList[finalIndex]=="Items")
      pw.Column( 
       crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
              pw.Text('Items:', style: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: kitchenItemsModel.titleSize!.toDouble())),
            
                 pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                  pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text("2X  Pizza Prosciutto",style: pw.TextStyle(fontSize: kitchenItemsModel.itemsSize!.toDouble())),
              if(kitchenItemsModel.addCheckbox==true)
             pw.Image(uncheckedImage, width:kitchenItemsModel.itemsSize!.toDouble()+8, height: kitchenItemsModel.itemsSize!.toDouble()+8), 

              ],
              ),
              if(kitchenItemsModel.showAddonNames==true)
                      pw.Text('- Size:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                 pw.Row(
                  children: [
                    // if(kitchenItemsModel.showAddonNames==true)
                    //   pw.Text('Size:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                      pw.Text(' * Small',style: pw.TextStyle(fontSize: kitchenItemsModel.itemCommentSize!.toDouble(),fontItalic: Font.timesItalic())),
                  ]
                 ),
                 if(kitchenItemsModel.showAddonNames==true)
               pw.Text('- Crust:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                 pw.Row(
                  children: [
              //       if(kitchenItemsModel.showAddonNames==true)
              //  pw.Text('Crust:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
              pw.Text(' * Fluffy',style: pw.TextStyle(fontSize: kitchenItemsModel.itemCommentSize!.toDouble(),fontItalic: Font.timesItalic())),
                  ]
                 ),
                 if(kitchenItemsModel.showAddonNames==true)
                      pw.Text('- Toppings:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                     pw.Row(
                      children: [
                      //    if(kitchenItemsModel.showAddonNames==true)
                      // pw.Text('Toppings:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                      pw.Text(' * Extra mozzarella ',style: pw.TextStyle(fontSize: kitchenItemsModel.itemCommentSize!.toDouble(),fontItalic: Font.timesItalic())),
                      
                    ]
                  ),
                
              //     pw.Row(
              //   children: [
              //      if (commentImage != null) pw.Image(commentImage, width: 10, height: 10), 
              //      pw.SizedBox(width: 5),
              //  pw.Text('No mushrooms, please!', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: kitchenItemsModel.itemCommentSize!.toDouble())),
               
              //   ]
              //  ),
              ]
            ),
              
             
               pw.SizedBox(height: 10),
          pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text('Pizza Pepperoni',style: pw.TextStyle(fontSize: kitchenItemsModel.itemsSize!.toDouble())),
             
              if(kitchenItemsModel.addCheckbox==true)
             pw.Image(uncheckedImage, width:kitchenItemsModel.itemsSize!.toDouble()+8, height: kitchenItemsModel.itemsSize!.toDouble()+8), 

                ],
              ),    
              if(kitchenItemsModel.showAddonNames==true)
                      pw.Text('- Size:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                pw.Row(
                  children: [
                      //  Text(" - "),
                    // if(kitchenItemsModel.showAddonNames==true)
                    //   pw.Text('Size:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                      pw.Text(' * Small',style: pw.TextStyle(fontSize: kitchenItemsModel.itemCommentSize!.toDouble(),fontItalic: Font.timesItalic())),
                    ]
                 ),
                   if(kitchenItemsModel.showAddonNames==true)
               pw.Text('- Crust:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                 pw.Row(
                  children: [
                      //  Text(" - "),
              //       if(kitchenItemsModel.showAddonNames==true)
              //  pw.Text('Crust:',style: pw.TextStyle(fontSize: kitchenItemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
              pw.Text(' * Crispy',style: pw.TextStyle(fontSize: kitchenItemsModel.itemCommentSize!.toDouble(),fontItalic: Font.timesItalic())),
                  ]
                 ),
          
              pw.SizedBox(height: 10),
                             ]
      ),

            if(finalCompList[finalIndex]=="Is Paid")
               pw.Column(
                    children: [
                          pw.Divider(),
                           pw.SizedBox(height: 3),
                 pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                children: [
                   if (uncheckedImage != null) pw.Image(uncheckedImage, width: isPaidTitleSize.toDouble()+8, height: isPaidTitleSize.toDouble()+8), 
                   pw.SizedBox(width: 6),
                  pw.Text('Paid', style: pw.TextStyle(fontSize: isPaidTitleSize.toDouble(), fontWeight: pw.FontWeight.bold)),
                  
                 ]
                ),
                   pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                children: [
                   if (checkedImage != null) pw.Image(checkedImage, width: 20, height: 20), 
                   pw.SizedBox(width: 6),
                  pw.Text('Not Paid', style: pw.TextStyle(fontSize: isPaidTitleSize.toDouble(), fontWeight: pw.FontWeight.bold)),
                 ]
                 )
                ],
              ),
               pw.SizedBox(height: 3),
               pw.Divider(),
              ]
              ),
    

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
              pw.Text(' Signature:.....................................',style: pw.TextStyle(fontSize:  packagingQualityModel.flyerSize!.toDouble())),
                pw.SizedBox(height: 30),
              ]
              ),
            ],
          );

            })
          )
        
          ]);
         
        },
      ),
    );

    // Save PDF to file
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = "${directory.path}/eatsBeeReceiptKitchenDemo.pdf";
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print("PDF saved successfully at: $filePath");
    return filePath;
  } catch (e) {
    print("Error generating PDF: $e");
    return "";
  }
}