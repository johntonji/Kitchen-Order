import 'package:blue_thermal_printer/blue_thermal_printer.dart' as blu;
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/models/printer_modal.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/ui/printer/auto_print_orders.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:order_receiving/utilities/utility_class.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BluetoothPrintersFound extends StatefulWidget {
  const BluetoothPrintersFound({super.key});

  @override
  State<BluetoothPrintersFound> createState() => _BluetoothPrintersFoundState();
}

class _BluetoothPrintersFoundState extends State<BluetoothPrintersFound> {
  final BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  blu.BlueThermalPrinter bluetooth = blu.BlueThermalPrinter.instance;

void getDevices() async {
  List<blu.BluetoothDevice> devices = await bluetooth.getBondedDevices();
  devices.forEach((device) {
    debugPrint("Device: ${device.name}, MAC: ${device.address}");
  });
}
  late AppProvider provider;
  String deviceMessage = "";
  bool _connected = false;
  bool _isMounted = false;
  bool loader = true;
  bool devCon = false;
  List<blu.BluetoothDevice> selectedDevices = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
   getDevices();
    Future.delayed(const Duration(seconds: 6), () {
      if (!_isMounted) return;
     if(mounted){
       setState(() {
        loader = false;
      });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  @override
  void dispose() {
    _isMounted = false;
    bluetoothPrint.state.drain(); // Stop listening to avoid memory leaks
    super.dispose();
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 10));
    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      if (!_isMounted) return;

      if(mounted){
        setState(() {
      });}
    });

    if (!mounted) return;

    if(mounted){
      setState(() {
      _connected = isConnected;
    });
   }
  }

  Future<void> checkPermission() async {
    var bluetoothStatus = await Permission.bluetooth.status;
    var scanStatus = await Permission.bluetoothScan.status;
    var connectStatus = await Permission.bluetoothConnect.status;
    var locationStatus = await Permission.location.status;

    if (bluetoothStatus.isDenied || bluetoothStatus.isPermanentlyDenied) {
      bluetoothStatus = await Permission.bluetooth.request();
    }
    if (scanStatus.isDenied || scanStatus.isPermanentlyDenied) {
      scanStatus = await Permission.bluetoothScan.request();
    }
    if (connectStatus.isDenied || connectStatus.isPermanentlyDenied) {
      connectStatus = await Permission.bluetoothConnect.request();
    }
    if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
      locationStatus = await Permission.location.request();
    }
    if (bluetoothStatus.isGranted && locationStatus.isGranted) {
      initBluetooth();
    } else {
      debugPrint("Permission denied");
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, isChild) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Searching Printers',
            style: TextStyle(
              fontSize: 18,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.primaryColor,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: loader
              ? _buildLoader()
              : 
              FutureBuilder<List<blu.BluetoothDevice>>(
                  future: bluetooth.getBondedDevices(),
                  initialData: [],
                  builder: (c, snapshot) {
                    if (snapshot.hasError || snapshot.data!.isEmpty) {
                       return _buildNoPrintersFound();
                    }
                    bool contains=false;
                    // check
                    for(blu.BluetoothDevice d in snapshot.data!){
                      if(d.name!.startsWith("EPSON") || d.name!.startsWith("STAR") || d.name!.startsWith("TM-")|| d.name!.startsWith("TSP") || d.name!.startsWith("SP") || d.name!.startsWith("MC")){
                          contains=true;
                          break;
                      }
                    }
                    if(contains==false){
                       return _buildNoPrintersFound();
                    }
                    //
                    return _buildPrinterList(snapshot.data!);
                  },
                ),
        ),
      );
    });
  }

  Widget _buildLoader() {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.amber),
          SizedBox(height: 15),
          Text(
            "Searching printers",
            style: TextStyle(
              fontSize: 12,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.textLightGrayColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPrintersFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
            color: AppAssets.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
         Text(
          'Press the Bluetooth button on the printer for about 10 seconds and then press "Retry"',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontFamily: AppAssets.nunitoBold,
            color: AppAssets.textLightGrayColor,
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.black)),
          onPressed: () {
            initBluetooth();
            if(mounted){
              setState(() {
              loader = true;
            });}
            Future.delayed(const Duration(seconds: 6), () {
              if(mounted){
                setState(() {
                loader = false;
              });
             }
            });
          },
          child: const Text("Retry"),
        ),
      ],
    );
  }

  Widget _buildPrinterList(List<blu.BluetoothDevice> devices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            "SELECT",
            style: TextStyle(
              fontSize: 13,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.textLightGrayColor,
            ),
          ),
        ),
        const Divider(),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: devices.map((d) {
              bool addPrinter=true;
                 for(PrinterModal pm in provider.addedPrinterList){
                          if(d.address ==pm.ipAddress){ 
                                addPrinter=false;
                                  break;
                                 }
                            }
              return 
              (d.name!.startsWith("EPSON") || d.name!.startsWith("STAR") || d.name!.startsWith("TM-")|| d.name!.startsWith("TSP") || d.name!.startsWith("SP") || d.name!.startsWith("MC")) ? 
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(d.name!),
                subtitle: Text(d.address!),
                value:(addPrinter==true)? selectedDevices.contains(d) : true,
                onChanged: (val) {
                 debugPrint("bluetooth device type is ${d.type}");
                 if(mounted){
                   if(addPrinter==true){
                     setState(() {
                    if (selectedDevices.contains(d)) {
                      selectedDevices.remove(d);
                     } else {
                      selectedDevices.add(d);
                    }
                  });
                  }
                  }
                },
              ) 
              : SizedBox();
            }).toList(),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                selectedDevices.isEmpty
                    ? const Color.fromARGB(255, 238, 211, 129)
                    : Colors.amber,
              ),
            ),
            onPressed: selectedDevices.isEmpty ? null : _addPrinters,
            child: Text(
              "Add Printer(s)".toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontFamily: AppAssets.nunitoBold,
                color: AppAssets.whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addPrinters() async {
    debugPrint("inside _addPrinters");
      
                                   SharedPreferenceManager.getInstance().getUserData().then((data) async{ 
                                    for(blu.BluetoothDevice i in selectedDevices){
                                       bool add=true;
                                        PrinterModal printerModal =
                                                  PrinterModal(
                                                      printerName: i.name,
                                                      ipAddress: i.address,
                                                      autoPrint: "",
                                                      deviceUuid: "",
                                                      merchantId: provider.restrauntMenu[0].menus![0].merchantId,
                                                      printerType: "Bluetooth",
                                                      serviceId: "");
                                                      for(PrinterModal pm in provider.addedPrinterList){
                                                        if(i.address==pm.ipAddress){ 
                                                          add=false;
                                                          break;
                                                        }
                                                      }
                                              if(add==true){
                                             await  provider.addPrinters(data.authToken!, printerModal).then((status) {
                                                 if (status.isSuccess) {
                                                   UtilityClass.showSuccessDialog(context,"Printer added successfully","");
                                                   }
                                               
                                              });
                                              }else{
                                                   UtilityClass.showFailedDialog(context,"Printer ${i.name} already added","");
                                                debugPrint("printer already added");
                                              }
                                              UtilityClass.showLoadingDialog(context);
                                          Future.delayed(Duration(seconds: 7),()async{
                                        
                                          int count = 0;
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 3; // Stops after popping 3 times (leaving 4th page)
                                       });
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AutoPrintOrders()));
                                      
                                    });
                                    }
                                   });
                                   
  }
}
