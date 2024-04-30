import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/group_model.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/screens/group/widget/group_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupMemberScreen extends StatefulWidget {
  final ChatGroup chatGroup;
  const GroupMemberScreen({super.key, required this.chatGroup});

  @override
  State<GroupMemberScreen> createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  @override
  Widget build(BuildContext context) {
   String myId = FirebaseAuth.instance.currentUser!.uid;
    bool isAdmin = widget.chatGroup.admin!.contains(FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text("Group members"),
        actions: [
          isAdmin ?
          IconButton(onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditGroupScreen(chatGroup: widget.chatGroup,)));
          }, icon: Icon(Iconsax.user_edit),)
              : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').where('id',whereIn: widget.chatGroup.members).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List<ChatUser> userList = snapshot
                        .data!
                        .docs
                        .map((e) => ChatUser.fromJson(e.data()))
                        .toList();
                    return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                    bool admin = widget.chatGroup.admin!.contains(userList[index].id);
                        return ListTile(
                          title: Text(userList[index].name!),
                          subtitle: admin? Text("Admin", style: TextStyle(color:  Colors.green),) : Text("Member"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isAdmin && myId!=userList[index].id
                                  ?  IconButton(
                                  onPressed: (){
                                    FireData().removeMember(widget.chatGroup.id!, userList[index].id!).then((value) {
                                      setState(() {
                                        widget.chatGroup.members!.remove(userList[index].id!);
                                      });
                                    });
                                  },
                                  icon: Icon(Iconsax.trash)
                              )
                                  : Container(),
                              isAdmin ?IconButton(
                                  onPressed: (){
                                    admin
                                    ? FireData().removeAdmin(widget.chatGroup.id!, userList[index].id!).then((value) {
                                      setState(() {
                                        widget.chatGroup.admin!.remove(userList[index].id);
                                      });
                                    })
                                    : FireData().promptAdmin(widget.chatGroup.id!, userList[index].id!).then((value) {
                                      setState(() {
                                        widget.chatGroup.admin!.remove(userList[index].id);
                                      });
                                    });
                                  }, icon: Icon(Iconsax.user_tick))
                                  : Container(),
                            ],),);});} else{return Container();
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}