
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hubcare/Constants/ConstImage.dart';
import 'package:hubcare/Screens/TransactionHistory.dart';
import 'package:hubcare/Screens/skip_cash_payment_page.dart';
import 'package:hubcare/Widgets/button_widget.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';
import '../Constants/InputField.dart';
import '../Constants/SharedPreference.dart';
import 'add_card_payment.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({super.key});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {

  TextStyle smallText = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.blackColor);

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController amountController = TextEditingController();
  String token = "";
  dynamic myWallet;
  bool isLoading = true;

  @override
  void initState() {
    SharedPreference.getString(AppConstants.loginToken).then((value) {
      setState(() {
        token = value;
        getMyWallet();
      });
    });
    super.initState();
  }

  getMyWallet() {
    var url = BaseUrl.getMyWallet;
    HttpService.getDataWithHeader(url,token).then((response) {
      setState(() {
        debugPrint('getMyWallet: '+response.body.toString());
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['status']) {
          myWallet = responseJson['wallet'];
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

  Future<void> addMoney(String amount) async {
    setState(() => isLoading = true);
    try {
      dynamic data = {
        "amount": amount,
      };
      HttpService.postWithHeader(BaseUrl.addToWallet, data,token).then((response) {
        setState(() {
          Map<String, dynamic> responseJson = json.decode(response.body);
          if (responseJson['status'] == true) {
            setState(() => isLoading = false);
            Get.to(()=> SkipCashWebView(paymentUrl: '',))?.then((v){
              getMyWallet();
            });

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
      setState(() => isLoading = false);
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet',
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),),
      automaticallyImplyLeading: false,),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 17,right: 17),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstImage().buildImage('flagIcon.png', 50, 50),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          myWallet!=null ?
                          Text(
                            "QR ${myWallet['balance'] ?? "0.0"}" ,
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),)
                          : Text(
                            "0.00" ,
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),),
                          Text('Available',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),),
                        ],
                      )
                    ],
                  ),


                    const SizedBox(
                      height: 15,
                    ),
                  SizedBox(height: 15,),
                  Text('Enter Amount',
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      controller: amountController,
                      style: smallText,
                      keyboardType: TextInputType.number,
                      decoration: InputField().inputDecoration(
                          '100',
                          AppColors.whiteColor,
                          AppColors.blackColor.withOpacity(.5)),
                      validator: (value) {
                        if (value!.length < 3) {
                          return '';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Text('You can add up to QR3000',
                      style: TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.w400, color: AppColors.grayColor99),),

                    SizedBox(height: 30,),
                    ButtonWidget(text: 'Add money to Wallet',
                        onPressed: (){
                      if(amountController.text.isNotEmpty){
                        addMoney(amountController.text);

                        // Get.to(()=> AddCardScreen(
                        //   amount: amountController.text,))?.then((value){
                        //   amountController.clear();
                        //   getMyWallet();
                        //
                        // });
                      }else{
                        Fluttertoast.showToast(
                            msg: "Enter Amount",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: AppColors.themeColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }),
                    SizedBox(height: 25,),
                    InkWell(
                      onTap: () {
                        Get.to(()=> TransactionHistory());
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(7, 12, 7, 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.grayColor66.withOpacity(0.3),
                          ),
                          color: AppColors.whiteColor,
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(10.0)),
                        ),
                        child: Row(
                          children: [
                            Text('Latest Transaction',
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),),
                            Expanded(child: SizedBox()),
                            Icon(Icons.arrow_forward_ios,size: 20,)
                          ],
                        ),
                      ),
                    )
                ],),
              ),
            ),
          )),
    );
  }
}
