import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../Screens/LoginScreen.dart';

class HttpService {
  /// -------------------- Post -------------------- ///

  static Future<dynamic> post(var url, Map data) async {
    var response = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        // "Content-Type": "application/x-www-form-urlencoded",
        // 'Authorization': 'Bearer $token'
        //"accept": "application/json",
        // "Access-Control-Allow-Origin": "*"
      },
    );
    debugPrint(url);
    debugPrint(response.body);

    if (response.statusCode == 401) {
      // 🚨 Token expired or invalid
      handleTokenExpiry();
    }

    return response;
  }

  /// -------------------- Post Header-------------------- ///

  static Future<dynamic> postWithHeader(var url, Map data, var token) async {
    var response = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        // "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer $token",
        "accept": "application/json",
        // "Access-Control-Allow-Origin": "*"
      },
    );
    debugPrint(url);
    debugPrint(response.body);

    if (response.statusCode == 401) {
      // 🚨 Token expired or invalid
      handleTokenExpiry();
    }
    return response;
  }

  /// -------------------- Post Json -------------------- ///

  static Future<dynamic> postJson(var url, dynamic data) async {
    // String body = json.encode(data);
    //  debugPrint(data);

    var response = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Content-Type": "application/json",
        // 'Authorization': 'Bearer ${AppConstants.loginToken}'
        // "accept": "application/json",
        // "Access-Control-Allow-Origin": "*"
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 401) {
      // 🚨 Token expired or invalid
      handleTokenExpiry();
    }
    return response;
  }

  /// -------------------- Post Json -------------------- ///

  static Future<dynamic> postJsonWithHeader(
      var url, dynamic data, var token) async {
    // String body = json.encode(data);
    //  debugPrint(data);

    var response = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Content-Type": "application/json",
        'Authorization': '$token', //Bearer
        "accept": "application/json",
        // "Access-Control-Allow-Origin": "*"
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 401) {
      // 🚨 Token expired or invalid
      handleTokenExpiry();
    }
    return response;
  }

  /// -------------------- Put Json -------------------- ///

  static Future<dynamic> putJsonWithHeader(
      var url, dynamic data, var token) async {
    // String body = json.encode(data);
    //  debugPrint(data);

    var response = await http.put(
      Uri.parse(url),
      body: data,
      headers: {
        "Content-Type": "application/json",
        'Authorization': '$token', //Bearer
        "accept": "application/json",
        // "Access-Control-Allow-Origin": "*"
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 401) {
      // 🚨 Token expired or invalid
      handleTokenExpiry();
    }
    return response;
  }

  /// -------------------- Patch Json -------------------- ///

  static Future<dynamic> patchJsonWithHeader(
      var url, dynamic data, var token) async {
    // String body = json.encode(data);
    //  debugPrint(data);

    var response = await http.put(
      Uri.parse(url),
      body: data,
      headers: {
        "Content-Type": "application/json",
        'Authorization': '$token', //Bearer
        "accept": "application/json",
        // "Access-Control-Allow-Origin": "*"
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 401) {
      // 🚨 Token expired or invalid
      handleTokenExpiry();
    }
    return response;
  }

  /// -------------------- update ProfileImg -------------------- ///

  static Future<dynamic> postWithImg(var url, String userId, var files) async {
    Map<dynamic, dynamic> headers = {
      // "Accept": "application/json",
    };
    var request = http.MultipartRequest("POST", Uri.parse(url));
    // request.headers.addAll(headers);
    request.fields['userId'] = userId;

    if (files != null) request.files.addAll(files); // add files if not null

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    debugPrint("responseBody $responseString");
    if (response.statusCode == 200) {}
    return responseString;
  }

  /// -------------------- multipart With List -------------------- ///

  static Future<void> multipartWithList({
    required var url_,
    required String token,
    required Map<String, String> fields, // Dynamic text fields
    required List<String> imagePaths, // Multiple image paths
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    var url = Uri.parse(url_); // Ensure BaseUrl is defined
    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest('PUT', url);
    request.headers.addAll(headers);

    // Add dynamic text fields
    fields.forEach((key, value) {
      request.fields[key] = value.trim();
    });

    // Add multiple images
    for (String imagePath in imagePaths) {
      if (imagePath.isNotEmpty) {
        final mimeType = lookupMimeType(imagePath);
        final multipartFile = await http.MultipartFile.fromPath(
          'images[]',
          // Use array format for multiple images if backend supports it
          imagePath,
          contentType: MediaType.parse(mimeType!),
        );
        request.files.add(multipartFile);
      }
    }

    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      debugPrint("Response Code: ${response.statusCode}");
      debugPrint("Response Body: $responseString");

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(responseString);
        if (responseData["status"]) {
          onSuccess();
          Fluttertoast.showToast(
              msg: responseData["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          onError();
          Fluttertoast.showToast(
              msg: responseData["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        onError();
        Fluttertoast.showToast(
            msg: "Server error ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      debugPrint('Exception: $e');
      onError();
    }
  }

   /// -------------------- multipart Without List -------------------- ///

  static Future<void> multipartWithoutList({
    required var url_,
    required String isToken,
    required String token,
    required Map<String, String> fields, // Dynamic text fields
    required Map<dynamic, dynamic> images, // Multiple image paths
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    var url = Uri.parse(url_); // Ensure BaseUrl is defined
    Map<String, String> headers = {
      "Accept": "application/json",
      if(isToken == "1")
        'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest('PUT', url);
    request.headers.addAll(headers);

    // Add dynamic text fields
    fields.forEach((key, value) {
      request.fields[key] = value.trim();
    });

    // Add multiple images

    for (var entry in images.entries) {
      String fieldName = entry.key; // e.g., "image1", "image2"
      String imagePath = entry.value;

      if (imagePath.isNotEmpty) {
        final mimeType = lookupMimeType(imagePath);
        final multipartFile = await http.MultipartFile.fromPath(
          fieldName, // Use the key name (image1, image2, etc.)
          imagePath,
          contentType: MediaType.parse(mimeType!),
        );
        request.files.add(multipartFile);
      }
    }


    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      debugPrint("Response Code: ${response.statusCode}");
      debugPrint("Response Body: $responseString");

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(responseString);
        if (responseData["status"]) {
          onSuccess();
          Fluttertoast.showToast(
              msg: responseData["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          onError();
          Fluttertoast.showToast(
              msg: responseData["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        onError();
        Fluttertoast.showToast(
            msg: "Server error ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      debugPrint('Exception: $e');
      onError();
    }
  }



  /// -------------------- send  message -------------------- ///

  static Future<dynamic> chatting(var url, String appointmentId, senderId,
      receiverId, message, lang, var files) async {
    Map<dynamic, dynamic> headers = {
      // "Accept": "application/json",
    };
    var request = http.MultipartRequest("POST", Uri.parse(url));
    // request.headers.addAll(headers);
    request.fields['appointment_id'] = appointmentId;
    request.fields['sender_id'] = senderId;
    request.fields['receiver_id'] = receiverId;
    request.fields['message'] = message;
    request.fields['lang'] = lang;

    /*if (partParams != null) {
      request.fields.addAll(partParams);
    } */ // add part params if not null
    if (files != null) request.files.addAll(files); // add files if not null

    var response = await request.send();
    print("request $request");
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody $responseString");
    if (response.statusCode == 200) {}
    return responseString;
  }

  /// ---------------------- Get Apis ---------------------- ///

  static Future getData(var url) {
    // var url = BaseUrl.getCategories/*+"limit="+limit+"&offset="+offset*/;
    debugPrint("url = $url");
    return http.get(
      Uri.parse(url),
    );
  }


  static Future getDataWithHeader(var url, var token) {
    // var url = BaseUrl.getCategories/*+"limit="+limit+"&offset="+offset*/;
    debugPrint("url = $url");
    return http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
  }

  /// -------------------- Patch with Header -------------------- ///

  static Future patchDataWithHeader(var url,  var token) {
    debugPrint("url = $url");
    return http.get(Uri.parse(url), headers: {'Authorization': '$token'});
  }
}
void handleTokenExpiry() {
  // Clear user session (token, user data, etc.)
  // Example if you are using SharedPreferences
  // await prefs.clear();
  Fluttertoast.showToast(msg: "Session expired. Please login again");
  // Navigate to Login Screen and clear all routes
  Get.offAll(() => LoginScreen());
}