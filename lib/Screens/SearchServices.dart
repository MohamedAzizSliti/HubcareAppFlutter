//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/route_manager.dart';
// import 'package:hubcare/Screens/ServiceDetails.dart';
//
// import '../Constants/ColorCodes.dart';
// import '../Constants/InputField.dart';
//
// class SearchServices extends StatefulWidget {
//   const SearchServices({super.key});
//
//   @override
//   State<SearchServices> createState() => _SearchServicesState();
// }
//
// class _SearchServicesState extends State<SearchServices> {
//
//   TextStyle smallText = TextStyle(
//       fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.blackColor);
//   TextStyle editText = TextStyle(
//       fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor);
//
//   TextEditingController searchController = TextEditingController();
//
//   var argumentData = Get.arguments;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar:  AppBar(
//         backgroundColor: Colors.transparent, // Make AppBar transparent
//         elevation: 0, // Optional: Remove shadow
//         title: Row(
//           children: [
//             InkWell(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: SvgPicture.asset('assets/backArrow.svg',height: 28,)),
//             const SizedBox(
//               width: 5,
//             ),
//             Text(
//               argumentData[0] == "1"? 'Search for services':'Sofa Cleaning',
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.blackColor),
//             ),
//           ],
//         ),
//
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(child: Padding(
//         padding: const EdgeInsets.only(left: 17, right: 17),
//         child: Column(
//           children: [
//             SizedBox(height: 7,),
//             if(argumentData[0] == "1")
//             TextFormField(
//               controller: searchController,
//               style: smallText,
//               decoration: InputField().inputDecoration(
//                   'Search',
//                   AppColors.whiteColor,
//                   AppColors.blackColor.withOpacity(.5)),
//
//             ),
//             SizedBox(height: 7,),
//             buildService()
//           ],
//         ),
//       )),
//     );
//   }
//
//   Widget buildService() =>
//       Expanded(
//         child: ListView.builder(
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             itemCount: 7,//notification.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Container(
//                 margin: const EdgeInsets.only(top: 4,left: 2,right: 2),
//                 child: InkWell(
//                   onTap: () {
//                     //Get.to(()=> ServiceDetails());
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 12,right: 12),
//                     child: Column(children: [
//                       const SizedBox(height: 15,),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                       ClipRRect(
//                       borderRadius: BorderRadius.circular(7),
//                               // Image radius
//                               child: //notification[index]['sender']['profile_image'].isEmpty
//                                Image.asset(
//                                 'assets/catImg.png',
//                                 fit: BoxFit.cover,
//                                 height: 45,
//                               ),
//
//                           ),
//                           const SizedBox(width: 7,),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Sofa Cleaning',
//                                   style: TextStyle(
//                                       fontSize: 14.0,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.fontColors),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.star,
//                                       color: AppColors.themeColor,
//                                       size: 18,
//                                     ),
//                                     SizedBox(width: 2),
//                                     Text(
//                                       '4.6',
//                                       textAlign: TextAlign.start,
//                                       style: TextStyle(
//                                           fontSize: 13.0, fontWeight: FontWeight.w500, color: AppColors.fontLiteColors),
//                                     ),
//                                     SizedBox(width: 5),
//                                     Icon(
//                                       Icons.circle,
//                                       color: AppColors.themeColor,
//                                       size: 7,
//                                     ),
//                                     SizedBox(width: 5),
//                                     Text(
//                                       //notification[index]['body'],
//                                       'SparkHive Cleaning Services',
//                                       style: TextStyle(
//                                           fontSize: 13.0,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.fontGrayColors),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 15,),
//                       Container(
//                         color: AppColors.inputColor.withOpacity(
//                           .8,
//                         ),
//                         height: 5,
//                         width: MediaQuery.of(context).size.width - 10,
//                       ),
//
//                     ],),
//                   ),
//                 ),
//               );
//             }),
//       );
// }

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/InputField.dart';
import '../Widgets/button_widget.dart';
import 'ServiceDetails.dart';

class SearchServices extends StatefulWidget {
  const SearchServices({super.key});

  @override
  State<SearchServices> createState() => _SearchServicesState();
}

class _SearchServicesState extends State<SearchServices> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> services = [];
  bool isLoading = true;
  Map<String, dynamic> provider = {};
  var argumentData = Get.arguments;
  bool isVisible = false;

  SfRangeValues _values = SfRangeValues(100.0, 400.0);
  String _selectedValue = "Low to high";
  var listOfValue = ['Low to high', 'High to low'];

  @override
  void initState() {
    super.initState();
    fetchServices(); // fetch initially
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchServices({
    String sort = 'desc',
    double minPrice = 100,
    double maxPrice = 500,
    String search = '',
  }) async {
    setState(() => isLoading = true);


    var urlB = BaseUrl.getSearchFilter;
    String url = "$urlB?sort=$sort&minPrice=$minPrice&maxPrice=$maxPrice&search=$search";
    HttpService.getData(url).then((response) {
      setState(() {
        // ignore: avoid_print
        print('search CategoryLists: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          setState(() => isLoading = false);
          var data = responseJson['data'];
          services = data ?? [];
          setState(() => isLoading = false);
        } else {
          setState(() => isLoading = false);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: SvgPicture.asset('assets/backArrow.svg', height: 28),
            ),
            const SizedBox(width: 5),
            Text(
              argumentData[0] == "1" ? 'Search for services' : 'Sofa Cleaning',
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Column(
                children: [
                  if (argumentData[0] == "1") ...[
                    SizedBox(height: 7),
                    TextFormField(
                     // controller: searchController,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.blackColor),
                      decoration: InputField().inputDecoration(
                        'Search',
                        AppColors.whiteColor,
                        AppColors.blackColor.withOpacity(.5),
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.filter_alt_outlined, color: AppColors.blackColor),
                          onPressed: () {
                            setState(() {
                              isVisible = true;
                            });
                          },
                        ),
                      ),
                      onChanged: (search){
                          searchController.text = search;
                            fetchServices(search: searchController.text);
                      },
                    ),

                  ],
                  SizedBox(height: 7),
                  isLoading
                      ? Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: CircularProgressIndicator(),
                      )
                      : services.isEmpty
                      ? Text("No services found")
                      : buildServiceList(),
                ],
              ),
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
                              ButtonWidget(text: 'Apply', onPressed: () {
                                fetchServices(
                                  sort: _selectedValue == "Low to high" ? "dec" :"asc",
                                  minPrice: _values.start,
                                  maxPrice: _values.end,
                                  search: searchController.text,
                                );

                                setState(() {
                                  isVisible = false; // Hide the filter popup after applying
                                });

                              })
                            ]))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildServiceList() => Expanded(
    child: ListView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        var service = services[index];
        String imageUrl = service["serviceImages"] != null && service["serviceImages"].isNotEmpty
            ? "${BaseUrl.imageUrl}${service["serviceImages"][0]}"
            : "";

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () {
              Get.to(() => ServiceDetails(
                categoryId: service['id'],
              subCategoryId: service['subCategoryId'],
              ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                          height: 45,
                          width: 45,
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                              'assets/place_holder.png',
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover),
                          errorWidget: (context, url, error) => Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.error, color: Colors.red),
                          ),
                        ) : Image.asset(
                          'assets/catImg.png',
                          height: 45,
                          width: 45,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service["serviceName"] ?? 'No Service Name',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.fontColors,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: AppColors.themeColor, size: 18),
                                const SizedBox(width: 2),
                                Text(
                                  service["rating"]?.toString() ?? "0.0",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.fontLiteColors,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(Icons.circle, color: AppColors.themeColor, size: 7),
                                const SizedBox(width: 5),
                                Text(
                                  provider["discription"] ?? "Unknown Provider",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.fontGrayColors,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    color: AppColors.inputColor.withOpacity(.8),
                    height: 5,
                    width: MediaQuery.of(context).size.width - 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
