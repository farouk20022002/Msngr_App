import 'package:chat_material3/firebase/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_material3/utils/colors.dart';
import 'package:iconsax/iconsax.dart';
import '../../widget/text_field.dart';

class SetupProfile extends StatefulWidget {
  const SetupProfile({super.key});

  @override
  State<SetupProfile> createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameCon = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        actions:[
          IconButton(
            onPressed:() async {
          await FirebaseAuth.instance.signOut();
        }
            ,icon:const Icon(Icons.logout))

        ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text("Welcome",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Please Enter your Name",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              CustomField(controller: nameCon ,label: "Name" ,icon: Iconsax.user ,),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if(nameCon.text.isNotEmpty) {
                      await FirebaseAuth
                          .instance
                          .currentUser!
                          .updateDisplayName(nameCon.text)
                          .then((value) { FireAuth.createUser();});

                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Center(
                      child: Text(
                        "Continue".toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black),
                      )
                  )
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}