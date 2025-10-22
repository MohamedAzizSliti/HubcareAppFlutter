
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConstImage.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  String token = "";
  List<dynamic> transaction = [];
  bool isLoading = true;

  @override
  void initState() {
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        getTransaction();
      });
    });
    super.initState();
  }

  getTransaction() {
    var url = BaseUrl.getTransactions;
    HttpService.getDataWithHeader(url,token).then((response) {
      setState(() {
        debugPrint('getTransaction: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status'] == true) {
          transaction = responseJson['transactions'];
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: responseJson['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColors.themeColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    });
  }

  String formatCustomDate(String isoDateString) {
    DateTime dateTime = DateTime.parse(isoDateString).toLocal();
    String dayName = DateFormat('EEE').format(dateTime); // Mon, Tue...
    String day = DateFormat('dd').format(dateTime); // 01, 02...
    String month = DateFormat('MMM').format(dateTime); // Jan, Feb...
    String time = DateFormat('hh:mm a').format(dateTime); // 10:10 AM
    return '$dayName, $day $month at $time';
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
              'Latest Transaction',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.fontColors),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 17, right: 17),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.themeColor,
                ),
              )
            : transaction.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: transaction.length, //notification.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                    size: const Size.fromRadius(30),
                                    // Image radius
                                    child: SvgPicture.asset(
                                      'assets/tranIcon.svg',
                                      fit: BoxFit.cover,
                                      height: 35,
                                    )),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${transaction[index]['type']}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.fontColors),
                                    ),
                                    Text(
                                      formatCustomDate(transaction[index]['createdAt'].toString()),
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.fontGrayColors),
                                    ),
                                  ],
                                ),
                              ),
                              transaction[index]['type'] == "CREDIT" ?
                              Text(
                                '+QR${'${transaction[index]['amount']}'}',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.greenColor),
                              ):Text(
                                '-QR${'${transaction[index]['amount']}'}',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.red_color),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: AppColors.inputColor.withOpacity(
                              .8,
                            ),
                            height: 5,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                        ],
                      );
                    })
                :Center(child: const Text("No Transaction found.")),
      )),
    );
  }
}
