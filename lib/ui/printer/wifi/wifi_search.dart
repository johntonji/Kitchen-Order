import 'dart:io';

import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/ui/printer/wifi/wifi_printers_found.dart';

class WifiSearch extends StatefulWidget {
  const WifiSearch({super.key});

  @override
  State<WifiSearch> createState() => _WifiSearchState();
}

class _WifiSearchState extends State<WifiSearch> {
 @override
  void initState() {
    getHostName("192.168.0.150");
    super.initState();
  }

 getHostName(String ip) async {
  try {
    ProcessResult result = await Process.run('nslookup', [ip]);
     debugPrint("name of device with Ip $ip is ${result.stdout.toString()}");
  } catch (e) {
    debugPrint("Error in getting device name: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Network cable or Wifi',
          style: TextStyle(
              fontSize: 18,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                'Make sure that printer and this sevice are connected through same network.',
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppAssets.nunitoBold,
                    color: AppAssets.textLightGrayColor)),
            SizedBox(
              height: 20,
            ),
            Text(
                'For example printer is plugged into a Wifi router(using a network cable). In such case you should connect this device to the same Wifi',
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppAssets.nunitoBold,
                    color: AppAssets.textLightGrayColor)),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.amber)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> PrinterScanner()));
                    },
                    child: Text("Start Search".toUpperCase() ,style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppAssets.nunitoBold,
                      color: AppAssets.whiteColor))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
