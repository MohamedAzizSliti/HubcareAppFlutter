
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/ChooseLocation.dart';
import 'package:hubcare/Screens/HomeScreen.dart';
import 'package:hubcare/Screens/ProfileScreen.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConnectivityUtil.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import '../Widgets/button_widget.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  bool isLoading = false;
  var otp ="";
  var otpShow ="";
  var phone ="";
  var uniqueDeviceId ="";
  var token ="";
  var argumentData = Get.arguments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     phone = argumentData[0];
    // token = argumentData[1];
     otpShow = argumentData[1];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Image.asset('assets/splashLogo.png',height: 100,width: 120,),

                Padding(
                  padding: const EdgeInsets.only(left: 17,right: 17),
                  child: Column(children: [
                    const SizedBox(height: 20,),
                    Text(
                      'Verification code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      'Please enter the 4-digit code sent on',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontLiteColors),
                    ),
                    Text(
                      phone??"",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackColor),
                    ),
                    Text(
                      'Otp: $otpShow',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontLiteColors),
                    ),
                    const SizedBox(height: 50,),
                    SizedBox(
                      height: 56,
                      child: OtpTextField(
                        numberOfFields: 4,
                        borderColor: AppColors.themeColor,
                        focusedBorderColor: AppColors.themeColor,
                        cursorColor: AppColors.themeColor,
                        //set to true to show as box or false to show as dash
                        showFieldAsBox: true,
                        fieldWidth: 50,
                        borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                        //runs when a code is typed in
                        onCodeChanged: (String code) {
                          //handle validation or checks here
                          setState(() {
                            otp = code;
                          });

                        },
                        onSubmit: (String verificationCode){
                          otp = verificationCode;
                         /* showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: const Text("Verification Code"),
                                  content: Text('Code entered is $verificationCode'),
                                );
                              }
                          );*/
                        }, // end onSubmit
                      ),
                    ),
                    const SizedBox(height: 30,),
                    ButtonWidget(text: 'Verify', onPressed: (){
                     // Get.to(()=> ChooseLocation(),arguments: ["1"]);
                      if(otp.length == 4) {
                        _checkConnectivity();
                      }else{
                        Fluttertoast.showToast(
                            msg: 'Please enter valid otp',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: AppColors.themeColor,
                            textColor: Colors.white,
                            fontSize: 15.0);
                      }

                    }),
                    const SizedBox(height: 10,),
                    Text(
                      "Haven't received the code yet?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontLiteColors,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        sendOtpResponse();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Resend',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                              decoration: TextDecoration.underline,
                          decorationColor: AppColors.blackColor),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          )),
        ),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              color: AppColors.themeColor,
            ),
          )
      ],
    );
  }

  /// ----------------------- Send Otp Api Response ------------------------ ///

  sendOtpResponse() async {
    try {
      var jsonObject = {
        "phoneNumber": phone,
      };
      var jsonParam = json.encode(jsonObject);
      // print(BaseUrl.sendOtp);
      print("Map = $jsonObject");
      HttpService.postJson(BaseUrl.sendOtp, jsonParam).then((response) {
        setState(() {
          Map<String, dynamic> responseJson = json.decode(response.body);
          setState(() {
            isLoading = false;
          });
          if (responseJson['status']) {
            print(responseJson);

           // token = responseJson['data']['token'];
            String otp = responseJson['otp'];
            debugPrint(responseJson.toString());
            otpShow = otp;

          } else {
            Fluttertoast.showToast(
                msg: responseJson['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.themeColor,
                textColor: Colors.white,
                fontSize: 15.0);
          }
        });
      });
    } on Exception catch (_, e) {
      debugPrint('$e');
    }
  }

  otpVerifyResponse() async {
    try {
      var jsonObject = {
        'phoneNumber': phone,
        'otp': otp,
      };
      var jsonParam = json.encode(jsonObject);
      HttpService.postJson(BaseUrl.verifyOtp, jsonParam).then((response) {
        setState(() {
          Map<String, dynamic> responseJson = json.decode(response.body);
          setState(() {
            isLoading = false;
          });
          if (responseJson['status']) {
            print(responseJson);

            var isProfileUpdate = responseJson['isProfile'];
            debugPrint(responseJson.toString());
             token = responseJson['token'];
            // SharedPreference.putString(AppConstants.userId, responseJson['data']['id'].toString());
             SharedPreference.putString(AppConstants.loginToken, token);
           //  SharedPreference.putBool(AppConstants.isLogin, true);
           // Get.to(()=> ChooseLocation(),arguments: ["1"]);

            if(isProfileUpdate == 0) {
              Get.offAll(() => const ProfileScreen(),arguments: ['1']);
            }else {
              SharedPreference.putBool(AppConstants.isLogin, true);
              Get.offAll(() => const HomeScreen(),arguments: ['1']);
            }

          } else {
            Fluttertoast.showToast(
                msg: responseJson['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.themeColor,
                textColor: Colors.white,
                fontSize: 15.0);
          }
        });
      });
    } on Exception catch (_, e) {
      debugPrint('$e');
    }
  }

  /// ------------ Check Internet Connection -------------- ///

  Future<void> _checkConnectivity() async {
    bool isConnected = await ConnectivityUtil.checkConnectivity(context);
    setState(() {
      if (isConnected) {
        setState(() {
          isLoading = true;
        });
        otpVerifyResponse();

      }
    });
  }


}
