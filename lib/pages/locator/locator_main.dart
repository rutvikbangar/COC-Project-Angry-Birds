import 'dart:convert';
import 'package:chatme/pages/locator/locatondisplay.dart';
import 'package:chatme/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../../helper/helper_function.dart';
import '../../service/database_service.dart';
import '../../widgets/widget.dart';

class LocatorMainPage extends StatefulWidget {
  @override
  State<LocatorMainPage> createState() => _LocatorMainPageState();
}

class _LocatorMainPageState extends State<LocatorMainPage> {
  String currentAddress = 'Click below to fetch the location';
  Position? currentposition;
 // Stream? location;
  String userName = "";
  bool _isloading = false;
  String simiplified = "";


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
    // await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
    //     .getUserLocation()
    //     .then((snapshot) {
    //   setState(() {
    //     location = snapshot;
    //   });
    // });

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


  //lcation geeting function
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
        actions: [
          IconButton(onPressed: () {
            nextScreen(context, LocationDisplay());
          },
              icon: Icon(CupertinoIcons.map, color: Colors.white,))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
                child: Text(
              currentAddress,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            )),
            SizedBox(
              height: 10,
            ),
            currentposition != null
                ? Center(
                    child: Text(
                    "latitude = " + currentposition!.latitude.toString(),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ))
                : Container(),
            currentposition != null
                ? Center(
                    child: Text(
                    "longitude = " + currentposition!.longitude.toString(),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ))
                : Container(),
            currentposition != null
                ? Image(
                    width: 250,
                    height: 400,
                    image: AssetImage('assets/images/Globe1.gif'))
                : Container(),

            currentposition != null
                ? SizedBox(
              height: 50,
              width: 300,
                child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Constants().primaryColor,
                ),
                onPressed: () {

                  if(currentAddress != ""){
                    setState(() {
                      _isloading= true;
                    });
                    simiplified = "Latitude = ${currentposition!.latitude.toString()}\nLongitude = ${currentposition!.longitude.toString()}";
                    DatabaseService(uid : FirebaseAuth.instance.currentUser!.uid)
                        .updateLocation(FirebaseAuth.instance.currentUser!.uid, simiplified, currentAddress)
                        .whenComplete(() {
                      _isloading = false;
                    });
                   nextScreen(context, LocatorMainPage());
                    showSnackbar(context, Colors.green, "Location Saved");

                  }



                },
                child: Text(
                  "Save this Address !",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ) : Container(),


          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          height: 50,
          width: 300,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Constants().primaryColor,
            ),
            onPressed: () {
              _determinePosition();
            },
            child: Text(
              "Locate me",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }



}


