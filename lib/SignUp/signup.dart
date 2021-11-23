import 'package:app_chat/helper/helperfunctions.dart';
import 'package:app_chat/services/auth.dart';
import 'package:app_chat/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/chat_room/chatRoomScreen.dart';
import 'package:app_chat/services/database.dart';
class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();  

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){

    if (formKey.currentState!.validate()){
      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text
      };

      HelperFunctions.saveUserEmailsharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNamesharedPreference(userNameTextEditingController.text);
      //HelperFunctions.saveUserNamesharedPreference(userNameTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods.signUpwithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
            //print("${val.uid}");

        databaseMethods.upLoadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInsharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng ký" ,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
      ),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ):Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 150,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val){
                        return val!.isEmpty || val.length < 4 ? "Tên đăng nhập phải có ít nhất 4 ký tự" : null;
                      },
                      controller: userNameTextEditingController,
                      style: TextStyle(color: Colors.black),
                      decoration: textFieldInputDecoration("username"),
                    ),

                    TextFormField(
                      validator: (val){
                        return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!) ? null :"Email bạn nhập không đúng";
                      },
                      controller: emailTextEditingController ,
                      style: TextStyle(color: Colors.black),
                      decoration: textFieldInputDecoration("email"),
                    ),

                    TextFormField(
                      obscureText: true,
                      validator: (val){
                        return (val!.length) > 5 ? null: "Mật khẩu phải có ít nhất 6 ký tự";
                      },
                      controller: passwordTextEditingController,
                      style: TextStyle(color: Colors.black),
                      decoration: textFieldInputDecoration("password"),
                    ),
                  ],
                ),
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
                  signMeUp();
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
                    'Sign Up',
                    style: TextStyle( fontSize: 20,decoration:TextDecoration.none, fontWeight: FontWeight.bold ),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have account ?" ,style: TextStyle(color: Colors.black, fontSize: 16),),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Đăng nhập lun" ,
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
