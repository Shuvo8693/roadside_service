class ChatModel {
  final String? sender;
  final String? receiver;
  final String? message;
  final DateTime? timestamp;
  final String? id;
  final int? v;
  final String? senderImage;
  final String? receiverImage;

  ChatModel({
    this.sender,
    this.receiver,
    this.message,
    this.timestamp,
    this.id,
    this.v,
    this.senderImage,
    this.receiverImage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      sender: json['sender'],
      receiver: json['receiver'],
      message: json['message'],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      id: json['_id'],
      v: json['__v'],
      senderImage: json['senderImage'],
      receiverImage: json['receiverImage'],
    );
  }
}
