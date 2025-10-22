
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/BookingDone.dart';
import 'package:hubcare/Widgets/button_widget.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConstImage.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import 'HomeScreen.dart';

class PaymentSummary extends StatefulWidget {
  bool promoCode;
  String serviceId;
  String servicePrice;
  String serviceName;
  String serviceDate;
  String serviceTime;
  String workHours;
  String numberOfWorker;
  String locationId;


   PaymentSummary({super.key, this.promoCode=false,required this.servicePrice,required this.serviceName,
     required this.serviceId,required this.serviceDate,required this
   .numberOfWorker,required this.serviceTime,required this.workHours,required this.locationId});

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}



class _PaymentSummaryState extends State<PaymentSummary> {
  var token;
  TextEditingController promoController = TextEditingController();
  bool isApplying = false;
  double  discountAmount = 0;
  double  finalAmount = 0;
  String discountType = "";
  bool isLoading = false;

  @override
  void initState() {
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
      });
    });
    super.initState();
  }



  Future<void> _bookOnService() async {
    setState(() => isLoading = true);
    try {
      dynamic data = {
        "serviceDate": widget.serviceDate,
        "numberOfWorker": widget.numberOfWorker,
        "startTime": widget.serviceTime,
        "workHours": widget.workHours,
        "locationId": widget.locationId,
       // "offerId":"af93d030-a0a0-495b-ae45-e5fd26fed5e8",  // OPTIONAL
        "paymentMethod":"WALLET"   //WALLET //CASH
      };
      HttpService.postWithHeader("${BaseUrl.addBooking}${widget.serviceId}", data,token).then((response) {
        setState(() {
          Map<String, dynamic> responseJson = json.decode(response.body);
          if (responseJson['status'] == true) {
            setState(() => isLoading = false);
            debugPrint(responseJson.toString());
            Get.to(() => BookingDone());

          } else {
            setState(() => isLoading = false);
            Fluttertoast.showToast(
                msg: responseJson['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.themeColor,
                textColor: Colors.black,
                fontSize: 16.0);
          }
        });
      });
    } on Exception catch (_, e) {
      setState(() => isLoading = false);
      debugPrint('$e');
    }
  }

  Future<void> applyPromoCode() async {
    final url = BaseUrl.getCheckCoupanCode;
    setState(() => isApplying = true);

    try {
      final response = await HttpService.getDataWithHeader("${url}offerCode=${promoController.text}", token);
      print('bookingStatus: ${response.body}');
      Map<String, dynamic> responseJson = json.decode(response.body);

      if (responseJson['status'] == true) {
        final data = responseJson['data'];
        setState(() {
          promoController.clear();
          discountType = data['discountType'];
          discountAmount = double.parse(data['discountValue'].toString());
          double originalPrice = double.parse(widget.servicePrice) * int.parse(widget.workHours);

          if (discountType == "PERCENTAGE") {
            double discountValue = (originalPrice * discountAmount) / 100;
            finalAmount = originalPrice - discountValue;
          } else {
            finalAmount = originalPrice - discountAmount;
          }
        });

        Fluttertoast.showToast(msg: responseJson['message']);
      } else {
        Fluttertoast.showToast(msg: responseJson['message']);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() => isApplying = false);
    }
  }


  double calculateDiscountPercentFromAmount(double originalPrice, double discountAmount) {
    return (discountAmount / originalPrice) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.inputCornerColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: ConstImage().buildSvgImage('backArrow.svg', 28)),
            const SizedBox(
              width: 7,
            ),
            Text(
              'Payment summary',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.fontColors),
            ),
          ],
        ),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.only(left: 17,right: 17),
        child: ListView(
          children: [
          const SizedBox(
            height: 15,
          ),

          Container(
            padding: EdgeInsets.fromLTRB(5, 12, 5, 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.grayColor66.withOpacity(0.0),
              ),
              color: AppColors.whiteColor,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(
                  Radius.circular(1.0)),
            ),
            child:
            // Row(
            //   children: [
            //
            //     Text(
            //       'Promo code 20%',
            //       textAlign: TextAlign.start,
            //       style: TextStyle(
            //           fontSize: 14.0,
            //           fontWeight: FontWeight.w600,
            //           color: AppColors.blackColor),
            //     ),
            //
            //     Expanded(
            //       child: const SizedBox(
            //         height: 15,
            //       ),
            //     ),
            //
            //     SizedBox(
            //       width: 75,
            //       height: 35,
            //       child: TextButton(
            //         style: ButtonStyle(
            //             backgroundColor: MaterialStateProperty.all(
            //                 AppColors.blue_light_color),
            //             shape:
            //             MaterialStateProperty.all<RoundedRectangleBorder>(
            //                 RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(10.0),
            //                 ))),
            //         onPressed: () {
            //
            //         },
            //         child: const Text('Apply',
            //             style: TextStyle(color: Colors.blue)),
            //       ),
            //     ),
            //   ],
            // ),
            widget.promoCode== true ?
            TextField(
              controller: promoController,
              decoration: InputDecoration(
                labelText: 'Enter Promo Code',
                suffixIcon: isApplying
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ): Container(
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            AppColors.blue_light_color),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                    onPressed: () => applyPromoCode(),
                    child: const Text('Apply',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
            ):Container(),
          ),


          const SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 12, 5, 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.grayColor66.withOpacity(0.0),
              ),
              color: AppColors.whiteColor,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(
                  Radius.circular(1.0)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Service Charge',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      'QR ${widget.servicePrice}/hr',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Text(
                      'Number of Worker',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      widget.numberOfWorker,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Text(
                      'Number of hours',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      '${widget.workHours}hr',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                // Row(
                //   children: [
                //     Text(
                //       'Taxes & fee',
                //       style: TextStyle(
                //           fontSize: 14.0,
                //           fontWeight: FontWeight.w500,
                //           color: AppColors.fontColors),
                //     ),
                //     Expanded(child: SizedBox()),
                //     Text(
                //       'QR 20',
                //       style: TextStyle(
                //           fontSize: 14.0,
                //           fontWeight: FontWeight.w500,
                //           color: AppColors.fontColors),
                //     ),
                //   ],
                // ),
                finalAmount!=0 ?
                Row(
                  children: [
                    Text(
                      'Promo Code',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      discountType == "PERCENTAGE" ?
                      "-${discountAmount ?? ""}%":
                      "-${discountAmount ?? ""}",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blueColor),
                    ),
                  ],
                ):Container(),
                const SizedBox(
                  height: 10,
                ),

                Container(
                  color: AppColors.inputColor.withOpacity(.8,),
                  height: 2,
                  width: MediaQuery.of(context).size.width - 10,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fontColors),
                    ),
                    Expanded(child: SizedBox()),
                    finalAmount!=0 ?
                    Text(
                      'QR $finalAmount',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ):
                    Text(
                      'QR ${ int.parse(widget.servicePrice.toString()) * int.parse(widget.workHours.toString())}',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonWidget(text: 'Pay with Wallet',
            isLoading: isLoading,
            onPressed: isLoading ? null : _bookOnService,
          ),
          const SizedBox(
            height: 12,
          ),
          // client hide on case
            // ButtonWidget(text: 'Pay with Case', onPressed: (){
          //   _bookOnService();
          // }),
          // const SizedBox(
          //   height: 12,
          // ),
        ],),
      )),
    );
  }
}
