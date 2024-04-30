import 'package:chat_material3/models/group_model.dart';
import 'package:chat_material3/screens/group/create_group.dart';
import 'package:chat_material3/screens/group/widget/group_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupHomeScreen extends StatefulWidget {
  const GroupHomeScreen({super.key});

  @override
  State<GroupHomeScreen> createState() => _GroupHomeScreenState();
}

class _GroupHomeScreenState extends State<GroupHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        Navigator
            .push(context, MaterialPageRoute(
          builder: (context) =>
              CreateGroupScreen(),
        )
        );
      },
      child: Icon(Iconsax.message_add_1),
      ),
      appBar: AppBar(
          title:Text("Groups")
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore
                      .instance
                      .collection('groups')
                      .where('members',arrayContains: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      List<ChatGroup> items = snapshot
                          .data!
                          .docs
                          .map((e) => ChatGroup.fromJson(e.data()))
                          .toList()
                        ..sort((a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!),);
                      return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context,index){
                            return GroupCard(chatGroup: items[index],);
                          });
                    }
                    else{
                      return Container();
                    }

                  }
                ))
          ],
        ),
      ),
    );
  }
}
