import 'package:chatme/models/medicine.dart';
import 'package:chatme/pages/medication/global_block.dart';
import 'package:chatme/pages/medication/medicine_detail.dart';
import 'package:chatme/pages/medication/new_entry/new_entry_page.dart';
import 'package:chatme/shared/constant.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicationReminder extends StatefulWidget {
  @override
  State<MedicationReminder> createState() => _MedicationReminderState();
}

class _MedicationReminderState extends State<MedicationReminder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().WhiteishColour,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nextScreen(context, NewEntryPage());
        },
        child: Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        backgroundColor: Colors.green.shade400,
      ),
      body: Column(
        children: [
          topContainer(),
          Flexible(child: bottomContainer()),
        ],
      ),
    );
  }
}

class topContainer extends StatefulWidget {
  @override
  State<topContainer> createState() => _topContainerState();
}

class _topContainerState extends State<topContainer> {
  @override
  Widget build(BuildContext context) {
    final GlobalBlock globalBlock = Provider.of<GlobalBlock>(context);
    return Container(
      decoration: BoxDecoration(color: Constants().WhiteishColour),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 5, top: 10),
            child: Text("Welcome to medication \nremainder.",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.only(left: 5),
              alignment: Alignment.topLeft,
              child: Text("Enter your Dose",
                  style: Theme.of(context).textTheme.titleSmall)),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<List<Medicine>>(
              stream: globalBlock.medicineList$,
              builder: (context, snapshot) {
                return Container(
                  child: Text(
                    !snapshot.hasData ? "0" : snapshot.data!.length.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                );
              })
        ],
      ),
    );
  }
}

class bottomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBlock globalBlock = Provider.of<GlobalBlock>(context);
    return Container(
      decoration: BoxDecoration(
        color: Constants().WhiteishColour,
      ),
      child: StreamBuilder(
          stream: globalBlock.medicineList$,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No Medicine",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return MedicineCard(medicine: snapshot.data![index]);
                },
              );
            }
          }),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  Hero makeIcon() {
    if (medicine.medicineType == 'bottle') {
      return Hero(
          tag: medicine.medicineName! + medicine.medicineType!,
          child: Image.asset(
            "assets/svg/bottle2.png",
            height: 100,
          ));
    } else if (medicine.medicineType == 'pill') {
      return Hero(
          tag: medicine.medicineName! + medicine.medicineType!,
          child: Image.asset(
            "assets/svg/pill.png",
            height: 100,
          ));
    } else if (medicine.medicineType == 'syringe') {
      return Hero(
          tag: medicine.medicineName! + medicine.medicineType!,
          child: Image.asset(
            "assets/svg/syringe3.png",
            height: 100,
          ));
    } else if (medicine.medicineType == 'tablet') {
      return Hero(
          tag: medicine.medicineName! + medicine.medicineType!,
          child: Image.asset(
            "assets/svg/tablet.png",
            height: 100,
          ));
    }
    return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Icon(Icons.error));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // nextScreen(context, MedicineDetails());

        Navigator.of(context).push(
          PageRouteBuilder<void>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                    animation: animation,
                    builder: (context, Widget? child) {
                      return Opacity(
                          opacity: animation.value,
                          child: MedicineDetails(
                            medicine: medicine,
                          ));
                    });
              },
              transitionDuration: Duration(milliseconds: 500)),
        );
      },
      splashColor: Colors.grey,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
        width: 100,
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeIcon(),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 2),
              child: Hero(
                tag: medicine.medicineName!,
                child: Text(
                  medicine.medicineName!,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 25),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                medicine.interval == 1
                    ? "Every ${medicine.interval} hour"
                    : "Every ${medicine.interval} hours",
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 15, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
