import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/room_models.dart';
import 'package:chat_material3/widget/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../chat/widgets/chat_card.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  TextEditingController emailCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        showBottomSheet(
            context: context,
            builder: (context) { 
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text("Enter Friend Email",
                        style: Theme.of(context).textTheme.bodyLarge,),
                      const Spacer(),
                      IconButton.filled(
                          onPressed: () {

                          },
                          icon: const Icon(Iconsax.scan_barcode)
                      )
                    ],
                  ),
                  CustomField(label: "Email", icon: Iconsax.direct, controller: emailCon
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        ),
                        backgroundColor: Theme
                            .of(context)
                            .colorScheme
                            .primaryContainer,
                      ),
                      onPressed: (){
                        if(emailCon.text.isNotEmpty){
                          FireData().createRoom(emailCon.text).then((value) {
                            setState(() {
                              emailCon.text="";
                            }
                            );
                            Navigator.pop(context);
                          });
                        }

                      },
                      child: const Center(
                    child: Text("Create Chat"),))
                ],
              ),
            );},
        );
      },
      child: const Icon(Iconsax.message_add),),
      appBar: AppBar(
          title:const Text("Chats"),
      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .where('members',arrayContains: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ChatRoom> items = snapshot
                      .data!
                      .docs
                      .map((e) =>ChatRoom.fromJson(e.data()))
                      .toList()..sort((a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!),);
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ChatCard(item: items[index],);
                      }

                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
            ),
          )
        ],),
      ) ,
    );
  }
}


