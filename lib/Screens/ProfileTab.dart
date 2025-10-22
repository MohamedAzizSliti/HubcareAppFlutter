import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/HelpSupport.dart';
import 'package:hubcare/Screens/LoginScreen.dart';
import 'package:hubcare/Screens/ProfileScreen.dart';
import 'package:hubcare/Screens/privacy_policy_screen.dart';
import 'package:hubcare/Widgets/button_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {

  String phone = '';
  String profile = '';
  String name = '';
  String email = '';
  String userId = '';

  File _pickedImage = File("");
  PickedFile? imageFile;
  var token = "";
  bool isLoading = false;

  @override
  void initState() {
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        isLoading = true;
        getProfile();
      });
    });
    super.initState();
  }

  getProfile() async {
    var url = BaseUrl.getProfile;
    print('Token $token');

    try {
      final response = await HttpService.getDataWithHeader(url, token);
      print(response.body.toString());

      Map<String, dynamic> responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          phone = responseJson['user']['phone'] ?? "";
          name = responseJson['user']['name'] ?? "";
          email = responseJson['user']['email'] ?? "";
          profile = responseJson['user']['profile_image'] ?? "";
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
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "Failed to load profile",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error fetching profile: $e");
      Fluttertoast.showToast(
        msg: "Failed to load profile",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
        print('isLoading: $isLoading');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.grayLightColor.withOpacity(.9),
                          ),
                          color: AppColors.whiteColor,
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        child: Row(
                         // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                width: 90,
                                height: 90,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(55),
                                  // Adjust the radius as needed
                                  child: profile.isNotEmpty
                                          ? Image.network(
                                              "${BaseUrl.imageUrl}${profile}",
                                              fit: BoxFit.cover,
                                              width: 90,
                                              height: 90,
                                            )
                                          : Image.asset(
                                              'assets/image.png',
                                              height: 90,
                                              width: 90,
                                            ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      name,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor),
                                    ),
                                    SizedBox(width: 7),
                                    InkWell(
                                      onTap: (){
                                        Get.to(()=> ProfileScreen(),arguments: ["2"]);
                                      },
                                        child: SvgPicture.asset('assets/edit.svg')),
                                  ],
                                ),
                                Text(
                                 phone,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blackColor),
                                ),
                                Text(
                                  email,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blackColor),
                                ),
                               /* Row(
                                  children: [
                                    Text(
                                      'Your Reward Points',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackColor),
                                    ),
                                    SizedBox(width: 7),
                                    Text(
                                      '500 points',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.yellowColor),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1),
                                SizedBox(
                                  height: 37,
                                  width: MediaQuery.of(context).size.width-142,
                                    child: ButtonWidget(text: 'Redeem Now', onPressed: (){}))*/
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          Get.to(()=> ProfileScreen(),arguments: ["2"]);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grayLightColor.withOpacity(.9),
                            ),
                            color: AppColors.whiteColor,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/editImg.svg'),
                              SizedBox(width: 7),
                              Text(
                                'Edit Profile',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor),
                              ),
                              Expanded(child: SizedBox()),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.fontLiteColors,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Visibility(
                        visible: false,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grayLightColor.withOpacity(.9),
                            ),
                            color: AppColors.whiteColor,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/location.svg'),
                              SizedBox(width: 7),
                              Text(
                                'Manage address',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor),
                              ),
                              Expanded(child: SizedBox()),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.fontLiteColors,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                    //  SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          Get.to(()=> HelpSupport());
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grayLightColor.withOpacity(.9),
                            ),
                            color: AppColors.whiteColor,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/help_support.svg'),
                              SizedBox(width: 7),
                              Text(
                                'Help & Support',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor),
                              ),
                              Expanded(child: SizedBox()),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.fontLiteColors,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: (){
                          Get.to(()=> PrivacyPolicyScreen());
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grayLightColor.withOpacity(.9),
                            ),
                            color: AppColors.whiteColor,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/privacy_policy.svg'),
                              SizedBox(width: 7),
                              Text(
                                'Privacy policy',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor),
                              ),
                              Expanded(child: SizedBox()),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.fontLiteColors,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: (){
                          logoutUser(context);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12, 17, 12, 17),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grayLightColor.withOpacity(.9),
                            ),
                            color: AppColors.whiteColor,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/logout.svg'),
                              SizedBox(width: 7),
                              Text(
                                'Logout',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor),
                              ),
                              Expanded(child: SizedBox()),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.fontLiteColors,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                    ]))));
  }

    Future<void> logoutUser(BuildContext context) async {
    await SharedPreference.putString(AppConstants.loginToken, "");
    await SharedPreference.putBool(AppConstants.isLogin, false);
    await SharedPreference.putString("userType", "");
    await SharedPreference.putString(AppConstants.userId, "");

    Fluttertoast.showToast(
      msg: "Logged out",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );

    Get.offAll(() => const LoginScreen());
  }


}
