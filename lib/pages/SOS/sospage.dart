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


            backgroundColor: Color(0xffc50c2e),
            title: Text("SOS",style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.white)),
          ),

        floatingActionButton: FloatingActionButton(

          child: Text("Call number",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
          onPressed: () {
            popUpDialog(context);
          },
          backgroundColor: Color(0xffc50c2e),
        ),
        body: Container(
         height: 750,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
             Color(0xffc50c2e),Color(0xff791229),Color(0xff4e1226),Color(0xff261928),Color(0xff181925)
            ])

          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(

                    margin: EdgeInsets.only(left: 85,right: 70,top: 50),
                    child: Text("Emergency Call Police 🚓",textAlign: TextAlign.center ,style:
                    Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,fontSize: 32)
                    )
                ),
                SizedBox(height: 50),
                CircleAvatar(
                      radius: 70,
                      backgroundColor:Colors.white,
                      child: Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(70),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffc50c2e),Color(0xff791229),Color(0xff4e1226),Color(0xff261928),Color(0xff181925)
                                ])

                        ),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: IconButton(
                            onPressed: () async {
                              await FlutterPhoneDirectCaller.callNumber("8530271197");
                            },
                            icon: Icon(CupertinoIcons.phone_fill_arrow_up_right,color: Colors.white,size: 55),


                          ),
                        ),
                      )
                  ),

                Container(
                    margin: EdgeInsets.only(left: 85,right: 70,top: 50),
                    child: Text("Emergency Call Ambulance",textAlign: TextAlign.center ,style:
                    Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,fontSize: 32))
                ),
                SizedBox(height: 50),
                CircleAvatar(
                    radius: 70,
                    backgroundColor:Colors.white,
                    child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(70),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xffc50c2e),Color(0xff791229),Color(0xff4e1226),Color(0xff261928),Color(0xff181925)
                              ])

                      ),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: IconButton(
                          onPressed: () async {
                            await FlutterPhoneDirectCaller.callNumber("8208443163");
                          },
                          icon: Icon(Icons.directions_bus_filled,color: Colors.white,size: 55),


                        ),
                      ),
                    )
                ),



              ],
            ),
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
        }
    );
  }

}