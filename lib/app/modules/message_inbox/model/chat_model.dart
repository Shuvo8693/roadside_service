class ChatModel {
  int? code;
  String? message;
  ChatData? data;

  ChatModel({this.code, this.message, this.data});

  ChatModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? ChatData.fromJson(json['data']) : null;
  }
}

class ChatData {
  List<ChatAttributes>? attributes;

  ChatData({this.attributes});

  ChatData.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      attributes = <ChatAttributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(ChatAttributes.fromJson(v));
      });
    }
  }
}

class ChatAttributes {
  String? sId;
  String? chatRoomId;
  Sender? sender;
  String? message;
  String? media;
  String? messageType;
  bool? isDeleted;
  String? timestamp;
  DateTime? createdAt;
  String? updatedAt;
  int? iV;

  ChatAttributes(
      {this.sId,
        this.chatRoomId,
        this.sender,
        this.message,
        this.media,
        this.messageType,
        this.isDeleted,
        this.timestamp,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ChatAttributes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chatRoomId = json['chatRoomId'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    message = json['message'];
    media = json['media'];
    messageType = json['messageType'];
    isDeleted = json['isDeleted'];
    timestamp = json['timestamp'];
    createdAt =DateTime.parse(json['createdAt'].toString());
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class Sender {
  String? name;
  Image? image;
  String? id;

  Sender({this.name, this.image, this.id});

  Sender.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    id = json['id'];
  }
}

class Image {
  String? url;
  String? path;

  Image({this.url, this.path});

  Image.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    path = json['path'];
  }
}
