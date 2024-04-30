import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/message_model.dart';
import 'package:chat_material3/utils/date_time.dart';
import 'package:chat_material3/utils/photp_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ChatMessageCard extends StatefulWidget {
  final int index;
  final Message messageItem;
  final String roomId;
  final bool selected;
  const ChatMessageCard({
    super.key, required this.index, required this.messageItem, required this.roomId, required this.selected,
  });

  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
  @override
  void initState() {
    // TODO: implement initState
    if(widget.messageItem.toId==FirebaseAuth.instance.currentUser!.uid){
      FireData().readMessage(widget.roomId, widget.messageItem.id!);
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    bool isMe = widget.messageItem.fromId==FirebaseAuth.instance.currentUser!.uid;
    return Container(
      decoration: BoxDecoration(
          color: widget.selected ? Colors.grey: Colors.transparent,
          borderRadius: BorderRadius.circular(12)
      ),
      margin:const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end: MainAxisAlignment.start,
        children: [
          isMe ? IconButton(onPressed: () {},
              icon: const Icon(Iconsax.message_edit)
          ):
          const SizedBox(),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isMe ? 16 :0),
                    bottomRight: Radius.circular(isMe ? 0:16),
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16)
                )
            ),
            color: isMe ? Theme.of(context).colorScheme.background:
            Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width/2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.messageItem.type == 'image'
                        ? GestureDetector(
                         onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoViewScreen(img: widget.messageItem.msg!))),
                          child: Container(
                            child: CachedNetworkImage(
                              imageUrl: widget.messageItem.msg!,
                              placeholder: (context,url){
                              return Container(
                                height: 100,
                              );
                                                },
                                                ),
                                              ),
                        ):
                    Text(widget.messageItem.msg!),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        isMe ?  Icon(
                          Iconsax.tick_circle,
                          size: 18,
                          color: widget.messageItem.read ==""
                              ? Colors.red
                              : Colors.green,
                        ):
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                         MyDateTime.timeDate(widget.messageItem.createdAt!),

                          style: Theme.of(context).textTheme.labelSmall,),

                      ],
                    )],
                ),
              ),
            ),
          ),

        ],),
    );
  }
}
