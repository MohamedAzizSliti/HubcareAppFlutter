import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Global navigation key
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Local notifications instance
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification Permission Granted');

      // Initialize local notifications (for foreground handling)
      _initializeLocalNotifications();

      // ✅ Handle foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Foreground Notification: ${message.notification?.title}");

        // Show an in-app notification using local notifications
        _showLocalNotification(message);
      });

      // ✅ Handle notification click when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("🔔 Notification Clicked (Background): ${message.data}");
        _handleMessageClick(message);
      });

      // ✅ Handle notification click when app is terminated
      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          print("🚀 App Opened via Notification: ${message.data}");
          _handleMessageClick(message);
        }
      });
    } else {
      print('❌ Notification Permission Denied');
    }
  }

  /// ✅ Show local notification when app is open
  static void _showLocalNotification(RemoteMessage message) async {
    // Build local notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('high_importance_channel', 'High Importance Notifications',
        channelDescription: 'Channel for showing important notifications',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show local notification
    await _localNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title ?? "New Notification",
      message.notification?.body ?? "You have a new message",
      platformChannelSpecifics,
      payload: message.data['screen'], // Pass screen info
    );
  }

  /// ✅ Initialize local notifications
  static void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    _localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (message) async {

          print("🔔 Foreground Notification Clicked:jh ${message.payload}");
          print("🔔 Foreground Notification Clicked:jj ${message.notificationResponseType.name}");
          _handlePayloadClick("Parcel Added");
          // This function handles the click in the notification when the app is in foreground
          // Get.toNamed(NOTIFICATIOINS_ROUTE);
        });
  }

  /// ✅ Handle message click from Firebase notifications
  static void _handleMessageClick(RemoteMessage message) {
    if (message.data.containsKey('screen')) {
      String screen = message.data['screen'];
      _navigateToScreen(screen);
    }
  }

  /// ✅ Handle local notification click (Foreground)
  static void _handlePayloadClick(String screen) {
    _navigateToScreen(screen);
  }

  /// ✅ Navigate to screen
  static void _navigateToScreen(String screen) {
    if (screen == 'details') {
     // navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => DetailsScreen()),);
    }
  }
}
