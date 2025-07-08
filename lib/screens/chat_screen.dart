import 'package:chat_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
final FirebaseFirestore firestore = FirebaseFirestore.instance;
User? loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser()async{
    try{
      final user = await auth.currentUser;
      if(user!=null){
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    }catch(e){
      print(e);
    }
  }

  void putMessages()async{
    try{
      final data = await  firestore.collection('messages').add({
        'text' : messageText,
        'sender' : loggedInUser!.email,
        'timestamp': FieldValue.serverTimestamp(),

      });
      print(data);
    }catch(e){
      print('Error $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false);
            },),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller : messageTextController,
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: kMessageTextFieldDecoration
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        messageTextController.clear();
                        putMessages();
                      },
                      child: Text('Send',
                          style: kSendButtonTextStyle,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return   Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loader when waiting for data
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Show message when there is no chat data
            return Center(child: Text('No messages yet'));
          }
          final messages = snapshot.data!.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message['text'];
            final messageSender = message['sender'];

            final currentUser = loggedInUser!.email;
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            children: messageBubbles,
          );
        },
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  const MessageBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(

        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(fontSize: 12,color: Colors.black45),),
          Material(
            elevation: 6.0,
            color: isMe  ? Colors.lightBlueAccent : Colors.white,
            borderRadius: isMe ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : BorderRadius.only( bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
              child: Text(
                text,style: TextStyle(color: isMe ? Colors.white : Colors.black54,fontSize: 19),
              ),
            ),
          ),
        ],
      )
    );
  }
}
