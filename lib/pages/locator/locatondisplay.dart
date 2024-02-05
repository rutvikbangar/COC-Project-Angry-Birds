import 'package:chatme/pages/locator/locationtile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../master_page.dart';
import '../../service/database_service.dart';
import '../../shared/constant.dart';
import '../../widgets/widget.dart';
import '../finding_people/setting.dart';


class LocationDisplay extends StatefulWidget {

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay> {
  Stream? location;
  String userName = "";

  @override


  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }
  gettingUserData() async {
    await HelperFunction.getUserNameFromSF().then((value) =>
    {
      setState(() {
        userName = value!;
      })
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserLocation()
        .then((snapshot) {
      setState(() {
        location = snapshot;
      });
    });

  }



  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1,res.lastIndexOf("_")
    );
  }
  String getdetail(String res){
    return res.substring(res.lastIndexOf("_")+1,

    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: locationList(),

    );
  }

  locationList() {
    return StreamBuilder(
      stream: location,
      builder: (context, AsyncSnapshot snapshot) {
        //checks
        if (snapshot.hasData) {
          if (snapshot.data['location'] != null) {
            if (snapshot.data['location'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['location'].length,

                  itemBuilder: (context, index){
                    int reverseIndex = snapshot.data['location'].length - index - 1;
                    return LocationTile(
                        banner: "Saved Location ${reverseIndex+1}",
                        currentaddress: getName(snapshot.data['location'][reverseIndex]) ,
                        coordinates:  getdetail(snapshot.data['location'][reverseIndex]),
                        userId:getId(snapshot.data['location'][reverseIndex])
                    );
                  }

              );
            } else {
              return noNotesWidget();
            }
          } else {
            return noNotesWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator(color: Theme
              .of(context)
              .primaryColor));
        }
      },
    );
  }

  noNotesWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Center(child : Text("You have not saved any address",
          textAlign: TextAlign.center,))
    );
  }
}
