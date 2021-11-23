import 'package:app_chat/chat_room/chatRoomScreen.dart';
import 'package:app_chat/helper/helperfunctions.dart';
import 'package:app_chat/services/auth.dart';
import 'package:app_chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_chat/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//bool checkEmail = true ;
class SignIn extends StatefulWidget{
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn>{
  bool signInCheck = false ;
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods() ;
  bool isLoading = false ;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  late QuerySnapshot snapshotUserInfo ;

  signIn(){
    if (formKey.currentState!.validate()){
      HelperFunctions.saveUserEmailsharedPreference(emailTextEditingController.text);

      databaseMethods.getUserbyUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val ;
        HelperFunctions.saveUserNamesharedPreference(snapshotUserInfo.docs[0]["name"]);
      });

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text)
      .then((val){
       if (val != null){
         databaseMethods.getUserbyUserEmail(emailTextEditingController.text);
         signInCheck = true ;
         HelperFunctions.saveUserLoggedInsharedPreference(true);
         Navigator.pushReplacement(context, MaterialPageRoute(
             builder: (context) => ChatRoom()
         ));
       }
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("App chat (SE346)" ,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              new Image.asset('images/uit.png'),
              Form(
                key: formKey ,
                child: Column(children: [
                  TextFormField(
                    validator: (val) {
                      if (signInCheck == true)
                        return "Email hoặc mật khẩu bạn nhập không đúng";
                      else {
                        return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!) ? null :"Email hoặc mật khẩu bạn nhập không đúng";
                        };
                    },
                    controller: emailTextEditingController,
                    style: TextStyle(color: Colors.black),
                    decoration: textFieldInputDecoration("email"),
                  ),
                  TextFormField(
                    validator: (val){
                      return (val!.length) > 5 ? null: "Mật khẩu bạn nhập không đúng";
                    },
                    controller: passwordTextEditingController,
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    decoration: textFieldInputDecoration("password"),
                  ),
                ],),
              ),
              SizedBox(height: 8),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('Forgot Password?',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              SizedBox(height: 8),

              //Button signIn
              GestureDetector(
                onTap: (){
                  signIn() ;
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 12),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child : Text(
                    'Sign In',
                    style: TextStyle( fontSize: 20,decoration:TextDecoration.none, fontWeight: FontWeight.bold, color: Colors.white ),
                  ),
                ),
              ),
              SizedBox(height: 8,),

          // SignIn With google
              GestureDetector(
                onTap: (){
                  widget.toggle();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child : Text(
                    'Sign in with Google',
                    style: TextStyle( fontSize: 20,decoration:TextDecoration.none, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account ?" ,style: TextStyle(color: Colors.black, fontSize: 16),),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Đăng ký ngay" ,
                        style: TextStyle(color: Colors.blue, fontSize: 16,
                            decoration: TextDecoration.underline
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
            ], //Children
          ),
        ),
      ),
    );
  }
}
