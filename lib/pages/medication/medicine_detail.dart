import 'package:chatme/models/medicine.dart';
import 'package:chatme/pages/medication/global_block.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails({Key? key, required this.medicine}) : super(key: key);

  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {


  @override
  Widget build(BuildContext context) {
    final GlobalBlock _globalBlock = Provider.of<GlobalBlock>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainSection(medicine: widget.medicine),
            SizedBox(
              height: 20,
            ),
            ExtendedSection(
              medicine: widget.medicine,
            ),
            SizedBox(
              height: 250,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    openAlertBox(context,_globalBlock);
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  openAlertBox(BuildContext context,GlobalBlock _globalblock) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            title: Text("Delete this remainder"),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    _globalblock.removeMedicine(widget.medicine);
                    Navigator.popUntil(context, ModalRoute.withName("/"));

                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );
        });
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldinfo;
  final String fieldtitle;

  const ExtendedInfoTab(
      {Key? key, required this.fieldinfo, required this.fieldtitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldtitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            fieldinfo,
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontSize: 22),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({Key? key, required this.medicine}) : super(key: key);
  final Medicine? medicine;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 8),
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldinfo: medicine!.medicineType! == 'None'
              ? 'Not Specified'
              : medicine!.medicineType!,
          fieldtitle: 'Medicine Type',
        ),
        SizedBox(
          height: 5,
        ),
        ExtendedInfoTab(
            fieldinfo: "Every ${medicine!.interval} hours |"
                " ${medicine!.interval == 24 ? "One time a day" : "${24 / medicine!.interval!.floor()} times a day"} ",
            fieldtitle: "Dose Interval"),
        SizedBox(
          height: 5,
        ),
        ExtendedInfoTab(
            fieldinfo:
                '${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}',
            fieldtitle: "Start Time"),
      ],
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({Key? key, required this.medicine}) : super(key: key);
  final Medicine? medicine;
  Hero makeIcon() {
    if (medicine!.medicineType! == 'bottle') {
      return Hero(
          tag: medicine!.medicineName! + medicine!.medicineType!,
          child: Image.asset(
            "assets/svg/bottle2.png",
            height: 100,
          ));
    } else if (medicine!.medicineType == 'pill') {
      return Hero(
          tag: medicine!.medicineName! + medicine!.medicineType!,
          child: Image.asset(
            "assets/svg/pill.png",
            height: 100,
          ));
    } else if (medicine!.medicineType == 'syringe') {
      return Hero(
          tag: medicine!.medicineName! + medicine!.medicineType!,
          child: Image.asset(
            "assets/svg/syringe3.png",
            height: 100,
          ));
    } else if (medicine!.medicineType == 'tablet') {
      return Hero(
          tag: medicine!.medicineName! + medicine!.medicineType!,
          child: Image.asset(
            "assets/svg/tablet.png",
            height: 100,
          ));
    }
    return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Icon(Icons.error));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        makeIcon(),
        Column(
          children: [
            MainInputTab(
                fieldinfo: medicine!.medicineName!,
                fieldtitle: "Medicine Name"),
            SizedBox(
              height: 5,
            ),
            MainInputTab(
                fieldinfo: medicine!.dosage == 0
                    ? "Not Specified"
                    : "${medicine!.dosage} mg",
                fieldtitle: "Dosage"),
          ],
        )
      ],
    );
  }
}

class MainInputTab extends StatelessWidget {
  final String fieldinfo;
  final String fieldtitle;

  const MainInputTab(
      {Key? key, required this.fieldinfo, required this.fieldtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          fieldtitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(fieldinfo,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
      ],
    );
  }
}
