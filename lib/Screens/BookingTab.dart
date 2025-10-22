// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
// import 'package:hubcare/Screens/BookingDetails.dart';
//
// import '../Constants/ColorCodes.dart';
//
// class BookingTab extends StatefulWidget {
//   const BookingTab({super.key});
//
//   @override
//   State<BookingTab> createState() => _BookingTabState();
// }
//
// class _BookingTabState extends State<BookingTab> {
//   int isSelected = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Padding(
//         padding: EdgeInsets.only(left: 15.0, right: 15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 16),
//             Text(
//               'Booking',
//               style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.blackColor),
//             ),
//             SizedBox(height: 16),
//             Container(
//               height: 42,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: AppColors.fontLiteColors.withOpacity(0),
//                 ),
//                 color: AppColors.fontLiteColors.withOpacity(0.1),
//                 shape: BoxShape.rectangle,
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(20.0),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         isSelected = 1;
//                       });
//                     },
//                     child: DecoratedBox(
//                       decoration: isSelected == 1
//                           ? BoxDecoration(
//                               border: Border.all(
//                                 color: AppColors.blackColor.withOpacity(0.2),
//                               ),
//                               color: AppColors.blackColor.withOpacity(0.7),
//                               shape: BoxShape.rectangle,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(20.0),
//                               ),
//                             )
//                           : BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(0),
//                               ),
//                             ),
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(17, 8, 17, 8),
//                         child: Text(
//                           'Active',
//                           style: TextStyle(
//                               fontSize: 15.0,
//                               fontWeight: FontWeight.w600,
//                               color: isSelected == 1 ?AppColors.whiteColor:AppColors.blackColor),
//                         ),
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         isSelected = 2;
//                       });
//                     },
//                     child: DecoratedBox(
//                       decoration: isSelected == 2
//                           ? BoxDecoration(
//                               border: Border.all(
//                                 color: AppColors.blackColor.withOpacity(0.2),
//                               ),
//                               color: AppColors.blackColor.withOpacity(0.7),
//                               shape: BoxShape.rectangle,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(20.0),
//                               ),
//                             )
//                           : BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(0),
//                               ),
//                             ),
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
//                         child: Text(
//                           'Completed',
//                           style: TextStyle(
//                               fontSize: 15.0,
//                               fontWeight: FontWeight.w600,
//                               color: isSelected == 2
//                                   ? AppColors.whiteColor
//                                   : AppColors.blackColor),
//                         ),
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         isSelected = 3;
//                       });
//                     },
//                     child: DecoratedBox(
//                       decoration: isSelected == 3
//                           ? BoxDecoration(
//                               border: Border.all(
//                                 color: AppColors.blackColor.withOpacity(0.2),
//                               ),
//                               color: AppColors.blackColor.withOpacity(0.7),
//                               shape: BoxShape.rectangle,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(20.0),
//                               ),
//                             )
//                           : BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(0),
//                               ),
//                             ),
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
//                         child: Text(
//                           'Cancelled',
//                           style: TextStyle(
//                               fontSize: 15.0,
//                               fontWeight: FontWeight.w600,
//                               color: isSelected == 3
//                                   ? AppColors.whiteColor
//                                   : AppColors.blackColor),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: 6,
//                 itemBuilder: (context, i) {
//                   return  InkWell(
//                          onTap: () {
//                            Get.to(()=> BookingDetails());
//                          },
//                     child: Container(
//                       margin: EdgeInsets.only(bottom: 15),
//                       padding: EdgeInsets.only(left: 7,right: 7),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppColors.fontLiteColors.withOpacity(0.1),
//                         ),
//                         color: AppColors.whiteColor,
//                         shape: BoxShape.rectangle,
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(15.0),
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 7),
//                           Row(
//                             children: [
//                               Text(
//                                 '#5152dd',
//                                 textAlign: TextAlign.start,
//                                 style: TextStyle(
//                                     fontSize: 12.0, fontWeight: FontWeight.w500, color: AppColors.blueColor),
//                               ),
//                               Expanded(child: SizedBox(width: 5)),
//                               if(isSelected == 1)
//                               Icon(
//                                 Icons.circle,
//                                 color: AppColors.fontLiteColors,
//                                 size: 6,
//                               ),
//                               SizedBox(width: 5),
//                               if(isSelected == 1)
//                               Text(
//                                 'Pending',
//                                 textAlign: TextAlign.start,
//                                 style: TextStyle(
//                                     fontSize: 12.0, fontWeight: FontWeight.w500, color: AppColors.fontLiteColors),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 5),
//                           Row(
//                             children: [
//                               Text(
//                                 'Pet Grooming',
//                                 textAlign: TextAlign.start,
//                                 style: TextStyle(
//                                     fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),
//                               ),
//                               Expanded(child: SizedBox(width: 5)),
//                               Icon(
//                                 Icons.arrow_forward_ios,
//                                 color: AppColors.fontLiteColors,
//                                 size: 17,
//                               ),
//
//                             ],
//                           ),
//
//                           Text(
//                             'Mon, 23 Jan at 10:30 AM',
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                                 fontSize: 13.0, fontWeight: FontWeight.w500, color: AppColors.blackColor),
//                           ),
//                           SizedBox(height: 7),
//                           Divider(color: AppColors.grayLightColor,),
//                           SizedBox(height: 7),
//                           Row(
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Service Amount',
//                                     textAlign: TextAlign.start,
//                                     style: TextStyle(
//                                         fontSize: 13.0, fontWeight: FontWeight.w500, color: AppColors.blackColor),
//                                   ),
//                                   Text(
//                                     'QR 200',
//                                     textAlign: TextAlign.start,
//                                     style: TextStyle(
//                                         fontSize: 13.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),
//                                   ),
//                                   SizedBox(height: 7),
//                                 ],
//                               ),
//                              Expanded(child: SizedBox()),
//                               if(isSelected == 1)
//                               SizedBox(
//                                   width: 130,
//                                   height:35,
//                                   child: TextButton(
//                                       style: ButtonStyle(
//                                           padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(7)),
//                                           backgroundColor: MaterialStateProperty.all<Color>(AppColors.redLightColor),
//                                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                               RoundedRectangleBorder(
//                                                   borderRadius: BorderRadius.circular(10.0),
//                                                   side: BorderSide(color: AppColors.redLightColor)
//                                               )
//                                           )
//                                       ),
//                                       onPressed: (){},
//                                       child: Text(
//                                           "Cancel Booking",
//                                           style: TextStyle(fontSize: 14,color: AppColors.redColor)
//                                       ))),
//
//                               if(isSelected != 1)
//                               SizedBox(
//                                   width: 110,
//                                   height:35,
//                                   child: TextButton(
//                                       style: ButtonStyle(
//                                           padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(7)),
//                                           backgroundColor: MaterialStateProperty.all<Color>(AppColors.whiteColor),
//                                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                               RoundedRectangleBorder(
//                                                   borderRadius: BorderRadius.circular(10.0),
//                                                   side: BorderSide(color: AppColors.fontLiteColors)
//                                               )
//                                           )
//                                       ),
//                                       onPressed: (){},
//                                       child: Text(
//                                           "Book Again",
//                                           style: TextStyle(fontSize: 14,color: AppColors.blackColor)
//                                       )))
//
//
//                             ],
//                           ),
//                           SizedBox(height: 5),
//
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import '../Screens/BookingDetails.dart';
import 'Summary.dart';

