
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/ServiceProvideInfo.dart';
import 'package:hubcare/Screens/Summary.dart';
import 'package:hubcare/Widgets/button_widget.dart';
import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import 'all_service_provider.dart';


class ServiceDetails extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;
  const ServiceDetails({super.key,required this.categoryId,required this.subCategoryId});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  dynamic categoryDetails ;
  List<dynamic>  providerList = [] ;
  List<dynamic> imageList = [] ;
  var getRecommendedList = [];
  bool isLoading = true;
  var token = "";

  @override
  void initState() {
    getSubCategoryDetails();
    getProviderList();
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        getRecommendedLists();
      });
    });
    super.initState();
  }

  getSubCategoryDetails() {
    var url = BaseUrl.getSubCategoriesToCategoryDetail;
    HttpService.getData("${url}/${widget.categoryId}").then((response) {
      setState(() {
        // ignore: avoid_print
        print('home CategoryLists: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          categoryDetails = responseJson['data'];
          imageList = categoryDetails['serviceImages'] ?? [];
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

  getProviderList() {
    var url = BaseUrl.getProviders;
    HttpService.getData("$url${widget.subCategoryId}").then((response) {
      setState(() {
        // ignore: avoid_print
        print('home getProviders: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          providerList = responseJson['data'];
         // imageList = categoryDetails['serviceImages'] ?? [];
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

  getRecommendedLists() {
    var url = BaseUrl.getServicesRecommended;
    HttpService.getDataWithHeader(url,token).then((response) {
      setState(() {
        // ignore: avoid_print
        print('home getRecommendedLists: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status'] == true) {
          getRecommendedList = responseJson['data'] as List;
          print('home getRecommendedList: ${getRecommendedList.length}');

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
      body: Stack(
        children: [
          isLoading
              ? Center(
            child: CircularProgressIndicator(
              color: AppColors.themeColor,
            ),
          )
              :
          categoryDetails!=null ?
          SingleChildScrollView(
            child: Column(
              children: [
             // Image.asset('assets/serviceImg.png',height: 250,width: double.infinity,fit: BoxFit.cover,),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    clipBehavior: Clip.antiAlias,
                    autoPlay: false,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      // You can add a setState here if you want to track the current index
                    },
                  ),
                  items: imageList.isNotEmpty
                      ? imageList.map<Widget>((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        imageUrl:  "${BaseUrl.imageUrl}$img",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                            'assets/place_holder.png',
                            fit: BoxFit.cover),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                      )
                    );
                  }).toList() : [
                    Image.asset(
                      'assets/images/ind_img.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 17, right: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          categoryDetails['serviceName'] ?? "",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                        ),
                        Expanded(child: SizedBox(width: 5)),
                        Text(
                          'QR ${ categoryDetails['servicePrice']}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.themeColor,
                          size: 18,
                        ),
                        SizedBox(width: 2),
                        Text(
                          categoryDetails['averageRating'].toString() ,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.w500, color: AppColors.fontLiteColors),
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.circle,
                            color: AppColors.themeColor,
                            size: 7,
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            categoryDetails['serviceDescription'],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.w500, color: AppColors.fontLiteColors),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          // Image radius
                          child:
                            CachedNetworkImage(
                          height: 65,
                          width: 65,
                          imageUrl: "${BaseUrl.imageUrl}${categoryDetails['provider']['profile_image'] ?? ""}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>  Center(
                            child: Icon(Icons.account_circle, color: Colors.grey, size: 65),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.error, color: Colors.red),
                          ),
                        )
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Get.to(()=> ServiceProvideInfo(providerId: categoryDetails['providerId'] ,));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Service Provider'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.themeColor),
                                    ),

                                    Expanded(child: SizedBox()),
                                    Container(
                                      padding: EdgeInsets.only(left: 7,right: 7,top: 3,bottom: 3),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.fontLiteColors.withOpacity(0.1),
                                        ),
                                        color: AppColors.whiteColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'View',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 13.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: AppColors.blackColor,
                                            size: 13,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                categoryDetails['provider']['name'] ?? "",
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
                                      categoryDetails['averageRating'].toString()  ?? "0.0",
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AppColors.themeColor,
                                      size: 18,
                                    ),
                                    SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                    categoryDetails['provider']['companyaddress'] ?? "",
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
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: AppColors.inputColor.withOpacity(.8,),
                      height: 12,
                      width: MediaQuery.of(context).size.width - 10,
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    Text(
                      'Recommended service',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fontColors),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: getRecommendedList.length,
                        itemBuilder: (context, i) {
                          final recommended = getRecommendedList[i];
                          final imageUrl = "${BaseUrl.imageUrl}${recommended['serviceImages'][0] ?? ""}";
                          return  Container(
                            margin: EdgeInsets.only(right: 15),
                            width: 160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(17), // Adjust the radius as needed
                                  child: CachedNetworkImage(
                                    width: 160,
                                    height: 120,
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                        'assets/place_holder.png',
                                        width: 160,
                                        height: 120,
                                        fit: BoxFit.cover),
                                    errorWidget: (context, url, error) => Container(
                                      width: 160,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.error, color: Colors.red),
                                    ),
                                  )
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppColors.themeColor,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      recommended['averageRating'] ?? '0.0',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.fontLiteColors),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.circle,
                                      color: AppColors.fontLiteColors,
                                      size: 7,
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        recommended['serviceDescription'],
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.fontLiteColors),
                                      ),
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: Text(
                                    '${recommended['serviceName']}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 13.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'QR ${recommended['servicePrice']}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                                    ),

                                    SizedBox(width: 5),
                                    Text(
                                      '/hr',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12.0, fontWeight: FontWeight.w500, color: AppColors.fontLiteColors),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    providerList.isNotEmpty ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Providers',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.fontColors),
                        ),
                        InkWell(
                          onTap: (){
                            Get.to(() => AllServiceProvider(subCategoryId: widget.subCategoryId));

                          },
                          child: Text(
                            'View all',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.themeColor),
                          ),
                        ),
                      ],
                    ):Container(),
                    const SizedBox(
                      height: 15,
                    ),
                    providerList.isNotEmpty ?
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: providerList.length.clamp(0, 5),
                        itemBuilder: (context, i) {
                          final provider = providerList[i];
                          final imageUrl = "${BaseUrl.imageUrl}${provider['profile_image'] ?? ""}";
                          return  InkWell(
                            onTap: (){
                              Get.to(()=> ServiceProvideInfo(providerId: provider['id'] ,));
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 15),
                              width: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child:
                                    CachedNetworkImage(
                                      width: 65,
                                      height: 65,
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>  Center(
                                        child: Icon(Icons.account_circle, color: Colors.grey, size: 65),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.error, color: Colors.red),
                                      ),
                                    )
                                    // Image.network(
                                    //   imageUrl,
                                    //   fit: BoxFit.cover,
                                    //   height: 65,
                                    //   width: 65,
                                    //   errorBuilder: (context, error, stackTrace) {
                                    //     return const Center(
                                    //       child: Icon(Icons.account_circle, color: Colors.grey, size: 65),
                                    //     );
                                    //   },
                                    // ),
                                  ),
                                  SizedBox(height: 5),
                                  Flexible(
                                    child: Text(
                                      '${provider['name']}',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 13.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ):Container(),
                    SizedBox(height: 15),

                    ButtonWidget(text: 'Continue', onPressed: (){
                      Get.to(()=> Summary(
                        promoCode: categoryDetails['isPromocodeApplied'],
                        serviceId: categoryDetails['id'],
                        serviceName: categoryDetails['serviceName'],
                        servicePrice: categoryDetails['servicePrice'].toString(),));
                    })
                  ],
                ),
              ),
            ],),
          ):Container(),

          Positioned(
            top: 38,
            left: 19,
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(
                  'assets/backRound.svg',
                  height: 41,
                )),
          ),
        ],
      ),
    );
  }
}
