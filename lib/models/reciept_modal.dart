

// class PreviewOptionsModel{
//  String? orders;
//  String? times;
//  String? payments;

//  PreviewOptionsModel({required this.orders,required this.times,required this.payments});
//  static PreviewOptionsModel empty=PreviewOptionsModel(orders: "Pickup", times: "now", payments: "Cash");
// }

class PaymentMethodModel{
  int? titleSize;
  int? cardDetailsSize;
  bool? showCardDetails;
  PaymentMethodModel({ required this.titleSize, required this.cardDetailsSize,required this.showCardDetails});
  
 static  PaymentMethodModel empty=PaymentMethodModel(
    titleSize: 11, cardDetailsSize: 10, showCardDetails: true);
  
    factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      titleSize: json['titleSize'], cardDetailsSize: json['cardDetailsSize'], showCardDetails: json['showCardDetails']);
    
    }
  }

class DirectionModel{
  int? titleSize;
  int? addressSize;
  int? addressInfoSize;
  bool? showOR;
  DirectionModel({ required this.titleSize,required this.addressSize,required this.addressInfoSize,required this.showOR});

 static DirectionModel empty =DirectionModel(titleSize: 11, addressSize: 9, addressInfoSize: 9, showOR: false);


    factory DirectionModel.fromJson(Map<String, dynamic> json) {
    return DirectionModel(titleSize: json['titleSize'], addressSize: json['addressSize'], addressInfoSize: json['addressInfoSize'], showOR: json['showOR']);
    }
}

class OrderDetailsModel{
  int? titleSize;
  int? numberSize;
  int? placedSize;
  int? acceptedSize;
  int? fullfilledSize;
  OrderDetailsModel({ required this.titleSize,required this.numberSize,required this.placedSize,required this.acceptedSize,required this.fullfilledSize});

 static OrderDetailsModel empty =OrderDetailsModel(titleSize: 11, numberSize: 9, placedSize: 9, acceptedSize: 9, fullfilledSize: 9);

    factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(titleSize: json['titleSize'],
     numberSize: json['numberSize'],
      placedSize: json['placedSize'],
       acceptedSize: json['acceptedSize'],
        fullfilledSize: json['fullfilledSize']);
    }
}

class ClientInfoModel{
  int? titleSize;
  int? firstSize;
  int? lastSize;
  int? emailSize;
  int? phoneSize;
  bool? showEmail;

  ClientInfoModel({ required this.titleSize,required this.firstSize,required this.lastSize,required this.emailSize,required this.phoneSize,required this.showEmail});
 static ClientInfoModel empty=ClientInfoModel(titleSize: 11, firstSize: 9, lastSize: 9, emailSize: 9, phoneSize: 9, showEmail: true);


 factory ClientInfoModel.fromJson(Map<String, dynamic> json) {
   return ClientInfoModel(titleSize: json['titleSize'], 
        firstSize: json['firstSize'], lastSize: json['lastSize'],
         emailSize: json['emailSize'], phoneSize: json['phoneSize'], showEmail: json['showEmail']);
    }
  }
class ItemsModel{
  int? titleSize;
  int? itemsSize;
  int? choicAddonSize;
  int? itemCommentSize;
  int? feesSize;
  int? totalSize;
  bool? showAddonFees;
  bool? showAddonNames;

  ItemsModel({ required this.titleSize,required this.itemsSize,required this.choicAddonSize,required this.itemCommentSize,required this.feesSize,required this.totalSize, required this.showAddonFees,required this.showAddonNames});
 static ItemsModel empty=ItemsModel(titleSize: 11, itemsSize: 9, choicAddonSize: 9, itemCommentSize: 9, feesSize: 9,totalSize:9, showAddonFees:true, showAddonNames: true);  

    factory ItemsModel.fromJson(Map<String, dynamic> json) {
      return ItemsModel(titleSize: json["titleSize"], itemsSize: json['itemsSize'], choicAddonSize: json['choicAddonSize'], itemCommentSize: json['itemCommentSize'], feesSize: json['feesSize'], totalSize: json['totalSize'], showAddonFees: json['showAddonFees'], showAddonNames: json['showAddonNames']);
    }

}


class ContactDetailsModel{
  int? nameSize;
  int? addressSize;
  int? phoneSize;

  ContactDetailsModel({ required this.nameSize,required this.addressSize,required this.phoneSize});
 static ContactDetailsModel empty = ContactDetailsModel(nameSize: 9, addressSize: 9, phoneSize: 9);

    factory ContactDetailsModel.fromJson(Map<String, dynamic> json) {
  return ContactDetailsModel(nameSize: json['nameSize'], addressSize: json['addressSize'], phoneSize: json['phoneSize']);
    }
}

