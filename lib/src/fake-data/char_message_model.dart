import 'dart:convert';

SocketMessageModel chatMessageModelFromJson(String str) =>
    SocketMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(SocketMessageModel data) =>
    json.encode(data.toJson());

class SocketMessageModel {
  int id;
  int to;
  int from;
  List<String> message;
  String chatType;
  bool toUserOnlineStatus;

  SocketMessageModel({
    this.id,
    this.to,
    this.from,
    this.message,
    this.chatType,
    this.toUserOnlineStatus,
  });

  factory SocketMessageModel.fromJson(Map<String, dynamic> json) =>
      SocketMessageModel(
        id: json["id"],
        to: json["to"],
        from: json["from"],
        message: List<String>.from(json["message"].map((x) => x)),
        chatType: json["chat_type"],
        toUserOnlineStatus: json['to_user_online_status'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "to": to,
        "from": from,
        "message": List<dynamic>.from(message.map((x) => x)),
        "chat_type": chatType,
      };
}
