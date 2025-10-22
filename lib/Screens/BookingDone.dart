
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hubcare/Constants/ConstImage.dart';
import 'package:hubcare/Screens/HomeScreen.dart';

import '../Constants/ColorCodes.dart';

class BookingDone extends StatefulWidget {
  const BookingDone({super.key});

  @override
  State<BookingDone> createState() => _BookingDoneState();
}

class _BookingDoneState extends State<BookingDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [

          ConstImage().buildImage('done.png', 100, 100),

          Text(
            'Thanks for \nChoosing our Service',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor),
          ),
          SizedBox(height: 35),
          InkWell(
            onTap: () {
             Get.offAll(()=> HomeScreen());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back),
                SizedBox(width: 10),
                Text(
                  'Back to home',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor),
                ),
              ],
            ),
          ),

        ],
      )),
    );
  }
}
