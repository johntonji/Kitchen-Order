import 'package:flutter/material.dart';
import 'package:order_receiving/assets/app_assets.dart';
import 'package:order_receiving/models/user_model.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final profileKey = GlobalKey<FormState>();
  UserModel userModel = UserModel.getInstance();

  getuser() async {
    userModel = await SharedPreferenceManager.getInstance().getUserData();
    setState(() {}); // Ensure UI updates after fetching data
  }

  @override
  void initState() {
    super.initState();
    getuser();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController(text: userModel.username);
    TextEditingController firstNameController = TextEditingController(text: userModel.firstName);
    TextEditingController lastNameController = TextEditingController(text: userModel.lastName);
    TextEditingController emailController = TextEditingController(text: userModel.emailAddress);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontFamily: AppAssets.nunitoBold,
              color: AppAssets.primaryColor,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: profileKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  buildTextField("Username", userNameController),
                  SizedBox(height: 25),
                  buildTextField("First Name", firstNameController),
                  SizedBox(height: 25),
                 (lastNameController.value.text!="") ?  buildTextField("Last Name", lastNameController):SizedBox(),
                  SizedBox(height: 25),
                (emailController.value.text!="") ?  buildTextField("Email", emailController): SizedBox(),
                  SizedBox(height: 25),
             
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to create a text field
  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return  TextField(
                      enabled: false,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      controller: controller,
                      decoration: InputDecoration(
                        border:  InputBorder.none,
                        labelText: label,
                        labelStyle: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular,),
                        floatingLabelStyle: TextStyle(fontSize: 18, fontFamily: AppAssets.nunitoMedium, color: AppAssets.textNormalGrayColor),
                      ),
                      cursorColor: AppAssets.widgetGrayColor,
                      style: TextStyle(fontSize: 16, fontFamily: AppAssets.nunitoRegular, color: AppAssets.blackColor),
                 
    );

  }
}
