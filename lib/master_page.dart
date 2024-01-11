import 'package:chatme/pages/homepage.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:flutter/material.dart';

class MasterPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      body: Center(child: ElevatedButton(
        child: Text("welcome to homepage"),
        onPressed: (){
          nextScreen(context, Homepage());
        },
      ),),

    );
  }

}