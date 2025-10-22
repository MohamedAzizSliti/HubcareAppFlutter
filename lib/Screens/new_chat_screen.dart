import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Constants/AppConstants.dart';
import '../Constants/BaseUrl.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConstImage.dart';
import '../Constants/HttpService.dart';
import '../Constants/SharedPreference.dart';
import 'new_chat_controller.dart';

class NewChatScreen extends StatefulWidget {
  final String bookingId;
  NewChatScreen({
    required this.bookingId,
  });

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final ChatController controller = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String userId = "";
  String token = "";

  @override
  void initState() {
    SharedPreference.getString(AppConstants.loginToken).then((tkn) async {
      token = tkn;
      await getProfile();
    });
    super.initState();
  }

  getProfile() async {
    var url = BaseUrl.getProfile;
    try {
      final response = await HttpService.getDataWithHeader(url, token);
      Map<String, dynamic> responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseJson['status']== true) {
          userId = responseJson['user']['id'].toString();
          controller.initialize(uid: userId, bid: widget.bookingId, authToken: token, scrollController: _scrollController);
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
        Fluttertoast.showToast(
          msg: "Failed to load profile",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load profile",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && userId.isNotEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
              controller: _scrollController,
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                final isMe = message['senderId'] == userId;
                return Align(
                  alignment:
                  isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child:Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      children: [
                        Align(
                          alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: isMe
                                  ? const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              )
                                  : const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              color: isMe ? Colors.grey.shade200 : AppColors.themeColor,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              message['content'] ?? '',
                              style: const TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Align(
                          alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                          child: Text(
                            message['formatted_created_at'] ?? '',
                            style: TextStyle(fontSize: 12, color: AppColors.fontGrayColors),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );}),
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayLightColor),
        color: AppColors.whiteColor.withOpacity(.9),
      ),
      padding: const EdgeInsets.all(9),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: messageController,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.blackColor),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Write your message',
                hintStyle: TextStyle(fontSize: 14, color: AppColors.fontGrayColors),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(.1),
                contentPadding: const EdgeInsets.all(7),
              ),
            ),
          ),
          const SizedBox(width: 5),
          InkWell(
            onTap: () {
              if (messageController.text.trim().isNotEmpty) {
                controller.sendMessage(messageController.text.trim(),_scrollController);
                messageController.clear();
              }
            },
            child: ConstImage().buildSvgImage('send.svg', 37),
          ),
        ],
      ),
    );
  }
}
