import 'package:chatme/master_page.dart';
import 'package:chatme/pages/homepage.dart';
import 'package:chatme/pages/profilepage.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import '../shared/constant.dart';
import 'auth/loginpage.dart';

class SettingPage extends StatefulWidget{

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String userName = "";
  String email = "";
  Authservice authservice = Authservice();

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting",
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600,
            color: Constants().textColor),),
      ),

        body:Container(
          child: ListView(
        padding: EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor:Colors.transparent,
            child: SizedBox(
              width: 100,
                height: 100,
                child: ClipOval(child: Image.asset("assets/images/leading.jpg"),),
            ),

          ),
          SizedBox(height: 15),
          Text(userName, textAlign: TextAlign.center, style:
          TextStyle(fontWeight: FontWeight.bold,color: Constants().textColor, fontSize: 18),),
              SizedBox(height: 5),
          Text(email,textAlign: TextAlign.center,style: TextStyle(color: Constants().textColor),),

          ListTile(
          onTap: () {
          //   profile page to be created 
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: Icon(Icons.person,color: Color(0xFFA095C1),),
          title: Text("Profile", style: TextStyle(color:Constants().textColor),),
        ),
          ListTile(
          onTap: () async {
            showDialog(context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Logout",style: TextStyle(color: Constants().textColor),),
                    content: Text("Are you sure you want to logout",style: TextStyle(color: Constants().textColor)),
                    actions: [
                      IconButton(onPressed: () {
                        Navigator.pop(context);
                      },
                          icon: Icon(Icons.cancel, color: Colors.red)
                      ),
                      IconButton(onPressed: () async {
                        await authservice.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Loginpage()),
                                (route) => false);
                      },
                          icon: Icon(Icons.done, color: Colors.green,)
                      ),
                    ],
                  );
                });
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: Icon(Icons.exit_to_app,color: Color(0xFFA095C1),),
          title: Text("Logout", style: TextStyle(color: Constants().textColor),),
        )


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
                onPressed: (){nextScreen(context, MasterPage());},
                icon: Icon(Icons.home,size:30,color:Color(0xFFA095C1) )),

            IconButton(
                onPressed: (){},
                icon : Icon(Icons.notifications,size: 30,color: Color(0xFFA095C1))),


            IconButton( onPressed: (){nextScreen(context, SettingPage());},
                icon: Icon( Icons.settings,size: 30,color: Constants().textColor,))

          ],
        ),
      ),

    );
  }


}