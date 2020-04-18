class Message {
  Message(
      {this.sender,
      this.senderDisplayName,
      this.text,
      this.isMe,
      this.isImage,
      this.dateTime});

  final String sender;
  final String senderDisplayName;
  final String text;
  final bool isMe;
  final bool isImage;
  final DateTime dateTime;
}
