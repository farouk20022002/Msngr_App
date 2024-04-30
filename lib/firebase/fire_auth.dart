import 'package:chat_material3/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static User user = auth.currentUser!;
  static Future createUser() async{
    ChatUser chatUser = ChatUser(
        id: user.uid,
        about: "Hello i am new",
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        email: user.email ?? "",
        image: '',
        lastActivated: DateTime.now().millisecondsSinceEpoch.toString(),
        name: user.displayName ?? "",
        online: false,
        pushToken: '',
      myUsers: [],
    );
    await firebaseFirestore.collection('users').doc(user.uid).set(chatUser.toJson());
  }

  Future getToken(String token)async{
    await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).update({'push_token':token});
  }

  Future updateActivated(bool online)async{
    await firebaseFirestore.collection('users').doc(user.uid).update({
      'online':online,
      'last_activated':DateTime.now().millisecondsSinceEpoch.toString()
    });
  }
}