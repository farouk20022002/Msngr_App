import 'package:chat_material3/firebase/fire_auth.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderApp with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  int mainColor = 0xff405085;
  ChatUser? me;


  getUserDetails()async{
  String myId = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore
      .instance
      .collection('users')
      .doc(myId)
      .get()
      .then((value) => me = ChatUser.fromJson(value.data()!));
      notifyListeners();
      FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.getToken().then((value) {
        if(value != null){
          me!.pushToken=value;
          FireAuth().getToken(value);
        }
      });
      notifyListeners();
  }


  changeMode(bool dark)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
 themeMode =   dark? ThemeMode.dark : ThemeMode.light;
 sharedPreferences.setBool('dark', themeMode == ThemeMode.dark);
  notifyListeners();
}


changeColor(int c) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    mainColor = c;
  sharedPreferences.setInt('color', mainColor);
    notifyListeners();
}

getValuesPref() async{
final   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
bool isDark = sharedPreferences.getBool('dark') ?? false;
themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
mainColor = sharedPreferences.getInt('color') ?? 0xff405085;
notifyListeners();
}
}