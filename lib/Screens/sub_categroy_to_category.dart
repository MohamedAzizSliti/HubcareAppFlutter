
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/ServiceDetails.dart';

import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/InputField.dart';

class SubCategoryToCategory extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const SubCategoryToCategory({super.key,required this.categoryId,required this.categoryName});

  @override
  State<SubCategoryToCategory> createState() => _SubCategoryToCategoryState();
}

class _SubCategoryToCategoryState extends State<SubCategoryToCategory> {
  List<dynamic> subCategoryList = [];

  @override
  void initState() {
    getSubCategoryLists();
    super.initState();
  }

  getSubCategoryLists() {
    var url = BaseUrl.getSubCategoriesToCategory;
    HttpService.getData("${url}/${widget.categoryId}").then((response) {
      setState(() {
        // ignore: avoid_print
        print('home CategoryLists: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          subCategoryList = responseJson['data'] as List;
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
    return  Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Optional: Remove shadow
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset('assets/backArrow.svg',height: 28,)),
            const SizedBox(
              width: 5,
            ),
            Text(
             widget.categoryName ??"",
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
        padding: const EdgeInsets.only(left: 17, right: 17),
        child: Column(
          children: [
            SizedBox(height: 7,),
            buildService()
          ],
        ),
      )),
    );
  }

  Widget buildService() =>
      Expanded(
        child: subCategoryList.isNotEmpty ?
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: subCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              final category = subCategoryList[index];
              final imageUrl = "${BaseUrl.imageUrl}${category['serviceImages'][0] ?? ""}";
              return Container(
                margin: const EdgeInsets.only(top: 4,left: 2,right: 2),
                child: InkWell(
                  onTap: () {
                    Get.to(()=> ServiceDetails(
                      categoryId:category["id"] ?? "" ,
                      subCategoryId: category['subCategoryId'],
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
                            child: CachedNetworkImage(
                              width: 80,
                              height: 45,
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                  'assets/place_holder.png',
                                  width: 80,
                                  height: 45,
                                  fit: BoxFit.cover),
                              errorWidget: (context, url, error) => Container(
                                width: 80,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.error, color: Colors.red),
                              ),
                            )

                          ),
                          const SizedBox(width: 7,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category['serviceName'] ?? "",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.fontColors),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppColors.themeColor,
                                      size: 18,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      category['averageRating'] ?? '4.6',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13.0, fontWeight: FontWeight.w500, color: AppColors.fontLiteColors),
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
                                          category['serviceDescription'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.fontGrayColors),
                                      ),
                                    ),
                                  ],
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
            }): Center(child: const Text("No service found.")),
      );
}
