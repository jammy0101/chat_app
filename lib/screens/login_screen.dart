import 'package:chat_app/RoundedButtons/roundedButton.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class LoginScreen extends StatefulWidget {
  static const String  id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration: KEmailTextFieldDecoration,
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: KPasswordTextFieldDecoration,
            ),
            SizedBox(
              height: 24.0,
            ),
          loading ? Center(child: CircularProgressIndicator()) : RoundedButton(
               title: 'Log In',
               color: Colors.lightBlueAccent,
               onPressed: ()async{
                 // Your logic
                 try{
                   setState(() {
                     loading = true;
                   });
                  final user = await  auth.signInWithEmailAndPassword(
                       email: email,
                       password: password
                   );
                  if(user != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }

                 }catch(e){
                   print(e);
                 }finally{
                   setState(() {
                     loading = false;
                   });
                 }
               }
           ),
          ],
        ),
      ),
    );
  }
}
