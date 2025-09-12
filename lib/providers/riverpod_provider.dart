
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:order_receiving/models/order_model.dart';
import 'package:order_receiving/models/printer_modal.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:ping_discover_network_plus/ping_discover_network_plus.dart';
import 'package:provider/provider.dart';
import 'package:riverpod/riverpod.dart' as rv;
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as blu;

final scanPrintersNotifierProvider =
    rv.NotifierProvider<ScanPrintersNotifier, Map<String, dynamic>>(() {
  return ScanPrintersNotifier();
});

// notifier class for provider
class ScanPrintersNotifier extends rv.Notifier<Map<String, dynamic>> {
bool autoPrint=false;

UserModel userModel=UserModel.getInstance();  //L

blu.BlueThermalPrinter bluetooth = blu.BlueThermalPrinter.instance;

  OrderModel? autoOrderData;
  String kitchenReceiptPath = "";
  blu.BluetoothDevice? bluetoothClientPrinterConnected;   
  blu.BluetoothDevice? bluetoothKitchenPrinterConnected;

  List<Map<String,String>> foundPrinters = [];
  List<PrinterModal> savedPrinters =  [];
  bool isScanning = true;

  Map<String,String>selectedClientWifiPrinterIp={"ip":"","name":""};
  Map<String,String> selectedKitchenWifiPrinterIp={"ip":"","name":""};

  @override
  Map<String, dynamic> build() {
    return {
      "bluetooth":bluetooth,
      "autoPrint": autoPrint,

      "autoOrderData": autoOrderData,
      "bluetoothClientPrinterConnected":bluetoothClientPrinterConnected,
      "bluetoothKitchenPrinterConnected":bluetoothKitchenPrinterConnected,

      "foundPrinters":foundPrinters,
      "savedPrinters":savedPrinters,

      "selectedClientWifiPrinterIp":selectedClientWifiPrinterIp,
      "selectedKitchenWifiPrinterIp":selectedKitchenWifiPrinterIp
    };
  }

/// updates variable when their value changes (used in place of update(['enroll']))
  void updateVar() {
    state = {
      ...state,
      "bluetooth":bluetooth,
      "autoPrint": autoPrint,

      "autoOrderData": autoOrderData,
      "bluetoothClientPrinterConnected":bluetoothClientPrinterConnected,
      "bluetoothKitchenPrinterConnected":bluetoothKitchenPrinterConnected,

      "foundPrinters":foundPrinters,
      "savedPrinters":savedPrinters,
      
      "selectedClientWifiPrinterIp":selectedClientWifiPrinterIp,
      "selectedKitchenWifiPrinterIp":selectedKitchenWifiPrinterIp
    };
    debugPrint("value of bluetoothClientPrinterConnected is  $bluetoothClientPrinterConnected");
  }

  onChangeAutoPrint(bool value) {
    autoPrint = value;
    updateVar();
  }



