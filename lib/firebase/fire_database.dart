import 'dart:async';
import 'dart:convert';

import 'package:chat_material3/models/group_model.dart';
import 'package:chat_material3/models/message_model.dart';
import 'package:chat_material3/models/room_models.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class FireData{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  String now = DateTime.now().millisecondsSinceEpoch.toString();


 Future createRoom(String email) async{
    QuerySnapshot userEmail =await firestore
        .collection('users')
        .where('email',isEqualTo:email)
        .get();
    if(userEmail.docs.isNotEmpty)  {
      String userId = userEmail.docs.first.id;
      List<String> members = [myUid, userId]..sort((a, b) => a.compareTo(b),);
      QuerySnapshot roomExist = await firestore
          .collection('rooms')
          .where('members', isEqualTo: members)
          .get();
      if (roomExist.docs.isEmpty) {
        ChatRoom chatRoom = ChatRoom(
            id: members.toString(),
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            lastMessage: "",
            members: members,
            lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString()
        );
        await firestore
            .collection('rooms')
            .doc(members.toString())
            .set(chatRoom.toJson());
      }
    }
  }


  Future addContact(String email) async {
    QuerySnapshot userEmail =await firestore
        .collection('users')
        .where('email',isEqualTo:email)
        .get();
        if(userEmail.docs.isNotEmpty){
          String userId=userEmail.docs.first.id;
          firestore.collection('users').doc(myUid).update({'my_users': FieldValue.arrayUnion([userId])});
        }
 }


  Future sendMessage(String uid, String msg, String roomId,ChatUser chatUser ,BuildContext context, {String? type}) async{
   String msgId = const Uuid().v1();
   Message message = Message(
       id: msgId,
       fromId: myUid,
       createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
       msg: msg,
       read: '',
       toId: uid,
       type: type ?? 'text'
   );
   await firestore
       .collection('rooms')
       .doc(roomId)
       .collection('messages')
       .doc(msgId)
       .set(message.toJson())
       .then((value) => sendNotification(chatUser: chatUser,context:context ,msg:type ?? msg ));;
   firestore.collection('rooms').doc(roomId).update(
       {
      'last_message': type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }



  Future sendGMessage(String msg, String groupId,BuildContext context,ChatGroup chatGroup,{String? type}) async{
    String msgId = Uuid().v1();
    List<ChatUser> chatUsers = [];
    chatGroup.members = chatGroup.members!.where((element) => element != myUid).toList();
    firestore
        .collection('users')
        .where('id',whereIn: chatGroup.members)
        .get()
        .then((value) => chatUsers.addAll(value.docs.map((e) => ChatUser.fromJson(e.data()))));
    Message message = Message(
        id: msgId,
        fromId: myUid,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        msg: msg,
        read: '',
        toId: '',
        type: type ?? 'text'
    );
    await firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(msgId)
        .set(message.toJson())
    .then((value) {
      for(var element in chatUsers){
        sendNotification(chatUser: element, context: context, msg: msg,groupName: chatGroup.name);
      }
    })
    ;

    firestore.collection('groups').doc(groupId).update(
        {
          'last_message': type ?? msg,
          'last_message_time': DateTime.now().millisecondsSinceEpoch.toString()
        });
  }



  Future readMessage(String roomId,String msgId) async {
   await firestore
       .collection('rooms')
       .doc(roomId)
       .collection('messages')
       .doc(msgId)
       .update(
       {'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future createGroup(String nane, List members) async {
   String gId = Uuid().v1();
   members.add(myUid);
   ChatGroup chatGroup = ChatGroup(
       id: gId,
       name: nane,
       image: '',
       members: members,
       admin: [myUid],
       lastMessage: '',
       lastMessageTime: now,
       createdAt: now,);
       await firestore.collection('groups').doc(gId).set(chatGroup.toJson());

  }

  deleteMsg(String roomId,List<String> msgs) async{
   if(msgs.length==1){
     firestore
         .collection('rooms')
         .doc(roomId)
         .collection('messages')
         .doc(msgs.first)
         .delete();
   }else{
   for (var element in msgs){
      firestore
         .collection('rooms')
         .doc(roomId)
         .collection('messages')
         .doc(element)
         .delete();
   };}

  }

  Future editGroup(String gId, String name, List members) async{
   await firestore.collection('groups').doc(gId).update({
     'name':name,
     'members':FieldValue.arrayUnion(members)});
  }

  Future removeMember(String gId,String memberId )async{
   await firestore.collection('groups').doc(gId).update({'members': FieldValue.arrayRemove([memberId])});
  }

  Future promptAdmin(String gId,String memberId)async{
   await firestore.collection('groups').doc(gId).update({'admins_id': FieldValue.arrayUnion([memberId])});
  }

  Future removeAdmin(String gId,String memberId)async{
   await firestore.collection('groups').doc(gId).update({'admins_id': FieldValue.arrayRemove([memberId])});
  }

  editProfile(String name,String about) async {
   await firestore.collection('users').doc(myUid).update({'name':name,'about':about});

  }

  sendNotification(
      {required ChatUser chatUser,required BuildContext context, required String msg, String? groupName})async{
   final header ={
     'Content-Type': 'application/json',
     'Authorization' :
     'key = eHKThi5SRNmuy8ohaLg_mA:APA91bEkAfOCpUdayryGeL9A8dx6iJg1xvn6QXbn0TSZdwMhkN6ahxn_yVje9ApqKdIC8RGC05YAeVhCqHNH3FxdfEBPSHTRfkhnzTGGaIUGhrYOJZ6YRftFrP4Mmi5uQTfDb7LQ9Y4x'
   };
   final body = {
     'to' : chatUser.pushToken,
     "notification":{
       "title": groupName == null
           ? Provider.of<ProviderApp>(context,listen: false).me!.name
           : groupName+" : "+" ${Provider.of<ProviderApp>(context,listen: false).me!.name} ",
       "body":msg,
     }
   };
   final req = await http.post(
       Uri.parse('https://fcm.googleapis.com/fcm/send'),
       body: jsonEncode(body),
       headers: header
   );
  }
}
