import 'package:chatme/pages/locator/locationtile.dart';
import 'package:chatme/pages/locator/locator_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/database_service.dart';
import '../../widgets/widget.dart';


class DetailLocation extends StatelessWidget {
  String currentaddress;
  String coordinates;
  String userId;


  DetailLocation({Key? key,required this.currentaddress,
    required this.coordinates,required this.userId})
      : super(key: key);
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body:Container(

        child: Padding(
          padding: const EdgeInsets.only(top: 12.0,left: 12),
          child: Column(
            children: [
              Text("Saved Location:",style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Colors.black
              ),),
              Center(child: Text("\n ${currentaddress}",style: Theme.of(context).textTheme.titleSmall ,)),
              SizedBox(height: 60,),
              Text("(Latitude,Longitude)\n",style:Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.black
              ) ,),
              Text(coordinates,style: Theme.of(context).textTheme.titleSmall,)

            ],

          ),
        ),
      ),
      bottomSheet:  Container(
        color: Colors.white,
        width: 375,
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: (){

              DatabaseService(uid : FirebaseAuth.instance.currentUser!.uid).
              deletelocationfromuser(
             FirebaseAuth.instance.currentUser!.uid, currentaddress,
             coordinates).whenComplete((){
              nextScreenReplace(context, LocatorMainPage());
              });


              },


                icon: Icon(Icons.delete,size:30,color: Color(0xff595959))),
          ],
        ),
      ),
    );
  }
}
