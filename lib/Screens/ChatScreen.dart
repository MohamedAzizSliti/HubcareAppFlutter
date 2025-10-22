import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

import '../../Constants/AppConstants.dart';
import '../../Constants/BaseUrl.dart';
import '../../Constants/HttpService.dart';
import '../../Constants/SharedPreference.dart';
import '../Constants/ColorCodes.dart';
import '../Constants/ConstImage.dart';

class ChatScreen extends StatefulWidget {
  final String bookingId;
  const ChatScreen({Key? key,required this.bookingId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();

  bool isLoading = false;
  List<dynamic> chatList = [];
  Timer? timer;

  String userId = "";
  String token = "";

  dynamic argumentData = Get.arguments;

  @override
  void initState() {
    super.initState();
      SharedPreference.getString(AppConstants.loginToken).then((tkn) async {
        token = tkn;
        await getProfile();
        getMessages();
        // timer = Timer.periodic(const Duration(seconds: 15), (timer) {
        //   getMessages();
        // });
      });
  }


  getProfile() async {
    var url = BaseUrl.getProfile;
    try {
      final response = await HttpService.getDataWithHeader(url, token);
      Map<String, dynamic> responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseJson['status']== true) {
           userId = responseJson['user']['id'].toString();

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
    } finally {
      setState(() {
        isLoading = false;
        print('isLoading: $isLoading');
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: ConstImage().buildSvgImage('backArrow.svg', 37),
            ),
            const SizedBox(width: 7),
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(23),
                child: SvgPicture.asset(
                  'assets/avatar.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat',
                  style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.fontColors),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 2),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: chatList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                itemBuilder: (context, index) {
                  final message = chatList[index];
                  final isMe = message['senderId'].toString() == userId;

                  return Container(
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
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
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
              if (messageController.text.isNotEmpty) {
                sendMessage();
              }
            },
            child: ConstImage().buildSvgImage('send.svg', 37),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    try {
      final data = {
        "receiverId": "",
        "content": messageController.text,
        "messageType": "text",
        "attachments": "",
      };

      HttpService.postWithHeader("${BaseUrl.messagesSend}/${widget.bookingId}", data, token).then((response) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        setState(() {
          isLoading = false;
          if (responseJson['status'] == true) {
            messageController.clear();
            getMessages();
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
      });
    } catch (e) {
      debugPrint('Send message error: $e');
    }
  }

  void getMessages() {
    final url = "${BaseUrl.getMessages}${widget.bookingId}";
    HttpService.getDataWithHeader(url, token).then((response) {

      if (mounted) {
        setState(() {
          Map<String, dynamic> responseJson = json.decode(response.body);
          if (responseJson['status'] == true) {
            chatList = responseJson['messages'] ?? [];
            if (chatList.isNotEmpty) {
              _animateToLast();
            }
          }
        });
      }
    });
  }

  void _animateToLast() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
