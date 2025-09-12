import 'dart:io';

import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/models/printer_modal.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/ui/printer/auto_print_orders.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:order_receiving/utilities/utility_class.dart';
import 'package:ping_discover_network_plus/ping_discover_network_plus.dart';
import 'package:provider/provider.dart';

class PrinterScanner extends StatefulWidget {
  
  @override
  _PrinterScannerState createState() => _PrinterScannerState();
}

class _PrinterScannerState extends State<PrinterScanner> {
  List<String> namesWIFiPrinters=[];
  List<Map<String,String>> foundPrinters = [{'ip':"",'port':'','name':''}];
  List<dynamic> channelWifiPrinters=[];
 bool isTapped=false;
  bool isScanning = true;
     List<String> selectedPrinters=[];
     List<dynamic> selectedPrintersMapList=[];

void getHostName(String ip) async {
  try {
    final result = await InternetAddress.lookup(ip);
    if (result.isNotEmpty) {
      namesWIFiPrinters.add(result.first.host);
    }
  } catch (e) {
    print("could not get name");
    // ignore
  }
  // return null;
}

////name
Future<void> scanNetwork() async {
  final ip = await NetworkInfo().getWifiIP();
  if (ip == null) return;

  final String subnet = ip.substring(0, ip.lastIndexOf('.'));
  const port = 9100;

  List<Future> futures = [];

  for (int i = 1; i < 255; i++) {
    final String targetIp = '$subnet.$i';

    futures.add(Socket.connect(targetIp, port, timeout: Duration(milliseconds: 300)).then((socket) async {
      try {
        final host = await InternetAddress(targetIp).reverse();
        print('✅ Found device at $targetIp with hostname: ${host.host}');
      } catch (_) {
        print('✅ Found device at $targetIp (no hostname)');
      } finally {
        socket.destroy();
      }
    }).catchError((error) {
      // ignore failed connections
    }));
  }

  await Future.wait(futures);
  print('🔍 scanNetwork Done');
}

  Future<void> scanForPrinters() async {
  //  channelWifiPrinters= await  Provider.of<AppProvider>(context,listen: false).getWifiPrintersWithName();
    
    setState(() {
      isScanning = true;
      foundPrinters.clear();
      isTapped=false;
    });

    final info = NetworkInfo();
    String? localIP = await info.getWifiIP();
    if (localIP == null) {
      setState(() {
        isScanning = false;
      });
      return;
    }

    List<String> ipParts = localIP.split('.');
    String subnet = "${ipParts[0]}.${ipParts[1]}.${ipParts[2]}";
    
/// for STAR Printer
    final stream2 =
    NetworkAnalyzer.i.discover2(subnet, 9101); // Check printer port

    await for (NetworkAddress addr in stream2) {
      if (addr.exists) {
        setState(() {
          foundPrinters.add({'ip':addr.ip,'port':"9101"});
        });
      }
    }

/// for EPSON Printer
    final stream = NetworkAnalyzer.i.discover2(subnet, 9100); // Check printer port

    await for (NetworkAddress addr in stream) {
      if (addr.exists) {
        /////
      setState(() {
          foundPrinters.add({'ip':addr.ip,'port':"9100"});
        });
      }
    }


          // ScaffoldMessenger.of(context).showSnackBar(
          //            SnackBar(
          //             content: Text("found printers are ${foundPrinters}"),
          //           ),
          //         );
                 

          // ScaffoldMessenger.of(context).showSnackBar(
          //            SnackBar(
          //             content: Text("found printer names are ${namesWIFiPrinters}"),
          //           ),
          //         );

    setState(() {

      isScanning = false;

    });

  }
  void filterPrinterList(){
StackTrace? stack;
  //  bugsnag.notify("Wi-Fi Printer Discovery Found printers: $foundPrinters", stack);
      print("1 found printers are $foundPrinters");
          for(Map<String,String> m in foundPrinters ){

            bool has9100 = foundPrinters.any((e) => e['ip'] == m['ip'] && e['port'] == '9100');
            bool has9101 = foundPrinters.any((e) => e['ip'] == m['ip'] && e['port'] == '9101');

          if (has9100 && has9101) {
               foundPrinters.removeWhere((e) => e['ip'] == m['ip'] && e['port'] == '9100');
          }
         }

      // bugsnag.notify("2 Wi-Fi Printer Discovery Found printers: $foundPrinters", stack);
    print("2 found printers are $foundPrinters");
  }
  
