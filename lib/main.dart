import 'dart:async';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/repositories/app_repo.dart';
import 'package:order_receiving/ui/dashboard.dart';
import 'package:order_receiving/ui/login.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:provider/provider.dart';

import 'assets/app_assets.dart';
import 'notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  AwesomeNotifications().initialize(
    null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ]);
  bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=> AppProvider(appRepo: AppRepo())),
    ],
      //child: LocalizedApp(delegate, MyApp())
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppAssets.fullName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {

    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );

    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async{
    await Future.delayed(const Duration(milliseconds: 3000), () {
      SharedPreferenceManager.getInstance().getAuthToken().then((value) {
        if (value.isEmpty) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Dashboard()), (Route<dynamic> route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppAssets.whiteColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppAssets.appLogo, width: 100, height: 100,),
            const SizedBox(height: 6),
            Text(AppAssets.fullNameTwoLines, style: TextStyle(fontSize: 30, fontFamily: AppAssets.nunitoMedium, color: AppAssets.primaryColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
