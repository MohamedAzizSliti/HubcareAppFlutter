import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hubcare/Constants/AppConstants.dart';
import 'package:hubcare/Constants/ColorCodes.dart';
import 'package:hubcare/Constants/SharedPreference.dart';
import 'package:hubcare/Screens/HomeScreen.dart';
import 'package:hubcare/Screens/LoginScreen.dart';

// Global instance of FlutterLocalNotificationsPlugin for use in HomeScreen
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

/// Initialize Firebase (optional - will not crash if initialization fails)
Future<void> initializeFirebase() async {
  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDrc8khnGo7eUC_A63DSt-yzYNDwi1pCdM',
          appId: '1:1045851095498:android:93b5907de331f4ce640f33',
          messagingSenderId: '1045851095498',
          projectId: 'hubcare-8ad42',
        ),
      );
    } else if (Platform.isIOS) {
      await Firebase.initializeApp();
    }

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('⚠️ Firebase initialization failed (optional): $e');
    // Continue without Firebase - app will still work
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase (optional - won't crash if it fails)
  await initializeFirebase();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US')],
      path: 'lib/lang',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hubcare',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: AppColors.themeColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.themeColor,
          primary: AppColors.themeColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          // Show loading indicator while checking login status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.themeColor,
                ),
              ),
            );
          }

          // Navigate based on login status
          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }

  /// Check if user is logged in from SharedPreferences
  Future<bool> _checkLoginStatus() async {
    try {
      final isLogin = await SharedPreference.getBool(AppConstants.isLogin);
      return isLogin == true;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }
}