 Future<bool> connectPrinter(String printerIp) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);
    PosPrintResult result  = await printer.connect(printerIp, port: 9100);
    if(result== PosPrintResult.success){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('printer Ip $printerIp added successfully')));
      //  connectedPrinters.add(printerIp);
      return true;
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could printer Ip $printerIp ')));
      return false;
    }
  }
////////////////
// Future<void> scanPrinters() async {
//   String subnet = "192.168.1"; // Change this based on your network
//   int port = 9100; // Common port for network printers
  
//   for (int i = 1; i < 255; i++) {
//     String ip = "$subnet.$i";
//     try {
//       final socket = await Socket.connect(ip, port, timeout: Duration(milliseconds: 500));
//       debugPrint("Printer found at: $ip");
//       socket.destroy();
//     } catch (e) {
//       // No printer found on this IP
//     }
//   }
// }
/////////////////


  /// Send ESC/POS command to get the printer name
  Future<String> getPrinterName(String ip) async {
    try {
      Socket socket = await Socket.connect(ip, 9100, timeout: Duration(seconds: 2));
      
      // ESC/POS Command: GS I 0x01 (Request Printer Name)
      List<int> command = [0x1D, 0x49, 0x01];
      socket.add(command);
      await socket.flush();
      
      List<int> response = [];
      socket.listen((data) {
        response.addAll(data);
      });

      await Future.delayed(Duration(seconds: 1));
      socket.destroy();

      if (response.isNotEmpty) {
         return response.toString();
        // return String.fromCharCodes(response).trim();
      }
    }catch (e) {
      debugPrint("Error getting printer name: $e");
    }
    return "Unknown Printer";
  }

