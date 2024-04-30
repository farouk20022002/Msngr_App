import 'package:chat_material3/models/group_model.dart';
import 'package:chat_material3/screens/group/group_screen.dart';
import 'package:flutter/material.dart';

import 'package:chat_material3/screens/chat/chat_screen.dart';

class GroupCard extends StatelessWidget {
  final ChatGroup chatGroup;
  const GroupCard({
    super.key, required this.chatGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context)=> GroupScreen(chatGroup: chatGroup,),),),
        leading: CircleAvatar(
          child: Text(chatGroup.name!.characters.first),
        ),
        title: Text(chatGroup.name!),
        subtitle: Text(chatGroup.lastMessage! == ''? "send first msg":chatGroup.lastMessage!,maxLines: 1,),
        trailing: Text(chatGroup.lastMessageTime!)
      ),
    );
  }
}