class InfoBox1Model{
  int? titleSize;
  int? textSize;
  String? title;
  String? text;

  InfoBox1Model({ required this.titleSize,required this.textSize,required this.title,required this.text});
 static InfoBox1Model empty=InfoBox1Model(titleSize: 14, textSize: 14,title:"",text:"");

    factory InfoBox1Model.fromJson(Map<String, dynamic> json) {
    return InfoBox1Model(
      titleSize: json['titleSize'],
      textSize: json['textSize'],
      title: json['title'],
      text: json['text']);
    }
}
class InfoBox2Model{
  int? titleSize;
  int? textSize;
  String? title;
  String? text;

  InfoBox2Model({ required this.titleSize,required this.textSize,required this.title,required this.text});
 static InfoBox2Model empty=InfoBox2Model(titleSize: 14, textSize: 14,title:"",text:"");

    factory InfoBox2Model.fromJson(Map<String, dynamic> json) {
    return InfoBox2Model(
      titleSize: json['titleSize'],
      textSize: json['textSize'],
      title: json['title'],
      text: json['text']);
    }
}

class ClientConfirmationModel{
  int? titleSize;
  int? textSize;

  ClientConfirmationModel({ required this.titleSize,required this.textSize});
 static ClientConfirmationModel empty=ClientConfirmationModel(titleSize: 11, textSize: 9);

    factory ClientConfirmationModel.fromJson(Map<String, dynamic> json) {
    return ClientConfirmationModel(titleSize: json['titleSize'], textSize: json['textSize']);
    }
}

class ClientReceiptSettings {

  String previewOrdersVal;
  String previewTimesVal;
  String previewPaymentsVal;
  int blankLinesVal;
  InfoBox1Model infoBox1Model;
  InfoBox2Model infoBox2Model;
  PaymentMethodModel paymentMethod;
  OrderDetailsModel orderDetails;
  DirectionModel direction;
  ClientInfoModel clientInfo;
  ItemsModel items;
  ContactDetailsModel contactDetails;
  ClientConfirmationModel clientConfirmation;
  int timeTitleSize;
  int clientCommentSize;
  int isPaidTitleSize;
  int orderOnlineTitleSize;
  String premiseTypeVal;
  String otherPremiseText;
  String premiseTypeFinalVal;
  List<Map<String, dynamic>> finalCompList;

  ClientReceiptSettings({
    required this.previewOrdersVal,
    required this.previewTimesVal,
    required this.previewPaymentsVal,
    required this.blankLinesVal,
    required this.paymentMethod,

    required this.infoBox1Model,
    required this.infoBox2Model,
    required this.orderDetails,
    required this.direction,
    required this.clientInfo,
    required this.items,
    required this.contactDetails,
    required this.clientConfirmation,
    required this.timeTitleSize,
    required this.clientCommentSize,
    required this.isPaidTitleSize,
    required this.orderOnlineTitleSize,
    required this.premiseTypeVal,
    required this.otherPremiseText,
    required this.premiseTypeFinalVal,
    required this.finalCompList,
  });

  /// Convert JSON to `ReceiptSettings` object
  factory ClientReceiptSettings.fromJson(Map<String, dynamic> json) {
    return ClientReceiptSettings(
      previewOrdersVal: json['previewOrdersVal'],
      previewTimesVal: json['previewTimesVal'],
      previewPaymentsVal: json['previewPaymentsVal'],
      blankLinesVal: json['blankLinesVal'],
      infoBox1Model: InfoBox1Model.fromJson(json['infoBox1Model']),
      infoBox2Model:InfoBox2Model.fromJson(json['infoBox2Model']),

      paymentMethod: PaymentMethodModel.fromJson(json['paymentMethod']),
      orderDetails: OrderDetailsModel.fromJson(json['orderDetails']),
      direction: DirectionModel.fromJson(json['direction']),
      clientInfo: ClientInfoModel.fromJson(json['clientInfo']),
      items: ItemsModel.fromJson(json['items']),
      contactDetails: ContactDetailsModel.fromJson(json['contactDetails']),
      clientConfirmation: ClientConfirmationModel.fromJson(json['clientConfirmation']),
      timeTitleSize: json['timeTitleSize'],
      clientCommentSize: json['clientCommentSize'],
      isPaidTitleSize: json['isPaidTitleSize'],
      orderOnlineTitleSize: json['orderOnlineTitleSize'],
      premiseTypeVal: json['premiseTypeVal'],
      otherPremiseText: json['otherPremiseText'],
      premiseTypeFinalVal: json['premiseTypeFinalVal'],
      finalCompList: List<Map<String, dynamic>>.from(json['finalCompList']),
    );
  }
  


}

