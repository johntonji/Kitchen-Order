class OrderModel {
  OrderData? orderData;
  List<Items>? items;
  Customer? customer;

  OrderModel({this.orderData, this.items, this.customer});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderData = json['order_data'] != null
        ? OrderData.fromJson(json['order_data'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderData != null) {
      data['order_data'] = orderData!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class OrderData {
  String? total;
  String? orderId;
  String? orderUuid;
  String? merchantId;
  String? clientId;
  String? status;
  String? paymentStatus;
  String? serviceCode;
  String? formattedAddress;
  String? whentoDeliver;
  String? deliveryDate;
  String? deliveryTime;
  String? deliveryTimeEnd;
  String? isView;
  String? isCritical;
  String? dateCreated;

  OrderData(
      {this.total,
        this.orderId,
        this.orderUuid,
        this.merchantId,
        this.clientId,
        this.status,
        this.paymentStatus,
        this.serviceCode,
        this.formattedAddress,
        this.whentoDeliver,
        this.deliveryDate,
        this.deliveryTime,
        this.deliveryTimeEnd,
        this.isView,
        this.isCritical,
        this.dateCreated});

  OrderData.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    orderId = json['order_id'];
    orderUuid = json['order_uuid'];
    merchantId = json['merchant_id'];
    clientId = json['client_id'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    serviceCode = json['service_code'];
    formattedAddress = json['formatted_address'];
    whentoDeliver = json['whento_deliver'];
    deliveryDate = json['delivery_date'];
    deliveryTime = json['delivery_time'];
    deliveryTimeEnd = json['delivery_time_end'];
    isView = json['is_view'];
    isCritical = json['is_critical'];
    dateCreated = json['date_created'];
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
    return data;
  }
}

class Items {
  String? itemRow;
  String? catId;
  String? itemToken;
  String? itemName;
  String? itemChanges;
  String? itemNameReplace;
  String? urlImage;
  String? specialInstructions;
  String? ifSoldOut;
  int? qty;
  Price? price;
  List<Addons>? addons;
  List<Tax>? tax;

  Items(
      {this.itemRow,
        this.catId,
        this.itemToken,
        this.itemName,
        this.itemChanges,
        this.itemNameReplace,
        this.urlImage,
        this.specialInstructions,
        this.ifSoldOut,
        this.qty,
        this.price,
        this.addons,
        this.tax});

  Items.fromJson(Map<String, dynamic> json) {
    itemRow = json['item_row'];
    catId = json['cat_id'];
    itemToken = json['item_token'];
    itemName = json['item_name'];
    itemChanges = json['item_changes'];
    itemNameReplace = json['item_name_replace'];
    urlImage = json['url_image'];
    specialInstructions = json['special_instructions'];
    ifSoldOut = json['if_sold_out'];
    qty = json['qty'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(Addons.fromJson(v));
      });
    }
    if (json['tax'] != null) {
      tax = <Tax>[];
      json['tax'].forEach((v) {
        tax!.add(Tax.fromJson(v));
      });
    }
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
    if (price != null) {
      data['price'] = price!.toJson();
    }
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
  String? itemSizeId;
  double? price;
  String? sizeName;
  int? discount;
  String? discountType;
  double? priceAfterDiscount;
  String? prettyPrice;
  String? prettyPriceAfterDiscount;
  double? total;
  String? prettyTotal;
  double? totalAfterDiscount;
  String? prettyTotalAfterDiscount;

  Price(
      {this.itemSizeId,
        this.price,
        this.sizeName,
        this.discount,
        this.discountType,
        this.priceAfterDiscount,
        this.prettyPrice,
        this.prettyPriceAfterDiscount,
        this.total,
        this.prettyTotal,
        this.totalAfterDiscount,
        this.prettyTotalAfterDiscount});

  Price.fromJson(Map<String, dynamic> json) {
    itemSizeId = json['item_size_id'];
    price = json['price'].toDouble();
    sizeName = json['size_name'];
    discount = json['discount'];
    discountType = json['discount_type'];
    priceAfterDiscount = json['price_after_discount'].toDouble();
    prettyPrice = json['pretty_price'];
    prettyPriceAfterDiscount = json['pretty_price_after_discount'];
    total = json['total'].toDouble();
    prettyTotal = json['pretty_total'];
    totalAfterDiscount = json['total_after_discount'].toDouble();
    prettyTotalAfterDiscount = json['pretty_total_after_discount'];
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

class Addons {
  int? subcatId;
  String? subcategoryName;
  List<AddonItems>? addonItems;

  Addons({this.subcatId, this.subcategoryName, this.addonItems});

  Addons.fromJson(Map<String, dynamic> json) {
    subcatId = json['subcat_id'];
    subcategoryName = json['subcategory_name'];
    if (json['addon_items'] != null) {
      addonItems = <AddonItems>[];
      json['addon_items'].forEach((v) {
        addonItems!.add(AddonItems.fromJson(v));
      });
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
  int? subItemId;
  String? subItemName;
  String? itemDescription;
  num? price;
  String? prettyPrice;
  String? urlImage;
  int? qty;
  num? addonsTotal;
  String? prettyAddonsTotal;
  String? multiple;

  AddonItems(
      {this.subItemId,
        this.subItemName,
        this.itemDescription,
        this.price,
        this.prettyPrice,
        this.urlImage,
        this.qty,
        this.addonsTotal,
        this.prettyAddonsTotal,
        this.multiple});

  AddonItems.fromJson(Map<String, dynamic> json) {
    subItemId = json['sub_item_id'];
    subItemName = json['sub_item_name'];
    itemDescription = json['item_description'];
    price = json['price'];
    prettyPrice = json['pretty_price'];
    urlImage = json['url_image'];
    qty = json['qty'];
    addonsTotal = json['addons_total'];
    prettyAddonsTotal = json['pretty_addons_total'];
    multiple = json['multiple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_item_id'] = subItemId;
    data['sub_item_name'] = subItemName;
    data['item_description'] = itemDescription;
    data['price'] = price;
    data['pretty_price'] = prettyPrice;
    data['url_image'] = urlImage;
    data['qty'] = qty;
    data['addons_total'] = addonsTotal;
    data['pretty_addons_total'] = prettyAddonsTotal;
    data['multiple'] = multiple;
    return data;
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
    taxId = json['tax_id'];
    taxName = json['tax_name'];
    taxInPrice = json['tax_in_price'];
    taxRate = json['tax_rate'];
    taxRateType = json['tax_rate_type'];
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

class Customer {
  String? clientId;
  String? clientUuid;
  String? firstName;
  String? lastName;
  String? contactPhone;
  String? emailAddress;
  String? avatar;
  String? memberSince;

  Customer(
      {this.clientId,
        this.clientUuid,
        this.firstName,
        this.lastName,
        this.contactPhone,
        this.emailAddress,
        this.avatar,
        this.memberSince});

  Customer.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    clientUuid = json['client_uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    contactPhone = json['contact_phone'];
    emailAddress = json['email_address'];
    avatar = json['avatar'];
    memberSince = json['member_since'];
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
    return data;
  }
}