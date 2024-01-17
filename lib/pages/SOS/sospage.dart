import 'package:chatme/master_page.dart';
import 'package:chatme/shared/constant.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class SosPage extends StatefulWidget{
  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  String number = "" ;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text("SOS",style: TextStyle(color: Colors.white),),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text("Call number",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
          onPressed: () {
            popUpDialog(context);
          },
          backgroundColor: Colors.redAccent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
          
               margin: EdgeInsets.only(left: 85,right: 70,top: 50),
                  child: Text("Emergency Call Police 🚓",textAlign: TextAlign.center ,style: TextStyle(
                      fontSize: 32,fontWeight: FontWeight.bold,color: Constants().textColor),)
              ),
              SizedBox(height: 50),
              CircleAvatar(
              radius: 70,
               backgroundColor:Colors.redAccent,
               child: SizedBox(
                width: 100,
                 height: 100,
                     child: IconButton(
                       onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber("8530271197");
                       },
                       icon: Icon(CupertinoIcons.phone_fill_arrow_up_right,color: Colors.white,size: 55),
          
          
                     ),
               )
                 ),
              Container(
                  margin: EdgeInsets.only(left: 85,right: 70,top: 50),
                  child: Text("Emergency Call Ambulance",textAlign: TextAlign.center ,style: TextStyle(
                      fontSize: 32,fontWeight: FontWeight.bold,color: Constants().textColor),)
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () async {
                  await FlutterPhoneDirectCaller.callNumber("7447762674");
                },
                child: CircleAvatar(
                    radius: 70,
                    backgroundColor:Colors.green,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Text("🚑",textAlign: TextAlign.center,style: TextStyle(fontSize: 60),)
                    )
                ),
              ),
          
            ],
          ),
        )


    );


  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Call a number",textAlign: TextAlign.left,),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (val){
                    setState(() {
                      number = val;
                    });
                  },
                  style:  TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder:  OutlineInputBorder(
                          borderSide:  BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      errorBorder:  OutlineInputBorder(
                          borderSide:  BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      focusedBorder:  OutlineInputBorder(
                          borderSide:  BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Cancel",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FlutterPhoneDirectCaller.callNumber(number);
                },
                child: Icon(CupertinoIcons.phone_fill_arrow_up_right,color: Colors.white,),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              )
            ],
          );
        });
  }

}


