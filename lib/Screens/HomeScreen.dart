//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hubcare/Screens/BookingTab.dart';
// import 'package:hubcare/Screens/CategoryTab.dart';
// import 'package:hubcare/Screens/HomeTab.dart';
// import 'package:hubcare/Screens/ProfileTab.dart';
// import 'package:hubcare/Screens/WalletTab.dart';
//
// import '../Constants/ColorCodes.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   List<Widget>? _children ;
//
//
//   void _onItemTap(int index) {
//     setState(() {
//       _selectedIndex = index;
//
//     });
//   }
//
//   @override
//   void initState() {
//     _children = [const HomeTab(), const CategoryTab(), BookingTab(),const WalletTab(),const ProfileTab(),];
//     super.initState();
//   }
//
//   @override
//   void dispose(){
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//         body: _children![_selectedIndex],
//
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         bottomNavigationBar: Container(
//           height: 70,
//           // padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//           decoration: BoxDecoration(
//             color: AppColors.blackColor,
//             borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(1), topLeft: Radius.circular(1)),
//           ),
//           child: BottomNavigationBar(
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             type: BottomNavigationBarType.fixed,
//
//             //fixedColor: Colors.black,
//             unselectedItemColor: AppColors.unSelectedTabColor,
//             selectedItemColor: AppColors.themeColor,
//             currentIndex: _selectedIndex,
//             showSelectedLabels: true,
//             showUnselectedLabels: true,
//             onTap: _onItemTap,
//
//             items: [
//               BottomNavigationBarItem(
//                 icon: SvgPicture.asset('assets/home.svg'),activeIcon: SvgPicture.asset('assets/home_s.svg'),
//                 label: 'Home',
//               ),
//
//               BottomNavigationBarItem(
//                   icon: SvgPicture.asset('assets/category.svg'), activeIcon: SvgPicture.asset('assets/category_s.svg'),
//                 label: 'Category',),
//
//               BottomNavigationBarItem(
//                   icon: SvgPicture.asset('assets/booking.svg'),activeIcon: SvgPicture.asset('assets/booking_s.svg'),
//                   label: 'Booking'),
//
//               BottomNavigationBarItem(
//                   icon: SvgPicture.asset('assets/wallet.svg'),activeIcon: SvgPicture.asset('assets/wallet_s.svg'),
//                   label: 'Wallet'),
//
//               BottomNavigationBarItem(
//                   icon: SvgPicture.asset('assets/profile.svg'),activeIcon: SvgPicture.asset('assets/profile_s.svg'),
//                   label: 'Profile'),
//             ],
//           ),
//         ),
//
//     );
//   }
// }

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hubcare/Screens/BookingTab.dart';
import 'package:hubcare/Screens/CategoryTab.dart';
import 'package:hubcare/Screens/HomeTab.dart';
import 'package:hubcare/Screens/ProfileTab.dart';
import 'package:hubcare/Screens/WalletTab.dart';

import '../Constants/ColorCodes.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget>? _children;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _requestNotificationPermission();
    _setupFCMListeners();
    _configureLocalNotificationTap();
    super.initState();
    _children = [
      const HomeTab(),
      const CategoryTab(),
      BookingTab(),
      const WalletTab(),
      const ProfileTab(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }


  void _requestNotificationPermission() async {
   var  token = await FirebaseMessaging.instance.getToken();
    print("📲 FCM Token: $token");
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notification permission granted");
    } else {
      print("🚫 Notification permission denied");
    }
  }


  void _setupFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📥 Foreground Message: ${message.notification?.title}");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              channelDescription: 'your_channel_description',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(message.data);
      }
    });
  }

  void _configureLocalNotificationTap() {
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _handleNotificationTap(data);
        }
      },
    );
  }


  void _handleNotificationTap(Map<String, dynamic> data) {
    // Navigate to a screen based on data

    print("===========================>:::::::${data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _children!,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.blackColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(1),
            topLeft: Radius.circular(1),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: AppColors.unSelectedTabColor,
          selectedItemColor: AppColors.themeColor,
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: _onItemTap,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/home.svg'),
              activeIcon: SvgPicture.asset('assets/home_s.svg'),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/category.svg'),
              activeIcon: SvgPicture.asset('assets/category_s.svg'),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/booking.svg'),
              activeIcon: SvgPicture.asset('assets/booking_s.svg'),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/wallet.svg'),
              activeIcon: SvgPicture.asset('assets/wallet_s.svg'),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/profile.svg'),
              activeIcon: SvgPicture.asset('assets/profile_s.svg'),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
