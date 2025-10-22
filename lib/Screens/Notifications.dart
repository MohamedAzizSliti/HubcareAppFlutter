
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

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  String token = "";
  String userType = "";

  bool isLoading = false;
  dynamic argumentData = Get.arguments;
  var notification = [];

  @override
  void initState() {
    super.initState();
    SharedPreference.getString(AppConstants.loginToken).then((v) {
      setState(() {
        token = v;
        isLoading = true;
        getNotifications();
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                  'Notifications',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.fontColors),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 2),
              child: isLoading ? loaderView() : notification.isEmpty ? emptyView() : buildNotification(),),),),

      ],
    );
  }

  Widget loaderView()=> Center(
    child: CircularProgressIndicator(
      color: AppColors.themeColor,
    ),
  );

  Widget emptyView() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 130),
      Center(child: ConstImage().buildImage('empty.png', 150,150)),
      SizedBox(height: 10),
      Text(
        'Notification are empty',
        style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w700,
            color: AppColors.fontColors),
      ), SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 50,right: 50),
        child: Text(
          'No notifications at the moment. Stay tuned—updates about bookings, new services and more will appear here soon.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.fontColors),
        ),
      ),
    ],
  );


  Widget buildNotification() =>
      ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: notification.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(top: 4,left: 2,right: 2),
              child: InkWell(
                onTap: () {
                /* if(notification[index]['notification_type'] == "Trip Added"){
                   //Get.to(() => const DelivererDetail(),arguments: [notification[index]['tripId'],"2"]);
                 }
                 if(notification[index]['notification_type'] == "Parcel Added"){
                   //Get.to(() => const MyParcelDetail(),arguments: ["2",notification[index]['parcelId']]);
                 }*/
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12,right: 12),
                  child: Column(children: [
                    const SizedBox(height: 15,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       /* ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(30),
                            // Image radius
                            child: //notification[index]['sender']['profile_image'].isEmpty
                            "".isEmpty
                                ? SvgPicture.asset(
                              'assets/avatar.svg',
                              fit: BoxFit.cover,
                              height: 35,
                            )
                                : Image.network(
                              notification[index]['sender']['profile_image'],
                              fit: BoxFit.cover,
                              height: 35,
                            ),
                          ),
                        ),*/
                        const SizedBox(width: 7,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification[index]['title'],
                                      //'Your booking is confirmed',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.fontColors),
                                    ),
                                  ),

                                  Text(
                                    formatCustomDate(notification[index]['createdAt']),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.fontGrayColors),
                                  ),
                                ],
                              ),
                              Text(
                                notification[index]['message'],
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.fontGrayColors),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      color: AppColors.inputColor.withOpacity(
                        .8,
                      ),
                      height: 5,
                      width: MediaQuery.of(context).size.width - 10,
                    ),

                  ],),
                ),
              ),
            );
          });

  String formatCustomDate(String isoDateString) {
    DateTime dateTime = DateTime.parse(isoDateString).toLocal();
    // Define format parts
    String dayName = DateFormat('EEE').format(dateTime); // Mon, Tue...
    String day = DateFormat('dd').format(dateTime); // 01, 02...
    String month = DateFormat('MMM').format(dateTime); // Jan, Feb...
    String time = DateFormat('hh:mm a').format(dateTime); // 10:10 AM
    // Combine into desired output
    //return '$dayName, $day $month at $time';
    return time;
  }

  getNotifications() {
    var url = BaseUrl.getNotification;
    HttpService.getDataWithHeader(url, token).then((response) {
      setState(() {
        // ignore: avoid_print
        print(response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);
        isLoading = false;
        if (response.statusCode == 200) {
           notification = responseJson['data'] as List;
           setState(() {
             isLoading = false;
           });
        } else {
          if (response.statusCode == 403) {
            Fluttertoast.showToast(
                msg: responseJson['error'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.themeColor,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      });
    });
  }
}
