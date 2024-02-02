import 'dart:typed_data';
import 'dart:ui';
import 'package:order_receiving/models/order_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../assets/app_assets.dart';

Future<Uint8List> makePdf(OrderModel orderModel) async {
  final pdf = Document();
  final imageLogo = MemoryImage((await rootBundle.load(AppAssets.appLogo)).buffer.asUint8List());

  pdf.addPage(
    MultiPage(
      pageTheme: const PageTheme(orientation: PageOrientation.portrait,),
      build: (context) {
        return <Widget> [
          _headerLayout(orderModel),
          /*for(int i=0; i<teachersList.length; i++)
            _fetchSingleTeacher(workloadList, teachersList[i].userModel.userId),*/
        ];
      }),
  );
  return pdf.save();
}

_emptyRow() {
  return Table(border: TableBorder.all(color: PdfColors.black), children: [
    ]);
}

_headerLayout(OrderModel orderModel){
  return Column(children: [
    Text("EatsBee Orders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 4),
    Text("Order ID: ${orderModel.orderData!.orderId}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 10),
    Table(
        border: TableBorder.all(color: PdfColors.black),
        children: [
          TableRow(children: [
            Padding(padding: const EdgeInsets.only(left: 10, right: 10, top: 26), child: Text("#", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.only(top: 26), child: Center( child: Text("Name & Designation", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),),
            Expanded(flex:4, child: Table(border: TableBorder.all(color: PdfColors.black), children: [
              TableRow(children: [
                Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Name of Classes in own And other departments + course title for which payment will not be demanded+credit hours", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                Padding(padding: const EdgeInsets.all(4), child: Text("Name of Classes in own And other departments + course title for which payment will be demanded+credit hours", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
                ]),
              TableRow(children: [
                Padding(padding: const EdgeInsets.all(4), child: Text("Own/Other Departments", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
                Padding(padding: const EdgeInsets.all(4), child: Text("Own/Other Departments", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),
              ]),
              TableRow(children: [
                Table(border: TableBorder.all(color: PdfColors.black), children: [
                  TableRow(children: [
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Sr\n#", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 4, right: 4, top: 8), child: Text("Class", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Reg/SS", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 4, right: 4, top: 8), child: Text("Course Title", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),),
                    Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(4), child: Text("Course Code", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Cr.Hr", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(4), child: Text("Semester/\nSession", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                  ]),
                ]),
                Table(border: TableBorder.all(color: PdfColors.black), children: [
                  TableRow(children: [
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Sr\n#", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 4, right: 4, top: 8), child: Text("Class", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Reg/SS", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 4, right: 4, top: 8), child: Text("Course Title", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),),
                    Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(4), child: Text("Course Code", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(child: Padding(padding: const EdgeInsets.all(4), child: Text("Cr.Hr", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                    Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(4), child: Text("Semester/\nSession", style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.center),),),
                  ]),
                ]),
              ]),
            ])),
          ]),
        ]),
  ]);
}