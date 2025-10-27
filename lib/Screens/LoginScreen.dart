import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hubcare/Screens/HomeScreen.dart';
import 'package:hubcare/Screens/OtpScreen.dart';
import 'package:hubcare/Screens/ProfileScreen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConnectivityUtil.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import '../Widgets/button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  var uniqueDeviceId = "";
  var deviceType = "";
  var deviceToken = "1";
  String country_code = "";

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ["profile", "email"],
  );

  @override
  void initState() {
    getFirebaseToken();
    super.initState();
  }

  getFirebaseToken(){
    // NotificationPermissions.requestNotificationPermissions();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((value) {
      String token = value!;
      deviceToken = token;
      debugPrint(" FirebaseToken == $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      deviceType = "Android";
    } else {
      deviceType = "ios";
    }
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/Loginbg.png'),
                      fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Image.asset(
                    'assets/splashLogo.png',
                    height: 100,
                    width: 120,
                  ),
                  // Expanded(child: SizedBox(height: 0,)),
                  Container(
                    margin: const EdgeInsets.only(top: 55),
                    width: double.infinity,
                    // width: MediaQuery.of(context).size.width,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.whiteColor, AppColors.whiteColor],
                          // Gradient colors
                          begin: Alignment.topLeft,
                          // Starting point
                          end: Alignment.bottomRight, // Ending point
                        ),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(
                                18)), // Optional: Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17, right: 17),
                        child: Form(
                          key: formKey,
                          onChanged: () => formKey.currentState!.validate(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Login to manage you account through your phone number',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.fontLiteColors),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                IntlPhoneField(
                                  controller: phoneController,
                                  flagsButtonPadding: const EdgeInsets.all(4),
                                  dropdownIconPosition: IconPosition.trailing,
                                  decoration: InputDecoration(
                                    hintText: 'Phone number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: BorderSide(
                                        width: 0,
                                        color: AppColors.blackColor
                                            .withOpacity(.5),
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.blackColor
                                              .withOpacity(.5),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.blackColor
                                              .withOpacity(.5),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(.2),
                                    counterText: "",
                                    contentPadding: const EdgeInsets.all(7),
                                  ),
                                  initialCountryCode: 'QA',
                                  validator: (value) {
                                    if (value == null || value.number.isEmpty) {
                                      return 'Please enter a phone number';
                                    }
                                    /*if (!RegExp(r'^\d{10}$').hasMatch(value.number)) {
                                    return 'Enter a valid phone number';
                                  }*/
                                    return null;
                                  },
                                  onChanged: (phone) {
                                    setState(() {

                                      country_code= phone.countryCode.toString();
                                      print(phone.completeNumber);
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ButtonWidget(
                                    text: 'Continue',
                                    onPressed: () {
                                      // Get.to(() => const OtpScreen());
                                      if (formKey.currentState!.validate()) {
                                        if (phoneController.text.isNotEmpty) {
                                          _checkConnectivity();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Please enter mobile number',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  AppColors.themeColor,
                                              textColor: Colors.white,
                                              fontSize: 15.0);
                                        }
                                      }
                                    }),
                                const SizedBox(
                                  height: 18,
                                ),
                                /*Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  children: [
                                    TextSpan(text: 'Click to proceed. Need help?',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.fontLiteColors),),
                                    TextSpan(
                                      text: 'Visit Help & Support.',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.blackColor,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              const SizedBox(height: 17,),*/
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        height: 1,
                                        // width: MediaQuery.of(context).size.width / 2 - 76,
                                        color: AppColors.inputColor,
                                      ),
                                    ),
                                    Text(
                                      'or Continue with',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.fontLiteColors),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        height: 1,
                                        // width: MediaQuery.of(context).size.width / 2 - 76,
                                        color: AppColors.inputColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 17,
                                ),
                                InkWell(
                                  onTap: () {
                                    signInWithGoogle();
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.fontLiteColors,
                                        ),
                                        color: AppColors.whiteColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(7.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 12, 20, 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/google.svg',
                                              height: 18,
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              'Continue with Google',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.blackColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 19,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
        "phoneNumber": phoneController.text,
        "device_type": deviceType,
        "device_token": deviceToken,
      };
      var jsonParam = json.encode(jsonObject);
      print(BaseUrl.sendOtp);
      print("Map = $jsonObject");
      HttpService.postJson(BaseUrl.sendOtp, jsonParam).then((response) {
        setState(() {
          Map<String, dynamic> responseJson = json.decode(response.body);
          setState(() {
            isLoading = false;
          });
          if (responseJson['status']) {
            print(responseJson);

            // String token = responseJson['data']['token'];
            String otp = "${responseJson['otp']}";
            debugPrint(responseJson.toString());

            Get.to(() => const OtpScreen(),
                arguments: [phoneController.text, otp]);
            //Get.toNamed(RouteName.otpScreen,arguments: [phoneController.text,token,otp]);
          } else {
            Fluttertoast.showToast(
                msg: responseJson['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.themeColor,
                textColor: Colors.white,
                fontSize: 15.0);
            print('otp error: ${responseJson['message']}');
          }
        });
      });
    } on Exception catch (_, e) {
      debugPrint('eeee $e');
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
        sendOtpResponse();
      }
    });
  }

  /// ------------ Google SignIn -------------- ///

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      print('google login: $user');
      setState(() {
        isLoading = true;
      });
      var pData = {
        "sId": "${user!.providerData[0].uid}",
        "name": "${user.displayName}",
        "email": "${user.email}",
      };
      _getSocialLogin(pData);

      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print(e.toString());
    }
  }

  /// ----------------------- Get Social Login Api Response ------------------------ ///

  _getSocialLogin(var userData) async {
    try {
      var jsonObject = {
        "socialId": userData['sId'],
        "name": userData['name'],
        "email": userData['email'],
        "device_type": deviceType,
        "device_token": deviceToken,
        //"role": "User",
      };
      var jsonParam = json.encode(jsonObject);
      print('jsonObject _getSocialLogin: ${jsonObject}');
      HttpService.postJson(BaseUrl.socialLogin, jsonParam).then((response) {
        setState(() {
          print('ggggggggggggg');
          Map<String, dynamic> responseJson = json.decode(response.body);
          isLoading = false;
          //if (responseJson['status']) {
          if (response.statusCode == 200) {
            String token = responseJson['data']['accessToken'];
            String userId = responseJson['data']['userId'].toString();
            debugPrint('special login resp: $responseJson');
            SharedPreference.putString(AppConstants.loginToken, token);
            SharedPreference.putString(AppConstants.userId, userId);

            if (responseJson['data']['isProfile'] == 0) {
              Get.offAll(() => const ProfileScreen(), arguments: ['1']);
            } else {
              SharedPreference.putBool(AppConstants.isLogin, true);
              Get.offAll(() => const HomeScreen(), arguments: ['1']);
            }

          } else {
            if (response.statusCode == 404 || response.statusCode == 403) {
              Fluttertoast.showToast(
                  msg: responseJson['error'],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: AppColors.themeColor,
                  textColor: Colors.black,
                  fontSize: 16.0);
            }
          }
        });
      });
    } on Exception catch (_, e) {
      debugPrint('$e');
    }
  }
}
