class UserModel {
  String? username;
  String? authToken;
  String? userUuid;
  String? firstName;
  String? lastName;
  String? emailAddress;
  String? contactNumber;
  String? avatar;
  String? address;
  String? merchantId;
  String? logo;
  String? path;
  bool? autoAccept;
  int? merchantOrderRejectMins;
 
  // List<String>? wifiPrinters;

  UserModel.getInstance();

  UserModel(
      { this.username,
        this.authToken,
        this.userUuid,
        this.firstName,
        this.lastName,
        this.emailAddress,
        this.contactNumber,
        this.avatar,
        this.address,
        this.merchantId,
        this.logo,
        this.merchantOrderRejectMins,
        this.path,
        this.autoAccept
        });

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    authToken = json['user_token'];
    userUuid = json['user_uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailAddress = json['email_address'];
    contactNumber = json['contact_number'];
    avatar = json['avatar'];
    address = json['address'];
    merchantId = json['merchant_id'];
    logo = json['logo'];
    merchantOrderRejectMins = json['merchant_order_reject_mins'];
    path = json['path'];
    autoAccept=json["merchant_auto_accept_order"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['user_token'] = authToken;
    data['user_uuid'] = userUuid;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email_address'] = emailAddress;
    data['contact_number'] = contactNumber;
    data['avatar'] = avatar;
    data['address'] = address;
    data['merchant_id'] = merchantId;
    data['logo'] = logo;
    data['path'] = path;
    data["merchant_auto_accept_order"]=autoAccept;
    data["merchant_order_reject_mins"] = merchantOrderRejectMins;

    return data;
  }
}