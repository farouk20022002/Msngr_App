import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/screens/contact/contact_card.dart';
import 'package:chat_material3/widget/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactHomeScreen extends StatefulWidget {
  const ContactHomeScreen({super.key});
  @override
  State<ContactHomeScreen> createState() => _ContactHomeScreenState();
}

class _ContactHomeScreenState extends State<ContactHomeScreen> {
  bool searched = false;
  List myContacts = [];
  TextEditingController searchCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();

  // getMyContact() async {
  //   final contact = await FirebaseFirestore
  //       .instance
  //       .collection('users')
  //       .doc(FirebaseAuth
  //       .instance
  //       .currentUser!
  //       .uid)
  //       .get()
  //       .then((value) => myContacts=value.data()!['my_users']);
  //   print(myContacts);
  // }
  // @override
  //
  // void initState() {
  //   // TODO: implement initState
  //   getMyContact();
  //   super.initState();
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [searched?
          IconButton(onPressed: (){
            setState(() {
              searched = false;
              searchCon.text="";
            });
          }, icon: Icon(Iconsax.close_circle))
        :IconButton(onPressed: (){
          setState(() {
            searched = true;
          });
        }, icon: Icon(Iconsax.search_normal))],
          title:searched?
              Row(children:[
                Expanded(
                    child : TextField(
                  onChanged: (value) {
                    setState(() {
                      searchCon.text=value;
                    });
                  },
                  autofocus: true,
                  controller: searchCon,
                  decoration : InputDecoration(
                    hintText:"Search by Name",
                    border: InputBorder.none,
                  )
                ))
              ])
              :Text("My Contact"),
      ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          showBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text("Enter Friend Email", style: Theme.of(context).textTheme.bodyLarge,),
                        Spacer(),
                        IconButton.filled(onPressed: () {}, icon: Icon(Iconsax.scan_barcode))
                      ],
                    ),
                    CustomField(label: "Email",
                        icon: Iconsax.direct,
                        controller: emailCon
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        onPressed: (){
                          FireData().addContact(emailCon.text).then((value) {
                            setState(() {
                              emailCon.text="";
                            });
                          });
                        },
                        child: Center(
                          child: Text("Add Contact"),))
                  ],
                ),
              );},
          );
        },
          child: const Icon(Iconsax.user_add),),
      body: Column(children: [
        Expanded(child: StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),

          builder: (context, snapshot) {

            if(snapshot.hasData){
              myContacts = snapshot.data!.data()!['my_users'] ?? [];
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
                        .where((element) => element.name!.toLowerCase()
                        .startsWith(searchCon.text.toLowerCase()))
                        .toList()..sort((a, b) => a.name!.compareTo(b.name!),);
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context,index){
                          return ContactCard(
                            user: items[index],);
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
      ],),
    );
  }
}

