import 'package:flutter/material.dart';
import 'package:flash_chatt/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = FirebaseFirestore.instance;
late User loggedIn;

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";



  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  Timestamp timestamp = Timestamp.now();
  final _auth = FirebaseAuth.instance;
  late String messageText ;

  void getCurrentUser() async{
    try{
      final user  = await _auth.currentUser;
      loggedIn = user!;
    }catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessageStream(),

              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        style: TextStyle(
                          color: Colors.black
                        ),
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        _firestore.collection("messages").add(
                          {
                            "sender":loggedIn.email,
                            "text" : messageText,
                            "time":timestamp,
                          }
                        );
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: _firestore.collection("messages").snapshots(),
      builder: (context,snapshot){
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),

          );

        }
        List<MessageBubble>messageBubbles = [];
        if(snapshot.hasData){
          final messages = snapshot.data?.docs.reversed;
          for(var message in messages!){
            final messageText = message.data()['text'];
            final messageSender = message.data()["sender"];
            final currentUser = loggedIn.email;
            if(currentUser == messageSender){

            }
            final messageBubble =MessageBubble(sender: messageSender, text: messageText ,
            isMe: currentUser == messageSender);
            messageBubbles.add(messageBubble);
          }

        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {

  MessageBubble({required this.sender,required this.text , required this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),),
          Material(
            borderRadius:isMe? BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)) :BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)) ,
            elevation: 5,
            color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
              child: Text(
                "$text",
                style: TextStyle(
                  color: isMe ?  Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );;
  }
}
