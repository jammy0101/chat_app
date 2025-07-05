import 'package:chat_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? loggedInUser;
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
      });
      print(data);
    }catch(e){
      print('Error $e');
    }
  }

  // void getMessages()async{
  //   try{
  //     final messages = await firestore.collection('messages').get();
  //     for(var message in messages.docs){
  //       print(message.data());
  //     }
  //   }catch(e){
  //     print('Error : $e');
  //   }
  // }

  void messageStream()async{
    await for(var snapshot in firestore.collection('messages').snapshots()){
      for(var message in snapshot.docs){
              print(message.data());
            }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false);
              // getMessages();
              messageStream();
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('messages').snapshots(),
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
                  List<Text> messageWidgets = [];

                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageSender = message['sender'];
                    final messageWidget = Text('$messageText from $messageSender');
                    messageWidgets.add(messageWidget);
                  }

                  return ListView(
                    padding: EdgeInsets.all(8),
                    children: messageWidgets,
                  );
                },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: kMessageTextFieldDecoration
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        putMessages();
                      },
                      child: Text('Send',
                          style: kSendButtonTextStyle
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
