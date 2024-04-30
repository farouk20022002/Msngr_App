import 'package:chat_material3/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../widget/logo.dart';
import '../../widget/text_field.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailcon = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const LogoApp(),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Reset Password",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Please Enter your Email",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              CustomField(
                controller: emailcon,
                label: "Email",
                icon: Iconsax.direct,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailcon.text)
                        .then((value) {
                      Navigator.pop(context);
                      return ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Email sentt check ur Email")));
                    }).onError((error, stackTrace) =>
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString()))));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Center(
                      child: Text(
                    "Login".toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ))),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
