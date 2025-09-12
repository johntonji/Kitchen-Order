
import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/ui/printer/bluetooth/bluetooth_search.dart';
import 'package:order_receiving/ui/printer/wifi/wifi_search.dart';

class AddPrinters extends StatefulWidget {
  const AddPrinters({Key? key}) : super(key: key);

  @override
  State<AddPrinters> createState() => _AddPrintersState();
}

class _AddPrintersState extends State<AddPrinters> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Add Printer(s)',style: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoBold, color: AppAssets.primaryColor),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text("Choose how this device will connect to Printer".toUpperCase(),style: TextStyle(fontSize: 13, fontFamily: AppAssets.nunitoBold, color: AppAssets.textLightGrayColor),),
            ),
            const Divider(),
            ListTile(
              title: Text('Network cable or Wifi',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppAssets.nunitoBold,
                      color: AppAssets.primaryColor)),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> WifiSearch()));
                      },
            ),
            ListTile(
              title: Text('Bluetooth',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppAssets.nunitoBold,
                      color: AppAssets.primaryColor)),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BluetoothSearch()));
                      },
            )
          ],
          ),
        ),);
  }
}
