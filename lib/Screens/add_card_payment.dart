// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:get/get.dart';
// // import 'package:get/get_core/src/get_main.dart';
// //
// // import '../Constants/ColorCodes.dart';
// // import '../Widgets/button_widget.dart';
// //
// // class AddCardScreen extends StatelessWidget {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _cardHolderController = TextEditingController();
// //   final TextEditingController _cardNumberController = TextEditingController();
// //   final TextEditingController _expiryController = TextEditingController();
// //   final TextEditingController _cvvController = TextEditingController();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent, // Make AppBar transparent
// //         elevation: 0, // Optional: Remove shadow
// //         title: Row(
// //           children: [
// //             InkWell(
// //                 onTap: () {
// //                   Get.back();
// //                 },
// //                 child: SvgPicture.asset('assets/backArrow.svg',height: 28,)),
// //             const SizedBox(
// //               width: 5,
// //             ),
// //             Text(
// //               "Add card details",
// //               textAlign: TextAlign.start,
// //               style: TextStyle(
// //                   fontSize: 15.0,
// //                   fontWeight: FontWeight.w600,
// //                   color: AppColors.blackColor),
// //             ),
// //           ],
// //         ),
// //
// //         automaticallyImplyLeading: false,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text("Pay with credit or debit card"),
// //                 const SizedBox(height: 10),
// //                 Row(
// //                   children: [
// //                     Image.asset('assets/visa.png', height: 30),
// //                     const SizedBox(width: 10),
// //                     Image.asset('assets/mastercard.png', height: 30),
// //                     const SizedBox(width: 10),
// //                     Image.asset('assets/sbi.png', height: 30),
// //                     const SizedBox(width: 10),
// //                     Image.asset('assets/paypal.png', height: 30),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20),
// //                 TextFormField(
// //                   controller: _cardHolderController,
// //                   decoration: _inputDecoration("Card Holder Name", icon: Icons.person_outline),
// //                   validator: (value) => value!.isEmpty ? "Enter card holder name" : null,
// //                 ),
// //                 const SizedBox(height: 15),
// //
// //                 TextFormField(
// //                   controller: _cardNumberController,
// //                   decoration: _inputDecoration("0000 0000 0000 0000", icon: Icons.credit_card),
// //                   keyboardType: TextInputType.number,
// //                   inputFormatters: [
// //                     FilteringTextInputFormatter.digitsOnly,
// //                     _CardNumberInputFormatter(),
// //                   ],
// //                   validator: _validateCardNumber,
// //                 ),
// //                 const SizedBox(height: 15),
// //
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: TextFormField(
// //                         controller: _expiryController,
// //                         decoration: _inputDecoration("00/00", hint: "MM / YY", icon: Icons.calendar_today),
// //                         keyboardType: TextInputType.datetime,
// //                         validator: (value) => value!.isEmpty ? "Enter expiry date" : null,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 16),
// //                     Expanded(
// //                       child: TextFormField(
// //                         controller: _cvvController,
// //                         decoration: _inputDecoration("CVV", icon: Icons.lock_outline),
// //                         keyboardType: TextInputType.number,
// //                         inputFormatters: [
// //                           FilteringTextInputFormatter.digitsOnly,
// //                           LengthLimitingTextInputFormatter(3),
// //                         ],
// //                         validator: (value) => value!.length != 3 ? "Enter valid CVV" : null,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //
// //                 const SizedBox(height: 30),
// //                 ButtonWidget(text: 'Add',
// //                     onPressed: (){
// //                       if (_formKey.currentState!.validate()) {
// //                         // Submit card info
// //                       }
// //                     }),
// //
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   String? _validateCardNumber(String? value) {
// //     if (value == null || value.isEmpty) return "Enter card number";
// //     String cleaned = value.replaceAll(' ', '');
// //     if (!_luhnCheck(cleaned)) return "Invalid card number";
// //     return null;
// //   }
// //
// //   bool _luhnCheck(String number) {
// //     int sum = 0;
// //     bool alternate = false;
// //
// //     for (int i = number.length - 1; i >= 0; i--) {
// //       int n = int.parse(number[i]);
// //       if (alternate) {
// //         n *= 2;
// //         if (n > 9) n -= 9;
// //       }
// //       sum += n;
// //       alternate = !alternate;
// //     }
// //     return sum % 10 == 0;
// //   }
// // }
// // InputDecoration _inputDecoration(String label, {String? hint, IconData? icon}) {
// //   return InputDecoration(
// //     labelText: label,
// //     hintText: hint,
// //     prefixIcon: icon != null ? Icon(icon) : null,
// //     border: OutlineInputBorder(
// //       borderRadius: BorderRadius.circular(12),
// //     ),
// //     enabledBorder: OutlineInputBorder(
// //       borderSide: const BorderSide(color: Colors.grey),
// //       borderRadius: BorderRadius.circular(12),
// //     ),
// //     focusedBorder: OutlineInputBorder(
// //       borderSide: const BorderSide(color: Colors.blue, width: 2),
// //       borderRadius: BorderRadius.circular(12),
// //     ),
// //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //   );
// // }
// //
// //
// // class _CardNumberInputFormatter extends TextInputFormatter {
// //   @override
// //   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
// //     final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
// //     final formatted = digitsOnly.replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)} ");
// //     return TextEditingValue(
// //       text: formatted.trimRight(),
// //       selection: TextSelection.collapsed(offset: formatted.length),
// //     );
// //   }
// // }
//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
// import '../Constants/AppConstants.dart';
// import '../Constants/BaseUrl.dart';
// import '../Constants/ColorCodes.dart';
// import '../Constants/HttpService.dart';
// import '../Constants/SharedPreference.dart';
// import '../Widgets/button_widget.dart';
//
//
// class AddCardScreen extends StatefulWidget {
//   final String amount;
//   const AddCardScreen({super.key,required this.amount});
//
//   @override
//   State<AddCardScreen> createState() => _AddCardScreenState();
// }
//
// class _AddCardScreenState extends State<AddCardScreen> {
//   final _formKey = GlobalKey<FormState>();
//   CardFieldInputDetails? _cardFieldInput;
//   bool isLoading = false;
//   String token = "";
//
//
//   @override
//   void initState() {
//     SharedPreference.getString(AppConstants.loginToken).then((value) {
//       setState(() {
//         token = value;
//       });
//     });
//     super.initState();
//   }
//
//   Future<void> createCardToken() async {
//     try {
//       final tokenData = await Stripe.instance.createToken(
//         const CreateTokenParams.card(params: CardTokenParams()),
//       );
//       print('✅ Token: ${tokenData.id}');
//       addMoney(tokenData.id);
//     } catch (e) {
//       print('❌ Error creating token: $e');
//     }
//   }
//
//   Future<void> addMoney(String tokenId) async {
//     setState(() => isLoading = true);
//     try {
//       dynamic data = {
//         "amount": widget.amount,
//         "description":"Add Recharge",
//         "token": tokenId
//       };
//       HttpService.postWithHeader(BaseUrl.addToWallet, data,token).then((response) {
//         setState(() {
//           Map<String, dynamic> responseJson = json.decode(response.body);
//           if (responseJson['status'] == true) {
//             setState(() => isLoading = false);
//             Get.back();
//
//           } else {
//             setState(() => isLoading = false);
//             Fluttertoast.showToast(
//                 msg: responseJson['message'],
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.BOTTOM,
//                 timeInSecForIosWeb: 1,
//                 backgroundColor: AppColors.themeColor,
//                 textColor: Colors.black,
//                 fontSize: 16.0);
//           }
//         });
//       });
//     } on Exception catch (_, e) {
//       setState(() => isLoading = false);
//       debugPrint('$e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Row(
//           children: [
//             InkWell(
//               onTap: () => Get.back(),
//               child: SvgPicture.asset('assets/backArrow.svg', height: 28),
//             ),
//             const SizedBox(width: 5),
//             Text(
//               "Add card details",
//               style: TextStyle(
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.blackColor),
//             ),
//           ],
//         ),
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("Pay with credit or debit card"),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Image.asset('assets/visa.png', height: 30),
//                   const SizedBox(width: 10),
//                   Image.asset('assets/mastercard.png', height: 30),
//                   const SizedBox(width: 10),
//                   Image.asset('assets/sbi.png', height: 30),
//                   const SizedBox(width: 10),
//                   Image.asset('assets/paypal.png', height: 30),
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               const Text("Card Details"),
//               const SizedBox(height: 10),
//               CardField(
//                 onCardChanged: (card) {
//                   setState(() {
//                     _cardFieldInput = card;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//               ButtonWidget(
//                 text: 'Add',
//                 isLoading: isLoading,
//                 onPressed: isLoading ? null
//                     : () {
//                   if (_cardFieldInput?.complete == true) {
//                     createCardToken();
//                   } else {
//                     Get.snackbar("Error", "Please enter complete card details.");
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
