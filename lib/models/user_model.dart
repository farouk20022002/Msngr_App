

class ChatUser {
  String? id;
  String? name;
  String? email;
  String? about;
  String? image;
  String? createdAt;
  String? pushToken;
  String? lastActivated;
  bool? online;
  List? myUsers;


  ChatUser({
    required this.id,
    required this.about,
    required this.createdAt,
    required this.email,
    required this.image,
    required this.lastActivated,
    required this.name,
    required this.online,
    required this.pushToken,
    required this.myUsers,
}
      );
  factory ChatUser.fromJson(Map<String,dynamic> json){
    return ChatUser(id: json['id'] ?? "",
        about: json['about'],
        createdAt: json['created_at'],
        email: json['email'],
        image: json['image'],
        lastActivated: json['last_activated'],
        name: json['name'],
        online: json['online'],
        pushToken: json['push_token'],
        myUsers: json['my_users'],
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'id' : id,
      'name' : name,
      'image' : image,
      'email' : email,
      'about' : about,
      'online' : online,
      'push_token' : pushToken,
      'last_activated' : lastActivated,
      'created_at' : createdAt,
      'my_users' : myUsers,
    };
  }

}