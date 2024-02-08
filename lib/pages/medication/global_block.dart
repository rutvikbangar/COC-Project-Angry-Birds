import 'dart:convert';

import 'package:chatme/models/medicine.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalBlock {
  BehaviorSubject<List<Medicine>>? _medicinelist$;
  BehaviorSubject<List<Medicine>>? get medicineList$ => _medicinelist$;

  GlobalBlock() {
    _medicinelist$ = BehaviorSubject<List<Medicine>>.seeded([]);
    makeMedicineList();
  }

  Future removeMedicine(Medicine tobeRemoved) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    List<String> medicineJsonList=[];
    var blocklist = _medicinelist$!.value;
    blocklist.removeWhere((medicine) => medicine.medicineName == tobeRemoved.medicineName);
    
    for(int i=0;i<(24/ tobeRemoved.interval!).floor();i++){
      flutterLocalNotificationsPlugin.cancel(int.parse(tobeRemoved.notificationIDs![i]));
      
    }
    
    if(blocklist.isNotEmpty){
      for(var blockMedicine in blocklist){
        String medicineJson = jsonEncode(blockMedicine.toJson());
        medicineJsonList.add(medicineJson);
      }

    }
    sharedUser.setStringList("medicines", medicineJsonList);
    _medicinelist$!.add(blocklist);

  }

  Future updateMedicineList(Medicine newMedicine) async {
    var blocList =_medicinelist$!.value;
    blocList.add(newMedicine);
    _medicinelist$!.add(blocList);

    Map<String,dynamic> tempMap = newMedicine.toJson();
    SharedPreferences? sharedUser=await SharedPreferences.getInstance();
    String newMedicineJson =jsonEncode(tempMap);
    List<String> medicineJsonList=[];
    if (sharedUser.getStringList("medicines")==null){
      medicineJsonList.add(newMedicineJson);
    }else{
      medicineJsonList=sharedUser.getStringList("medicines")!;
      medicineJsonList.add(newMedicineJson);
    }
    sharedUser.setString("medicines", medicineJsonList as String);
  }
  Future makeMedicineList() async {
    SharedPreferences? sharedUser = await SharedPreferences.getInstance();
    List<String>? jsonList = sharedUser.getStringList("medicines");
    List<Medicine> prefList = [];

    if (jsonList == null) {
      return;
    } else {
      for (String jsonmedicine in jsonList) {
        dynamic userMap = jsonDecode(jsonmedicine);
        Medicine tempMedicine = Medicine.fromJson(userMap);
        prefList.add(tempMedicine);
      }
      // our State is updated
      _medicinelist$!.add(prefList);
    }
  }

  void dispose() {
    _medicinelist$!.close();
  }
}
