import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/main.dart';
import 'package:order_receiving/models/reciept_modal.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:order_receiving/utilities/utility_class.dart';
import 'package:provider/provider.dart';

import 'package:order_receiving/providers/app_provider.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _faCodeController=TextEditingController();
  bool hidePassword=true;
  @override
  void initState() {
     requestPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(AppAssets.dimen_20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50, child: Image.asset(AppAssets.appLogo),),
                const SizedBox(height: 10,),
                Text("Administrator Login", style: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoBold,), maxLines: 1, overflow: TextOverflow.ellipsis,),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _userNameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      suffix: SizedBox(),
                      border: InputBorder.none,
                      labelText: "Username",
                      labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular),
                      floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                     ),
                    cursorColor: AppAssets.widgetGrayColor,
                    style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    obscureText: hidePassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                       suffix: GestureDetector(onTap: (){
                        setState(() {
                          hidePassword=!hidePassword;
                        });
                      },
                      child: hidePassword ? Icon(Icons.visibility) :Icon(Icons.visibility_off)),
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                      floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                    ),
                    cursorColor: AppAssets.widgetGrayColor,
                    style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(_userNameController.text.trim().isEmpty){
                      UtilityClass.showFailedDialog(context, "Data Missing", "The Username field is required");
                      return;
                    }
                    if(_passwordController.text.trim().isEmpty){
                      UtilityClass.showFailedDialog(context, "Data Missing", "The Password field is required");
                      return;
                    }

                    UtilityClass.showLoadingDialog(context);
                    appProvider.userLogin(_userNameController.text.trim(), _passwordController.text.trim()).then((status) async {
                      UtilityClass.dismissLoading(context);
                      if(status.isSuccess){
                       
                        saveClientRecieptPreferences();
                        saveKitchenRecieptPreferences();

                        if(AppProvider.faEnabled==true){
                           // popup for fa auth code
                           faDialog();
                        }
                        else{
                        //    setState(() {
                        //   _userNameController.text = "";
                        //   _passwordController.text = "";
                        //  });
                         UtilityClass.showSuccessDialog(context, "Login", status.message);
                           await Future.delayed(const Duration(seconds: 3), () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  Dashboard()), (route) => false);
                         });
                        }
                       
                      }else{
                        UtilityClass.showFailedDialog(context, "Failed", status.message);
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppAssets.greenColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text("Sign in", style: TextStyle(fontSize: 20, fontFamily: AppAssets.nunitoMedium, color: AppAssets.whiteColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

  }

    saveClientRecieptPreferences() async {
// pre-save client receipt
  List<Map<String, dynamic>> data = [
    {"Preview Options": false},
    {"Ticket holder space": false},
    {"Merchant Contact Details": true},
    {"Payment method": true},
    {"Time": true},
    {"Delivery/Pickup": true},
    {"Order details": true},
    {"Client Info": true},
    // {"Client Comment": true},
    {"Items": true},
    {"Is Paid": true},
    // {"Order Online": true},
    {"Your info box 1": false},
    {"Your info box 2": false},
    {"Client confirmation": true}
  ];

  String previewOrdersVal = "Pickup";
  String premiseTypeVal = "Dine-in";
  String premiseTypeFinalVal = "Table Number";
  String previewTimesVal = "now";
  String previewPaymentsVal = "COD";
  int blankLinesVal = 1;

  // PreviewOptionsModel previewOptionsModel=PreviewOptionsModel.empty;
  InfoBox1Model infoBox1Model=InfoBox1Model.empty;
  InfoBox2Model infoBox2Model=InfoBox2Model.empty;

  ////
  PaymentMethodModel paymentMethodModel = PaymentMethodModel.empty;
  OrderDetailsModel orderDetailsModel = OrderDetailsModel.empty;
  DirectionModel directionModel = DirectionModel.empty;
  ClientInfoModel clientInfoModel = ClientInfoModel.empty;
  ItemsModel itemsModel = ItemsModel.empty;
  ContactDetailsModel contactDetailsModel = ContactDetailsModel.empty;
  ClientConfirmationModel clientConfirmationModel = ClientConfirmationModel.empty;

  int timeTitleSize = 10;
  int clientCommentSize = 10;
  int isPaidTitleSize = 12;
  int orderOnlineTitleSize = 13;

    Map<String, dynamic> recieptMap = {
      "previewOrdersVal": previewOrdersVal,
      "previewTimesVal": previewTimesVal,
      "previewPaymentsVal": previewPaymentsVal,
      "blankLinesVal": blankLinesVal,

      //models
       "infoBox1Model":{
       "titleSize":infoBox1Model.titleSize,
       "textSize":infoBox1Model.textSize,
       "title":"",
       "text":"",
       },
        "infoBox2Model":{
       "titleSize":infoBox2Model.titleSize,
       "textSize":infoBox2Model.textSize,
       "title":"",
       "text":"",
       },

      "paymentMethod": {
        "titleSize": paymentMethodModel.titleSize,
        "cardDetailsSize": paymentMethodModel.cardDetailsSize,
        "showCardDetails": paymentMethodModel.showCardDetails
      },
      "orderDetails": {
        "titleSize": orderDetailsModel.titleSize,
        "numberSize": orderDetailsModel.numberSize,
        "placedSize": orderDetailsModel.placedSize,
        "acceptedSize": orderDetailsModel.acceptedSize,
        "fullfilledSize": orderDetailsModel.fullfilledSize
      },
      "direction": {
        "titleSize": directionModel.titleSize,
        "addressSize": directionModel.addressSize,
        "addressInfoSize": directionModel.addressInfoSize,
        "showOR": directionModel.showOR
      },
      "clientInfo": {
        "titleSize": clientInfoModel.titleSize,
        "firstSize": clientInfoModel.firstSize,
        "lastSize": clientInfoModel.lastSize,
        "emailSize": clientInfoModel.emailSize,
        "phoneSize": clientInfoModel.phoneSize,
        "showEmail": clientInfoModel.showEmail,
      },
      "items": {
        "titleSize": itemsModel.titleSize,
        "itemsSize": itemsModel.itemsSize,
        "choicAddonSize": itemsModel.choicAddonSize,
        "itemCommentSize": itemsModel.itemCommentSize,
        "feesSize": itemsModel.feesSize,
        "totalSize": itemsModel.totalSize,
        "showAddonFees": itemsModel.showAddonFees,
        "showAddonNames": itemsModel.showAddonNames,
      },
      "contactDetails": {
        "nameSize": contactDetailsModel.nameSize,
        "addressSize": contactDetailsModel.addressSize,
        "phoneSize": contactDetailsModel.phoneSize,
      },
      "clientConfirmation": {
        "titleSize": clientConfirmationModel.titleSize,
        "textSize": clientConfirmationModel.textSize,
      },

      ////
      "timeTitleSize": timeTitleSize,
      "clientCommentSize": clientCommentSize,
      "isPaidTitleSize": isPaidTitleSize,
      "orderOnlineTitleSize": orderOnlineTitleSize,

      "premiseTypeVal": premiseTypeVal,
      "otherPremiseText": "",
      "premiseTypeFinalVal": premiseTypeFinalVal,
      "finalCompList": data
    };
    SharedPreferenceManager.getInstance()
        .saveReceiptData(recieptMap,"MerchantReceipt");
  }
 
   saveKitchenRecieptPreferences() async {
     List<Map<String, dynamic>> data = [
    {"Preview Options": false},
    {"Ticket holder space": false},
    {"Header": true},
    {"Order details": true},
    // {"Client Comment": true},
    {"Items": true},
    {"Is Paid": true},
    {"Packaging station quality control": true},
  ];
  String previewOrdersVal = "Pickup";


  String premiseTypeVal = "Dine-in";
  String premiseTypeFinalVal = "Table Number";
  String previewTimesVal = "now";
  String previewPaymentsVal = "COD";


  // PreviewOptionsModel previewOptionsModel=PreviewOptionsModel.empty;
HeaderModel headerModel=HeaderModel.empty; 
  OrderDetailsModel orderDetailsModel = OrderDetailsModel.empty;
  KitchenItemsModel kitchenItemsModel = KitchenItemsModel.empty;
  ContactDetailsModel contactDetailsModel = ContactDetailsModel.empty;
  PackagingQualityModel packagingQualityModel=PackagingQualityModel.empty;
  int clientCommentSize = 10;
  int isPaidTitleSize = 12;
  int blankLinesVal = 1;

    Map<String, dynamic> recieptMap = {
      "previewOrdersVal": previewOrdersVal,
      "previewTimesVal": previewTimesVal,
      "previewPaymentsVal": previewPaymentsVal,
       "blankLinesVal": blankLinesVal,
       
       //model 
       "headerModel":{
        "typeSize": headerModel.typeSize,
        "fulfillmentSize": headerModel.fulfillmentSize,
       },
      "orderDetails": {
        "titleSize": orderDetailsModel.titleSize,
        "numberSize": orderDetailsModel.numberSize,
        "placedSize": orderDetailsModel.placedSize,
        "acceptedSize": orderDetailsModel.acceptedSize,
        "fullfilledSize": orderDetailsModel.fullfilledSize
      },

      "kitchenItems": {
        "titleSize": kitchenItemsModel.titleSize,
        "itemsSize": kitchenItemsModel.itemsSize,
        "choicAddonSize": kitchenItemsModel.choicAddonSize,
        "itemCommentSize": kitchenItemsModel.itemCommentSize,

        "addCheckbox": kitchenItemsModel.addCheckbox,
        "showAddonNames": kitchenItemsModel.showAddonNames,
        "showInternalNames": kitchenItemsModel.showInternalNames,
      },
      "contactDetails": {
        "nameSize": contactDetailsModel.nameSize,
        "addressSize": contactDetailsModel.addressSize,
        "phoneSize": contactDetailsModel.phoneSize,
      },
      "packagingQualityModel": {
        "titleSize": packagingQualityModel.titleSize,
        "correctItemsSize": packagingQualityModel.correctItemsSize,
        "allItemsSize": packagingQualityModel.allItemsSize,
        "flyerSize": packagingQualityModel.flyerSize,
      },

      "clientCommentSize": clientCommentSize,
      "isPaidTitleSize": isPaidTitleSize,

      "premiseTypeVal": premiseTypeVal,
      "otherPremiseText": "",
      "onPermiseSize":11,
      "premiseTypeFinalVal": premiseTypeFinalVal,
      "finalCompList": data
    };
    SharedPreferenceManager.getInstance()
        .saveReceiptData(recieptMap,"KitchenEssentials");
  }  

  faDialog(){
   showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
      
        return 
         AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: const EdgeInsets.all(0),
              elevation: 6,
              scrollable: true,
              // insetPadding: const EdgeInsets.symmetric(horizontal: 120),
              backgroundColor: AppAssets.whiteColor,
              content: 
              Container(
                width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 30),
                decoration: const BoxDecoration(
                  color: AppAssets.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
               ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                const SizedBox(height: 30,),

                Text("Please enter the 6-digit code", style: TextStyle(fontSize: AppAssets.dimen_16, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textDarkGrayColor),),
                // const SizedBox(height: 10,),
                 Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppAssets.widgetGrayColor, width: 1)
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                   maxLength: 6,
              
                    controller: _faCodeController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                  counterText: "",
                      // labelText: "",
                      labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                      floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                    ),
                    cursorColor: AppAssets.widgetGrayColor,
                    style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                  ),
                ),
                SizedBox(height: 10,),
                      OutlinedButton(
                         style: ButtonStyle(
                         foregroundColor: WidgetStatePropertyAll(Colors.black)),
                         onPressed: () async {
                            Provider.of<AppProvider>(context, listen: false).verify2fa( _faCodeController.text.trim(),_userNameController.text).then((status){
                              if(status.isSuccess){
                                UtilityClass.showSuccessDialog(context, "", status.message);
                                // Navigator.pop(context);
                                // Future.delayed(const Duration(seconds: 3), () {
                               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  Dashboard()), (route) => false);
                            //  });
                             } else{
                             UtilityClass.showFailedDialog(context, "Failed", status.message);
                            }
                            });
                           },
                           child: Text("OK",style: TextStyle(fontFamily: AppAssets.nunitoRegular),)),
               ],
             ),)
              );
      },
    );
    
  }

}
