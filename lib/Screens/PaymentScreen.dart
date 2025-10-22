
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/PaymentSuccess.dart';
import 'package:hubcare/Widgets/button_widget.dart';

import '../Constants/ColorCodes.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Optional: Remove shadow
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(
                  'assets/backArrow.svg',
                  height: 28,
                )),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Payment',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.only(left: 17, right: 17, top: 5),
        child: Column(
          children: [

            Expanded(child: SizedBox(height: 300,)),

            ButtonWidget(text: 'Pay', onPressed: (){
              Get.to(()=> PaymentSuccess());
            })
          ],
        ),
      )),
    );
  }
}
