import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/ChatScreen.dart';
import 'package:hubcare/Screens/PaymentScreen.dart';
import 'package:hubcare/Screens/RatingScreen.dart';
import 'package:hubcare/Widgets/button_widget.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConstImage.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import 'new_chat_screen.dart';

class BookingDetails extends StatefulWidget {
  final String bookingId;
  const BookingDetails({super.key,required this.bookingId});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  int isBtn = 1;
  var bookingStatus;
  dynamic bookingDetails;
  String token = "";
  bool isLoading = true;
  bool isLoadingBookingStartEnd = false;
  List<dynamic> workerAssign = [];

  @override
  void initState() {
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        getBookingDetails();
        getBookingStatus();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
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
              'Booking details',
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
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 17, right: 17),
        child: isLoading
              ? Center(
            child: CircularProgressIndicator(
              color: AppColors.themeColor,
            ),
          ) : bookingDetails != null
                  ? SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: AppColors.inputColor.withOpacity(.8,),
                            height: 12,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4, left: 2, right: 2),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.network(
                                          bookingDetails['service']['serviceImages']!=null ?
                                          "${BaseUrl.imageUrl}${bookingDetails['service']['serviceImages'][0]}" :"",
                                          fit: BoxFit.cover,
                                          height: 65,
                                            width: 65,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(Icons.broken_image, color: Colors.grey, size: 65),
                                              );
                                            }
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '#5152dd',
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.blueColor),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Text(
                                                  bookingDetails['bookingStatus'] ?? "",
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight.w500,
                                                      color:
                                                          AppColors.themeColor),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              bookingDetails['service']['serviceName'] ?? '',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.fontColors),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'QR ${ bookingDetails['service']['servicePrice'].toString()}',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w500,
                                                      color:
                                                          AppColors.fontColors),
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  //notification[index]['body'],
                                                  'PER HR.',
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight.w500,
                                                      color:
                                                          AppColors.themeColor),
                                                ),
                                                Expanded(child: SizedBox()),
                                                bookingDetails['approved']== true ?
                                                InkWell(
                                                  onTap: () {
                                                   // Get.to(() => ChatScreen(bookingId: bookingDetails['id'],));
                                                    Get.to(() => NewChatScreen(bookingId: bookingDetails['id'],));
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 7,
                                                        right: 7,
                                                        top: 3,
                                                        bottom: 3),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppColors
                                                            .fontLiteColors
                                                            .withOpacity(0.1),
                                                      ),
                                                      color: AppColors.whiteColor,
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.message,
                                                          color: AppColors
                                                              .blackColor,
                                                          size: 13,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Chat',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: AppColors
                                                                  .blackColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ):Container(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    color: AppColors.inputColor.withOpacity(
                                      .9,
                                    ),
                                    height: 1,
                                    width: MediaQuery.of(context).size.width - 10,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      bookingDetails['bookingStatus']!= "CANCELLED" ||
                                      bookingDetails['bookingStatus']!= "COMPLETED" ||
                                      bookingDetails['approved']== true ?
                                      workerAssign.isEmpty ?
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width -
                                              70,
                                          height: 40,
                                          child: TextButton(
                                              style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all<EdgeInsets>(
                                                          EdgeInsets.all(7)),
                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                      AppColors.redLightColor),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                          side: BorderSide(color: AppColors.redLightColor)))),
                                              onPressed: () {
                                                 cancelBooking(bookingDetails['id'].toString());
                                              },
                                              child: Text("Cancel Booking", style: TextStyle(fontSize: 14, color: AppColors.redColor)))):Container():Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: AppColors.inputColor.withOpacity(
                              .8,
                            ),
                            height: 12,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Service scheduled on',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.fontColors),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 9, right: 9, top: 7, bottom: 7),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        AppColors.fontLiteColors.withOpacity(0.1),
                                  ),
                                  color:
                                      AppColors.grayLightColor.withOpacity(0.5),
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.grayColor66),
                                    ),
                                    Text(
                                      '${bookingDetails['serviceDate']}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 9, right: 9, top: 7, bottom: 7),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        AppColors.fontLiteColors.withOpacity(0.1),
                                  ),
                                  color:
                                      AppColors.grayLightColor.withOpacity(0.5),
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Time \n(Start from)',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.grayColor66),
                                    ),
                                    Text(
                                      '${bookingDetails['startTime']}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 9, right: 9, top: 7, bottom: 7),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.themeColor.withOpacity(0.1),
                                  ),
                                  color: AppColors.themeColor.withOpacity(0.2),
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Number of \nWorker',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.themeColor),
                                    ),
                                    Text(
                                      '${bookingDetails['numberOfWorker']}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.themeColor),
                                    ),
                                  ],
                                ),
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
                            height: 12,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Assigned Worker',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.fontColors),
                          ),
                          const SizedBox(
                            height: 5,
                          ),


                          const SizedBox(
                            height: 15,
                          ),
                          workerAssign.isNotEmpty ?
                          GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: workerAssign.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                  (orientation == Orientation.portrait) ? 2 : 2,
                                  childAspectRatio: 3.5),
                              itemBuilder: (BuildContext context, int index) {
                                var worker = workerAssign[index];
                                return Container(
                                  margin: const EdgeInsets.only(top: 5,left: 2,right: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.fontLiteColors.withOpacity(0.1),
                                    ),
                                    color: AppColors.whiteColor,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(47.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          // Image radius
                                          child:
                                          Image.network(
                                              worker['worker']!=null ?
                                              "${BaseUrl.imageUrl}${worker['worker']['profile_image']}" :"",
                                              fit: BoxFit.cover,
                                              height: 42,
                                              width: 42,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/catImg.png',
                                                  fit: BoxFit.cover,
                                                  height: 42,
                                                );
                                              }
                                          )
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        worker['worker']['name'] ?? "",
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor),
                                      ),
                                    ],
                                  ),
                                );
                              }):
                          Text(
                            'No workers are currently assigned by the service provider.',
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.redColor),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: AppColors.inputColor.withOpacity(
                              .8,
                            ),
                            height: 12,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(37),
                                // Image radius
                                child: //notification[index]['sender']['profile_image'].isEmpty
                                    Image.asset(
                                  'assets/catImg.png',
                                  fit: BoxFit.cover,
                                  height: 65,
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Service Provider'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.themeColor),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${bookingDetails['service']['provider']['name']}',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.fontColors),
                                        ),
                                        Expanded(child: SizedBox(width: 2)),
                                        Icon(
                                          Icons.star,
                                          color: AppColors.themeColor,
                                          size: 18,
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          bookingDetails['service']['provider']['averageRating'].toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.fontLiteColors),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: AppColors.themeColor,
                                          size: 18,
                                        ),
                                        SizedBox(width: 2),
                                        Flexible(
                                          child: Text(
                                            bookingDetails['service']['provider']['companyaddress'] ?? "",
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.fontColors),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                            height: 12,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Booking Status',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.fontColors),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          bookingStatus != null
                              ? Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        bookingStatus['bookingConfirmed'] == false
                                            ? Icon(
                                                Icons.circle_outlined,
                                                color: AppColors.grayLightColor,
                                                size: 16,
                                              )
                                            : Icon(
                                                Icons.check_circle,
                                                color: AppColors.blueColor,
                                                size: 18,
                                              ),
                                        bookingStatus['bookingConfirmed'] == false
                                            ? Container(
                                                color: AppColors.grayLightColor,
                                                height: 60,
                                                width: 2,
                                              )
                                            : Container(
                                                color: AppColors.blueColor,
                                                height: 60,
                                                width: 3,
                                              ),
                                        // workerAssigned condition
                                        bookingStatus['workerAssigned'] == false
                                            ? Icon(
                                                Icons.circle_outlined,
                                                color: AppColors.grayLightColor,
                                                size: 16,
                                              )
                                            : Icon(
                                                Icons.check_circle,
                                                color: AppColors.blueColor,
                                                size: 18,
                                              ),
                                        bookingStatus['workerAssigned'] == false
                                            ? Container(
                                                color: AppColors.grayLightColor,
                                                height: 60,
                                                width: 2,
                                              )
                                            : Container(
                                                color: AppColors.blueColor,
                                                height: 60,
                                                width: 3,
                                              ),

                                        // serviceCompleted condition
                                        bookingStatus['serviceCompleted'] == false
                                            ? Icon(
                                                Icons.circle_outlined,
                                                color: AppColors.grayLightColor,
                                                size: 16,
                                              )
                                            : Icon(
                                                Icons.check_circle,
                                                color: AppColors.blueColor,
                                                size: 18,
                                              ),
                                        // bookingStatus['serviceCompleted'] == false
                                        //     ? Container(
                                        //         color: AppColors.grayLightColor,
                                        //         height: 60,
                                        //         width: 2,
                                        //       )
                                        //     : Container(
                                        //         color: AppColors.blueColor,
                                        //         height: 60,
                                        //         width: 3,
                                        //       ),
                                        // amountPaid conditon client hide cash
                                        //
                                        // bookingStatus['amountPaid'] == false
                                        //     ? Icon(
                                        //         Icons.circle_outlined,
                                        //         color: AppColors.grayLightColor,
                                        //         size: 16,
                                        //       )
                                        //     : Icon(
                                        //         Icons.check_circle,
                                        //         color: AppColors.blueColor,
                                        //         size: 18,
                                        //       ),
                                        // SizedBox(
                                        //   height: 60,
                                        //   width: 2,
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Booking Confirmed',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.fontColors),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'Service provider has accept your booking',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.fontColors),
                                        ),
                                          /* const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Mon, 23 Jan, 2025 at 10:30 AM',
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.fontColors.withOpacity(.6)),
                          ),*/
                                        const SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Worker Assigned',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.fontColors),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'Vendor has assign the person for your service',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.fontColors),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Service Completed',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.fontColors),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'Service provider has complete his service',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.fontColors),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                        /*  client hide cash payment
                                        Text(
                                            'Amount Due',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.fontColors),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'QR 820',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.fontColors),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: AppColors.inputColor.withOpacity(
                              .8,
                            ),
                            height: 12,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                'Payment summary',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.fontColors),
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                'QR ${bookingDetails['amount']}/hr',
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
                                '${bookingDetails['numberOfWorker']}',
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
                                'Time Taken',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.fontColors),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                '${bookingDetails['workHours']} hours',
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
                                'Taxes & fee',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.fontColors),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                'QR ${bookingDetails['taxesAndFees']}',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.fontColors),
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
                            height: 12,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          bookingDetails['bookingStatus'] == "COMPLETED" ?
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                left: 9, right: 9, top: 7, bottom: 7),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.themeColor.withOpacity(0.1),
                              ),
                              color: AppColors.themeColor.withOpacity(0.2),
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                ConstImage().buildSvgImage('rat.svg', 100),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Rate the service and let us know how we did!',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => RatingScreen(providerId: bookingDetails['service']['providerId'],));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Give Review and Rating',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.themeColor,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ):Container(),
                         /* comment goutam
                         if (isBtn == 1)
                            ButtonWidget(
                                icon: Icons.arrow_forward,
                                text: 'Start Service',
                                onPressed: () {
                                  setState(() {
                                    isBtn = 2;
                                  });
                                }),
                          if (isBtn == 2)
                            ButtonWidget(
                                text: 'Complete Service',
                                onPressed: () {
                                  setState(() {
                                    isBtn = 3;
                                  });
                                }),
                          if (isBtn == 3)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  left: 9, right: 9, top: 7, bottom: 7),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.themeColor.withOpacity(0.1),
                                ),
                                color: AppColors.themeColor.withOpacity(0.2),
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  ConstImage().buildSvgImage('rat.svg', 100),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Rate the service and let us know how we did!',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => RatingScreen());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Give Review and Rating',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.themeColor,
                                            decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                          const SizedBox(
                            height: 7,
                          ),
                          bookingDetails['workingStatus'] == "NOT_STARTED" ?
                          ButtonWidget(
                            text: 'Start Service',
                            isLoading: isLoadingBookingStartEnd,
                            onPressed: isLoading ? null : () {
                              bookingStartEnd("START");
                              },
                          ):Container(),
                          bookingDetails['workingStatus'] == "STARTED" ?
                          ButtonWidget(
                            backgroundColor: Colors.transparent,
                            borderColor: AppColors.grayColor66,
                            text: 'Complete Service',
                            textColor: AppColors.blackColor,
                            isLoading: isLoadingBookingStartEnd,
                            onPressed: isLoading ? null : () {
                              bookingStartEnd("COMPLETE");
                            },
                          ):Container(),
                          const SizedBox(
                            height: 7,
                          ),
                        ],
                      ),
                  )
                  : Container(),
      )),
    );
  }

  getBookingDetails() {
    var url = BaseUrl.getBookingDetails;
    HttpService.getDataWithHeader("$url/${widget.bookingId}",token).then((response) {
      setState(() {
        print('getBookingDetails: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          bookingDetails = responseJson['data'];
          workerAssign = responseJson['data']['assignedWorkers'];
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

  getBookingStatus() {
    var url = BaseUrl.getBookingStatus;
    HttpService.getDataWithHeader("${url}/${widget.bookingId}",token).then((response) {
      setState(() {
        print('bookingStatus: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          bookingStatus = responseJson['data'];
          print('bookingStatus: ${bookingStatus}');

        } else {
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

  Future<void> cancelBooking(String bookingId) async {
    var url = BaseUrl.cancelBooking; // your base endpoint
    try {
      final response = await HttpService.postWithHeader(
        "$url/$bookingId",
        {},   // If no body is required, send empty JSON
        token,
      );

      print('Cancel Booking API Response: ${response.body}');
      Map<String, dynamic> responseJson = json.decode(response.body);

      if (responseJson['status'] == true) {
        setState(() {
          Fluttertoast.showToast(
            msg: responseJson['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppColors.themeColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          getBookingDetails();
        });
      } else {
        Fluttertoast.showToast(
          msg: responseJson['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.themeColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error cancelling booking: $e");
    }
  }


  Future<void> bookingStartEnd(String action) async {
    setState(() {
      isLoadingBookingStartEnd = true;
    });
    var url = BaseUrl.bookingStartEnd; // your base endpoint
    try {
      final response = await HttpService.postWithHeader(
        "$url${widget.bookingId}",
        {
          "action": action // START // "COMPLETE"
        },   // If no body is required, send empty JSON
        token,
      );

      print('bookingStartEnd API Response: ${response.body}');
      Map<String, dynamic> responseJson = json.decode(response.body);

      if (responseJson['status'] == true) {
        setState(() {
          isLoadingBookingStartEnd = false;
          getBookingDetails();
          getBookingStatus();
        });
      } else {
        setState(() {
          isLoadingBookingStartEnd = false;
        });
        Fluttertoast.showToast(
          msg: responseJson['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.themeColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error bookingStartEnd: $e");
    }
  }
}

