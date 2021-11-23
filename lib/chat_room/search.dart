import 'package:app_chat/helper/constant.dart';
import 'package:app_chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'conversation_screen.dart';
import 'package:app_chat/modal/user.dart';
import 'package:app_chat/widgets.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

bool pressCheck = false ;

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods() ;
  TextEditingController searchtextEditingController = new TextEditingController();

  QuerySnapshot? searchSnapshot ;

  Widget searchList(){
    if (searchSnapshot != null) {
      return ListView.builder(
        itemCount: searchSnapshot!.docs.length ,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return SearchTile(
            userName: searchSnapshot!.docs[index]["name"],
            userEmail: searchSnapshot!.docs[index]["email"],
          );
        });
    } else return Container();

  }

  initiateSearch(){
    databaseMethods.getUserbyUsername(searchtextEditingController.text)
        .then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  // create chatRoom, send user to ConversationScreen
  createChatRoomAndStartConversation({required String userName}){
    print("${Constants.myName}");
    if (userName != Constants.myName){

      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName,Constants.myName];
      Map<String, dynamic> charRoomMap = {
        "users" : users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId,charRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>  ConversationScreen(
              chatRoomId
          )
      ));
    } else {
      print("Bạn không thể gửi tin nhắn cho chính mình");
    }
  }

  // danh sach tim kiem
  Widget SearchTile({required String userName, required String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: TextStyle(color: Colors.black,fontSize: 20),),
              Text(userEmail,style: TextStyle(color: Colors.black,fontSize: 20),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(
                  userName: userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text("Nhắn tin",style: TextStyle(color: Colors.black,fontSize: 20)),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset("images/uit.png",height: 50,),),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black12,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchtextEditingController ,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Nhập tên người dùng...",
                          hintStyle: TextStyle(
                            color: Colors.black
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      pressCheck = true ;
                      initiateSearch();
                    },
                    child: Container(
                        height: 40 ,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(2),
                        child: Image.asset("images/search.png",height: 50,)),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b){
  if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else {
    return "$a\_$b";
  }
}


