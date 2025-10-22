
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/RatingScreen.dart';

import '../Constants/ColorCodes.dart';
import '../Constants/ConstImage.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
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
          SizedBox(height: 15,),



          SizedBox(height: 35),
          InkWell(
            onTap: () {

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
                      fontWeight: FontWeight.w600,
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
