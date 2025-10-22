import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConstImage.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import '../Widgets/button_widget.dart';


class RatingScreen extends StatefulWidget {
  String providerId;
   RatingScreen({Key? key,required this.providerId}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {

  TextStyle smallText = TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.w500,
      color: AppColors.fontGrayColors);

  TextStyle editText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor);

  TextStyle hintText = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: AppColors.fontGrayColors);

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController descriptionController = TextEditingController();


  bool isLoading = false;
  var token = "";
  var id = "";
  var jobId = "";
  var catId = "";
  var rating_ = "";

  @override
  void initState() {
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
      });
    });
    super.initState();
  }



  Future<void> _writeReview() async {
    try {
      dynamic data = {
        "rating":rating_,
        "review": descriptionController.text,
      };
      print(data);
      HttpService.postWithHeader("${BaseUrl.submitReview}${widget.providerId}", data,token).then((response) {
        setState(() {
          Map<String, dynamic> responseJson = json.decode(response.body);
          if (responseJson['status'] == true) {
            debugPrint(responseJson.toString());
            Get.back();

          } else {
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
                  'Write Review',
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
            padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: ListView(
                  children: [
                   // Center(child: ConstImage().buildImage('rating.png', 220, 220)),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: AppColors.inputColor.withOpacity(
                        .8,
                      ),
                      height: 12,
                      width: MediaQuery.of(context).size.width - 10,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Text(
                        'Add Rating',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.fontColors),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    Center(
                      child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.orangeAccent,
                        ),
                        onRatingUpdate: (rating) {
                          rating_ = rating.toString();
                          //print(rating);
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: AppColors.inputColor.withOpacity(
                        .8,
                      ),
                      height: 12,
                      width: MediaQuery.of(context).size.width - 10,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      style: editText,
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Share your review',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.fontGrayColors),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            width: 0,
                            color: AppColors.grayColor99.withOpacity(.5),
                            style: BorderStyle.none,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                              AppColors.grayColor99.withOpacity(.5),
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
                          return 'Please enter review.';
                        }
                        return null;
                      },
                    ),

                  ],
                ),
              ),
              ButtonWidget(
                onPressed: () {
                  if(rating_!=null && rating_.isNotEmpty){
                    _writeReview();
                  }else{
                    Fluttertoast.showToast(
                        msg: "Rating is required",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.themeColor,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                text: 'Submit Review',
              ),
              const SizedBox(
                height: 37,
              ),
            ]),
          ),
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

}
