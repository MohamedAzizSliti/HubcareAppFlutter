import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Screens/HomeScreen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConnectivityUtil.dart';
import '../Constants/HttpService.dart';
import '../Constants/InputField.dart';
import '../Constants/SharedPreference.dart';
import '../Widgets/button_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextStyle smallText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.blackColor);
  TextStyle editText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor);

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String? dropdownValue;

  String _selectedGender = "";
  String phone = '';
  String profile = '';
  String userId = '';
  String birthDate = '';
  File _pickedImage1 = File("");
  File _pickedImage = File("");
  PickedFile? imageFile;
  var countries = [];

  bool isLoading = false;
  var token = "";
  var argumentData = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        print('token : $token');
        isLoading = true;
        getProfile();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Make AppBar transparent
            elevation: 0, // Optional: Remove shadow
            title: Row(
              children: [
                if(argumentData[0] == "2")
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      'assets/backArrow.svg',
                      height: 28,
                    )),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Update Profile',
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
          body: SafeArea(
              child: SingleChildScrollView(
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
                      InkWell(
                        onTap: () {
                         // _showChoiceDialog(context);
                        },
                        child: Center(
                          child: SizedBox(
                            width: 90,
                            height: 99,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(55),
                                  // Adjust the radius as needed
                                  child: _pickedImage.path.isNotEmpty
                                      ? Image.file(
                                          _pickedImage,
                                          fit: BoxFit.cover,
                                        )
                                      : profile.isNotEmpty
                                          ? Image.network(
                                      "${BaseUrl.imageUrl}${profile}",
                                              fit: BoxFit.cover,
                                              width: 90,
                                              height: 90,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(Icons.account_circle, color: Colors.grey, size: 65),
                                        );
                                      }
                                             // errorBuilder: (context, error, stackTrace) {
                                             // return const Icon(Icons.error_outline_rounded, size: 60, color: Colors.red);
                                             // },
                                            )
                                          : Image.asset(
                                              'assets/image.png',
                                              height: 90,
                                              width: 90,
                                            ),
                                ),
                                Positioned(
                                    right: 1,
                                    bottom: 1,
                                    child: InkWell(
                                        onTap: () {
                                           _showChoiceDialog(context);
                                        },
                                        child: SvgPicture.asset(
                                            'assets/add_pic.svg'))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Full Name',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        controller: nameController,
                        style: smallText,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputField().inputDecoration(
                            'Name',
                            AppColors.whiteColor,
                            AppColors.blackColor.withOpacity(.5)),
                        validator: (value) {
                          if (value!.length < 3) {
                            return 'Name must be greater than 3 characters'
                                .tr();
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Text(
                        'Email',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      ),
                      const SizedBox(
                        height: 7,
                      ),

                      TextFormField(
                        controller: emailController,
                        style: smallText,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputField().inputDecoration(
                            'Email',
                            AppColors.whiteColor,
                            AppColors.blackColor.withOpacity(.5)),
                        validator: _validateEmail
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Phone',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      ),
                      const SizedBox(
                        height: 7,
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
                              color: AppColors.blackColor.withOpacity(.5),
                              style: BorderStyle.none,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.blackColor.withOpacity(.5),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.blackColor.withOpacity(.5),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(.2),
                          counterText: "",
                          contentPadding: const EdgeInsets.all(7),
                        ),
                        initialCountryCode: 'IN',
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
                            print(phone.completeNumber);
                          });
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ButtonWidget(
                          text: 'Update',
                          onPressed: () {
                             if (formKey.currentState!.validate()) {
                                  _checkConnectivity();
                            }else{
                               formKey.currentState!.validate();
                             }
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                    ]),
              ),
            ),
          )),
        ),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              color: AppColors.themeColor,
            ),
          ),
      ],
    );
  }

  /// --------- Pick Image --------- ///

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    setState(() {
      try {
        // imageFile = pickedFile;
        _pickedImage1 = File(pickedFile!.path);
        _cropImage(_pickedImage1.path);
      } catch (err) {
        //print(err.runtimeType);
      }
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      try {
        // imageFile = pickedFile!;
        _pickedImage1 = File(pickedFile!.path);
        _cropImage(_pickedImage1.path);
      } catch (err) {
        print(err.runtimeType);
      }
    });
    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'choose_option'.tr(),
              style: TextStyle(color: AppColors.themeColor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: AppColors.themeColor,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text('gallery'.tr()),
                    leading: Icon(
                      Icons.account_box,
                      color: AppColors.themeColor,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.themeColor,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text('camera'.tr()),
                    leading: Icon(
                      Icons.camera,
                      color: AppColors.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Crop Image
  _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        final _pickedImage1 = croppedImage.path;
        _pickedImage = File(_pickedImage1);
        debugPrint(croppedImage.path);
      });
    }
  }

  /// ----------- getProfile -----------///

  // getProfile() {
  //   var url = BaseUrl.getProfile;
  //   print('Token $token');
  //   HttpService.getDataWithHeader(url, token).then((response) {
  //     setState(() {
  //       // ignore: avoid_print
  //       print(response.body.toString());
  //       Map<String, dynamic> responseJson = json.decode(response.body);
  //       isLoading = false;
  //       print('isLoading: $isLoading');
  //       if (response.statusCode == 200) {
  //         if (responseJson['success']) {
  //           phoneController.text = responseJson['user']['phone'] ?? "";
  //           nameController.text = responseJson['user']['name'] ?? "";
  //           emailController.text = responseJson['user']['email'] ?? "";
  //           profile = responseJson['user']['profile_image'] ?? "";
  //         } else {
  //           Fluttertoast.showToast(
  //               msg: responseJson['message'],
  //               toastLength: Toast.LENGTH_SHORT,
  //               gravity: ToastGravity.BOTTOM,
  //               timeInSecForIosWeb: 1,
  //               backgroundColor: AppColors.themeColor,
  //               textColor: Colors.white,
  //               fontSize: 16.0);
  //         }
  //       } else if (response.statusCode == 401) {
  //         // SharedPreference.putString(AppConstants.loginToken, "");
  //         // SharedPreference.putBool(AppConstants.isLogin, false);
  //         // SharedPreference.putString('userType', "");
  //         // SharedPreference.putString("UserId", "");
  //         // Get.offAll(()=> const UserType());
  //       }
  //     });
  //   });
  // }
  getProfile() async {
    var url = BaseUrl.getProfile;
    print('Token $token');

    try {
      final response = await HttpService.getDataWithHeader(url, token);
      print(response.body.toString());

      Map<String, dynamic> responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          phoneController.text = responseJson['user']['phone'] ?? "";
          nameController.text = responseJson['user']['name'] ?? "";
          emailController.text = responseJson['user']['email'] ?? "";
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
        // handle unauthorized
                // SharedPreference.putString(AppConstants.loginToken, "");
                // SharedPreference.putBool(AppConstants.isLogin, false);
                // SharedPreference.putString('userType', "");
                // SharedPreference.putString("UserId", "");
                // Get.offAll(()=> const UserType());
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


  /// ----------- Update profile ------------- ///
  updateProfile() async {
    var url = Uri.parse(BaseUrl.updateProfile);
    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest('PUT', url);
    request.headers.addAll(headers);
    request.fields['name'] = nameController.text.trim();
    request.fields['email'] = emailController.text.trim();
    request.fields['phone'] = phoneController.text.trim();


    if (_pickedImage.path.isNotEmpty) {

      final mimeType = lookupMimeType(_pickedImage.path);
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        _pickedImage.path,
        contentType: MediaType.parse(mimeType!),
      );
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      debugPrint("response.statusCode =  ${response.statusCode}");
      debugPrint("response.statusCode =  ${responseString}");

      if (response.statusCode == 200) {
        debugPrint("response123$responseString");
        Map<String, dynamic> resposne1 = jsonDecode(responseString);

        if (resposne1["status"]) {
          setState(() {
            isLoading = false;
          });
          if(argumentData[0]=="2") {
            Get.back();
          }else{
            SharedPreference.putBool(AppConstants.isLogin, true);
            Get.offAll(()=>HomeScreen());
          }

          debugPrint(resposne1.toString());
          Fluttertoast.showToast(
              msg: resposne1["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);

          debugPrint(resposne1["message"]);
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: resposne1["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Server error ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        debugPrint('Error updating profile.${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle the exception and print the error message
      debugPrint('Error updating profile.11');
      debugPrint('Exception: $e');
      setState(() {
        isLoading = false;
      });
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
        updateProfile();
      }
    });
  }

  String? _validateEmail(String? value) {
    const pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
