import 'package:chat_material3/screens/auth/forget_screen.dart';
import 'package:chat_material3/screens/auth/setup_profile.dart';
import 'package:chat_material3/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../widget/logo.dart';
import '../../widget/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailcon = TextEditingController();
    TextEditingController passcon = TextEditingController();
    final formKey = GlobalKey<FormState>();
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
                "Welcome Back",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Chat APP",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomField(
                      controller: emailcon,
                      label: "Email",
                      icon: Iconsax.direct,
                    ),
                    CustomField(
                      controller: passcon,
                      label: "Password",
                      icon: Iconsax.password_check,
                      isPass: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          child: const Text("Forget Password ?"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetScreen(),
                                ));
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailcon.text,
                                    password: passcon.text)
                                .then((value) => print("Done Login"))
                                .onError((error, stackTrace) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(error.toString()),
                              ));
                            });
                          }
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
                    OutlinedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailcon.text, password: passcon.text)
                              .then((value) => print("ok created "))
                              .onError((error, stackTrace) {
                            print(
                                " not created ");
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())));
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SetupProfile(),
                              ),
                              (route) => false);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.all(16),
                        ),
                        child: Center(
                            child: Text(
                          "Create Account".toUpperCase(),
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onPrimary),
                        )
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
