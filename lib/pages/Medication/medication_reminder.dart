import 'dart:io';

import 'package:chatme/pages/finding_people/homepage.dart';
import 'package:chatme/shared/constant.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:flutter/material.dart';

class MedicationReminder extends StatefulWidget {
  const MedicationReminder({super.key});

  @override
  State<MedicationReminder> createState() => _MedicationReminderState();
}

class _MedicationReminderState extends State<MedicationReminder> {
  String Reminder = "";
  bool isloading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Constants().WhiteishColour,
          title: Text(
            "Medication Reminder⏰",
            style: TextStyle(color: Constants().textColor),
            textAlign: TextAlign.left,
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Age with Grace",
              style: TextStyle(color: Constants().textColor, fontSize: 30),
              textAlign: TextAlign.left,
            ),
            Text(
              " Daily Wellness Wisdom!!😃",
              style: TextStyle(color: Constants().primaryColor, fontSize: 17),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 200,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "You doesn't have any reminder, tap on the add icon to create a Reminder.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Create a Reminder",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (val) {
                    setState(() {
                      Reminder = val;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Constants().WhiteishColour,
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20)),
                      errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () async {},
                child: Text(
                  "Create",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
              InkWell(
                onTap: () async {
                  await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 0, minute: 00),
                  );
                },
                splashColor: Constants().textColor,
                child: Icon(
                  Icons.timer,
                  color: Constants().primaryColor,
                  size: 50,
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.start,
          );
        });
  }
}
