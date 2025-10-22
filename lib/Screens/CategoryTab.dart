
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/SubCategory.dart';

import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import 'company_list.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  bool isLoading = true;
  var categoryList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryLists();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(height: 16),
          Text('Categories',
            style: TextStyle(
                fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),),
          SizedBox(height: 16),
            isLoading
                ? Expanded(
                child: const Center(child: CircularProgressIndicator())) :
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: categoryList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (orientation == Orientation.portrait) ? 3 : 3,
                  childAspectRatio: 0.8),
              itemBuilder: (BuildContext context, int index) {
                final category = categoryList[index];
                final imageUrl = "${BaseUrl.imageUrl}${category['categoryImage'] ?? ""}";
                return  InkWell(
                  onTap: () {
                    Get.to(() => CompanyList(categoryId: category['id'],categoryName:  category['categoryName'],));

                    //Get.to(()=> SubCategory(categoryId: category['id'],categoryName:  category['categoryName'],));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    color: null,
                    child:  Column(
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
                      //just for testing, will fill with image later
                    ),
                  ),
                );
              },
            ),
          ),
        ],),
      )),
    );
  }

  getCategoryLists() {
    var url = BaseUrl.getCategories;
    setState(() => isLoading = true);
    HttpService.getData(url).then((response) {
      setState(() {
        // ignore: avoid_print
        print('home CategoryLists: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          isLoading = false;
          categoryList = responseJson['data'] as List;
          print('home CategoryList: ${categoryList.length}');

          // Iterable list = responseJson['data'];
          // expertise1 = list.map((model) => Expertise.fromJson(model)).toList();
        } else {
          isLoading = false;
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
