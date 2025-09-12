import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/models/printer_modal.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/ui/printer/auto_print_orders.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:provider/provider.dart';

class EditPrinterName extends StatefulWidget {
 PrinterModal printerModal;
  EditPrinterName({super.key ,required this.printerModal});

  @override
  State<EditPrinterName> createState() => _EditPrinterNameState();
}

class _EditPrinterNameState extends State<EditPrinterName> {

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController=TextEditingController(text: widget.printerModal.printerName);

    return Consumer<AppProvider>(builder: (context, provider, isChild) {
     return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Printer name',
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
              ListTile(
                title: Text(
                  'Printer Name',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppAssets.nunitoBold,
                      color: AppAssets.textLightGrayColor))
                ,subtitle: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Add Name"
                  ),
                )
              ),
            
              SizedBox(
                height: 20,
              ),
              ListTile(
                title:Text(
                  'Ip Address',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppAssets.nunitoBold,
                      color: AppAssets.textLightGrayColor)),
                      subtitle: Text(widget.printerModal.ipAddress!),
              ),
      
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.amber)),
                      onPressed: () async{
                        setState(() {
                          widget.printerModal.printerName= nameController.text.trim();
                        });
                         debugPrint("name of printer is ${widget.printerModal.printerName}");
                         SharedPreferenceManager.getInstance().getUserData().then((data) {
                         provider.updatePrinter(data.authToken!, widget.printerModal);
                         });
                      
                      int count = 0;
                       Navigator.popUntil(context, (route) {
                           return count++ == 2; // Stops after popping 3 times (leaving 4th page)
                       });
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AutoPrintOrders()));
                       },
                      child: Text("Save".toUpperCase(),
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: AppAssets.nunitoBold,
                              color: AppAssets.whiteColor))),
                ),
              )
            ],
          ),
        ),
      );
   } );
  }
}