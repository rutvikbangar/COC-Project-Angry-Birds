import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

const textInputDecoration = InputDecoration(
 labelStyle: TextStyle(color: Colors.black,fontWeight:FontWeight.w400),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color:Color(0xFF503599),width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF503599),width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color:Color(0xFF503599),width: 2),
  ),
);

void nextScreen(context, page) {
  Navigator.push(context, PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0); // Animation starts from right
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  ));
}

void nextScreenReplace(context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> page));

}
void fadescreen(context, page){
  Get.to(() => page,transition:Transition.fade,duration:const Duration(seconds: 1));

}

void showSnackbar(context, color, message){
 ScaffoldMessenger.of(context).showSnackBar(SnackBar
   (content: Text(message, style: TextStyle(fontSize: 14),),
     backgroundColor: color,duration: Duration(seconds: 2),
     action : SnackBarAction(label: "ok", onPressed:(){},)));
}
class routes{
  static String medicationRoute = "/medication";

}