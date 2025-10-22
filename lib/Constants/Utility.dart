
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Utility {
  static Future<bool> checkConnection() async {
    List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    debugPrint(connectivityResult.toString());

    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }
  }

  static void showAlert(BuildContext context, String text) {
    var alert = AlertDialog(
      content: Container(
        child: Row(
          children: <Widget>[Text(text)],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ok',
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}
