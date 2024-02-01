import 'dart:convert';
import 'package:chatme/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flare_flutter/flare_actor.dart';



class LocatorMainPage extends StatefulWidget {
  @override
  State<LocatorMainPage> createState() => _LocatorMainPageState();
}

class _LocatorMainPageState extends State<LocatorMainPage> {
  String currentAddress = 'My Address';
  Position? currentposition;


  @override



  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Please keep your location on");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location Permission is denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location Permission is denied forever");
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentposition = position;
        currentAddress =
        "${place.street},${place.subLocality},\n${place.locality},${place.postalCode},\n${place.country}";
      });



    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Locator",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Constants().primaryColor,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                  padding: EdgeInsets.only(left: 30,right: 25),
                  child: Text(currentAddress)),
              SizedBox(height: 10,),
              currentposition != null
                  ? Text("latitude = " + currentposition!.latitude.toString())
                  : Container(),

              currentposition != null
                  ? Text("longitude = " + currentposition!.longitude.toString())
                  : Container(),
              TextButton(onPressed: () {

                _determinePosition();

              }, child: Text("Locate Me")),
            ],
          ),
        )

    );
  }
}
