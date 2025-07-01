import 'package:flutter/material.dart';


class RoundedButton extends StatelessWidget {
  String title;
  Color color ;
  VoidCallback  onPressed;
   RoundedButton({
    super.key,
    required this.title,
    required this.color,
    required this.onPressed
      });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          minimumSize: Size(200, 50),
        ),
        onPressed: onPressed,
        child: Text(title,style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
