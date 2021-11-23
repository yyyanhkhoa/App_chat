import 'package:app_chat/chat_room/conversation_screen.dart';
import 'package:app_chat/chat_room/search.dart';
import 'package:app_chat/helper/authenticate.dart';
import 'package:app_chat/helper/helperfunctions.dart';
import 'package:app_chat/services/auth.dart';
import 'package:app_chat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/helper/constant.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream? chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return ChatRoomTile(
                snapshot.data.docs[index]["chatroomId"]
                    .toString().replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                snapshot.data.docs[index]["chatroomId"]
              );
            }): Container();
      }, 
    );
  }

  @override
  void  initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    Constants.myName = (await HelperFunctions.getUserNamesharedPreference()) as String;
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState((){
        chatRoomsStream = value ;
      });
    });
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("images/uit.png",height: 50,),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app )),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoom;
  ChatRoomTile(this.userName,this.chatRoom);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoom)
        ));
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",
                style: TextStyle(color: Colors.black,fontSize: 20),),
            ),
            SizedBox(width: 8,),
            Text(userName, style: TextStyle(color: Colors.black,fontSize: 20),)
          ],
        ),

      ),
    );
  }
}



