import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../assets/app_assets.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

class ScanDevices extends StatefulWidget {
  const ScanDevices({Key? key}) : super(key: key);

  @override
  State<ScanDevices> createState() => _ScanDevicesState();
}

class _ScanDevicesState extends State<ScanDevices> {

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  var _device;

  @override
  void initState() {
    super.initState();

    checkPermission();
  }

  checkPermission() async {
    //Ask for runtime permissions if necessary.
    var bluetoothStatus = await Permission.bluetooth.status;
    var scanStatus = await Permission.bluetoothScan.status;
    var connectStatus = await Permission.bluetoothConnect.status;
    var locationStatus = await Permission.location.status;

    //Bluetooth
    if (bluetoothStatus.isDenied || bluetoothStatus.isPermanentlyDenied) {
      bluetoothStatus = await Permission.bluetooth.request();
    }

    //Bluetooth Scan
    if (scanStatus.isDenied || scanStatus.isPermanentlyDenied) {
      scanStatus = await Permission.bluetoothScan.request();
    }

    //Bluetooth Connect
    if (connectStatus.isDenied || connectStatus.isPermanentlyDenied) {
      connectStatus = await Permission.bluetoothConnect.request();
    }

    //Location
    if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
      locationStatus = await Permission.location.request();
    }

    //bluetoothPrint.startScan(timeout: const Duration(seconds: 4));


    if (bluetoothStatus.isGranted && locationStatus.isGranted) {
      bluetoothPrint.startScan(timeout: const Duration(seconds: 4)).then((value) {
        //print(bluetoothPrint.scanResults.length);
        bluetoothPrint.stopScan();
      });
    }else{
      print("something is missing");
      openAppSettings();
    }
  }

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
                        color: AppAssets.textNormalGrayColor.withOpacity(0.05),
                        spreadRadius: 6,
                        blurRadius: 6,
                        offset: const Offset(0, 3), // changes position of shadow
                      )]
                ),
                child: Row(children: [
                  GestureDetector(onTap: () {Navigator.of(context).pop();}, child: Container(padding: const EdgeInsets.all(16), height: 50, width: 50, child: Icon(MdiIcons.chevronLeft))),
                  Expanded(child: Container(padding: const EdgeInsets.only(left: 20, right: 20), child: Center(child: Text("Scan Devices", style: TextStyle(fontSize: 20, fontFamily: AppAssets.nunitoMedium), maxLines: 1, overflow: TextOverflow.ellipsis,)))),
                  Container(padding: const EdgeInsets.all(10), height: 50, width: 50,),
                ],),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: StreamBuilder<List<BluetoothDevice>>(
                    stream: bluetoothPrint.scanResults,
                    initialData: [],
                    builder: (c, snapshot) {
                      print("_______: ${snapshot.data!}");
                      return Column(
                        children: snapshot.data!.map((d) =>
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: AppAssets.whiteColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(
                                  color: AppAssets.textNormalGrayColor.withOpacity(0.05),
                                  spreadRadius: 6,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3), // changes position of shadow
                                )],
                              ),
                              child: ListTile(
                                title: Text(d.name ?? ''),
                                subtitle: Text(d.address ?? ''),
                                onTap: () async {
                                  setState(() {
                                    _device = d;
                                  });
                                  await bluetoothPrint.connect(_device);
                                },
                                trailing: _device != null &&
                                    _device.address == d.address ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ) : null,
                              ),
                            )).toList(),
                      );
                    }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
