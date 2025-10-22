import 'package:flutter/material.dart';

class ProgressLoading {
  static void onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.deepPurple,
          )),
        );
      },
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
    });
  }
}
