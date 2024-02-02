import 'dart:convert';
import 'dart:ffi';

import 'package:order_receiving/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SharedPreferenceManager {

  late SharedPreferenceManager instance;
  SharedPreferenceManager.getInstance();

  static String authToken = "user_token";
  static String userUniqueId = "user_uuid";
  static String userFirstName = "first_name";
  static String userLastName = "last_name";
  static String userPhoneNumber = "contact_number";
  static String userAvatar = "avatar";

  void saveUserData(UserModel userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authToken, userModel.authToken ?? "");
    prefs.setString(userUniqueId, userModel.userUuid ?? "");
    prefs.setString(userFirstName, userModel.firstName ?? "");
    prefs.setString(userLastName, userModel.lastName ?? "");
    prefs.setString(userPhoneNumber, userModel.contactNumber ?? "");
    prefs.setString(userAvatar, userModel.avatar ?? "");
  }

  Future<UserModel> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserModel userModel;
    try{
      return UserModel(
        authToken: prefs.getString(authToken),
        userUuid: prefs.getString(userUniqueId),
        firstName: prefs.getString(userFirstName),
        lastName: prefs.getString(userLastName),
        contactNumber: prefs.getString(userPhoneNumber),
        avatar: prefs.getString(userAvatar)
      );
    }catch(exception){
      return UserModel.getInstance();
    }
  }

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(authToken) ?? "";
  }

  Future<String> clearAllPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(authToken);
    prefs.remove(userUniqueId);
    prefs.remove(userFirstName);
    prefs.remove(userLastName);
    prefs.remove(userPhoneNumber);
    prefs.remove(userAvatar);

    return "Cleared";
  }
}