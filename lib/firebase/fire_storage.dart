import 'package:chat_material3/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'fire_database.dart';
class FireStorage{

final FirebaseStorage fireStorage = FirebaseStorage.instance;

sendImage({required File file,required String roomId,required String uid,required ChatUser chatUser,required BuildContext context})async {
  String ext = file.path.split('.').last;
  final ref = fireStorage
      .ref()
      .child('image/$roomId/${DateTime.now().millisecondsSinceEpoch}.$ext');

 await ref.putFile(file);

  String imageUrl = await ref.getDownloadURL();
   FireData().sendMessage(
       uid,
       imageUrl,
       roomId,
       chatUser,
       context,
       type: 'image');

}

Future updateProfileImage({required File file})async {
  String ext = file.path.split('.').last;
  String uid= FirebaseAuth.instance.currentUser!.uid;
  final ref = fireStorage
      .ref()
      .child('profile/$uid/${DateTime.now().millisecondsSinceEpoch}.$ext');

  await ref.putFile(file);

  String imageUrl = await ref.getDownloadURL();
  await FirebaseFirestore.instance.collection('users').doc(uid).update({'image':imageUrl});
}
}