import 'dart:io';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:order_receiving/models/printer_modal.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/providers/riverpod_provider.dart';
import 'package:order_receiving/ui/printer/add_printer.dart';
import 'package:order_receiving/ui/printer/edit_printer_name.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:ping_discover_network_plus/ping_discover_network_plus.dart';

import 'package:provider/provider.dart';
import '../../assets/app_assets.dart';

class AutoPrintOrders extends rv.ConsumerStatefulWidget {

   const AutoPrintOrders({super.key});

  @override
  rv.ConsumerState<AutoPrintOrders> createState() => _AutoPrintOrdersState();
}

class _AutoPrintOrdersState extends rv.ConsumerState<AutoPrintOrders> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  String deviceMessage = "";
  UserModel userModel=UserModel();  /////to get token
  bool _connected = true;
  String tips = 'no device connect';
  bool loading =true;
 bool devCon=false;

  @override
  void initState() {
    super.initState();
    getPrintersApi();  // get saved printers in api
      WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
      getConnected();
    scanForPrinters();
  }


List<String> apiAddedIp=[];
void getPrintersApi() async {
  try {
    final data = await SharedPreferenceManager.getInstance().getUserData();
    userModel = data;
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.getPrinters(data.authToken!, data.merchantId!);

    final addedPrinters = provider.addedPrinterList;

 
  // /*  
  // code to automatically make one printer as default priter if there's only one printer
  if ((AppProvider.defaultClientPrinterIp == "" || AppProvider.defaultKitchenPrinterIp == "") && addedPrinters.length == 1) {
      final singlePrinter = addedPrinters[0];
      
      if (AppProvider.defaultClientPrinterIp == "") {
        await provider.setDefaultPrinter(data.authToken!, data.merchantId!, singlePrinter.printerId!, "client");
        await provider.getdefaultPrinter(data.authToken!, data.merchantId!, "client");
        AppProvider.defaultClientPrinterIp = singlePrinter.ipAddress!;
      }

      if (AppProvider.defaultKitchenPrinterIp == "") {
        await provider.setDefaultPrinter(data.authToken!, data.merchantId!, singlePrinter.printerId!, "kitchen");
        await provider.getdefaultPrinter(data.authToken!, data.merchantId!, "kitchen");
        AppProvider.defaultKitchenPrinterIp = singlePrinter.ipAddress!;
      }
    } 
    // */
  } catch (e) {
    debugPrint("Error getting printers: $e");
  } finally {
    setState(() {
      loading = false;
    });
  }
}

 List<String> foundPrinters = [];
 List<PrinterModal> savedPrinters = [];
  bool isScanning = true;


////// Scan for WiFi printers 
  Future<void> scanForPrinters() async {
    setState(() {
      isScanning = true;
      foundPrinters.clear();
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

    final stream = 
     NetworkAnalyzer.i.discover2(subnet, 9100); // Check printer port

    await for (NetworkAddress addr in stream) {
      if (addr.exists) {
        setState(() {
          foundPrinters.add(addr.ip);
        });
      }
    }
      final stream2 = NetworkAnalyzer.i.discover2(subnet, 9101); // Check printer port

    await for (NetworkAddress addr in stream2) {
      if (addr.exists) {
        setState(() {
          foundPrinters.add(addr.ip);
        });
      }
    }

    setState(() {
      isScanning = false;
    });
    getWifiPrinters(); // saved printers
  }
  
 Future<bool> connectPrinter(String printerIp) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);
    PosPrintResult result  = await printer.connect(printerIp, port: 9100);
    if(result== PosPrintResult.success){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('printer Ip $printerIp connected successfully')));
     return true;
    }
    else{
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not add printer Ip $printerIp ')));
      return false;
    }
  }

  /// Send ESC/POS command to get the printer name
  Future<String> getPrinterName(String ip) async {
    try {
      Socket socket = await Socket.connect(ip, 9100, timeout: Duration(seconds: 2));
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
      }
    } catch (e) {
      debugPrint("Error getting printer name: $e");
    }
    return "Unknown Printer";
  }


    void getWifiPrinters() {
  List<PrinterModal> p= Provider.of<AppProvider>(context, listen: false).addedPrinterList;
  for(PrinterModal j in p){
    for(String  i in foundPrinters){
     if(j.ipAddress==i){
       savedPrinters.add(j);
     }else{
      // setState(() {
      //       i["name"]=j.printer_name!;
      //  });
     }
    }
  }
  }
