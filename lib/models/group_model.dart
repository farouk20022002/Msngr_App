class ChatGroup {
  String? id;
  String? name;
  String? image;
  List? members;
  List? admin;
  String? lastMessage;
  String? lastMessageTime;
  String? createdAt;
  ChatGroup(
      {
        required this.id,
        required this.name,
        required this.image,
        required this.members,
        required this.admin,
        required this.lastMessage,
        required this.lastMessageTime,
        required this.createdAt,

      });

  factory ChatGroup.fromJson(Map<String, dynamic> json) {
    return ChatGroup(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        image: json['image'] ?? "",
        members: json['members'] ?? [],
        admin: json['admins_id'] ?? [],
        createdAt: json['created_at'],
        lastMessage: json['last_message'] ?? "",
        lastMessageTime: json['last_message_time'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name' : name,
      'image' : image,
      'members': members,
      'admins_id' : admin,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'created_at': createdAt,
    };
  }
}
