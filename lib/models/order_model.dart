

class Addons {
  String? subcatId;
  String? subcategoryName;
  List<AddonItems>? addonItems;

  Addons({this.subcatId, this.subcategoryName, this.addonItems});

  // Addons.fromJson(Map<String, dynamic> json) {
  //   subcatId = json['subcat_id'].toString();
  //   subcategoryName = json['subcategory_name'].toString();
  //   if (json['addon_items'] != null) {
  //     addonItems = <AddonItems>[];
  //     json['addon_items'].forEach((v) {
  //       addonItems!.add(AddonItems.fromJson(v));
  //     });
  //   }
  // }
  Addons.fromJson(Map<String, dynamic> json) {
  subcatId = json['subcat_id']?.toString();
  subcategoryName = json['subcategory_name']?.toString();

  var rawList = json['addon_items'];

  if (rawList is List) {
    addonItems = rawList.map((e) => AddonItems.fromJson(e)).toList();
  } else {
    addonItems = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subcat_id'] = subcatId;
    data['subcategory_name'] = subcategoryName;
    if (addonItems != null) {
      data['addon_items'] = addonItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddonItems {
   String? itemRow;
   String? multiOption;
   int? subItemId;
   String? subcatId;
  String? subItemName;
   String? subcatName;
  String? itemDescription;
  String? qty;
  num? addonsTotal;
  String? prettyAddonsTotal;
   num? price;
   String? prettyPrice;
   String? urlImage;
   String? pizzaPortionTypeId;
   String? pizzaPortionSectionId;
   String? pizzaSizeName;
   PortionModel? portion;
   String? portionSection;
    String? isSubModifier;
   String? key;

  AddonItems({
     this.itemRow,
     this.multiOption,
     this.subItemId,
     this.subcatId,
        this.subItemName,
     this.subcatName,
        this.itemDescription,
        this.qty,
        this.addonsTotal,
        this.prettyAddonsTotal,
     this.price,
     this.prettyPrice,
     this.urlImage,
    this.pizzaPortionTypeId,
    this.pizzaPortionSectionId,
    this.pizzaSizeName,
    this.portion,
    this.portionSection,
     this.isSubModifier,
    this.key,
  });

  factory AddonItems.fromJson(Map<String, dynamic> json) {
    return AddonItems(
      itemRow: json['item_row'] ?? '',
      multiOption: json['multi_option'] ?? '',
      subItemId: json['sub_item_id'] ?? 0,
      subcatId: json['subcat_id'] ?? '',
      subItemName: json['sub_item_name'] ?? '',
      subcatName: json['subcat_name'] ?? '',
      itemDescription: json['item_description'] ?? '',
      qty: json['qty'] ?? '0',
      addonsTotal: json['addons_total'] ?? 0,
      prettyAddonsTotal: json['pretty_addons_total'] ?? '',
      price: json['price'] ?? 0,
      prettyPrice: json['pretty_price'] ?? '',
      urlImage: json['url_image'] ?? '',
      pizzaPortionTypeId: json['pizza_portion_type_id'],
      pizzaPortionSectionId: json['pizza_portion_section_id'],
      pizzaSizeName: json['pizza_size_name'],
     portion: json['portion'] is Map<String, dynamic>
    ? PortionModel.fromJson(json['portion'])
    : null,
      portionSection: json['portion_section'],
      isSubModifier: json['is_sub_modifier'] ?? '0',
      key: json['key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_row': itemRow,
      'multi_option': multiOption,
      'sub_item_id': subItemId,
      'subcat_id': subcatId,
      'sub_item_name': subItemName,
      'subcat_name': subcatName,
      'item_description': itemDescription,
      'qty': qty,
      'addons_total': addonsTotal,
      'pretty_addons_total': prettyAddonsTotal,
      'price': price,
      'pretty_price': prettyPrice,
      'url_image': urlImage,
      'pizza_portion_type_id': pizzaPortionTypeId,
      'pizza_portion_section_id': pizzaPortionSectionId,
      'pizza_size_name': pizzaSizeName,
      'portion': portion?.toJson(),
      'portion_section': portionSection,
      'is_sub_modifier': isSubModifier,
      'key': key,
    };
  }
}

class PortionModel {
  final String id;
  final String name;
  final String value;
  final String type;

  PortionModel({
    required this.id,
    required this.name,
    required this.value,
    required this.type,
  });

  factory PortionModel.fromJson(Map<String, dynamic> json) {
    return PortionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'type': type,
    };
  }
}

class Tax {
  String? taxId;
  String? taxName;
  bool? taxInPrice;
  String? taxRate;
  String? taxRateType;

  Tax(
      {this.taxId,
        this.taxName,
        this.taxInPrice,
        this.taxRate,
        this.taxRateType});

  Tax.fromJson(Map<String, dynamic> json) {
    taxId = json['tax_id'].toString();
    taxName = json['tax_name'].toString();
    taxInPrice = json['tax_in_price'];
    taxRate = json['tax_rate'].toString();
    taxRateType = json['tax_rate_type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tax_id'] = taxId;
    data['tax_name'] = taxName;
    data['tax_in_price'] = taxInPrice;
    data['tax_rate'] = taxRate;
    data['tax_rate_type'] = taxRateType;
    return data;
  }
}

class ConnectedProvidersModel{
 String? providerId;
 String? integrationAccountId;

 ConnectedProvidersModel({
  required this.providerId,
  required this.integrationAccountId
 });

 factory ConnectedProvidersModel.fromJson(Map<String, dynamic> json){
  return ConnectedProvidersModel(
    providerId: json['provider_id']?.toString() , 
    integrationAccountId: json['integration_account_id']?.toString());
 }
}

class OrderModel {
  final OrderData orderData;
  String? tip;
  final List<Items> items;
  final Customer customer;
  String? restaurantAddress;
  String? orderCompletionTime;
  List<AllTaxesUse> allTaxesUse;
  int? kitchenhubConnection;
  List<ConnectedProvidersModel>? connectedProvidersList;

  OrderModel({
    required this.orderData,
    this.tip,
    required this.items,
    required this.customer,
    this.restaurantAddress,
    this.orderCompletionTime,
    required this.allTaxesUse,
    this.kitchenhubConnection,
    this.connectedProvidersList
  });

  // factory OrderModel.fromJson(Map<String, dynamic> json) {
  //   return OrderModel(
  //     orderData: OrderData.fromJson(json['order_data']),
  //     tip: json['tip_amount'].toString() ,
  //     items: (json['items'] as List).map((i) => Items.fromJson(i)).toList(),
  //     customer: Customer.fromJson(json['customer']),
  //     restaurantAddress:json['restaurant_address'].toString() ,
  //     orderCompletionTime:json['order_completion_time'].toString() ,
  //     allTaxesUse: (json['all_taxes_use'] as List).map((i) => AllTaxesUse.fromJson(i)).toList(),
  //   );
  // }
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderData: OrderData.fromJson(json['order_data']),
    tip: json['tip_amount']?.toString(),
     kitchenhubConnection: json['kitchenhub_connection'] ?? 0,
     items: (json['items'] is List)
        ? (json['items'] as List)
            .map((i) => Items.fromJson(i))
            .toList()
        : [],
    connectedProvidersList: (json['connected_providers_list'] is List)
        ? (json['connected_providers_list'] as List)
            .map((i) => ConnectedProvidersModel.fromJson(i))
            .toList()
        : [],
      customer: Customer.fromJson(json['customer']),
    restaurantAddress: json['restaurant_address']?.toString(),
    orderCompletionTime: json['order_completion_time']?.toString(),
    allTaxesUse: (json['all_taxes_use'] is List)
        ? (json['all_taxes_use'] as List)
            .map((i) => AllTaxesUse.fromJson(i))
            .toList()
        : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderData != null) {
      data['order_data'] = orderData.toJson();
    }
    data["tip_amount"]=tip ?? "" ;
    if (items != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    if (customer != null) {
      data['customer'] = customer.toJson();
    }
    data["restaurant_address"]=restaurantAddress;
    data["order_completion_time"]=orderCompletionTime;
    data['kitchenhub_connection']=kitchenhubConnection ??0;
    if(allTaxesUse != null){
      data['all_taxes_use'] = allTaxesUse.map((v) => v.toJson()).toList();
    }
    return data;
    
  }

}

class OrderData {
  final String total;
  final String orderId;
  final String orderUuid;
  final String merchantId;
  final String clientId;
  final String status;
  final String paymentStatus;
  final String serviceCode;
  final String formattedAddress;
  final String whentoDeliver;
  final String deliveryDate;
 String deliveryTime;
  final String deliveryTimeEnd;
    String? isView;
  String? isCritical;
  String? dateCreated;
   String? deliveryStatus;
  String? paymentCode;
  String? totalDiscount;
  String? points;
  String? subTotal;
  String? subTotalLessDiscount;
  String? serviceFee;
  String? smallOrderFee;
  String? deliveryFee;
  String? packagingFee;
  String? cardFee;
  String? taxType;
  String? tax;
  String? taxTotal;
  String? offerDiscount;
  String? offerTotal;
  String? commissionType;
  String? totalOriginal;
  String? adjustmentCommission;
  String? adjustmentTotal;
  String? useCurrencyCode;
  String? baseCurrencyCode;
  String? exchangeRate;
  String? adminBaseCurrency;
  String? exchangeRateUseCurrencyToAdmin;
  String? exchangeRateMerchantToAdmin;
  String? exchangeRateAdminToMerchant;
  String? driverId;
  String? vehicleId;
  String? dateCancelled;
  String? earningApprove;
  String? deliveredAt;
  String? acceptedAt;
  String? isPrinted;


  OrderData({
    required this.total,
    required this.orderId,
    required this.orderUuid,
    required this.merchantId,
    required this.clientId,
    required this.status,
    required this.paymentStatus,
    required this.serviceCode,
    required this.formattedAddress,
    required this.whentoDeliver,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.deliveryTimeEnd,
    this.isView,
    this.isCritical,
    this.dateCreated,

     this.deliveryStatus,
    this.paymentCode,
    this.totalDiscount,
    this.points,
    this.subTotal,
    this.subTotalLessDiscount,
    this.serviceFee,
    this.smallOrderFee,
    this.deliveryFee,
    this.packagingFee,
    this.cardFee,
    this.taxType,
    this.tax,
    this.taxTotal,
    this.offerDiscount,
    this.offerTotal,
    this.commissionType,
    this.totalOriginal,
    this.adjustmentCommission,
    this.adjustmentTotal,
    this.useCurrencyCode,
    this.baseCurrencyCode,
    this.exchangeRate,
    this.adminBaseCurrency,
    this.exchangeRateUseCurrencyToAdmin,
    this.exchangeRateMerchantToAdmin,
    this.exchangeRateAdminToMerchant,
    this.driverId,
    this.vehicleId,
    this.dateCancelled,
    this.earningApprove,
    this.deliveredAt,
    this.acceptedAt,
    this.isPrinted
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      total: json['total'].toString() ?? '',
      orderId: json['order_id'].toString() ?? '',
      orderUuid: json['order_uuid'].toString() ?? '',
      merchantId: json['merchant_id'].toString() ?? '',
      clientId: json['client_id'].toString() ?? '',
      status: json['status'].toString() ?? '',
      paymentStatus: json['payment_status'].toString() ?? '',
      serviceCode: json['service_code'].toString() ?? '',
      formattedAddress: json['formatted_address'].toString() ?? '',
      whentoDeliver: json['whento_deliver'].toString() ?? '',
      deliveryDate: json['delivery_date'].toString() ?? '',
      deliveryTime: json['delivery_time'].toString() ?? '',
      deliveryTimeEnd: json['delivery_time_end'].toString() ?? '',
      isView : json['is_view'].toString(),
    isCritical :json['is_critical'].toString(),
    dateCreated : json['date_created'].toString(),

      paymentCode: json['payment_code'].toString(),
      totalDiscount: json['total_discount'].toString(),
      points: json['points'].toString(),
      subTotal: json['sub_total'].toString(),
      subTotalLessDiscount: json['sub_total_less_discount'].toString(),
      serviceFee: json['service_fee'].toString(),
      smallOrderFee: json['small_order_fee'].toString(),
      deliveryFee: json['delivery_fee'].toString(),
      packagingFee: json['packaging_fee'].toString(),
      cardFee: json['card_fee'].toString(),
      taxType: json['tax_type'].toString(),
      tax: json['tax'].toString(),
      taxTotal: json['tax_total'].toString(),
      
      offerDiscount: json['offer_discount'].toString(),
      offerTotal: json['offer_total'].toString(),
      commissionType: json['commission_type'].toString(),
   
      totalOriginal: json['total_original'].toString(),
      
      adjustmentCommission: json['adjustment_commission'].toString(),
      adjustmentTotal: json['adjustment_total'].toString(),
      useCurrencyCode: json['use_currency_code'].toString(),
      baseCurrencyCode: json['base_currency_code'].toString(),
      exchangeRate: json['exchange_rate'].toString(),
      adminBaseCurrency: json['admin_base_currency'].toString(),
      exchangeRateUseCurrencyToAdmin: json['exchange_rate_use_currency_to_admin'].toString(),
      exchangeRateMerchantToAdmin: json['exchange_rate_merchant_to_admin'].toString(),
      exchangeRateAdminToMerchant: json['exchange_rate_admin_to_merchant'].toString(),
      driverId: json['driver_id'].toString(),
      vehicleId: json['vehicle_id'].toString(),
      dateCancelled: json['date_cancelled'].toString(),
      earningApprove: json['earning_approve'].toString(),
      deliveredAt: json['delivered_at'].toString(),
      acceptedAt: json['accepted_at'] ?? "",
      isPrinted: json['is_print'].toString()

    );
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['order_id'] = orderId;
    data['order_uuid'] = orderUuid;
    data['merchant_id'] = merchantId;
    data['client_id'] = clientId;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['service_code'] = serviceCode;
    data['formatted_address'] = formattedAddress;
    data['whento_deliver'] = whentoDeliver;
    data['delivery_date'] = deliveryDate;
    data['delivery_time'] = deliveryTime;
    data['delivery_time_end'] = deliveryTimeEnd;
    data['is_view'] = isView;
    data['is_critical'] = isCritical;
    data['date_created'] = dateCreated;

     data['delivery_status']= deliveryStatus;
       data['payment_code']= paymentCode;
       data['total_discount']= totalDiscount;
       data['points']= points;
       data['sub_total']= subTotal;
       data['sub_total_less_discount']= subTotalLessDiscount;
       data['service_fee']= serviceFee;
       data['small_order_fee']= smallOrderFee;
       data['delivery_fee']= deliveryFee;
       data['packaging_fee']= packagingFee;
       data['card_fee']= cardFee;
       data['tax_type']= taxType;
       data['tax']= tax;
       data['tax_total']= taxTotal;
       data['offer_discount']= offerDiscount;
       data['offer_total']= offerTotal;
       data['commission_type']= commissionType;
       data['total_original']= totalOriginal;
       data['adjustment_commission']= adjustmentCommission;
       data['adjustment_total']= adjustmentTotal;
       data['use_currency_code']= useCurrencyCode;
       data['base_currency_code']= baseCurrencyCode;
       data['exchange_rate']= exchangeRate;
       data['admin_base_currency']= adminBaseCurrency;
       data['exchange_rate_use_currency_to_admin']= exchangeRateUseCurrencyToAdmin;
       data['exchange_rate_merchant_to_admin']= exchangeRateMerchantToAdmin;
       data['exchange_rate_admin_to_merchant']= exchangeRateAdminToMerchant;
       data['driver_id']= driverId;
       data['vehicle_id']= vehicleId;
       data['date_cancelled']= dateCancelled;
       data['earning_approve']= earningApprove;
       data['delivered_at']= deliveredAt;
       data['accepted_at']= acceptedAt;
       data['is_print']=isPrinted;
       
    return data;
  }
}

class Items {
  final String itemRow;
  final String catId;
  final String itemToken;
  final String itemName;
  final String itemChanges;
  final String urlImage;
  String? itemNameReplace;
  String? specialInstructions;
  String? ifSoldOut;
  final String qty;
  final Price price;
  List<Addons>? addons;
  List<Tax>? tax;

  Items({
    required this.itemRow,
    required this.catId,
    required this.itemToken,
    required this.itemName,
    required this.itemChanges,
    required this.urlImage,
            this.itemNameReplace,
        this.specialInstructions,
        this.ifSoldOut,
    required this.qty,
    required this.price,
    this.addons,
    this.tax
  });


  factory Items.fromJson(Map<String, dynamic> json) {
      List<Addons> addonsList = [];
  if (json['addons'] is List) {
    addonsList = (json['addons'] as List)
        .map((v) => Addons.fromJson(v))
        .toList();
  }
    
  List<Tax> taxList = [];
  if (json['tax'] is List) {
    taxList = (json['tax'] as List)
        .map((v) => Tax.fromJson(v))
        .toList();
  }

    return Items(
    itemRow: json['item_row']?.toString() ?? '',
    catId: json['cat_id']?.toString() ?? '',
    itemToken: json['item_token']?.toString() ?? '',
    itemName: json['item_name']?.toString() ?? '',
    itemChanges: json['item_changes']?.toString() ?? '',
    itemNameReplace: json['item_name_replace']?.toString(),
    specialInstructions: json['special_instructions']?.toString(),
    ifSoldOut: json['if_sold_out']?.toString(),
    urlImage: json['url_image']?.toString() ?? '',
    qty: json['qty']?.toString() ?? '',
    price: Price.fromJson(json['price'] ?? {}),
      tax: taxList,
        addons: addonsList,
    );
  }

  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_row'] = itemRow;
    data['cat_id'] = catId;
    data['item_token'] = itemToken;
    data['item_name'] = itemName;
    data['item_changes'] = itemChanges;
    data['item_name_replace'] = itemNameReplace;
    data['url_image'] = urlImage;
    data['special_instructions'] = specialInstructions;
    data['if_sold_out'] = ifSoldOut;
    data['qty'] = qty;
    data['price'] = price.toJson();

    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    if (tax != null) {
      data['tax'] = tax!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Price {
  final String itemSizeId;
  final double price;
    String? sizeName;
  final double discount;
   String? discountType;
  final double priceAfterDiscount;
  final String prettyPrice;
   String? prettyPriceAfterDiscount;
    double? total;
  String? prettyTotal;
  double? totalAfterDiscount;
  String? prettyTotalAfterDiscount;

  Price({
    required this.itemSizeId,
    required this.price,
    this.sizeName,
    required this.discount,
    this.discountType,
    required this.priceAfterDiscount,
    required this.prettyPrice,
    this.total,
    this.prettyTotal,
  this.prettyPriceAfterDiscount,
    this.totalAfterDiscount,
    this.prettyTotalAfterDiscount
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
    itemSizeId: json['item_size_id']?.toString() ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    sizeName: json['size_name']?.toString(),
    discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    discountType: json['discount_type']?.toString(),
    priceAfterDiscount:
        (json['price_after_discount'] as num?)?.toDouble() ?? 0.0,
    prettyPrice: json['pretty_price']?.toString() ?? '',
    prettyPriceAfterDiscount:
        json['pretty_price_after_discount']?.toString(),
    total: (json['total'] as num?)?.toDouble() ?? 0.0,
    prettyTotal: json['pretty_total']?.toString(),
    totalAfterDiscount:
        (json['total_after_discount'] as num?)?.toDouble() ?? 0.0,
    prettyTotalAfterDiscount:
        json['pretty_total_after_discount']?.toString(),
    );
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_size_id'] = itemSizeId;
    data['price'] = price;
    data['size_name'] = sizeName;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['price_after_discount'] = priceAfterDiscount;
    data['pretty_price'] = prettyPrice;
    data['pretty_price_after_discount'] = prettyPriceAfterDiscount;
    data['total'] = total;
    data['pretty_total'] = prettyTotal;
    data['total_after_discount'] = totalAfterDiscount;
    data['pretty_total_after_discount'] = prettyTotalAfterDiscount;
    return data;
  }
}

class Customer {
  final String clientId;
  final String clientUuid;
  final String firstName;
  final String lastName;
  final String contactPhone;
  final String emailAddress;
  final String avatar;
  final String memberSince;

  String? cardNumber;
  String? cardType;
  final TransactionMetaData? transcationMetaData;
  // String? transcationMetaData;

  Customer({
    required this.clientId,
    required this.clientUuid,
    required this.firstName,
    required this.lastName,
    required this.contactPhone,
    required this.emailAddress,
    required this.avatar,
    required this.memberSince,
    this.cardNumber,
    this.cardType,
    required this.transcationMetaData
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
  
    return Customer(
      clientId: json['client_id'] ?? '',
      clientUuid: json['client_uuid'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      contactPhone: json['contact_phone'] ?? '',
      emailAddress: json['email_address'] ?? '',
      avatar: json['avatar'] ?? '',
      memberSince: json['member_since'] ?? '',

      cardNumber: json['card_number'] ?? '',
      cardType: json['card_type'] ?? '',
      transcationMetaData: json['transaction_meta_data'] != null
     ? TransactionMetaData.fromJson(json['transaction_meta_data'])
     : TransactionMetaData.empty,
  
    //  transcationMetaData: TransactionMetaData.fromJson(json['transaction_meta_data'])
    );
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_id'] = clientId;
    data['client_uuid'] = clientUuid;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['contact_phone'] = contactPhone;
    data['email_address'] = emailAddress;
    data['avatar'] = avatar;
    data['member_since'] = memberSince;

    data['card_number'] = cardNumber;
    data['card_type'] = cardType;
    // data['transcation_meta_data'] = transcationMetaData;

   if (transcationMetaData != null) {
      data['transaction_meta_data'] = transcationMetaData!.toJson();
    }
    return data;
  }

}


class TransactionMetaData {
  String? status;
  String? responseCode;
  String? responseMessage;
  String? authCode;
  String? hostReferenceNumber;
  String? hostResponseCode;
  String? taskID;
  String? transactionID;
  String? transactionTimestamp;
  String? transactionAmount;
  String? processedAmount;
  String? transactionDate;
  String? customerReceipt;
  CardDetails? cardDetails;

  TransactionMetaData({
    this.status,
    this.responseCode,
    this.responseMessage,
    this.authCode,
    this.hostReferenceNumber,
    this.hostResponseCode,
    this.taskID,
    this.transactionID,
    this.transactionTimestamp,
    this.transactionAmount,
    this.processedAmount,
    this.transactionDate,
    this.customerReceipt,
    this.cardDetails
  });

 static final TransactionMetaData empty= TransactionMetaData(status: "",responseCode: "",authCode: "",hostReferenceNumber: "",
            taskID: "",transactionID: "",transactionTimestamp:"",responseMessage:"",
            transactionAmount:"",
            processedAmount:"" ,
            transactionDate:"",
            customerReceipt:"",
            cardDetails: CardDetails());

  factory TransactionMetaData.fromJson(Map<String, dynamic> json) {
    return TransactionMetaData(
      status: json['status'],
      responseCode: json['responseCode'],
      responseMessage: json['responseMessage'],
      authCode: json['authCode'],
      hostReferenceNumber: json['hostReferenceNumber'],
      hostResponseCode: json['hostResponseCode'],
      taskID: json['taskID'],
      transactionID: json['transactionID'],
      transactionTimestamp: json['transactionTimestamp'],
      transactionAmount: json['transactionAmount'],
      processedAmount: json['processedAmount'],
      transactionDate: json['transaction_date'],
      customerReceipt:json['customerReceipt'],
      // cardDetails: json['cardDetails']
      cardDetails:  CardDetails.fromJson(json['details'])
   
    );
  }

  Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status']= status;
      data['responseCode']= responseCode;
      data['responseMessage']= responseMessage;
      data['authCode']= authCode;
      data['hostReferenceNumber']= hostReferenceNumber;
      data['hostResponseCode']= hostResponseCode;
      data['taskID']= taskID;
      data['transactionID']= transactionID;
      data['transactionTimestamp']= transactionTimestamp;
      data['transactionAmount']= transactionAmount;
      data['processedAmount']= processedAmount;
      data['transaction_date']= transactionDate;
      data['customerReceipt']= customerReceipt;
      // 'details':cardDetails
        if (cardDetails != null) {
      data['details'] = cardDetails!.toJson();
    }
   return data;

  }

}


///// new
class CardDetails {
  String? entryMode;
  String? transactionType;
  String? authorization;
  String? cardType;
  String? transactionID;
  String? invoiceNumber;
  String? authCode;
  String? card;
  String? totalAmount;

  CardDetails(
      {this.entryMode,
      this.transactionType,
      this.authorization,
      this.cardType,
      this.transactionID,
      this.invoiceNumber,
      this.authCode,
      this.card,
      this.totalAmount});

  CardDetails.fromJson(Map<String, dynamic> json) {
    entryMode = json['entryMode'];
    transactionType = json['transactionType'];
    authorization = json['authorization'];
    cardType = json['cardType'];
    transactionID = json['transactionID'];
    invoiceNumber = json['invoiceNumber'];
    authCode = json['authCode'];
    card = json['card'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['entryMode'] = entryMode;
    data['transactionType'] = transactionType;
    data['authorization'] = authorization;
    data['cardType'] = cardType;
    data['transactionID'] = transactionID;
    data['invoiceNumber'] = invoiceNumber;
    data['authCode'] = authCode;
    data['card'] = card;
    data['totalAmount'] = totalAmount;
    return data;
  }
}


/// New Modal

class AllTaxesUse {
  String? taxId;
  String? taxName;
  bool? taxInPrice;
  String? taxRate;
  String? taxRateType;
  String? taxType;
  String? taxAmountType;
  String? taxRateCalculated;

  AllTaxesUse(
      {this.taxId,
      this.taxName,
      this.taxInPrice,
      this.taxRate,
      this.taxRateType,
      this.taxType,
      this.taxAmountType,
      this.taxRateCalculated});

  AllTaxesUse.fromJson(Map<String, dynamic> json) {
    taxId = json['tax_id'];
    taxName = json['tax_name'];
    taxInPrice = json['tax_in_price'];
    taxRate = json['tax_rate'];
    taxRateType = json['tax_rate_type'];
    taxType = json['tax_type'];
    taxAmountType = json['tax_amount_type'];
    taxRateCalculated = json['tax_rate_calculated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['tax_id'] = taxId;
    data['tax_name'] = taxName;
    data['tax_in_price'] = taxInPrice;
    data['tax_rate'] = taxRate;
    data['tax_rate_type'] = taxRateType;
    data['tax_type'] = taxType;
    data['tax_amount_type'] = taxAmountType;
    data['tax_rate_calculated'] = taxRateCalculated;
    return data;
  }
}
