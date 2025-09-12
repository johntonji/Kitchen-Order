import 'dart:convert';
import 'package:order_receiving/main.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/ui/printing/dynamic_template/print_pdf_dyn_client.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:open_filex/open_filex.dart';
import 'package:image/image.dart' as img;

// Future<void> openPdfFile(String filePath) async {
//   final result = await OpenFilex.open(filePath);
//   print("Open result: ${result.message}");
// }

Uint8List convertBase64Image(String base64String) {
  return base64Decode(base64String);
}

Future<pw.ImageProvider> getGrayscalePdfImage(Uint8List originalBytes) async {
  // Decode image from bytes
  img.Image? originalImage = img.decodeImage(originalBytes);
  if (originalImage == null) throw Exception("Image decoding failed");

  // Convert to grayscale
  img.Image grayscaleImage = img.grayscale(originalImage);

  // Encode back to PNG
  Uint8List grayscaleBytes = Uint8List.fromList(img.encodePng(grayscaleImage));

  // Convert to pw.MemoryImage
  return pw.MemoryImage(grayscaleBytes);
}
Future<String> demoClientPdfGenerate(
  String phone,
  String logo,
  String address,
    String previewOrdersVal,
    String previewTimesVal,
    String previewPaymentsVal,
    int blankLinesVal,
    // PreviewOptionsModel previewOptionsModel,
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
    String otherPremise, String premiseTypeFinalVal
    , List<String> finalCompList) async {
      
      print("component list in function is $finalCompList");
  try {
    final pdf = pw.Document();
  //comment
  final ByteData commentImageData = await rootBundle.load('assets/icons/comment.png');
  final Uint8List commentImageBytes = commentImageData.buffer.asUint8List();
  final pw.ImageProvider commentImage = pw.MemoryImage(commentImageBytes);

   //circularUnchecked
  final ByteData circularUncheckedImageData = await rootBundle.load('assets/icons/circular_uncheck.png');
  final Uint8List circularUncheckedImageBytes = circularUncheckedImageData.buffer.asUint8List();
  final pw.ImageProvider circularUncheckedImage = pw.MemoryImage(circularUncheckedImageBytes);  

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
                 pw.Image(logoImage, width: 50, height: 70), 
                 SizedBox(height: 6),
                 if(finalCompList.contains("Merchant Contact Details"))
                 Column(
                  children: [
                        pw.Text(
                          textAlign: TextAlign.center,
                       (address!=null)? formatAddress(address): "",
                            style: pw.TextStyle(
                                fontSize:
                                    contactDetailsModel.addressSize!.toDouble())),
                    pw.Text(
                        textAlign: TextAlign.center,
                         (phone!=null || phone!="") ?"Phone : $phone": "",
                            style: pw.TextStyle(
                                fontSize:
                                    contactDetailsModel.phoneSize!.toDouble())),
                  ]
                 ),
             SizedBox(height: 20),
            pw.Column(
              children: List.generate(finalCompList.length,(finalIndex){
          return  pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
            if(finalIndex==0)
            pw.ListView(children: List.generate(blankLinesVal, (j){
             return pw.SizedBox(height: 15);
            }
           )),

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
         pw.Text(infoBox1Model.text!, style: pw.TextStyle(color: PdfColors.black, fontSize: infoBox1Model.textSize!.toDouble())),

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
         pw.Text(infoBox2Model.text!, style: pw.TextStyle(color: PdfColors.black, fontSize: infoBox2Model.textSize!.toDouble())),
        SizedBox(height: 15),
      ]
     ),
          ]
        ),   
 


///////////
      if(finalCompList[finalIndex]=="Payment method")
            pw.Column(
              children: [
        pw.Row(
         children: [
         pw.Text(
          (previewPaymentsVal=="COD")? "COD" : "Card",
          style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: paymentMethodModel.titleSize!.toDouble()),
        ),
       ]
      ),
        SizedBox(height: 3),
       if(paymentMethodModel.showCardDetails==true && previewPaymentsVal!="COD")
           pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("mastercard", style: pw.TextStyle(color: PdfColors.black, fontSize: paymentMethodModel.cardDetailsSize!.toDouble())),
              pw.Text("ending in 1111", style: pw.TextStyle(color: PdfColors.black, fontSize: paymentMethodModel.cardDetailsSize!.toDouble())),
            ],
           ),
                pw.Divider(),
              ]
            ),
                
     

  if(finalCompList[finalIndex]=="Time")
         pw.Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                   SizedBox(height: 3),
      
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Exp. ${previewOrdersVal.firstToUpper()} :", style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: timeTitleSize.toDouble())),
             if(previewTimesVal=="now")
               Spacer(),
              pw.Expanded( child: 
               pw.Text((previewTimesVal=="now") ?"$previewTimesVal (60 min)" : "$previewTimesVal (10 March at 08:42AM)",maxLines: 2, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: timeTitleSize.toDouble())),
              )
            ],
          ),
      
          SizedBox(height: 3),
          pw.Divider(),
         ]
      ),
      if(finalCompList[finalIndex]=="Delivery/Pickup")
     pw.Column(
        children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
              if(previewOrdersVal!="Delivery" )
        pw.Text( "Order Type:", style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: directionModel.titleSize!.toDouble())),

        pw.Text( (previewOrdersVal!="On premise") ? previewOrdersVal:(premiseTypeVal=="other")?otherPremise: premiseTypeFinalVal, style: pw.TextStyle( fontWeight: pw.FontWeight.bold, fontSize: directionModel.titleSize!.toDouble())),

          ]
        ),
        SizedBox(height: 2),
        if(previewOrdersVal=="Delivery" )
        Row(
          children: [
            Expanded(child: pw.Text(address ,style: pw.TextStyle(fontSize: directionModel.addressSize!.toDouble())),
              ) ]
        ),
         SizedBox(height: 3),
         pw.Divider(),
         SizedBox(height: 15),

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
        
          if(finalCompList[finalIndex]=="Client Info")
      pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
              pw.Text('Client Info:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: clientInfoModel.titleSize!.toDouble())),
               pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                 pw.Text('First Name:',style: pw.TextStyle(fontSize: clientInfoModel.firstSize!.toDouble())),
                 pw.Text("John",style: pw.TextStyle(fontSize: clientInfoModel.firstSize!.toDouble())),
               
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                 pw.Text('Last Name:',style: pw.TextStyle(fontSize: clientInfoModel.lastSize!.toDouble())),
                 pw.Text("Doe",style: pw.TextStyle(fontSize: clientInfoModel.lastSize!.toDouble())),
               
                ],
              ),
              if(clientInfoModel.showEmail==true)
                 pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Email:',style: pw.TextStyle(fontSize: clientInfoModel.emailSize!.toDouble())),
                  pw.Text("support@eatsbee.com",style: pw.TextStyle(fontSize: clientInfoModel.emailSize!.toDouble())),
                ],
              ),
               pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text('Phone:',style: pw.TextStyle(fontSize: clientInfoModel.phoneSize!.toDouble())),
              pw.Text("+1 000-000-0000",style: pw.TextStyle(fontSize: clientInfoModel.phoneSize!.toDouble())),

                ],
              ),
              pw.SizedBox(height: 20),
                     ]
      ),

   if(finalCompList[finalIndex]=="Items")
      pw.Column(
       crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
              pw.Text('Items:', style: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: itemsModel.titleSize!.toDouble())),
            
                 pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                  pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text("2X  Pizza Prosciutto",style: pw.TextStyle(fontSize: itemsModel.itemsSize!.toDouble())),
              pw.Text('\$19.10',style: pw.TextStyle(fontSize: itemsModel.itemsSize!.toDouble())),

                ],
              ),
                 pw.Row(
                  children: [
                       Text(" - "),
                    if(itemsModel.showAddonNames==true)
                      pw.Text('Size:',style: pw.TextStyle(fontSize: itemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                      pw.Text('Small',style: pw.TextStyle(fontSize: itemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                 Spacer(),
                      if(itemsModel.showAddonFees==true)
                      pw.Text('\$0.00',style: pw.TextStyle(fontSize: itemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic()))
                   
                  ]
                 ),
                 pw.Row(
                  children: [
                       Text(" - "),
                    if(itemsModel.showAddonNames==true)
               pw.Text('Crust:',style: pw.TextStyle(fontSize: itemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
              pw.Text('Fluffy',style: pw.TextStyle(fontSize: itemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                  Spacer(),
                      if(itemsModel.showAddonFees==true)
                      pw.Text('\$0.00',style: pw.TextStyle(fontSize: itemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic()))
                   
                  ]
                 ),
                     pw.Row(
                      children: [
                           Text(" - "),
                         if(itemsModel.showAddonNames==true)
                      pw.Text('Toppings:',style: pw.TextStyle(fontSize: itemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                      pw.Text('Extra mozzarella ',style: pw.TextStyle(fontSize: itemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic())),
                      Spacer(),
                      if(itemsModel.showAddonFees==true)
                      pw.Text('\$1.50',style: pw.TextStyle(fontSize: itemsModel.choicAddonSize!.toDouble(),fontItalic: Font.timesItalic()))
                   
                    ]
                  ),
                
              //     pw.Row(
              //   children: [
              //      if (commentImage != null) pw.Image(commentImage, width: 10, height: 10), 
              //      pw.SizedBox(width: 5),
              // //  pw.Text('No mushrooms, please!', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: itemsModel.itemCommentSize!.toDouble())),
               
              //   ]
              //  ),
              ]
            ),
     
     
               pw.SizedBox(height: 15),
              pw.Divider(),
              pw.SizedBox(height: 15),

                pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text('Sub-Total',style: pw.TextStyle(fontSize: itemsModel.feesSize!.toDouble())),
              pw.Text('\$20.60',style: pw.TextStyle(fontSize: itemsModel.feesSize!.toDouble())),
                ],
              ), 
               pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text('Sales tax(6%)',style: pw.TextStyle(fontSize: itemsModel.feesSize!.toDouble())),
              pw.Text('\$0.70',style: pw.TextStyle(fontSize: itemsModel.feesSize!.toDouble())),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
              pw.Text('tip',style: pw.TextStyle(fontSize: itemsModel.feesSize!.toDouble())),
              pw.Text('\$5.00',style: pw.TextStyle(fontSize: itemsModel.feesSize!.toDouble())),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
               pw.Text('Total:', style: pw.TextStyle(fontSize: itemsModel.totalSize!.toDouble(), fontWeight: pw.FontWeight.bold)),
               pw.Text('\$26.30', style: pw.TextStyle(fontSize: itemsModel.totalSize!.toDouble(), fontWeight: pw.FontWeight.bold)),
                ],
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
              ]),

      if(finalCompList[finalIndex]=="Client confirmation")
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
              pw.Text('Client Confirmation:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: clientConfirmationModel.titleSize!.toDouble())),
              pw.SizedBox(height: 10),
              pw.Text('I acknowledge reception of order ID 1 from ${PlaceName(address)} on March 10.',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
              pw.SizedBox(height: 5),
              
              if(paymentMethodModel.showCardDetails==true && previewPaymentsVal=="Card")
              Column(
                children: [
             pw.Text('I acknowledge John Doe\'s card ending in 1111 was charged with his/her consent.',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
             
              pw.Row(  children: [
                           pw.Text('Entry Mode :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text("MANUAL",style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                         ),

                          pw.Row(
                          children: [
                           pw.Text('Transaction Type :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text("SALE",style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                         ),

                          pw.Row(
                          children: [
                           pw.Text('Authorization :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text("APPROVED",style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),

                          pw.Row(
                          children: [
                           pw.Text('Card Type :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text("ABC CARD",style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),

                          pw.Row(
                          children: [
                           pw.Text('Card :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text('**** **** **** 1234',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),

                          pw.Row(
                          children: [
                           pw.Text('Transaction ID :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text("12345678",style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),

                          pw.Row(
                          children: [
                           pw.Text('Invoice Number :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
                           pw.Text("12345678",style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                          ]
                          ),
              pw.Row(
                children: [
               pw.Text('Payment Auth code :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
               pw.Text('ABCD12',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                ]
              ),
              pw.Row(
                children: [
              pw.Text('Transcation Time  :',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble(),fontWeight: pw.FontWeight.bold)),
              pw.Text('March 10 at 07:42 AM',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                ]
              ),
                    

             ]
            ),

             
              pw.SizedBox(height: 10),
              pw.Text('My name is:',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
              if (circularUncheckedImage != null) pw.Image(circularUncheckedImage, width: 10, height: 10), 

               pw.SizedBox(width: 5),
               pw.Text('John Doe',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
                ]
              ),
              pw.SizedBox(height: 10),
               pw.Row(
                children: [
          if (circularUncheckedImage != null) pw.Image(circularUncheckedImage, width: 10, height: 10), 

               pw.SizedBox(width: 5),
               pw.Text('...................................................................',style: pw.TextStyle(fontSize: 9)),
               ]
              ),
              pw.SizedBox(height:5 ),
              pw.Text('I am authorized to act on behalf of John Doe',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
              pw.SizedBox(height: 30),
              pw.Text(' Signature:...................................................',style: pw.TextStyle(fontSize: clientConfirmationModel.textSize!.toDouble())),
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
    String filePath = "${directory.path}/eatsBeeReceiptClientDemo.pdf";
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print("PDF saved successfully at: $filePath");

    return filePath;

  } catch (e) {
    print("Error generating PDF: $e");
    return "";
  }
}