  void initilaizee(){
    getUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) => getConnected());
    getConnected();
  }

  void getUserData() {
    SharedPreferenceManager.getInstance().getUserData().then((value) {
      userModel = value;
    });
    
    }

      Future<bool> getConnected() async{
         
         bluetooth.getBondedDevices().then((devices){
           for (var i in devices){
          if(i.connected==true){
             bluetoothClientPrinterConnected=i; ///blu
             bluetoothKitchenPrinterConnected=i;
         updateVar();
          }
       }
         });
    return false;
  }



  Future<void> scanForPrinters(BuildContext context) async {

      isScanning = true;
      foundPrinters.clear();
    final info = NetworkInfo();
    String? localIP = await info.getWifiIP();
    if (localIP == null) {

        isScanning = false;
 
      return;
    }

    List<String> ipParts = localIP.split('.');
    String subnet = "${ipParts[0]}.${ipParts[1]}.${ipParts[2]}";

    final stream = NetworkAnalyzer.i.discover2(subnet, 9100); // Check printer port

    await for (NetworkAddress addr in stream) {
      if (addr.exists) {
          foundPrinters.add({"ip":addr.ip,"name":""});
          updateVar();

      }
    }

  final stream2 = NetworkAnalyzer.i.discover2(subnet, 9101); // Check printer port
    await for (NetworkAddress addr in stream2) {
      if (addr.exists) {
          foundPrinters.add({"ip":addr.ip,"name":""});
         updateVar();
      }
    }

    isScanning = false;
    getWifiPrinters(context); // saved printers
  }

  void getWifiPrinters(BuildContext context) {
  debugPrint("inside getWifiPrinters");
       List<PrinterModal> p=[];
       p= Provider.of<AppProvider>(context, listen: false).addedPrinterList;
      
     debugPrint("data in p is $p");
  for(PrinterModal j in p){
    for(Map<String,String>  i in foundPrinters){
     if(AppProvider.removePort(j.ipAddress!)==i["ip"]){  
       savedPrinters.add((j));
         updateVar();
     }else{
         updateVar();
     }
    }
  }
      connectPrinters();        /// connect printers//////
  }

  // to connect the printers if their i[ matches the default IP]
 void connectPrinters()async{
  debugPrint("default client is ${AppProvider.defaultClientPrinterIp} , default kitchen is ${AppProvider.defaultKitchenPrinterIp}");
      //bluetooth devices
      await bluetooth.getBondedDevices().then((devices){
        for (blu.BluetoothDevice i in devices){
            if(i.address==AppProvider.defaultClientPrinterIp || i.address==AppProvider.defaultKitchenPrinterIp){
         //client
          if(i.address==AppProvider.defaultClientPrinterIp){
           bluetoothClientPrinterConnected=i;
           selectedClientWifiPrinterIp['name']="";
           selectedClientWifiPrinterIp['ip']="";
           updateVar();

          }
          //kitchen
          if(i.address==AppProvider.defaultKitchenPrinterIp){
           bluetoothKitchenPrinterConnected=i;
           selectedKitchenWifiPrinterIp["ip"]="";
           selectedKitchenWifiPrinterIp["name"]="";
           updateVar();
          } // break; //imp
         }
        }
      });
    
     //wifi
   for(PrinterModal p in savedPrinters){
    if(AppProvider.removePort(p.ipAddress!)== AppProvider.defaultClientPrinterIp || AppProvider.removePort(p.ipAddress!)== AppProvider.defaultKitchenPrinterIp){
       //client
       if(AppProvider.removePort(p.ipAddress!)== AppProvider.defaultClientPrinterIp){
         selectedClientWifiPrinterIp['ip']=AppProvider.removePort(p.ipAddress!);
         selectedClientWifiPrinterIp["name"]=p.printerName!;
         bluetoothClientPrinterConnected=null;
         updateVar();
       }
        //kitchen
       if(AppProvider.removePort(p.ipAddress!)== AppProvider.defaultKitchenPrinterIp){
         selectedKitchenWifiPrinterIp["ip"]=AppProvider.removePort(p.ipAddress!);
         selectedKitchenWifiPrinterIp["name"]=p.printerName!;
         bluetoothKitchenPrinterConnected=null;
         updateVar();
       }
       debugPrint("wifi printers are client : ${selectedClientWifiPrinterIp['ip']} ,kitchen : ${selectedKitchenWifiPrinterIp["ip"]}");
      //  break; ///
    }
   }
 }
 
  Future<bool> connectPrinter(String printerIp ,context) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);
    PosPrintResult result ;
  try{
      result= await printer.connect(printerIp, port: 9100);   /// PORT 9100
      }catch(e){
        debugPrint("exception in wifi printer port 9100 $e");
        try{
          result= await printer.connect(printerIp, port: 9101);   ///PORT 9101
        }catch(e){
         debugPrint("exception in wifi printer port 9101 $e");
          result=PosPrintResult.timeout;
        }
      }
       if(result== PosPrintResult.success){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('printer Ip $printerIp connected successfully')));
         return true;
       }
      else{
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not add printer Ip $printerIp ')));
        return false;
       }
  }
 
}
