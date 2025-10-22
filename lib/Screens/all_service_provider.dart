import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import 'ServiceProvideInfo.dart';

class AllServiceProvider extends StatefulWidget {
  final String subCategoryId;
  const AllServiceProvider({Key? key,required this.subCategoryId}) : super(key: key);

  @override
  State<AllServiceProvider> createState() => _AllServiceProviderState();
}

class _AllServiceProviderState extends State<AllServiceProvider> {
  List<dynamic>  providerList = [] ;
  bool isLoading = true;
  @override
  void initState() {
    getProviderList();
    super.initState();
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
              "Service Providers",
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
      body: Padding(
        padding: EdgeInsets.only(left: 17,right: 17),
        child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.themeColor,
                  ),
                )
              : providerList.isNotEmpty
                  ? buildService()
                  : Container()),
    );
  }
  buildService(){
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: providerList.length,
      itemBuilder: (context, i) {
        final provider = providerList[i];
        final imageUrl = "${BaseUrl.imageUrl}${provider['profile_image'] ?? ""}";
        return Container(
          margin: const EdgeInsets.only(top: 4,left: 2,right: 2),
          child: InkWell(
            onTap: () {
              Get.to(()=> ServiceProvideInfo(providerId: provider['id'] ,));
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
                            '${provider['name']}',
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
      },
    );
  }
}
