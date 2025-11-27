import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/ui/reciept/receipt_components_kitchen.dart';
import 'package:order_receiving/ui/reciept/reciept_components_client.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';

class ReceiptTemplates extends StatefulWidget {
   String logo;
   String address;
   String phone;
   ReceiptTemplates({super.key ,required this.address,required this.logo,required this.phone});

  @override
  State<ReceiptTemplates> createState() => _ReceiptTemplatesState();
}

class _ReceiptTemplatesState extends State<ReceiptTemplates> {
  List<String> receiptTemplateList = [];
  List<String> templateType=["Client Receipt","Kitchen Essentials"];
  String templateTypeVal= "Client Receipt";

  @override
  void initState() {
    getList();
    super.initState();
  }

  getList() async {
    receiptTemplateList =
        await SharedPreferenceManager.getInstance().getReceiptTemplateList();
    debugPrint("list of receipts is $receiptTemplateList");
    // var receiptData = await SharedPreferenceManager.getInstance()
    //     .getReceiptData(receiptTemplateList[0]);
    // debugPrint("receipt data is $receiptData");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Print Templates',
          style: TextStyle(
              fontSize: 18,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.primaryColor),
        ),
      ),
      body: ListView(
               children: [
       ListTile(
              title: Text("Client Receipt",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppAssets.nunitoBold,
                      color: AppAssets.primaryColor)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FutureBuilder(
                  //  future:  SharedPreferenceManager.getInstance().getReceiptData("MerchantReceipt"),
                  //   builder: (context, recieptSnapshot) {
                  //     return
                       IconButton(onPressed: () {
                        SharedPreferenceManager.getInstance().getReceiptData("MerchantReceipt").then((receiptData){
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecieptComponentsClient(
                               recieptDataMap:receiptData!,
                                address: widget.address, logo: widget.logo, phone: widget.phone,)));
                        });
                      }, icon: Icon(Icons.edit))
                  //   }, 
                  // ),
                ],
              ),
            ),
               ListTile(
              title: Text("Kitchen Receipt",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppAssets.nunitoBold,
                      color: AppAssets.primaryColor)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FutureBuilder(
                  //  future:  SharedPreferenceManager.getInstance().getReceiptData("KitchenEssentials"),
                  //   builder: (context, recieptSnapshot) {
                  //     return 
                      IconButton(onPressed: () {
                    // debugPrint("kitchen data is ${recieptSnapshot.data}");
                      SharedPreferenceManager.getInstance().getReceiptData("KitchenEssentials").then((receiptData){
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecieptComponentsKitchen( recieptDataMap:receiptData!,)));
                      });
                 
                           }, icon: Icon(Icons.edit))
                  //   }, 
                  // ),
                ],
              ),
            ),
            
            ])
         
  
      
  );
  }
  
}






