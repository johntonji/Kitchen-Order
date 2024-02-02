import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/ui/order_printing/pdfexport.dart';
import 'package:printing/printing.dart';

import '../../assets/app_assets.dart';

class OrderPrinting extends StatefulWidget {
  OrderModel orderModel;
  OrderPrinting({required this.orderModel, Key? key}) : super(key: key);

  @override
  State<OrderPrinting> createState() => _OrderPrintingState();
}

class _OrderPrintingState extends State<OrderPrinting> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppAssets.backgroundColor,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.only(left: 0, right: 10),
                decoration: BoxDecoration(
                    color: AppAssets.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppAssets.textNormalGrayColor.withOpacity(0.3),
                        spreadRadius: 6,
                        blurRadius: 12,
                        offset: const Offset(0, 6), // changes position of shadow
                      )]
                ),
                child: Row(children: [
                  GestureDetector(onTap: () {Navigator.of(context).pop();}, child: Container(padding: const EdgeInsets.all(16), height: 50, width: 50, child: Icon(MdiIcons.chevronLeft))),
                  Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Order Receipt", style: TextStyle(fontSize: 20, fontFamily: AppAssets.nunitoMedium), maxLines: 1, overflow: TextOverflow.ellipsis,)))),
                  Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
                ],),
              ),
              Expanded(
                child: PdfPreview(
                  canChangeOrientation: true,
                  canDebug: false,
                  padding: const EdgeInsets.only(top: 100),
                  build: (context) => makePdf(widget.orderModel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
