import 'dart:io';

import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/firebase/fire_storage.dart';
import 'package:chat_material3/models/message_model.dart';
import 'package:chat_material3/screens/chat/widgets/chat_message_card.dart';
import 'package:chat_material3/utils/date_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model.dart';

class ChatScreen extends StatefulWidget {
final String roomId;
final ChatUser chatUser;
  const ChatScreen({
      super.key,
      required this.roomId,
      required this.chatUser
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgCon = TextEditingController();
  List<String> selectedMsg =[];
  List<String> copyMsg = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Column(
        children: [
          Text(widget.chatUser.name!),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(widget.chatUser.id).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Text(
                   snapshot.data!.data()!['online']? "OnLine"
                        :"Last seen ${MyDateTime.dateAndTime(widget.chatUser.lastActivated!)} at ${MyDateTime.timeDate(widget.chatUser.lastActivated!)}" ,
                  style:Theme.of(context).textTheme.labelLarge ,);
              }else{
return Container();
                }


            }
          )
        ],
      ),
      actions: [
        selectedMsg.isNotEmpty ?
        IconButton(
            onPressed: (){
          FireData().deleteMsg(widget.roomId, selectedMsg);
          setState(() {
            selectedMsg.clear();
            copyMsg.clear();
          });
        },
            icon: const Icon(Iconsax.trash)
        )
            : Container(),
        copyMsg.isNotEmpty ?
        IconButton(onPressed: (){
          Clipboard.setData(ClipboardData(text: copyMsg.join("\n")));
          setState(() {
            copyMsg.clear();
            selectedMsg.clear();
          });
        },
            icon: const Icon(Iconsax.copy))
            : Container(),
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
                          .collection('rooms')
                          .doc(widget.roomId)
                          .collection('messages')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          List<Message> messageItems = snapshot
                              .data!
                              .docs
                              .map((e) => Message
                              .fromJson(e.data()))
                              .toList()..sort((a, b) => b.createdAt!.compareTo(a.createdAt!),);
                          return messageItems.isNotEmpty?
                           ListView.builder(
                            itemCount: messageItems.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              String newDate = '';
                              bool  isSameDate = false;
                              if((index==0 && messageItems.length==1) || index == messageItems.length -1){
                                newDate=MyDateTime.dateAndTime(messageItems[index].createdAt.toString());
                              }else{
                                final DateTime date = MyDateTime.dateFormat(messageItems[index].createdAt.toString());
                                final DateTime  prDate = MyDateTime.dateFormat(messageItems[index+1].createdAt.toString());
                                isSameDate = date.isAtSameMomentAs(prDate);
                                newDate= isSameDate? "": MyDateTime.dateAndTime(messageItems[index].createdAt.toString());
                              }

                              return GestureDetector(
                                onTap: () {
                                        setState(() {
                                          selectedMsg.isNotEmpty
                                              ? selectedMsg.contains(
                                                      messageItems[index].id)
                                                  ? selectedMsg.remove(
                                                      messageItems[index].id)
                                                  : selectedMsg.add(
                                                      messageItems[index].id!)
                                              : null;
                                          copyMsg.isNotEmpty
                                          ? messageItems[index].type == 'text'
                                              ? copyMsg.contains(messageItems[index].msg)
                                              ?  copyMsg.remove(messageItems[index].msg)
                                              : copyMsg.add(messageItems[index].msg!)
                                              : null
                                          : null;
                                        });
                                      },
                                onLongPress: () {
                                  setState(() {
                                    selectedMsg.contains(messageItems[index].id)
                                    ? selectedMsg.remove(messageItems[index].id)
                                    : selectedMsg.add(messageItems[index].id!);
                                    messageItems[index].type == 'text'?
                                    copyMsg.contains(messageItems[index].msg)
                                    ?  copyMsg.remove(messageItems[index].msg)
                                        : copyMsg.add(messageItems[index].msg!)
                                        : null;
                                  });
                                },
                                child: Column(
                                  children: [
                                    if(newDate!="")
                                      Center(
                                        child: Text(newDate),
                                      ),
                                    ChatMessageCard(
                                      index: index,
                                      messageItem: messageItems[index],
                                      roomId: widget.roomId,
                                      selected: selectedMsg.contains(messageItems[index].id),
                                    ),
                                  ],
                                ),
                              );

                            },


                          ) :
                          Center(
                            child: GestureDetector(
                              onTap:()=> FireData().sendMessage(
                                  widget.chatUser.id!,
                                  "Say Hello 👋 ",
                                  widget.roomId,
                                  widget.chatUser,
                                  context
                              ),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "👋",
                                        style: Theme.of(context).textTheme.displayLarge,),
                                      const SizedBox(height: 16,),
                                      Text(
                                          "Say Hello",
                                          style: Theme.of(context).textTheme.displayMedium
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }return Container();

                      }
                    ),
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
                            IconButton(onPressed: (){}, icon: const Icon(Iconsax.emoji_happy),
                            ),
                            IconButton(
                                onPressed: ()async{
                              ImagePicker picker = ImagePicker();
                              XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if(image!=null){
                                FireStorage().sendImage(
                                   file: File(image.path),
                                   roomId: widget.roomId,
                                   uid: widget.chatUser.id!,
                                  context:context ,
                                  chatUser:widget.chatUser
                               );
                              }
                            }, icon: const Icon(Iconsax.camera)
                            )

                          ],),
                            border: InputBorder.none,
                        hintText: "Message",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,vertical: 10
                        )
                        ),
                      ),
                    ),
                  ),
                    IconButton.filled(onPressed: (){
                      if(msgCon.text.isNotEmpty){
                        FireData().sendMessage(widget.chatUser.id!, msgCon.text, widget.roomId,widget.chatUser,context).then((value) {

                        setState(() {
                          msgCon.text="";
                        }); });
                      }

                    },
                        icon: const Icon(Iconsax.send_1))
                ],)
                ]),
        ),
      ) ,
    );
  }
}

