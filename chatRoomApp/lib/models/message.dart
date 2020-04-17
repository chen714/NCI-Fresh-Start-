class Message {
  Message({this.sender, this.text, this.isMe, this.isImage, this.dateTime});

  final String sender;
  final String text;
  final bool isMe;
  final bool isImage;
  final DateTime dateTime;
}
