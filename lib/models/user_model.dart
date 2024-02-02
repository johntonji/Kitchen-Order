import 'package:flutter/material.dart';

class UserModel {
  String? authToken;
  String? userUuid;
  String? firstName;
  String? lastName;
  String? emailAddress;
  String? contactNumber;
  String? avatar;

  UserModel.getInstance();

  UserModel(
      {this.authToken,
        this.userUuid,
        this.firstName,
        this.lastName,
        this.emailAddress,
        this.contactNumber,
        this.avatar});

  UserModel.fromJson(Map<String, dynamic> json) {
    authToken = json['user_token'];
    userUuid = json['user_uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailAddress = json['email_address'];
    contactNumber = json['contact_number'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_token'] = authToken;
    data['user_uuid'] = userUuid;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email_address'] = emailAddress;
    data['contact_number'] = contactNumber;
    data['avatar'] = avatar;
    return data;
  }
}