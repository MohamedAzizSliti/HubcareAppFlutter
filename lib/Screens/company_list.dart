import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import 'ServiceDetails.dart';
import 'ServiceProvideInfo.dart';

class CompanyList extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CompanyList({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  List companyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCompanyList();
  }

  getCompanyList() async {
    var url = BaseUrl.allProviderList;
    try {
      var response = await HttpService.getData("$url${widget.categoryId}");
      Map<String, dynamic> responseJson = json.decode(response.body);

      setState(() {
        isLoading = false;
        if (responseJson['status']) {
          companyList = responseJson['data'] as List;
        } else {
          Fluttertoast.showToast(
            msg: responseJson['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.themeColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      });
    } catch (e) {
      setState(() => isLoading = false);
      Fluttertoast.showToast(
        msg: "Something went wrong!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset('assets/backArrow.svg', height: 28),
            ),
            const SizedBox(width: 5),
            Text(
              widget.categoryName,
              style:  TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: buildService(),
        ),
      ),
    );
  }

  Widget buildService() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (companyList.isEmpty) {
      return const Center(
        child: Text(
          "No companies found.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: companyList.length,
      itemBuilder: (BuildContext context, int index) {
        final category = companyList[index];
        final imageUrl =
            "${BaseUrl.imageUrl}${category['profile_image'] ?? ""}";

        return Container(
          margin: const EdgeInsets.only(top: 4, left: 2, right: 2),
          child: InkWell(
            onTap: () {
              Get.to(()=> ServiceProvideInfo(providerId: category['id'] ,));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: CachedNetworkImage(
                          width: 60,
                          height: 60,
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/place_holder.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category['companyname'] ?? '',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.fontColors,
                              ),
                            ),
                            Text(
                              category['name'] ?? '',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.fontGrayColors,
                              ),
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
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.themeColor,
                                  size: 18,
                                ),
                                SizedBox(width: 2),
                                Flexible(
                                  child: Text(
                                    category['companyaddress'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.fontColors,
                                    ),
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
                    color: AppColors.inputColor.withOpacity(0.8),
                    height: 5,
                    width: MediaQuery.of(context).size.width - 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