/////// kitchen

class KitchenReceiptSettings {

  String previewOrdersVal;
  String previewTimesVal;
  String previewPaymentsVal;
  int blankLinesVal;
  HeaderModel headerModel;
  OrderDetailsModel orderDetails;

  KitchenItemsModel items;
  PackagingQualityModel packagingQualityModel;

  int? onPermiseSize;
  int clientCommentSize;
  int isPaidTitleSize;
  String premiseTypeVal;
  String otherPremiseText;
  String premiseTypeFinalVal;
  List<Map<String, dynamic>> finalCompList;

  KitchenReceiptSettings({
    required this.previewOrdersVal,
    required this.previewTimesVal,
    required this.previewPaymentsVal,
    required this.blankLinesVal,
    required this.headerModel,
    required this.orderDetails,
    required this.items,
    required this.packagingQualityModel,
    required this.onPermiseSize,
    required this.clientCommentSize,
    required this.isPaidTitleSize,
    required this.premiseTypeVal,
    required this.otherPremiseText,
    required this.premiseTypeFinalVal,
    required this.finalCompList,
  });

  /// Convert JSON to `ReceiptSettings` object
  factory KitchenReceiptSettings.fromJson(Map<String, dynamic> json) {
    return KitchenReceiptSettings(
      previewOrdersVal: json['previewOrdersVal'],
      previewTimesVal: json['previewTimesVal'],
      previewPaymentsVal: json['previewPaymentsVal'],
      blankLinesVal: json['blankLinesVal'],
      orderDetails: OrderDetailsModel.fromJson(json['orderDetails']),
      headerModel: HeaderModel.fromJson(json['headerModel']),

      items: KitchenItemsModel.fromJson(json['kitchenItems']),
      packagingQualityModel: PackagingQualityModel.fromJson(json['packagingQualityModel']),

      onPermiseSize: json['onPermiseSize'],
      clientCommentSize: json['clientCommentSize'],
      isPaidTitleSize: json['isPaidTitleSize'],

      premiseTypeVal: json['premiseTypeVal'],
      otherPremiseText: json['otherPremiseText'],
      premiseTypeFinalVal: json['premiseTypeFinalVal'],
      finalCompList: List<Map<String, dynamic>>.from(json['finalCompList']),
    );
  }
}

class HeaderModel{
  int? typeSize;
  int? fulfillmentSize;

  HeaderModel({ required this.typeSize,required this.fulfillmentSize});
 static HeaderModel empty=HeaderModel(typeSize: 11, fulfillmentSize: 10);

    factory HeaderModel.fromJson(Map<String, dynamic> json) {
    return HeaderModel(typeSize: json['typeSize'], fulfillmentSize: json['fulfillmentSize']);
    }

}

  class KitchenItemsModel{
  int? titleSize;
  int? itemsSize;
  int? choicAddonSize;
  int? itemCommentSize;
  bool? addCheckbox;
  bool? showAddonNames;
  bool? showInternalNames;

  KitchenItemsModel({ required this.titleSize,required this.itemsSize,required this.choicAddonSize,required this.itemCommentSize,required this.addCheckbox, required this.showAddonNames,required this.showInternalNames});
 static KitchenItemsModel empty=KitchenItemsModel(titleSize: 11, itemsSize: 9, choicAddonSize: 9, itemCommentSize: 9,addCheckbox:true, showAddonNames:true, showInternalNames: true);  

    factory KitchenItemsModel.fromJson(Map<String, dynamic> json) {
      return KitchenItemsModel(titleSize: json["titleSize"], itemsSize: json['itemsSize'], choicAddonSize: json['choicAddonSize'], itemCommentSize: json['itemCommentSize'], addCheckbox: json['addCheckbox'], showAddonNames: json['showAddonNames'], showInternalNames: json['showInternalNames']);
    }

}

class PackagingQualityModel{
  int? titleSize;
  int? correctItemsSize;
  int? allItemsSize;
  int? flyerSize;
PackagingQualityModel({required this.titleSize, required this.correctItemsSize,required this.allItemsSize,required this.flyerSize});
  static PackagingQualityModel empty=PackagingQualityModel(titleSize: 12, correctItemsSize: 9, allItemsSize: 9, flyerSize: 9);
  factory PackagingQualityModel.fromJson(Map<String, dynamic> json) {
    return PackagingQualityModel(titleSize: json['titleSize'], correctItemsSize: json['correctItemsSize'], allItemsSize: json['allItemsSize'], flyerSize:json['flyerSize']);
  }

}