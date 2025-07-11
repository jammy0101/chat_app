import 'package:chat_app/RoundedButtons/roundedButton.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String  id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}


class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email;
  late String password;
  bool loading = false;
   final FirebaseAuth auth = FirebaseAuth.instance;
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
                email = value;
              },
              decoration: KEmailTextFieldDecoration.copyWith(hintText: 'Enter the Email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
               password = value;
              },
              decoration: KPasswordTextFieldDecoration,
            ),
            SizedBox(
              height: 24.0,
            ),
           loading ? Center(child: CircularProgressIndicator()) : RoundedButton(
                title: 'Register',
                color: Colors.blueAccent,
                onPressed: ()async{
                  try{
                   setState(() {
                     loading = true;
                   });
                    final  newUser  = await  auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password
                    );
                    if(newUser != null){
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
