import 'package:chatme/master_page.dart';
import 'package:chatme/pages/locator/detaillocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/constant.dart';
import '../../widgets/widget.dart';
import '../finding_people/setting.dart';

class LocationTile extends StatefulWidget {
String currentaddress;
String coordinates;
String banner;
String userId;



LocationTile({Key? key,required this.currentaddress,required this.banner,
    required this.coordinates,required this.userId})
      : super(key: key);
  @override
  State<LocationTile> createState() => _LocationTileState();
}

class _LocationTileState extends State<LocationTile> {
  @override

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          nextScreen(context, DetailLocation(
              currentaddress: widget.currentaddress,
              coordinates: widget.coordinates,
              userId: widget.userId));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8,right: 8,top: 12),
        child: Card(
          elevation: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Constants().WhiteishColour,
              borderRadius: BorderRadius.circular(12),
            ),

            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            child: ListTile(
              title: Text(widget.banner,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              leading: Icon(CupertinoIcons.location_solid,size: 45,),
             trailing: Icon(CupertinoIcons.map_fill,size: 40,),
            ),
          ),
        ),
      ),
    );
  }
}

