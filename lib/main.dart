import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hubcare/Constants/AppConstants.dart';
import 'package:hubcare/Screens/HomeScreen.dart';
import 'package:hubcare/Screens/LoginScreen.dart';

import 'Constants/ColorCodes.dart';
import 'Constants/SharedPreference.dart';
import 'services/PushNotificationService.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔙 Background Message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _initializeLocalNotifications();
  // Stripe payment gateWay use on SkipPayment
  // Stripe.publishableKey = AppConstants.publishableKey;
  // await Stripe.instance.applySettings();
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en', 'US')],
    path: 'lib/lang',
    // <-- change the path of the translation files
    fallbackLocale: const Locale('en', 'US'),
    saveLocale: true,
    startLocale: const Locale('en', 'US'),
    child: const MyApp(),
  ));

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.whiteColor,
    // navigation bar color
    statusBarColor: AppColors.whiteColor,
    // status bar color
    statusBarBrightness: Brightness.dark,
    //status bar brightness
    statusBarIconBrightness: Brightness.dark,
    //status barIcon Brightness
    // systemNavigationBarDividerColor: Colors.greenAccent,
    //Navigation bar divider color
    systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  ));
}

Future<void> _initializeLocalNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;

  @override
  initState() {
    super.initState();
    SharedPreference.getBool(AppConstants.isLogin)
        .then((value) => setState(() {
      isLogin = value ?? false;
    }));

  }

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
       // getPages: AppRoutes.appRoutes(),
        theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).textTheme,
            ),

            primarySwatch: Colors.deepOrange,
            useMaterial3: true
        ),
        home: isLogin ? buildHomeView() : buildLoginView()

    );
  }
  Widget buildHomeView()=>  const HomeScreen();
  Widget buildLoginView()=>  const LoginScreen();

}