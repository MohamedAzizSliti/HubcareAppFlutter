class ChatMessage {
  String messageContent;
  String senderId;
  String receiverId;
  String date;
  String image;

  ChatMessage(this.messageContent, this.senderId, this.receiverId, this.date,
      this.image);

  ChatMessage.fromJson(Map json)
      : messageContent = json['message'].toString(),
        senderId = json['sender_id'].toString(),
        receiverId = json['receiver_id'].toString(),
        date = json['date'].toString(),
        image = json['image'].toString();

  Map toJson() {
    return {
      'message': messageContent,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'date': date,
      'image': image
    };
  }
}
