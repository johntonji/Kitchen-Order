import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';

class NoPrinters extends StatefulWidget {
  const NoPrinters({super.key});

  @override
  State<NoPrinters> createState() => _NoPrintersState();
}

class _NoPrintersState extends State<NoPrinters> {
  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              AppAssets.noPrinters,
              width: MediaQuery.sizeOf(context).width / 2.5,
              height: MediaQuery.sizeOf(context).width / 2.5,
            ),
            Text(
          'No printers found',
          style: TextStyle(
              fontSize: 14,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.primaryColor),
        ),
        SizedBox(height: 10,),
            Text(
                'Press on the blutooth button on the printer for about 10 seconds and then press "Retry" ',
                textAlign: TextAlign.center,
                 style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppAssets.nunitoBold,
                    color: AppAssets.textLightGrayColor)),
            SizedBox(
              height: 20,
            ),
           OutlinedButton(
            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black)),
            onPressed: (){

           }, child: Text("Retry")),
          
          ],
        );
  }
}