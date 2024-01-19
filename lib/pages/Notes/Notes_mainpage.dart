import 'package:chatme/pages/Notes/notestile.dart';
import 'package:chatme/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../service/database_service.dart';
import '../../widgets/widget.dart';

class NotesPage extends StatefulWidget{
  @override

  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Stream? notes;
  String userName = "";
  bool _isloading = false;
  String title ="";
  String detailnotes = "";
  String notesid = "";
  Authservice authservice = Authservice();

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
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserNotes()
        .then((snapshot) {
      setState(() {
        notes = snapshot;
      });
    });

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

  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(

          title: Text("Notes",style: TextStyle(color: Colors.black,fontSize: 30),),
          backgroundColor: Colors.white,
        ),
      body: notesList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0Xff34835F),
        shape: CircleBorder(),
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: (){
          popUpDialog(context);
        },

      ),
    );


  }

  popUpDialog(BuildContext context) {
    showDialog(

        barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Color(0xFFF0F1EC),
            title: Text("Title",textAlign: TextAlign.left,),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 250,
                  height: 50,
                  child: TextField(
                    onChanged: (val){
                      setState(() {
                        title = val;
                      });
                    },
                    style:  TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder:  OutlineInputBorder(
                            borderSide:  BorderSide(color: Color(0Xff34835F)),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        errorBorder:  OutlineInputBorder(
                            borderSide:  BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        focusedBorder:  OutlineInputBorder(
                            borderSide:  BorderSide(color: Color(0Xff34835F)),
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  child: TextField(
                    maxLines: 3,
                    onChanged: (val){
                      setState(() {
                         detailnotes = val;
                      });
                    },
                    style:  TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                       border: InputBorder.none,
                        hintText: "Enter Your Detailed Note Here..",
                        hintStyle: TextStyle(color: Colors.black,fontSize: 16)
                    ),
                  ),
                ),

              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Cancel",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0Xff34835F),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if(title != ""){
                    setState(() {
                      _isloading= true;
                    });
                    DatabaseService(uid : FirebaseAuth.instance.currentUser!.uid)
                        .createNotes(userName,FirebaseAuth.instance.currentUser!.uid, title,detailnotes)
                        .whenComplete(() {
                      _isloading = false;
                    });
                    Navigator.of(context).pop();
                    showSnackbar(context, Colors.green, "Note Created");

                  }
          },
                child: Text("Create",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0Xff34835F),
                ),
              )
            ],
          );
        });
  }
  notesList() {
    return StreamBuilder(
      stream: notes,
      builder: (context, AsyncSnapshot snapshot) {
        //checks
        if (snapshot.hasData) {
          if (snapshot.data['notes'] != null) {
            if (snapshot.data['notes'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['notes'].length,

                  itemBuilder: (context, index){
                    int reverseIndex = snapshot.data['notes'].length - index - 1;
                    return NotesTile(
                      notesid: getId(snapshot.data['notes'][reverseIndex]),
                        title: getName(snapshot.data['notes'][reverseIndex]),
                        detailnotes: getdetail(snapshot.data['notes'][reverseIndex])   ,

                    );
                  }

              );
            } else {
              return noNotesWidget();
            }
          } else {
            return noNotesWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator(color: Theme
              .of(context)
              .primaryColor));
        }
      },
    );
  }

  noNotesWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Center(child : Text("You have not Created any notes",
        textAlign: TextAlign.center,))
    );
  }
}