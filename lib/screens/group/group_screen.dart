import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/group_model.dart';
import 'package:chat_material3/models/message_model.dart';
import 'package:chat_material3/screens/chat/widgets/chat_message_card.dart';
import 'package:chat_material3/screens/group/widget/group_member.dart';
import 'package:chat_material3/screens/group/widget/group_mesage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupScreen extends StatefulWidget {
  final ChatGroup chatGroup;
  const GroupScreen({super.key, required this.chatGroup});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  TextEditingController msgCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(widget.chatGroup.name!),
          StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection('users')
                .where('id', whereIn: widget.chatGroup.members)
                .snapshots(),
            builder: (context, snapshot) {
              List membersName = [];
              for(var e in snapshot.data!.docs){
                membersName.add(e.data()['name']);
              }
            if(snapshot.hasData){
              return Text(membersName.join(' , '),
                style:Theme.of(context).textTheme.labelLarge ,);
            }
              return Container();
            }
          )
        ],
      ),
      actions: [

        IconButton(onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => GroupMemberScreen(chatGroup: widget.chatGroup,)
              )
          );
        },
            icon: Icon(Iconsax.user)),
        // IconButton(onPressed: (){}, icon: Icon(Iconsax.copy)),
      ],
    ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children:[
                Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore
                            .instance
                            .collection('groups')
                            .doc(widget.chatGroup.id!)
                            .collection('messages')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            final List<Message> msgs = snapshot
                                .data!
                                .docs
                                .map((e) => Message.fromJson(e.data()))
                                .toList()
                              ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                            if(msgs.isEmpty){
                              return  Center(
                                child: GestureDetector(
                                  onTap: () => FireData().sendGMessage("👋 Hello", widget.chatGroup.id!,context,widget.chatGroup),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("👋",
                                            style: Theme.of(context).textTheme.displayLarge,
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Text("Say Hello",
                                              style: Theme.of(context).textTheme.displayMedium
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ) ;

                            }
                            else{
                              return ListView.builder(
                                itemCount: msgs.length,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  return GroupMessageCard(
                                    message: msgs[index],
                                    index: index,);},
                              );
                            }


                          }
                          else{
                           return Container();
                          }
                        }
                      )
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: TextField(
                          controller: msgCon,
                          maxLines: 2,
                          minLines: 1,
                          decoration:InputDecoration(
                              suffixIcon: Row(
                                mainAxisAlignment : MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: (){},
                                    icon: Icon(Iconsax.emoji_happy),
                                  ),
                                  IconButton(
                                      onPressed: (){},
                                      icon: Icon(Iconsax.camera)
                                  )
                                ],),
                              border: InputBorder.none,
                              hintText: "Message",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,vertical: 10
                              )
                          ),
                        ),
                      ),
                    ),
                    IconButton.filled(onPressed: (){
                      if(msgCon.text.isNotEmpty){
                        FireData().sendGMessage(msgCon.text, widget.chatGroup.id!,context,widget.chatGroup).then((value) {
                          setState(() {
                            msgCon.text='';
                          });
                        });
                      }
                      else{
                        Container();
                      }
                    },
                        icon: Icon(Iconsax.send_1))
                  ],)
              ]),
        ),
      ) ,
    );
  }
}

