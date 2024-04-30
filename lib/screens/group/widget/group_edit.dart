import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/group_model.dart';
import 'package:chat_material3/widget/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/user_model.dart';

class EditGroupScreen extends StatefulWidget {
  final ChatGroup chatGroup;
  const EditGroupScreen({super.key, required this.chatGroup});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  TextEditingController gNameCon = TextEditingController();
  List members = [];
  List myContacts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gNameCon.text = widget.chatGroup.name!;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton:FloatingActionButton.extended(
        onPressed: (){
          FireData()
              .editGroup(widget.chatGroup.id!, gNameCon.text, members)
              .then((value) => Navigator.pop(context));
        },
        label: Text("Done"),
        icon: Icon(Iconsax.tick_circle),) ,
      appBar:AppBar(
        title: Text("Edit Group"),
      ) ,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 40,
                        ),
                        Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.add_a_photo))
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: CustomField(
                        controller:gNameCon,
                        icon:Iconsax.user_octagon,
                        label: "Group Name",),
                    ),
                  )]
            ),
            SizedBox(
              height: 16,
            ),
            Divider(),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(" Add Members"),
                Spacer(),
                Text(members.length.toString())
              ],
            ),
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),

                    builder: (context, snapshot) {

                      if(snapshot.hasData){
                        myContacts = snapshot.data!.data()!['my_users'];
                        return StreamBuilder(
                            stream: FirebaseFirestore
                                .instance
                                .collection('users')
                                .where('id',whereIn: myContacts.isEmpty ? ['']: myContacts )
                                .snapshots(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                final List<ChatUser> items = snapshot
                                    .data!
                                    .docs
                                    .map((e) => ChatUser.fromJson(e.data()))
                                    .where((element) => element.id != FirebaseAuth.instance.currentUser!.uid)
                                    .where((element) => !widget.chatGroup.members!.contains(element.id))
                                    .toList()..sort((a, b) => a.name!.compareTo(b.name!),);
                                return ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context,index){
                                      return  CheckboxListTile(
                                        checkboxShape: CircleBorder(),
                                        title: Text(items[index].name!),
                                        value: members.contains(items[index].id),
                                        onChanged: (value){
                                          setState(() {
                                            if(value!){
                                              members.add(items[index].id!);
                                            }
                                            else{
                                              members.remove(items[index].id!);
                                            }
                                            print(members);
                                          });
                                        },);
                                    }
                                );
                              }else{
                                return Container();
                              }

                            }
                        );}
                      else{
                        return Container();
                      }
                    }
                )
            )
          ],
        ),
      ),
    );
  }
}
