
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import '../Widgets/button_widget.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  TextStyle editText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor);

  TextStyle hintText = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: AppColors.fontGrayColors);
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  bool _enableBtn = false;
  bool isLoading = false;
  var token = "";
  var user_id = "";
  getProfile() {
    var url = BaseUrl.getProfile;
    debugPrint('Token $token');
    HttpService.getDataWithHeader(url, token).then((response) {
      setState(() {
        // ignore: avoid_print
        debugPrint(response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);
        isLoading = false;
        if (responseJson['status'] == true) {
          user_id = responseJson['user']['id'] ?? "";
          print("USER ID IN HELP->  "+ user_id);
          SharedPreference.putString(AppConstants.userId, user_id+"");
          SharedPreference.getString(AppConstants.userId).then((v){
            setState(() {
              user_id = v;
            });
          });


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
  void initState() {
    super.initState();
    SharedPreference.getString(AppConstants.loginToken).then((v){
      setState(() {
        token = v;
        getProfile();
      });
    });



  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent
              elevation: 0, // Optional: Remove shadow
              title: Row(
                children: [
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
                    'Help & Support',
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
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 2),
                    child: Form(
                        key: formKey,
                        onChanged: () =>
                            setState(
                                    () =>
                                _enableBtn = formKey.currentState!.validate()),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),

                              Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.fontGrayColors),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: nameController,
                                style: editText,
                                keyboardType: TextInputType.name,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Enter name',
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.fontGrayColors),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                      width: 0,
                                      color: AppColors.grayColor99.withOpacity(
                                          .5),
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.grayColor99
                                            .withOpacity(.5),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                        AppColors.grayColor99.withOpacity(.5),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(.1),
                                  contentPadding: const EdgeInsets.all(7),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter Name.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.fontGrayColors),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: emailController,
                                style: editText,
                                keyboardType: TextInputType.emailAddress,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Enter email',
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.fontGrayColors),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                      width: 0,
                                      color: AppColors.grayColor99.withOpacity(
                                          .5),
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.grayColor99
                                            .withOpacity(.5),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                        AppColors.grayColor99.withOpacity(.5),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(.1),
                                  contentPadding: const EdgeInsets.all(7),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter email.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.fontGrayColors),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: phoneController,
                                style: editText,
                                keyboardType: TextInputType.phone,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Enter phone number',
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.fontGrayColors),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                      width: 0,
                                      color: AppColors.grayColor99.withOpacity(
                                          .5),
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.grayColor99
                                            .withOpacity(.5),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                        AppColors.grayColor99.withOpacity(.5),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(.1),
                                  contentPadding: const EdgeInsets.all(7),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter Phone Number.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ), Text(
                                'Message',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.fontGrayColors),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: messageController,
                                style: editText,
                                keyboardType: TextInputType.text,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: 'Type here..',
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.fontGrayColors),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                      width: 0,
                                      color: AppColors.grayColor99.withOpacity(
                                          .5),
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.grayColor99
                                            .withOpacity(.5),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                        AppColors.grayColor99.withOpacity(.5),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(.1),
                                  contentPadding: const EdgeInsets.all(7),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter message.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),

                              ButtonWidget(
                                onPressed: () {
                                  if (_enableBtn) {
                                    setState(() {
                                      isLoading = true;
                                      _sendHelpSupport();
                                    });
                                  } else {
                                    formKey.currentState!.validate();
                                  }
                                },
                                text: 'Send',
                              ),
                            ]))))),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              color: AppColors.themeColor,
            ),
          )
      ],
    );
  }



  _sendHelpSupport() async {
    try {
      dynamic data = {
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "message": messageController.text,
        "user_id":user_id.toString()
      };

      HttpService.postWithHeader(BaseUrl.helpSupport, data, 'Bearer '+token)
          .then((response) {
        setState(() {
          Map<String, dynamic> responseJson = json.decode(response.body);
          // Loader.hide();
          setState(() => isLoading = false);
          if (responseJson['status']) {
            debugPrint(responseJson.toString());
            Fluttertoast.showToast(
                msg: responseJson['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.themeColor,
                textColor: Colors.black,
                fontSize: 14.0);
            Get.back();
          } else {
            setState(() => isLoading = false);
            Fluttertoast.showToast(
                msg: responseJson['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.themeColor,
                textColor: Colors.black,
                fontSize: 16.0);
          }
        });
      });
    } on Exception catch (_, e) {
      debugPrint('$e');
    }
  }
}
