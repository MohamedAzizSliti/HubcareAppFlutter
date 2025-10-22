
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/SearchServices.dart';
import 'package:hubcare/Screens/sub_categroy_to_category.dart';

import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';

class SubCategory extends StatefulWidget {
 final String categoryId;
 final String categoryName;
  const SubCategory({super.key,required this.categoryId,required this.categoryName});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  var subCategoryList = [];

  @override
  void initState() {
    getSubCategoryLists();
    super.initState();
  }

  getSubCategoryLists() {
    var url = BaseUrl.getSubCategories;
    HttpService.getData("${url}/${widget.categoryId}").then((response) {
      setState(() {
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          subCategoryList = responseJson['data']['subCategories'] as List;
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
      appBar: AppBar(
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
              widget.categoryName  ??"",
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
      body: SafeArea(child: Padding(padding: EdgeInsets.only(left: 17,right: 17),
      child: buildService(),)),
    );
  }


  Widget buildService() =>
      ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: subCategoryList.length,
          itemBuilder: (BuildContext context, int index) {
            final category = subCategoryList[index];
            final imageUrl = "${BaseUrl.imageUrl}${category['subCategoryImage'] ?? ""}";
            return Container(
              margin: const EdgeInsets.only(top: 4,left: 2,right: 2),
              child: InkWell(
                onTap: () {
                  Get.to(() => SubCategoryToCategory(categoryId:category['id'],categoryName: category['subCategoryName'],));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12,right: 12),
                  child: Column(children: [
                    const SizedBox(height: 15,),
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          // Image radius
                          child: CachedNetworkImage(
                            width: 40,
                            height: 40,
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                                'assets/place_holder.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover),
                            errorWidget: (context, url, error) => Container(
                              width: 40,
                              height: 40,
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
                                category['subCategoryName'],
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.fontColors),
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
}
