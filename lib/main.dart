import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import 'package:order_receiving/firebase_options.dart';
import 'package:order_receiving/providers/app_provider.dart';
import 'package:order_receiving/repositories/app_repo.dart';
import 'package:order_receiving/ui/dashboard.dart';
import 'package:order_receiving/ui/login.dart';
import 'package:order_receiving/utilities/shares_pref_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:just_audio/just_audio.dart';

import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'assets/app_assets.dart';
import 'package:timezone/data/latest.dart' as tz;

extension StringExtension on String {
String firstToUpper() {
return "${this[0].toUpperCase()}${substring(1)}";
}
}
  AudioPlayer player = AudioPlayer();
  
void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  await player.setAsset('assets/bell_alert.mp3');
    WakelockPlus.enable();
  try{
    AwesomeNotifications().initialize(
    null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            playSound: true,
            soundSource: 'resource://raw/bell_alert',
            icon: 'resource://drawable/app_icon'
       )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ]);
      }catch(e,stack){
        //  // bugsnag.notify("3 error in getting notification is $e", stack);
      }


 try{ bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
}catch(e,stack){
   // bugsnag.notify("2 error in getting notification is $e", stack);
}
    if (!kReleaseMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // to keep app at portrait orientation
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // bugsnag.start(
  // apiKey: '8c1341097ef24cae40838da44e50a81e',
  // );
  runApp(
    MultiProvider( 
      providers: [
      ChangeNotifierProvider(create: (_)=> AppProvider(appRepo: AppRepo())),
    ],
      //child: LocalizedApp(delegate, MyApp())
      child: rv.ProviderScope(child: const MyApp()),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferenceManager.getInstance().getAuthToken(),
      builder: (context, snapshot) {
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
    );
  }
}
  Future<void> requestPermissions() async {
  // Request location and nearby devices permissions
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
  ].request();

  // Check if permissions are granted
  if (statuses[Permission.location]!=null && statuses[Permission.bluetoothScan]!=null && statuses[Permission.notification]!=null) {
  {
  if (statuses[Permission.location]!.isDenied || statuses[Permission.bluetoothScan]!.isDenied || statuses[Permission.notification]!.isDenied) {
    // Permission is denied
    debugPrint("Location or Bluetooth permission denied.");
  }
 
  }}
  if (statuses[Permission.location]!.isPermanentlyDenied) {
    // Open app settings to grant permissions manually
    openAppSettings();
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
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async{
    await Future.delayed(const Duration(milliseconds: 3000), () {
      SharedPreferenceManager.getInstance().getAuthToken().then((value) {
        if (value.isEmpty) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  Dashboard()), (Route<dynamic> route) => false);
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



/// Demo1111
/// Demo123