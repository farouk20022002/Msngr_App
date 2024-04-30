class Message {
  String? id;
  String? toId;
  String? fromId;
  String? msg;
  String? type;
  String? createdAt;
  String? read;

  Message({
    required this.id,
    required this.fromId,
    required this.createdAt,
    required this.msg,
    required this.read,
    required this.toId,
    required this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? "",
      toId: json['to_id'],
      createdAt: json['created_at'],
      fromId: json['from_id'],
      msg: json['msg'],
      read: json['read'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'to_id': toId,
      'from_id': fromId,
      'msg': msg,
      'type': type,
      'read': read,
      'created_at': createdAt,
    };
  }
}
