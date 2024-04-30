import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/screens/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactCard extends StatelessWidget {
  final ChatUser user;
  const ContactCard({
    super.key, required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.name!),
        leading: const CircleAvatar(),
        trailing: IconButton(
          onPressed: (){
            List<String> members = [ user.id!,FirebaseAuth.instance.currentUser!.uid]
                ..sort((a, b) => a.compareTo(b),);
            FireData().createRoom(user.email!).then((value) =>
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ChatScreen(roomId: members.toString(), chatUser: user),)
                )
            );

          },
          icon: const Icon(Iconsax.message),
        ),
        subtitle: Text(user.about!,maxLines: 1,),
      ),
    );
  }
}
