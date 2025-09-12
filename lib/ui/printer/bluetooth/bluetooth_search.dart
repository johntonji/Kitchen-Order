
import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/ui/printer/bluetooth/bluetooth_printers_found.dart';

class BluetoothSearch extends StatefulWidget {
  const BluetoothSearch({Key? key}) : super(key: key);

  @override
  State<BluetoothSearch> createState() => _BluetoothSearchState();
}

class _BluetoothSearchState extends State<BluetoothSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bluetooth',
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
                'To connect to Bluetooth printer press on the blutooth button on the printer for about 10 seconds and then press "Start Search" button on the app',
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppAssets.nunitoBold,
                    color: AppAssets.textLightGrayColor)),
            SizedBox(
              height: 20,
            ),
            Text(
                'If printer does not appear on the app , please repeate the process(Note: Most printers have a LED that lights up when bluetooth is on).',
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BluetoothPrintersFound()));
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