/* wifi fun end */


List<String> availBluetoothDevice=[];
/* bluetooth functions start*/
  Future<bool> getConnected() async{
      bluetoothPrint.scanResults.listen((device){
       for (var i in device){
         availBluetoothDevice.add(i.address!);
          if(i.connected ?? false ==true){
            setState(() {
              devCon=true;
            });
          }
       }
     });
       debugPrint("connected devices  are $devCon");
       return false;
  }
  
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 10));
    bool isConnected=await bluetoothPrint.isConnected??false;
    bluetoothPrint.state.listen((state) {
      debugPrint('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
      debugPrint("real connection state is $_connected");
    });

    if (!mounted) return;
  }
/* bluetooth functions end*/

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  setState(() {}); // Refresh when the page is revisited
}


  @override
  Widget build(BuildContext context) {
      final scanPrinterNotif = ref.watch(scanPrintersNotifierProvider); 
    return Consumer<AppProvider>(builder: (context, provider, isChild) {
         for(PrinterModal i in provider.addedPrinterList){
                       apiAddedIp.add(i.ipAddress!);
           }
   

      return Scaffold(
        appBar: AppBar(
          title:  Text('Auto-Print orders',style: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoBold, color: AppAssets.primaryColor),),
        ),
        body: RefreshIndicator(
          onRefresh: () {
           return connectPrinter("fvd");

          },
          child: SingleChildScrollView(
            child:(loading)
               ? Column(
                 children: [ 
                  SizedBox(height: 40,),
                  Center(child:
                   CircularProgressIndicator(color: Colors.amber)
                   )
                 ]
               )
                : (provider.addedPrinterList.isEmpty) 
                ? Center(
                   child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: <Widget>[
                              SizedBox(height: 40,),
                               Text(
                             'No printers Connected',
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
                               onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPrinters()));
                              }, child: Text("Add Printers")),
                             
                             ],
                           ),
                 )
                 : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text("Connected Printers",style: TextStyle(fontSize: 13, fontFamily: AppAssets.nunitoBold, color: AppAssets.textLightGrayColor),),
                ),
                 const Divider(),
                // // test start
                Column(
                  children: List.generate(provider.addedPrinterList.length, (int ind){
                    return 
                    (provider.addedPrinterList[ind].printerType=="WiFi")
                    ? ListTile(
                      leading: Icon(Icons.circle,size: 15,color: (foundPrinters.contains(AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!))) ?AppAssets.greenColor : Colors.grey,),
                      title:(provider.addedPrinterList[ind].printerName=="")
                      ?  Text(AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!))
                      : Text(provider.addedPrinterList[ind].printerName!),
                      subtitle: (provider.addedPrinterList[ind].printerName!="") 
                        ? Text(AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!))
                        : Text(""),
                    onTap: (){
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      (AppProvider.defaultClientPrinterIp== AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)  && AppProvider.defaultKitchenPrinterIp==AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)) 
                      ? BothLabel :
                         (AppProvider.defaultClientPrinterIp== AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)) 
                        ? clientLabel 
                        : (AppProvider.defaultKitchenPrinterIp== AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)) 
                          ? kitchenLabel
                          : SizedBox(),
                        PopupMenuButton(
                          itemBuilder: (BuildContext context) { 
                            return [
                            PopupMenuItem(child: ListTile(
                              title: Text("Edit Name"),
                              onTap: ()async{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditPrinterName(printerModal: provider.addedPrinterList[ind])));
                              },
                             )),
                            PopupMenuItem(child: 
                            (AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)==AppProvider.defaultClientPrinterIp)
                            ? ListTile(
                              title: Text("Remove Client Default"),
                              onTap: ()async{ 
                                provider.unsetDefaultprinters(userModel.authToken!,provider.addedPrinterList[ind].printerId!,"client");
                                  Future.delayed(Duration(milliseconds: 200),(){
                                      provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"client");
                                    //  ref.read(scanPrintersNotifierProvider.notifier).setWifiClientPrinetr("Unknown Printer", AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!));
                                   ref.read(scanPrintersNotifierProvider.notifier).clearWifiClientPrinter();
                                   });
                                Navigator.pop(context);
                                setState(() {
                                      AppProvider.defaultClientPrinterIp="";
                                  
                                });
                              },
                            )
                            : ListTile(
                              title: Text("Set Client Default"),
                              onTap: ()async{ 
                                provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, provider.addedPrinterList[ind].printerId!,"client");
                                  Future.delayed(Duration(milliseconds: 200),(){
                                      provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"client");
                                     ref.read(scanPrintersNotifierProvider.notifier).setWifiClientPrinetr("Unknown Printer", AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!));
                                       print("Clientttt  ip address is ${provider.addedPrinterList[ind].ipAddress!}");
                                   });
                                Navigator.pop(context);
                                setState(() {
                                      AppProvider.defaultClientPrinterIp=AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!);
                                  
                                });
                              },
                            ),),
                            PopupMenuItem(child: 
                            (AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)==AppProvider.defaultKitchenPrinterIp)
                            ? ListTile(
                              title: Text("Remove Kitchen Default"),
                              onTap: ()async{ 
                                provider.unsetDefaultprinters(userModel.authToken!,provider.addedPrinterList[ind].printerId!,"kitchen");
                                  Future.delayed(Duration(milliseconds: 200),(){
                                      provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"kitchen");
                                    //  ref.read(scanPrintersNotifierProvider.notifier).setWifiClientPrinetr("Unknown Printer", AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!));
                                   ref.read(scanPrintersNotifierProvider.notifier).clearWifiKitchenPrinter();
                                   });
                                Navigator.pop(context);
                                setState(() {
                                      AppProvider.defaultKitchenPrinterIp="";
                                  
                                });
                              },
                            )
                            : ListTile(
                              title: Text("Set Kitchen Default"),
                              onTap: ()async{ 
                                provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, provider.addedPrinterList[ind].printerId!,"kitchen");
                                  Future.delayed(Duration(milliseconds: 200),(){
                                     provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"kitchen");
                                     ref.read(scanPrintersNotifierProvider.notifier).setWifiKitchenPrinetr("Unknown Printer", AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!));
                                    print("kitchennnnn  ip address is ${provider.addedPrinterList[ind].ipAddress!}");
                                   });
                                Navigator.pop(context);
                                   setState(() {
                                      AppProvider.defaultKitchenPrinterIp=AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!);
                                     
                                   }); 
                              },
                            ),),
                            PopupMenuItem(
                              child: ListTile(
                                title: Text("Delete Printer"),
                                            onTap: () async {
                                              provider.deletePrinter(
                                                  userModel.authToken!,
                                                  provider.addedPrinterList[ind].ipAddress!,
                                                  provider.addedPrinterList[ind].printerId!,
                                                  provider.addedPrinterList[ind].printerName!);
                                   
                                   
                                  // if this is client printer
                                   if(AppProvider.defaultClientPrinterIp== AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)){
                                    // set kitchen default as client default
                                     provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, AppProvider.defaultKitchenPrinterID,"client");
                                     Future.delayed(Duration(milliseconds: 200),(){
                                     provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"client");
                                   });
                                   }

                                    if(AppProvider.defaultKitchenPrinterID== AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)){
                                    // set client default as kitchen default
                                     provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, AppProvider.defaultClientPrinterID,"kitchen");
                                     Future.delayed(Duration(milliseconds: 200),(){
                                     provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"kitchen");
                                   });
                                   }
                                  //delete printer api
                                  Navigator.pop(context);
                                   setState(() {
                                       if(AppProvider.defaultKitchenPrinterIp == AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)){
                                       AppProvider.defaultKitchenPrinterIp ="";
                                        ref.read(scanPrintersNotifierProvider.notifier).clearWifiKitchenPrinter();
                                      //  ref.read(scanPrintersNotifierProvider.notifier).selectedClientWifiPrinterIp={"name":"","ip":""};
                                         ref.read(scanPrintersNotifierProvider.notifier).bluetoothClientPrinterConnected=null;
                                       }

                                       if(AppProvider.defaultClientPrinterIp == AppProvider.removePort(provider.addedPrinterList[ind].ipAddress!)){
                                        AppProvider.defaultClientPrinterIp ="";
                                        ref.read(scanPrintersNotifierProvider.notifier).clearWifiClientPrinter();
                                        // ref.read(scanPrintersNotifierProvider.notifier).selectedKitchenWifiPrinterIp={"name":"","ip":""};
                                         ref.read(scanPrintersNotifierProvider.notifier).bluetoothKitchenPrinterConnected=null;
                                     }
                                        //  ref.read(scanPrintersNotifierProvider.notifier).updateVar();
                                   });
                                },
                              ))
                            ];
                           },),
                      ],
                    ),
                    )
                    : (provider.addedPrinterList[ind].printerType=="Bluetooth") 
                    ? ListTile(
                      leading: Icon(Icons.bluetooth,size: 15 ,color: Colors.blue),
                      title: Text(provider.addedPrinterList[ind].printerName??''),
                      subtitle: Text(provider.addedPrinterList[ind].ipAddress??''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        (AppProvider.defaultClientPrinterIp== provider.addedPrinterList[ind].ipAddress  && AppProvider.defaultKitchenPrinterIp== provider.addedPrinterList[ind].ipAddress) 
                      ? BothLabel :
                         (AppProvider.defaultClientPrinterIp== provider.addedPrinterList[ind].ipAddress) 
                        ? clientLabel 
                        : (AppProvider.defaultKitchenPrinterIp== provider.addedPrinterList[ind].ipAddress) 
                          ? kitchenLabel
                          : SizedBox(),
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                               PopupMenuItem(child: ListTile(
                              title: Text("Set Client Default"),
                              onTap: ()async{ 
                               await provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, provider.addedPrinterList[ind].printerId!,"client");
                               Future.delayed(Duration(milliseconds: 200),(){
                                 provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"client");
                               
                               });
                               Navigator.pop(context);
                               setState(() {
                                   AppProvider.defaultClientPrinterIp=provider.addedPrinterList[ind].ipAddress!;

                               });
                              },
                            ),),
                             PopupMenuItem(child: ListTile(
                              title: Text("Set Kitchen Default"),
                              onTap: () async{ 
                               await provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, provider.addedPrinterList[ind].printerId!,"kitchen");
                               Future.delayed(Duration(milliseconds: 200),(){
                                 provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"kitchen");

                               });
                               Navigator.pop(context);
                               setState(() {
                                   AppProvider.defaultKitchenPrinterIp=provider.addedPrinterList[ind].ipAddress!;

                               });
                              },
                            ),),
                            //  PopupMenuItem(
                            //       child: Text("Delete"),
                            //       onTap: (){
                            //         String printerId="";
                            //       for(PrinterModal pm in provider.addedPrinterList){
                            //         if(provider.addedPrinterList[ind].ip_address==pm.ip_address){
                            //           printerId=pm.printer_id!;
                            //           break;
                            //         }
                            //        }
                            //         provider.deletePrinter(userModel.authToken!, provider.addedPrinterList[ind].ip_address!, printerId, provider.addedPrinterList[ind].printer_name!);
                            //        bluetoothPrint.disconnect();
                            //          apiAddedIp.clear();
                              //      
                            //          for(PrinterModal i in provider.addedPrinterList){
                            //           apiAddedIp.add(i.ip_address!);
                            //        }
                            //        if(AppProvider.defaultClientPrinterIp== provider.addedPrinterList[ind].ip_address){
                            //         // set kitchen default as client default
                            //          provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, AppProvider.defaultKitchenPrinterID,"client");
                            //          Future.delayed(Duration(milliseconds: 200),(){
                            //          provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"client");
                            //        });
                            //        }
                            //         if(AppProvider.defaultKitchenPrinterID== provider.addedPrinterList[ind].ip_address){
                            //         // set client default as kitchen default
                            //          provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, AppProvider.defaultClientPrinterID,"kitchen");
                            //          Future.delayed(Duration(milliseconds: 200),(){
                            //          provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"kitchen");
                            //        });
                            //        }
                            //         //  Navigator.pop(context);
                            //        setState(() {
                            //          if(AppProvider.defaultKitchenPrinterIp == provider.addedPrinterList[ind].ip_address!){
                            //            AppProvider.defaultKitchenPrinterIp ="";
                            //          }
                            //           if(AppProvider.defaultClientPrinterIp == provider.addedPrinterList[ind].ip_address!){
                            //           AppProvider.defaultClientPrinterIp ="";
                            //          }
                            //        });
                            //       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AutoPrintOrders()));
                            //       },),
                              
                                 PopupMenuItem(
                              child: ListTile(
                                title: Text("Delete Printer"),
                                            onTap: () async {
                                              provider.deletePrinter(
                                                  userModel.authToken!,
                                                  provider.addedPrinterList[ind].ipAddress!,
                                                  provider.addedPrinterList[ind].printerId!,
                                                  provider.addedPrinterList[ind].printerName!);
                                   
                                   
                                  // if this is client printer
                                   if(AppProvider.defaultClientPrinterIp== provider.addedPrinterList[ind].ipAddress){
                                    // set kitchen default as client default
                                    //  provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, AppProvider.defaultKitchenPrinterID,"client");
                                    //  Future.delayed(Duration(milliseconds: 200),(){
                                     provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"client");
                                  //  });
                                   }

                                    if(AppProvider.defaultKitchenPrinterID== provider.addedPrinterList[ind].ipAddress){
                                    // set client default as kitchen default
                                    //  provider.setDefaultPrinter(userModel.authToken!, userModel.merchantId!, AppProvider.defaultClientPrinterID,"kitchen");
                                    //  Future.delayed(Duration(milliseconds: 200),(){
                                     provider.getdefaultPrinter(userModel.authToken!, userModel.merchantId!,"kitchen");
                                  //  });
                                   }
                                  Navigator.pop(context);
                                   setState(() {
                                       if(AppProvider.defaultKitchenPrinterIp == provider.addedPrinterList[ind].ipAddress!){
                                       AppProvider.defaultKitchenPrinterIp ="";
                                       ref.read(scanPrintersNotifierProvider.notifier).selectedClientWifiPrinterIp={"name":"","ip":""};
                                         ref.read(scanPrintersNotifierProvider.notifier).bluetoothClientPrinterConnected=null;
                                       }

                                       if(AppProvider.defaultClientPrinterIp == provider.addedPrinterList[ind].ipAddress!){
                                        AppProvider.defaultClientPrinterIp ="";
                                        ref.read(scanPrintersNotifierProvider.notifier).selectedKitchenWifiPrinterIp={"name":"","ip":""};
                                         ref.read(scanPrintersNotifierProvider.notifier).bluetoothKitchenPrinterConnected=null;
                                     }
                                         ref.read(scanPrintersNotifierProvider.notifier).updateVar();
                                   });
                                },
                              ))
                               ];
                              }),
                                
                        ],
                      ),
                     
                    )
                    :Text("${provider.addedPrinterList[ind].printerType} ${provider.addedPrinterList[ind].printerName}")
                    ;
                    
                   
                  }),
                ),
                

                  ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPrinters()));
            },
            backgroundColor: Colors.amber,
            child: const Icon(Icons.add ),
          ));
  });
  }
  Widget kitchenLabel=Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: AppAssets.tabBorderColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text("Kitchen", style: TextStyle(color: Colors.white),),
  );

  Widget clientLabel=Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: AppAssets.greenColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text("Client", style: TextStyle(color: Colors.white),),
  );

    Widget BothLabel=Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: AppAssets.greenColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text("Client & Kitchen", style: TextStyle(color: Colors.white),),
  );
}