class BookingTab extends StatefulWidget {
  const BookingTab({super.key});

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  int isSelected = 1;
  List bookings = [];
  bool isLoading = true;
  var token = "";

  @override
  void initState() {
    super.initState();
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        fetchBookings();
      });
    });
  }

  Future<void> fetchBookings() async {
    var url = BaseUrl.getBooking;
    setState(() => isLoading = true);

    final status = isSelected == 1
        ? 'active'
        : isSelected == 2
        ? 'completed'
        : 'cancelled';

    try {
      final response = await HttpService.getDataWithHeader("${url}status=$status",token);

      print('Booking API Response: ${response.body}');
      Map<String, dynamic> responseJson = json.decode(response.body);

      if (responseJson['status']) {
        setState(() {
          bookings = responseJson['data']; // <- Use 'data' array
          isLoading = false;
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
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("API error: $e");
      Fluttertoast.showToast(
        msg: "Something went wrong!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.themeColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() => isLoading = false);
    }
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
          fetchBookings();
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Booking',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor),
              ),
              const SizedBox(height: 16),
              _buildTabBar(),
              const SizedBox(height: 16),
              isLoading
                  ? Expanded(child: const Center(child: CircularProgressIndicator()))
                  : bookings.isEmpty
                  ? Expanded(child: Center(child: const Text("No bookings found.")))
                  : Expanded(
                child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, i) {
                    final item = bookings[i];
                    return _buildBookingCard(item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.fontLiteColors.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tabItem('Active', 1),
          _tabItem('Completed', 2),
          _tabItem('Cancelled', 3),
        ],
      ),
    );
  }

  Widget _tabItem(String label, int index) {
    final selected = isSelected == index;
    return InkWell(
      onTap: () {
        setState(() => isSelected = index);
        fetchBookings();
      },
      child: DecoratedBox(
        decoration: selected
            ? BoxDecoration(
          color: AppColors.blackColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        )
            : const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () => Get.to(() => BookingDetails(bookingId: item['id'],)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.fontLiteColors.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 7),
            Row(
              children: [
                Text(
                  '#87675',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blueColor),
                ),
                const Spacer(),
                if (isSelected == 1) ...[
                   item['approved'] == false ?
                   Icon(Icons.circle, size: 6, color: Colors.orange):Container(),
                  const SizedBox(width: 5),
                  item['approved'] == false ?
                  Text(
                     'Pending',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.fontLiteColors),
                  ):Image.asset('assets/booking_status.png',height: 28,),
                ]
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  item['service']['serviceName'] ?? '',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 17),
              ],
            ),
            Text(
              item['serviceDate'] ?? '',
              style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor),
            ),
            const SizedBox(height: 7),
            Divider(color: AppColors.grayLightColor),
            const SizedBox(height: 7),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Amount',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      'QR ${item['service']['servicePrice'] ?? '0'}',
                      style: const TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Spacer(),
                if (isSelected == 1 && item['approved'] == false)
                  _actionButton(
                      "Cancel Booking",
                      AppColors.redColor,
                      onPressed: () => cancelBooking(item['id'].toString()))
                else
                  isSelected == 1 ? Container() :
                  _actionButton("Book Again", AppColors.blackColor,
                      bgColor: AppColors.whiteColor,
                      borderColor: AppColors.fontLiteColors,
                    onPressed: (){
                      Get.to(()=> Summary(
                        promoCode: item['isPromocodeApplied'],
                        serviceId: item['id'],serviceName: item['service']['serviceName'],servicePrice:item['service']['servicePrice'].toString(),));

                    }
                  ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color textColor,
      {Color? bgColor, Color? borderColor, VoidCallback? onPressed,}) {
    return SizedBox(
      width: 130,
      height: 35,
      child: TextButton(
        onPressed: onPressed ?? () {},
        style: TextButton.styleFrom(
          backgroundColor: bgColor ?? AppColors.redLightColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor ?? AppColors.redLightColor),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}

