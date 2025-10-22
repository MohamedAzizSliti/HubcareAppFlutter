
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import 'ServiceDetails.dart';
import 'Summary.dart';
import 'current_location_screen.dart';

class ServiceProvideInfo extends StatefulWidget {
 final String providerId ;
  const ServiceProvideInfo({super.key,required this.providerId});

  @override
  State<ServiceProvideInfo> createState() => _ServiceProvideInfoState();
}

class _ServiceProvideInfoState extends State<ServiceProvideInfo> {
  dynamic providerDetails ;
  dynamic reviewDetails ;
  var servicesList =[];
  var reviewList =[];
  bool isLoading = true;

  @override
  void initState() {
    getProviderDetails();
    getReview();
    super.initState();
  }

  getProviderDetails() {
    var url = BaseUrl.getProviderDetail;
    HttpService.getData("${url}/${widget.providerId}").then((response) {
      setState(() {
        // ignore: avoid_print
        print('providerDetails: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          providerDetails = responseJson['data'];
          servicesList = responseJson['data']['services'];
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

  getReview() {
    var url = BaseUrl.getReview;
    HttpService.getData("${url}/${widget.providerId}").then((response) {
      setState(() {
        // ignore: avoid_print
        print('providerDetails: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          reviewDetails = responseJson['data'];
          reviewList = responseJson['data']['reviews'];
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
              'Service Provider details',
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
        child: SingleChildScrollView(
          child: isLoading
              ? Center(
            child: Padding(
              padding: const EdgeInsets.only(top:60),
              child: CircularProgressIndicator(
                color: AppColors.themeColor,
              ),
            ),
          ) :
          providerDetails!=null ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  // Image radius
                  child: //notification[index]['sender']['profile_image'].isEmpty
                  Image.network(
                    "${BaseUrl.imageUrl}${providerDetails['provider']['profile_image'] ?? ""}",
                    fit: BoxFit.cover,
                    height: 85,
                    width: 85,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey, size: 65),
                        );
                      }
                  )
                ),
              ),
              const SizedBox(
                width: 7,
              ),

              Center(
                child: Text(
                  providerDetails['provider']['name'] ?? "",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.fontColors),
                ),
              ),



              SizedBox(height: 3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.themeColor,
                    size: 18,
                  ),
                  SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      providerDetails['provider']['companyaddress'] ?? "",
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontColors),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                  padding: EdgeInsets.only(left: 7,right: 7,top: 3,bottom: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.themeColor.withOpacity(0.1),
                    ),
                    color: AppColors.themeColor.withOpacity(0.2),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.themeColor,
                        size: 18,
                      ),

                      SizedBox(width: 2),
                      Text(
                        providerDetails['provider']['averageRating'].toString(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.fontLiteColors),
                      ),
                    ],
                  ),
                ),

                  SizedBox(width: 7),
                  Text(
                    '${ providerDetails['provider']['totalReviews'].toString()} Reviews',
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor),
                  ),
              ],),

              const SizedBox(
                height: 15,
              ),
              Container(
                color: AppColors.inputColor.withOpacity(.8,),
                height: 1,
                width: MediaQuery.of(context).size.width - 10,
              ),
              const SizedBox(
                height: 15,
              ),

              Text(
                'Services offer',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.fontColors),
              ),
              const SizedBox(
                height: 10,
              ),
              servicesList.isNotEmpty ?
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: servicesList.length,//notification.length,
                  itemBuilder: (BuildContext context, int index) {
                    final services = servicesList[index];
                    final imageUrl = "${BaseUrl.imageUrl}${services['serviceImages'][0] ?? ""}";
                    return Container(
                      margin: const EdgeInsets.only(top: 4,left: 2,right: 2),
                      child: InkWell(
                        onTap: () {
                          Get.to(()=> ServiceDetails(
                            categoryId:services["id"] ?? "" ,
                            subCategoryId: services['subCategoryId'],
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12,right: 12),
                          child: Column(children: [
                            const SizedBox(height: 15,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  // Image radius
                                  child: //notification[index]['sender']['profile_image'].isEmpty
                                  Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    height: 60,
                                    width: 60,
                                  ),

                                ),
                                const SizedBox(width: 7,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        services["serviceName"]??"",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'QR ${services["servicePrice"]}',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.blackColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: 100,
                                    height: 35,
                                    child: TextButton(
                                        style: ButtonStyle(
                                            padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.all(7)),
                                            backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.whiteColor),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10.0),
                                                    side: BorderSide(
                                                        color: AppColors
                                                            .grayLightColor)))),
                                        onPressed: () {
                                          Get.to(()=> Summary(
                                            promoCode: services['isPromocodeApplied'],
                                            serviceId: services['id'],
                                            serviceName: services['serviceName'],
                                            servicePrice:services['servicePrice'].toString(),));

                                        },
                                        child: Text("Book Now", style: TextStyle(fontSize: 14, color: AppColors.themeColor)))),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              color: AppColors.inputColor.withOpacity(.8,),
                              height: 1,
                              width: MediaQuery.of(context).size.width - 10,
                            ),

                          ],),
                        ),
                      ),
                    );
                  }):Text(
                'No record found.',
                style: TextStyle(
                    fontSize: 14.0,
                    color: AppColors.blackColor),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: AppColors.inputColor.withOpacity(.8,),
                height: 1,
                width: MediaQuery.of(context).size.width - 10,
              ),
              const SizedBox(
                height: 15,
              ),


              Text(
                'Review & Rating',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.fontColors),
              ),
              const SizedBox(
                height: 15,
              ),

              reviewDetails!=null ?
              Row(
                children: [

                  Text(
                    "${reviewDetails['totalReviews'] ?? 0}",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBarIndicator(
                        rating:  double.parse(reviewDetails['averageRating'].toString()),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: AppColors.themeColor,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      Text(
                        'Overall Rating',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.fontLiteColors),
                      ),
                    ],
                  ),
                  // Expanded(child: SizedBox()),
                  // Text(
                  //   'Write a Review',
                  //   style: TextStyle(
                  //       fontSize: 15.0,
                  //       fontWeight: FontWeight.w600,
                  //       color: AppColors.blueColor,
                  //     decoration: TextDecoration.underline
                  //   ),
                  // ),
                ],
              ):Container(),

              const SizedBox(
                height: 15,
              ),
              reviewList.isNotEmpty ?
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviewList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var review = reviewList[index];
                    return Container(
                      margin: const EdgeInsets.only(top: 4,left: 2,right: 2),
                      child: InkWell(
                        onTap: () {
                          // Get.to(()=> LocationScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12,right: 12),
                          child: Column(children: [
                            const SizedBox(height: 15,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(37),
                                  // Image radius
                                  child: //notification[index]['sender']['profile_image'].isEmpty
                                  Image.asset(
                                    'assets/image.png',
                                    fit: BoxFit.cover,
                                    height: 47,
                                  ),

                                ),
                                const SizedBox(width: 7,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review['users']['name'] ?? "",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor),
                                      ),
                                      RatingBarIndicator(
                                        rating: double.parse(review['rating'].toString()) ,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: AppColors.themeColor,
                                        ),
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(height: 5,),
                            Text(
                                review['review'] ?? "",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor),
                            ),
                            const SizedBox(height: 15,),
                            Container(
                              color: AppColors.inputColor.withOpacity(.8,),
                              height: 1,
                              width: MediaQuery.of(context).size.width - 10,
                            ),
                          ],),
                        ),
                      ),
                    );
                  }):Container(),
              const SizedBox(
                height: 15,
              ),

            ],):Container(),
        ),
      )),
    );
  }
}
