import 'dart:async';

import 'package:chatme/pages/medication/Medication_mainpage.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();

}



class _SuccessScreenState extends State<SuccessScreen> {
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
      Navigator.popUntil(context, ModalRoute.withName("/") );


    });
  }
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child:  Image.asset(
        'assets/svg/check.png',

        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
      )


        ),
      );

  }
}
