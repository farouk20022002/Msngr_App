import 'package:chat_material3/models/room_models.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/utils/date_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/message_model.dart';
import '../chat_screen.dart';

class ChatCard extends StatelessWidget {
  final ChatRoom item;
  const ChatCard({
    super.key, required this.item,
  });

  @override
  Widget build(BuildContext context) {
    List member = item
        .members!
        .where((element) => element != FirebaseAuth.instance.currentUser!.uid)
        .toList();
    String userId = member
        .isEmpty
        ? FirebaseAuth
        .instance
        .currentUser!
        .uid
        : member
        .first;


    return StreamBuilder(
      stream: FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {

        if(snapshot.hasData) {
          ChatUser chatUser=ChatUser.fromJson(snapshot.data!.data()!);
          return Card(
            child: ListTile(
              onTap: () =>
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(roomId: item.id!,chatUser: chatUser,),),),
              leading:chatUser.image=="" ? CircleAvatar( ): CircleAvatar(backgroundImage: NetworkImage(chatUser.image!),),
              title: Text(chatUser.name!),
              subtitle: Text(
                  item.lastMessageTime! == ""
                      ? chatUser.about!
                      : item.lastMessage!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: StreamBuilder(stream: FirebaseFirestore
                  .instance
                  .collection('rooms')
                  .doc(item.id)
                  .collection('messages')
                  .snapshots(),
                  builder: (context, snapshot) {
                           final unReadList = snapshot
                               .data?.docs
                               .map((e) => Message
                               .fromJson(e.data()))
                               .where((element)=> element.read =="")
                           .where((element) => element.fromId != FirebaseAuth.instance.currentUser!.uid) ?? [];
                            return unReadList.length!=0
                                ? Badge(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12
                              ),
                                  label: Text(unReadList.length.toString()),
                                  largeSize: 30,
                                       )
                                : Text(
                              MyDateTime.dateAndTime(item.lastMessageTime!).toString()
                            );
                           },)
            ),
          );
        }
        else{
          return Container();
        }
      }
    );
  }
}
