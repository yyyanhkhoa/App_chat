import 'package:app_chat/helper/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_chat/chat_room/chatRoomScreen.dart';

import 'chat_room/search.dart';
import 'helper/helperfunctions.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

//void main() => runApp(MyApp());

//#state management
class MyApp extends StatefulWidget {
  static final String title = 'App chat (SE346)';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInsharedPreference().then((value){
      setState((){
        userIsLoggedIn = value! ;
      });
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: MyApp.title,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: userIsLoggedIn ? ChatRoom(): Authenticate() ,
  );
}

