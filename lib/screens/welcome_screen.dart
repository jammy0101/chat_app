import 'package:chat_app/RoundedButtons/roundedButton.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
class WelcomeScreen extends StatefulWidget {
  static const String  id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
      //upperBound: 100.0
    );

    animation = ColorTween(begin: Colors.red, end: Colors.brown).animate(controller);

    // animation = CurvedAnimation(
    //     parent: controller,
    //     curve: Curves.bounceOut,
    // );
    // animation.addStatusListener((status){
    //   if(status == AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   }else if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });
    controller.forward();
    controller.addListener((){
      setState(() {

      });
      print(animation.value);
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                title: 'Log In',
                color: Colors.lightBlueAccent,
                onPressed: (){
                  Navigator.pushNamed(context, LoginScreen.id);
                }
            ),
            RoundedButton(
                title: 'Register',
                color: Colors.blueAccent,
                onPressed: (){
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }
            ),
          ],
        ),
      ),
    );
  }
}
