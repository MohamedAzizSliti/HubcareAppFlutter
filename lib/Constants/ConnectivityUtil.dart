

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConnectivityUtil {
  // Method to check connectivity and show a toast if there is no internet connection
  static Future<bool> checkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
   // if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    if (connectivityResult != ConnectivityResult.none) {
      return true;
    } else {
      print("No internet connection == ");
      Fluttertoast.showToast(
        msg: "No internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }
}