import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/HttpService.dart';

class ChatController extends GetxController {
  late IO.Socket socket;
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  String userId = '';
  String bookingId = '';
  String token = '';
  RxBool isLoading = false.obs;

  void initialize({required String uid, required String bid, required String authToken , required ScrollController scrollController}) {
    userId = uid;
    bookingId = bid;
    token = authToken;
    connectSocket();
    fetchMessages(scrollController);
  }

  void connectSocket() {
    socket = IO.io(BaseUrl.url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');
      socket.emit('register', userId);
    });

    socket.on('newMessage', (data) {
      messages.add(Map<String, dynamic>.from(data));
    });

    socket.onDisconnect((_) => print('Socket disconnected'));
  }

  void sendMessage(String text, ScrollController controller) async {
    try {
      final data = {
        "receiverId": "",
        "content": text,
        "messageType": "text",
        "attachments": "",
      };

      HttpService.postWithHeader("${BaseUrl.messagesSend}/$bookingId", data, token).then((response) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
          if (responseJson['status'] == true) {
            messages.add(responseJson['data']);
            _animateToLast(controller);
          } else {
            Fluttertoast.showToast(
              msg: responseJson['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppColors.themeColor,
              textColor: Colors.black,
              fontSize: 16.0,
            );
          }
      });
    } catch (e) {
      debugPrint('Send message error: $e');
    }
  }

  void fetchMessages(ScrollController scrollController) {
    isLoading.value = true;
    final url = "${BaseUrl.getMessages}$bookingId";
    HttpService.getDataWithHeader(url, token).then((response) {
          Map<String, dynamic> responseJson = json.decode(response.body);
          if (responseJson['status'] == true) {
            messages.assignAll(
              (responseJson['messages'] as List)
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList(),
            );
            isLoading.value = false;
            _animateToLast(scrollController);
      }
    });
  }

  void _animateToLast(ScrollController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