@override
  void initState() {
    channelWifiPrinters.clear();
    scanForPrinters().then((onValue){
      filterPrinterList();
      });
    // scanNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, isChild) {
      return Scaffold(
        appBar: AppBar(title: Text("Searching Printers",style: TextStyle(
                fontSize: 18,
                fontFamily: AppAssets.nunitoBold,
                color: AppAssets.primaryColor),)),
        body: 
        isScanning
        ? Center(
          child: CircularProgressIndicator(color: Colors.amber,),
        )
        : Center(
          child:
        Column(
          mainAxisSize: MainAxisSize.max,
            children: [
              // SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: isScanning ? null : scanForPrinters,
              //   child: isScanning ? CircularProgressIndicator() : Text("Scan for Printers"),
              // ),
              SizedBox(height: 50),
              foundPrinters.isEmpty
                  ?  Column(
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
                SizedBox(
                  height: 20,
                ),
               OutlinedButton(
                style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black)),
                onPressed:(){
                  if(!isTapped){
                   isTapped=true;
                       if(isScanning==false){
                    try{
                      scanForPrinters().then((onValue){
                        filterPrinterList();
                      });
                    }catch(e){
                      print("exception in retry is $e");
                    }
                  }
                 }
                } ,
                 child: Text("Retry")),
              
              ],
            )
                  :
                   Expanded(
                      child: ListView.builder(
                        itemCount: foundPrinters.length,
                        itemBuilder: (context, index) {
                            bool addPrinter=true;
                          for(PrinterModal pm in provider.addedPrinterList){
                                                        if(foundPrinters[index]["ip"]==AppProvider.removePort(pm.ipAddress!)){
                                                          addPrinter=false;
                                                          break;
                                                        }
                                                      }
                          // getDeviceName(foundPrinters[index]);  ////added
                          return  CheckboxListTile(
                            controlAffinity : ListTileControlAffinity.leading,
                            title:  Text("Unknown Printer") , // printer name here
                            // title:  Text(foundPrinters[index]['ip']!),
                            subtitle:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("IP :${foundPrinters[index]['ip']!}"),
                                Text("Port :${foundPrinters[index]['port']}"),
                              ],
                            ),
                            value: (addPrinter==true) ? selectedPrinters.contains(foundPrinters[index]['ip']) :true , 
                            onChanged: (value) {
                              if(addPrinter==true){
                                      setState(() {
                                        if (selectedPrinters.contains(foundPrinters[index]['ip'])) {
                                          selectedPrinters.remove(foundPrinters[index]['ip']);
                                          selectedPrintersMapList.remove(foundPrinters[index]);
                                        }else {
                                         selectedPrinters.add(foundPrinters[index]['ip']!);
                                         selectedPrintersMapList.add(foundPrinters[index]);
                                       }
                                    });
                                  }
                               });
                        },
                      ),
                    ),
                           Spacer(),
                              foundPrinters.isNotEmpty
                              ? SizedBox(
                               width: MediaQuery.sizeOf(context).width,
                               child: TextButton(
                                  style: ButtonStyle( backgroundColor: WidgetStatePropertyAll((selectedPrinters.isEmpty)?const Color.fromARGB(255, 238, 211, 129) :Colors.amber)),
                                  onPressed: (selectedPrinters.isEmpty) 
                                    ? null
                                    : () async{
                                    List<Map<String,String>> savePrintersList=[];
                                    for(String i in selectedPrinters){
                                      savePrintersList.add({"ip":i,"name":""});
                                    }
                                    // Future.delayed(Duration(microseconds: 500),(){
                                    //  SharedPreferenceManager.getInstance().savePrinterList(savePrintersList);
                                    // });
                                    bool add=true;
                                     SharedPreferenceManager.getInstance().getUserData().then((data) { 
                                     for(String i in selectedPrinters){
                                      String printerName="";
                                      String port="";   //NEW
                                      for(dynamic v in selectedPrintersMapList){
                                        if(v["ip"]== i){
                                          printerName= "Unknown Printer";
                                          port=v["port"]!;   //NEW
                                          // v["name"]!;
                                        }
                                      }
                                      ///// 
                                    debugPrint("i is $i and authtoken is ${data.authToken}");
                                            PrinterModal printerModal =
                                                PrinterModal(
                                                    printerName:printerName,
                                                    ipAddress: "$i:$port",        //NEW appended port
                                                    autoPrint: "",
                                                    deviceUuid: "",
                                                    merchantId: data.merchantId,
                                                    printerType: "WiFi",
                                                    serviceId:"");
                                             for(PrinterModal pm in provider.addedPrinterList){
                                                        if(i==AppProvider.removePort(pm.ipAddress!)){
                                                          add=false;
                                                          break;
                                                        }
                                                      }

                                          if(add==true){
                                            provider.addPrinters(data.authToken!,printerModal).then((status){
                                              debugPrint("adding wifi printer status is ${status.message}");
                                               if (status.isSuccess) {
                                                   UtilityClass.showSuccessDialog(context,"Printer added successfully","");
                                                   }
                                                //   else {
                                                //    UtilityClass.showFailedDialog(context,"Failed",status.message);
                                                // } 
                                            });
                                            }else{
                                            debugPrint("printer already added!");
                                          }
                                            //  await connectPrinter(i);
                                    } 
                                    });
                                    
                                       UtilityClass.showLoadingDialog(context);
                                    Future.delayed(Duration(seconds: 2),()async{
                                    UtilityClass.dismissLoading(context);
                                      // if(devCon==false){
                                         int count = 0;
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 3; // Stops after popping 3 times (leaving 4t h page)
                                      });
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AutoPrintOrders()));
                                      // }
                                    });
                                    },
                              child: Text("Add Printer(s)".toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: AppAssets.nunitoBold,
                                          color: AppAssets.whiteColor))),
                            ) : SizedBox(), 
                            SizedBox(height: 20,) 
            ],
          ),
        ),
      );}
    );
  }

  /////// find name demo
  getDeviceName(String ipAddress) async {
  try {
    final host = await InternetAddress(ipAddress).reverse();
     debugPrint("name of device with Ip $ipAddress is ${host.host}");
  } catch (e) {
    debugPrint("Error in getting device name: $e");
  }
}
}

// import 'dart:io';

// Future<void> scanForPrinters() async {
//   String subnet = "192.168.1"; // Change this based on your network
//   int port = 9100; // Common port for network printers
  
//   for (int i = 1; i < 255; i++) {
//     String ip = "$subnet.$i";
//     try {
//       final socket = await Socket.connect(ip, port, timeout: Duration(milliseconds: 500));
//       debugPrint("Printer found at: $ip");
//       socket.destroy();
//     } catch (e) {
//       // No printer found on this IP
//     }
//   }
// }
