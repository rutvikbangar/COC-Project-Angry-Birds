import 'package:chatme/pages/Notes/Notes_mainpage.dart';
import 'package:chatme/pages/SOS/sospage.dart';
import 'package:chatme/pages/homepage.dart';
import 'package:chatme/pages/medication_reminder.dart';
import 'package:chatme/pages/setting.dart';
import 'package:chatme/service/auth_service.dart';
import 'package:chatme/service/database_service.dart';
import 'package:chatme/shared/constant.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'helper/helper_function.dart';

class MasterPage extends StatefulWidget{

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  String userName = "";
  String email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  //string manipulation
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1
    );
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) =>
    {
      setState(() {
        email = value!;
      })
    });
    await HelperFunction.getUserNameFromSF().then((value) =>
    {
      setState(() {
        userName = value!;
      })
    });

  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      top: false,
      child: Scaffold(

      appBar: AppBar(
        leading: Image.asset("assets/images/leading.jpg"),
        title: Text("Hii ${userName}",style:
        TextStyle(color: Color(0xFF432c81),fontWeight: FontWeight.w500)),

      ),
        
        body: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  nextScreen(context, MedicationReminder());
                },
                child: Container(
                 margin: EdgeInsets.only(top: 16,left: 20,right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Constants().WhiteishColour,

                  ),
                  width: 343,
                  height: 116,
                  child: Row(
                    children: [
                      Container(
                        width :183,
                        height: 72,
                        child: Text("Medication Remainder",textAlign: TextAlign.center,style:
                        TextStyle(color: Constants().textColor,fontWeight: FontWeight.w600,fontSize:20 ),),
                      ),
                      Expanded(child: Image.asset("assets/images/medical1.png")),

                    ],
                  )

                ),
              ),
              SizedBox(height: 16,),

              InkWell(
                onTap: (){
                  //For SOS
                  nextScreen(context, SosPage());
                },
                child: Container(
                    margin: EdgeInsets.only(left: 20,right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constants().WhiteishColour,

                    ),
                    width: 343,
                    height: 116,
                    child: Row(
                      children: [
                        Container(
                          width :183,
                          height: 40,
                          child: Text("SOS",textAlign: TextAlign.center,style:
                          TextStyle(color: Constants().textColor,fontWeight: FontWeight.w600,fontSize:20 ),),
                        ),
                        Expanded(child: Image.asset("assets/images/SOS.jpg"))
                      ],
                    )

                ),
              ),
              SizedBox(height: 16,),

              InkWell(
                onTap: (){
                  //For Locator
                },
                child: Container(
                    margin: EdgeInsets.only(left: 20,right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constants().WhiteishColour,

                    ),
                    width: 343,
                    height: 116,
                    child: Row(
                      children: [
                        Container(
                          width :183,
                          height: 40,
                          child: Text("Locator",textAlign: TextAlign.center,style:
                          TextStyle(color: Constants().textColor,fontWeight: FontWeight.w600,fontSize:20 ),),
                        ),
                        Expanded(child: Image.asset("assets/images/locator.jpg")),


                      ],
                    )

                ),
              ),
              SizedBox(height: 16,),

              InkWell(
                onTap: (){
                  nextScreen(context, Homepage());
                },
                child: Container(
                    margin: EdgeInsets.only(left: 20,right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constants().WhiteishColour,

                    ),
                    width: 343,
                    height: 116,

                    child: Row(
                      children: [

                        Container(
                          width :183,
                          height: 40,
                          child: Text("Finding People",textAlign: TextAlign.center,style:
                          TextStyle(color: Constants().textColor,fontWeight: FontWeight.w600,fontSize:20 ),),
                        ),
                        Expanded(child: Image.asset("assets/images/people.jpg")),
                      ],
                    ),
                ),
              ),
              SizedBox(height: 16,),

              InkWell(
                onTap: (){
                  //For Notes
                    nextScreen(context, NotesPage());
                },
                child: Container(
                    margin: EdgeInsets.only(left: 20,right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constants().WhiteishColour,

                    ),
                    width: 343,
                    height: 116,
                    child: Row(
                      children: [
                        Container(
                          width :183,
                          height: 40,
                          child: Text("Notes",textAlign: TextAlign.center,style:
                          TextStyle(color: Constants().textColor,fontWeight: FontWeight.w600,fontSize:20 ),),
                        ),
                        Expanded(child: Image.asset("assets/images/notes.jpg"))
                      ],
                    )

                ),
              ),


            ],
          ),
        ),
        
        bottomSheet: Container(
          color: Colors.white,
          width: 375,
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.home,size:30,color: Constants().textColor)),

              IconButton(
                  onPressed: (){},
                  icon : Icon(Icons.notifications,size: 30,color: Color(0xFFA095C1))),


               IconButton( onPressed: (){nextScreen(context, SettingPage());},
                icon: Icon( Icons.settings,size: 30,color: Color(0xFFA095C1),))

            ],
          ),
        ),

      ),
    );
  }
}