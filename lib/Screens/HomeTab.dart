import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Constants/ConstImage.dart';
import 'package:hubcare/Screens/Notifications.dart';
import 'package:hubcare/Screens/SearchServices.dart';
import 'package:hubcare/Screens/ServiceDetails.dart';
import 'package:hubcare/Screens/SubCategory.dart';
import 'package:hubcare/Widgets/button_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import 'Summary.dart';
import 'company_list.dart';
import 'current_location_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  TextStyle smallText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.blackColor);
  TextStyle editText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor);

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController searController = TextEditingController();

  List<dynamic> itemsList = [];
  List<dynamic> offerList = [];

  final items = [
    Image.asset('assets/ind_img.png'),
  ];

  int currentIndex = 0;
  var listOfValue = ['Low to high', 'High to low'];
  SfRangeValues _values = SfRangeValues(100.0, 400.0);
  bool isVisible = false;
  int isOpen = 1;
  var range = 'Low to high';
  String _selectedValue = "Low to high";
  var categoryList = [];
  var servicesUsedList = [];
  var getOverBestServicesList = [];
  var token = "";
  String fullAddress = '';
  String currentCity = '';

  @override
  void initState()  {
    _getCurrentLocation();
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        print('token : $token');
        getSliderImage();
        getCategoryLists();
        getOurBestServicesLists();
        getOfferLists();
        getServiceUsedList();
        _getCurrentLocation();
      });
    });
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: "Location permission denied", backgroundColor: Colors.red);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];

    setState(() {
      fullAddress = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      currentCity = "${place.locality}";
    });

  }



  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 17, right: 17),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.themeColor,
                              size: 20,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  Get.to(() => LocationScreen());
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentCity,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.whiteColor),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        fullAddress,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.whiteColor
                                                .withOpacity(.8)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => Notifications());
                              },
                              child: Icon(
                                Icons.notifications_none,
                                color: AppColors.whiteColor,
                                size: 27,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Get.to(() => SearchServices(), arguments: ['1']);
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.whiteColor.withOpacity(0.2),
                              ),
                              color: AppColors.whiteColor.withOpacity(0.2),
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                Icon(
                                  Icons.search,
                                  color: AppColors.whiteColor,
                                  size: 23,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Search',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.whiteColor),
                                  ),
                                ),
                                Container(
                                  color: AppColors.fontLiteColors,
                                  width: 1,
                                  height: 30,
                                ),
                                //SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    // setState(() {
                                    //   isVisible = true;
                                    // });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.filter_alt_outlined,
                                      color: AppColors.whiteColor,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                // SizedBox(width: 7),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 17, right: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 170,
                          clipBehavior: Clip.antiAlias,
                          autoPlay: true,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        // items: items,
                        items: itemsList
                            .map(
                              (item) => itemsList.isEmpty
                                  ? Image.asset(
                                  'assets/images/ind_img.png',
                                      width: MediaQuery.of(context).size.width,
                                     )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: "${BaseUrl.imageUrl}${item ?? ""}",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Image.asset(
                                            'assets/place_holder.png',
                                            height: 170,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context).size.width),
                                        errorWidget: (context, url, error) => Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(Icons.error, color: Colors.red),
                                        ),
                                      )
                                    ),
                            )
                            .toList(),
                      ),
                      Center(
                        child: DotsIndicator(
                          dotsCount: itemsList.isEmpty ? items.length : itemsList.length,
                          position: currentIndex,
                          decorator: DotsDecorator(
                            shape: const Border(),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            size: Size(10, 10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 12),
                      //   decoration: const BoxDecoration(
                      //       image: DecorationImage(
                      //     image: AssetImage("assets/offers.png"),
                      //     fit: BoxFit.fill,
                      //   )),
                      //   child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.only(
                      //               left: 20, right: 20, top: 15),
                      //           child: Text(
                      //             "Exclusive Offer!",
                      //             style: TextStyle(
                      //                 fontSize: 18.0,
                      //                 fontWeight: FontWeight.w600,
                      //                 color: AppColors.blackColor),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(
                      //               left: 20, right: 20, top: 8),
                      //           child: Text(
                      //             "Apply a Promo Code",
                      //             style: TextStyle(
                      //                 fontSize: 14.0,
                      //                 fontWeight: FontWeight.w600,
                      //                 color: AppColors.whiteColor),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 4,
                      //         ),
                      //         Text(
                      //           'Unlock discounts on all services!',
                      //           style: TextStyle(
                      //               fontSize: 14.0,
                      //               fontWeight: FontWeight.w500,
                      //               color: AppColors.whiteColor),
                      //         ),
                      //         const SizedBox(
                      //           height: 5,
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(
                      //               left: 20, right: 20, top: 10),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               ConstImage()
                      //                   .buildImage('offer.png', 20, 20),
                      //               const SizedBox(
                      //                 width: 5,
                      //               ),
                      //               Text(
                      //                 'Get 20% OFF on Your Order!',
                      //                 style: TextStyle(
                      //                     fontSize: 14.0,
                      //                     fontWeight: FontWeight.w600,
                      //                     color: AppColors.blackColor),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 15,
                      //         ),
                      //       ]),
                      // ),

                      offerList.isNotEmpty ?
                      Container(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: offerList.length, // You can increase itemCount to show multiple items
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width/1.1, // ⬅ full screen width
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/offers.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                                    child: Text(
                                      "Exclusive Offer!",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                                    child: Text(
                                      "Apply a Promo Code",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Unlock discounts on all services!',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Use Code: ${offerList[index]['offerCode']}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ConstImage().buildImage('offer.png', 20, 20),
                                        const SizedBox(width: 5),
                                        Text(
                                          offerList[index]['discountType'] == "PERCENTAGE" ?
                                          'Get ${offerList[index]['discountValue'] ?? ""}% OFF on Your Order!':
                                          'Get ${offerList[index]['discountValue'] ?? ""} OFF on Your Order!',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                        ),
                      ):Container(),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            'Categories',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor),
                          ),
                          // Expanded(child: SizedBox(height: 10)),
                          // SizedBox(
                          //   height: 20,
                          //   child: Text(
                          //     'See all',
                          //     overflow: TextOverflow.ellipsis,
                          //     textAlign: TextAlign.start,
                          //     style: TextStyle(
                          //         fontSize: 13.0,
                          //         fontWeight: FontWeight.w500,
                          //         color: AppColors.themeColor),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryList.length.clamp(0, 5),
                          itemBuilder: (BuildContext context, int index) {
                            final category = categoryList[index];
                            final imageUrl = "${BaseUrl.imageUrl}${category['categoryImage'] ?? ""}";

                            return InkWell(
                              onTap: () {
                               // Get.to(() => SubCategory(categoryId: category['id'],categoryName:  category['categoryName'],));
                                Get.to(() => CompanyList(categoryId: category['id'],categoryName:  category['categoryName'],));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 7, bottom: 10),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        height: 80,
                                        width: 80,
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Image.asset(
                                            'assets/place_holder.png',
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover),
                                        errorWidget: (context, url, error) => Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(Icons.error, color: Colors.red),
                                        ),
                                      )
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      category['categoryName'] ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 25),
                      Text(
                        'Our Best Services',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      ),
                      SizedBox(height: 10),
                      getOverBestServicesList.isNotEmpty ?
                      SizedBox(
                        height: 240,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: getOverBestServicesList.length,
                          itemBuilder: (context, i) {
                            final ourService = getOverBestServicesList[i];
                            final imageUrl = "${BaseUrl.imageUrl}${ourService['serviceImages'][0] ?? ""}";
                            return InkWell(
                              onTap: () {
                                Get.to(() => ServiceDetails(
                                  categoryId: ourService['id'],
                                  subCategoryId: ourService['subCategoryId'],
                                ));
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 15),
                                width: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(17),
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
                                          size: 18,
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          ourService['averageRating'].toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.fontLiteColors),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.circle,
                                          color: AppColors.themeColor,
                                          size: 7,
                                        ),
                                        SizedBox(width: 5),
                                        Flexible(
                                          child: Text(
                                            ourService['serviceDescription'],
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
                                          ourService['serviceName'],
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor),
                                      ),
                                    ),
                                    Text(
                                      'QR ${ourService['servicePrice']}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor),
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                        width: 100,
                                        height: 40,
                                        child: TextButton(
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsets>(
                                                        EdgeInsets.all(7)),
                                                backgroundColor:
                                                    MaterialStateProperty.all<Color>(
                                                        AppColors.themeColor),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(10.0),
                                                        side: BorderSide(color: AppColors.themeColor)))),
                                            onPressed: () {
                                              Get.to(()=> Summary(
                                                promoCode: ourService['isPromocodeApplied'],
                                                serviceId: ourService['id'],serviceName: ourService['serviceName'],servicePrice:ourService['servicePrice'].toString(),));
                                            },
                                            child: Text("Book Now", style: TextStyle(fontSize: 14, color: AppColors.whiteColor))))
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ): Center(
                        child: Text(
                          'No record found.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor),
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Services You’ve Used',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      ),
                      Text(
                        'Need it again? Rebook in seconds!',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.fontLiteColors),
                      ),
                      SizedBox(height: 10),
                      servicesUsedList.isNotEmpty ?
                      SizedBox(
                        height: 240,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: servicesUsedList.length,
                          itemBuilder: (context, i) {
                            final serviceUsed = servicesUsedList[i];
                            final imageUrl = "${BaseUrl.imageUrl}${serviceUsed['service']['serviceImages'][0] ?? ""}";
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => ServiceDetails(
                                  categoryId: serviceUsed['serviceId'],
                                  subCategoryId: serviceUsed['service']['subCategoryId'],
                                ));
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 15),
                                width: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(17),
                                      // Adjust the radius as needed
                                      child:  CachedNetworkImage(
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
                                          Icons.circle,
                                          color: AppColors.themeColor,
                                          size: 7,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Last service : ${serviceUsed['serviceDate']}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.themeColor),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${serviceUsed['services']}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor),
                                    ),
                                    Text(
                                      'QR ${serviceUsed['amount'].toString()}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor),
                                    ),
                                    SizedBox(height: 5),
                                    InkWell(
                                      onTap: (){
                                        Get.to(()=> Summary(
                                          promoCode: serviceUsed['isPromocodeApplied'],
                                          serviceId: serviceUsed['id'],serviceName: serviceUsed['services'],servicePrice:serviceUsed['amount'].toString(),));

                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'Book Again',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.blueColor),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: AppColors.blueColor,
                                            size: 17,
                                          ),
                                          SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ):  Center(
                        child: Text(
                          'No record found.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
        Positioned(
          bottom: 0,
          child: Visibility(
            visible: isVisible,
            child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22)),
                ),
                color: AppColors.whiteColor,
                elevation: 3,
                child: Container(
                    // color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: 340,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.whiteColor,
                      ),
                      color: AppColors.whiteColor,
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 37,
                            width: MediaQuery.of(context).size.width - 10,
                            child: Row(
                              children: [
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.fontColors),
                                ),
                                Expanded(child: Container()),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        isVisible = false;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.fontColors,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: AppColors.inputColor.withOpacity(
                              .8,
                            ),
                            height: 1,
                            width: MediaQuery.of(context).size.width - 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Price range',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.fontColors),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          SfRangeSlider(
                            min: 100.0,
                            max: 500.0,
                            values: _values,
                            interval: 100,
                            showTicks: true,
                            showLabels: true,
                            minorTicksPerInterval: 1,
                            onChanged: (SfRangeValues values) {
                              setState(() {
                                _values = values;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Rating',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.fontColors),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  width: 0,
                                  color: AppColors.blackColor.withOpacity(.9),
                                  style: BorderStyle.none,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor.withOpacity(.9),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blackColor.withOpacity(.9),
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(.2),
                              contentPadding: const EdgeInsets.all(7),
                            ),
                            value: _selectedValue,
                            hint: Text(
                              'choose one',
                            ),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                            items: listOfValue.map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 27,
                          ),
                          ButtonWidget(text: 'Apply', onPressed: () {})
                        ]))),
          ),
        )
      ],
    );
  }

  getCategoryLists() {
    var url = BaseUrl.getCategories;
    HttpService.getData(url).then((response) {
      setState(() {
        // ignore: avoid_print
        print('home CategoryLists: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          categoryList = responseJson['data'] as List;
          print('home CategoryList: ${categoryList.length}');

          // Iterable list = responseJson['data'];
          // expertise1 = list.map((model) => Expertise.fromJson(model)).toList();
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

  getOurBestServicesLists() {
    var url = BaseUrl.getOurBestServices;
    HttpService.getData(url).then((response) {
      setState(() {
        // ignore: avoid_print
        print('home getOurBestServices: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          getOverBestServicesList = responseJson['data'] as List;
          print('home getOurBestServices: ${getOverBestServicesList.length}');

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

  getOfferLists() {
    var url = BaseUrl.getOffer;
    HttpService.getData(url).then((response) {
      setState(() {
        // ignore: avoid_print
        print('home offerList: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          offerList = responseJson['data'] as List;

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

  getSliderImage() {
    var url = BaseUrl.getSliderImage;
    HttpService.getData(url).then((response) {
      setState(() async {
        // ignore: avoid_print
        print('SliderImage: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          itemsList = responseJson['data']['images'];

          // Preload all images
          for (var item in itemsList) {
            final imageUrl = "${BaseUrl.imageUrl}${item ?? ""}";
            await precacheImage(CachedNetworkImageProvider(imageUrl), context);
          }

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



  getServiceUsedList() {
    var url = BaseUrl.getServicesUsed;
    HttpService.getDataWithHeader(url,token).then((response) {
      setState(() {
        // ignore: avoid_print
        print('home getServicesUsed: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          servicesUsedList = responseJson['data'] as List;
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
}
