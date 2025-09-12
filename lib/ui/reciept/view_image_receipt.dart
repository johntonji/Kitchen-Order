import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:order_receiving/assets/app_assets.dart';
import 'package:pdf_render/pdf_render.dart' as render;


class ViewImageReceipt extends StatefulWidget {
  String filePath;
   ViewImageReceipt({super.key,required this.filePath});

  @override
  State<ViewImageReceipt> createState() => _ViewImageReceiptState();
}

class _ViewImageReceiptState extends State<ViewImageReceipt> {

Uint8List? imageBytes;

@override
void initState() {
  super.initState();
  loadImage();
}
Uint8List? convertImgToUint8List(img.Image? image) {
  if (image == null) return null;
  return Uint8List.fromList(img.encodePng(image));
}

Future<void> loadImage() async {
  final imgImage = await convertPdfToImage(widget.filePath);
  final bytes = convertImgToUint8List(imgImage);
  if (bytes != null) {
    setState(() {
      imageBytes = bytes;
    });
  }
}

Future<img.Image?> convertPdfToImage(String filePath) async {
  final doc = await render.PdfDocument.openFile(filePath);

final page = await doc.getPage(1);

// Get page size
final pageWidth = page.width;
final pageHeight = page.height;

// Set the target print width (576px for 80mm paper)
final targetWidth = 576;

// Maintain aspect ratio
final aspectRatio = pageHeight / pageWidth;
final targetHeight = (targetWidth * aspectRatio).round();

final pageImage = await page.render(
  width: targetWidth,
  height: targetHeight,
);

  final uiImage = await pageImage.createImageDetached();
  final byteData = await uiImage.toByteData(format: ImageByteFormat.png);

  if (byteData == null) return null;

  final pngBytes = byteData.buffer.asUint8List();
  final decodedImage = img.decodeImage(pngBytes);

  pageImage.dispose();
  // page.dispose(); // Don’t forget this

  return decodedImage;
}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.black,title:Text("Receipt Preview",style: TextStyle(fontFamily: AppAssets.nunitoRegular,color: Colors.white))),
      body: FutureBuilder<Uint8List?>(
        future: convertPdfToImage(widget.filePath).then(convertImgToUint8List),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child:  Text("Failed to load image",style: TextStyle(fontFamily: AppAssets.nunitoRegular,fontWeight: FontWeight.bold,color: Colors.white)));
          } else {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.sizeOf(context).width,
                child: SizedBox(
                   width: MediaQuery.sizeOf(context).width,
                    child:    InteractiveViewer(
      panEnabled: true, // Can pan the image
      minScale: 0.5,
      maxScale: 4,
      child: Image.memory(snapshot.data!),
   
                         )));
          }
        },
      ),
    );
  }
}
