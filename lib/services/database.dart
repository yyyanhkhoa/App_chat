import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserbyUsername(String username) async{
    return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();
  }
  getUserbyUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
  }

  upLoadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users")
        .add(userMap).catchError((e){
          print(e.toString());
    });
  }

  createChatRoom(String charRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(charRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId)
        .collection("chats").add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users",arrayContains: userName).snapshots();
  }


}