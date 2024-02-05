import 'dart:math';
import 'package:chatme/models/errors.dart';
import 'package:chatme/pages/medication/Medication_mainpage.dart';
import 'package:chatme/pages/medication/global_block.dart';
import 'package:chatme/pages/medication/new_entry_bloc.dart';
import 'package:chatme/pages/medication/succespage.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import '../../../models/convert_time.dart';
import '../../../models/medicine.dart';
import '../../../models/medicine_type.dart';

class NewEntryPage extends StatefulWidget {
  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  NewEntryBloc? _newEntryBloc;
  TextEditingController? nameController;
  FlutterLocalNotificationsPlugin?  flutterLocalNotificationsPlugin;
  TextEditingController? dosageController;
  GlobalKey<ScaffoldState>? _scaffoldkey;
  @override
  void dispose() {
    super.dispose();
    nameController!.dispose();
    dosageController!.dispose();
    _newEntryBloc!.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _scaffoldkey = GlobalKey<ScaffoldState>();
    _newEntryBloc = NewEntryBloc();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBlock globalBlock = Provider.of<GlobalBlock>(context);
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add New",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc!,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Panel_Title(
                title: "Medication Name",
                isRequired: true,
              ),
              TextField(
                controller: nameController,
                maxLength: 15,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(border: UnderlineInputBorder()),
              ),
              Panel_Title(
                title: "Dosage in mg",
                isRequired: false,
              ),
              TextField(
                controller: dosageController,
                maxLength: 15,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(border: UnderlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              Panel_Title(title: "Medicine Type", isRequired: false),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<MedicineType>(
                stream: _newEntryBloc!.selectedMedicineType,
                builder: (context, snapshot) {
                  return SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Medicine_Type_Column(
                            medicine_type: MedicineType.pill,
                            name: "Pill",
                            iconvalue: "assets/svg/pill.png",
                            isSelected: snapshot.data == MedicineType.pill
                                ? true
                                : false),
                        SizedBox(
                          width: 5,
                        ),
                        Medicine_Type_Column(
                            medicine_type: MedicineType.bottle,
                            name: "Bottle",
                            iconvalue: "assets/svg/bottle2.png",
                            isSelected: snapshot.data == MedicineType.bottle
                                ? true
                                : false),
                        SizedBox(
                          width: 10,
                        ),
                        Medicine_Type_Column(
                            medicine_type: MedicineType.syringe,
                            name: "Syringe",
                            iconvalue: "assets/svg/syringe3.png",
                            isSelected: snapshot.data == MedicineType.syringe
                                ? true
                                : false),
                        SizedBox(
                          width: 10,
                        ),
                        Medicine_Type_Column(
                            medicine_type: MedicineType.tablet,
                            name: "Tablet",
                            iconvalue: "assets/svg/tablet.png",
                            isSelected: snapshot.data == MedicineType.tablet
                                ? true
                                : false),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 3,
              ),
              Panel_Title(title: "Interval selection", isRequired: true),
              IntervalSelection(),
              Panel_Title(title: "Starting Time", isRequired: true),
              SelectTime(),
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                    width: 250,
                    height: 55,
                    child: TextButton(
                      onPressed: () {
                        String? medicineName;
                        int? dosage;
                        if (nameController?.text == "") {
                          _newEntryBloc?.submitError(EntryError.nameNull);
                          return;
                        }
                        if (nameController?.text != "") {
                          medicineName = nameController?.text;
                        }

                        if (dosageController?.text == "") {
                          dosage = 0;
                        }
                        if (dosageController?.text != "") {
                          dosage = int.parse(dosageController!.text);
                        }
                        for (var medicine in globalBlock.medicineList$!.value) {
                          if (medicineName == medicine.medicineName) {
                            _newEntryBloc
                                ?.submitError(EntryError.nameDuplicate);
                            return;
                          }
                        }
                        if (_newEntryBloc?.selectedIntervals!.value == 0) {
                          _newEntryBloc?.submitError(EntryError.interval);
                          return;
                        }
                        if (_newEntryBloc?.selectedTimeOfDay!.value == 'None') {
                          _newEntryBloc?.submitError(EntryError.startTime);
                          return;
                        }

                        String medicineType = _newEntryBloc!
                            .selectedMedicineType!.value
                            .toString()
                            .substring(13);
                        int interval = _newEntryBloc!.selectedIntervals!.value;
                        String startTime =
                            _newEntryBloc!.selectedTimeOfDay!.value;
                        List<int> intIDs = makeIDs(
                            24 / _newEntryBloc!.selectedIntervals!.value);
                        List<String> notificationIDs =
                            intIDs.map((i) => i.toString()).toList();
                        Medicine newEntryMedicine = Medicine(
                          notificationIDs: notificationIDs,
                          medicineName: medicineName,
                          dosage: dosage,
                          medicineType: medicineType,
                          interval: interval,
                          startTime: startTime,
                        );
                        globalBlock.updateMedicineList(newEntryMedicine);

                        scheduleNotification(newEntryMedicine);

                        nextScreen(context, SuccessScreen());
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        shape: StadiumBorder(),
                      ),
                      child: Center(
                        child: Text(
                          "Confirm",
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void initializeErrorListen() {
    _newEntryBloc?.errorState$!.listen((EntryError error) {
      switch (error) {
        case EntryError.nameNull:
          displayError("please enter the Medicine Name");
          break;
        case EntryError.nameDuplicate:
          displayError("medicine name already exist");
          break;
        case EntryError.dosage:
          displayError("please enter the dosage required");
          break;
        case EntryError.interval:
          displayError("please select reminders interval");
          break;
        case EntryError.startTime:
          displayError("please select reminders startTime");
          break;

        default:
      }
    });
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < 0; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(error),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  initializeNotifications() async{

    var initializeSettingAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializeSettingIOS = DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
      iOS: initializeSettingIOS,
      android: initializeSettingAndroid,
    );
    await flutterLocalNotificationsPlugin!.initialize(initializationSetting);

  }

  Future onSelectionNotification(String? payload) async {
    if(payload != null){
      debugPrint('notification payload : $payload');
    }
    await Navigator.push(context, MaterialPageRoute(builder: (context)=> MedicationReminder()));

  }
  Future<void> scheduleNotification(Medicine medicine) async{
    var hour = int.parse(medicine.startTime![0]+medicine.startTime![1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime![2]+ medicine.startTime![3]);

    var androidPlatformChannelSpecifies = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
      importance:  Importance.max,
      ledColor: Colors.red,
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
    );
    var iOSPlatformChannelSpecifies = DarwinNotificationDetails();
    var platformChannelSpecifies = NotificationDetails(
      android: androidPlatformChannelSpecifies,
      iOS: iOSPlatformChannelSpecifies
    );

    for(int i= 0 ;i<(24/medicine.interval!).floor(); i++){
      if(hour + (medicine.interval! * i) > 23){
        hour=hour + (medicine.interval! *i) - 24;
    }else{
        hour= hour + (medicine.interval!*i);

      }
     await flutterLocalNotificationsPlugin!.show(
         int.parse(medicine.notificationIDs![i]),
         'Remainder : ${medicine.medicineName}',
         medicine.medicineType.toString() != MedicineType.none.toString()?
         'It is time to take your ${medicine.medicineType!.toLowerCase()} according to the schedule ':
         'It is time to take your medicine ,according to schedule',

       //This line is not taken
       // Time(hour,minute,0),



         platformChannelSpecifies
     );
      hour = ogValue;
    }
  }

}

class SelectTime extends StatefulWidget {
  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay time = TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;
  Future<TimeOfDay?> _selectTime() async {

    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context,listen: false);

    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
        _clicked = true;
        //   update state via provider
        newEntryBloc.updatetime(convertTime(time.hour.toString())
            +convertTime(time.minute.toString()));
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 65,
        child: Padding(
          padding: const EdgeInsets.only(top: 11.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.cyan,
              shape: StadiumBorder(),
            ),
            onPressed: () {
              _selectTime();
            },
            child: Center(
              child: Text(
                _clicked == false
                    ? "Select Time"
                    : "${convertTime(time.hour.toString())}:${convertTime(time.minute.toString())}",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [1, 6, 8, 12, 24];

  var selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Remind me every",
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(
            width: 9,
          ),
          DropdownButton(
            hint: selected == 0
                ? Text(
                    "Select an interval",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  )
                : null,
            elevation: 4,
            value: selected == 0 ? null : selected,
            items: _intervals.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                );
              },
            ).toList(),
            onChanged: (newval) async {
              setState(
                () {
                  selected = newval!;
                  newEntryBloc.updateInterval(newval);
                },
              );
            },
          ),
          Text(
            selected == 1 ? "Hour" : "Hours",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}

class Medicine_Type_Column extends StatelessWidget {
  const Medicine_Type_Column(
      {Key? key,
      required this.medicine_type,
      required this.name,
      required this.iconvalue,
      required this.isSelected})
      : super(key: key);
  final MedicineType medicine_type;
  final String name;
  final String iconvalue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        //   select Medicine type
        //   new bloc of medicine
        newEntryBloc.updateMedicineType(medicine_type);
      },
      child: Column(
        children: [
          Container(
            width: 85,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.cyan : Colors.white,
            ),
            child: Image.asset(iconvalue),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              width: 80,
              height: 28,
              decoration: BoxDecoration(
                  color: isSelected ? Colors.cyan : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Text(name,
                      style: Theme.of(context).textTheme.displayLarge)),
            ),
          )
        ],
      ),
    );
  }
}

class Panel_Title extends StatelessWidget {
  final title;
  bool isRequired;
  Panel_Title({Key? key, required this.title, required this.isRequired})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 5),
      child: Text.rich(TextSpan(children: <TextSpan>[
        TextSpan(text: title, style: Theme.of(context).textTheme.labelMedium),
        TextSpan(
            text: isRequired ? "*" : "",
            style: Theme.of(context).textTheme.labelMedium)
      ])),
    );
  }
}
