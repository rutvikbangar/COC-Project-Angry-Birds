
import 'package:chatme/master_page.dart';
import 'package:chatme/pages/Notes/Notes_mainpage.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../service/database_service.dart';



class DetailNotes extends StatefulWidget{
  String detailnotes;
  String title;
  String notesid;



  DetailNotes( {Key? key,required this.notesid,required this.title,required this.detailnotes}) : super(key: key);

  @override
  State<DetailNotes> createState() => _DetailNotesState();
}

class _DetailNotesState extends State<DetailNotes> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      title: Text("${widget.title}",style: TextStyle(fontSize: 23),),

        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 20),
            child: Text(widget.detailnotes,style: TextStyle(fontSize: 20),),
          )

        ],

      ),
      bottomSheet:  Container(
        color: Colors.white,
        width: 375,
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: (){

                  DatabaseService(uid : FirebaseAuth.instance.currentUser!.uid)
                      .deletenotesfromnotes(widget.notesid);

                  DatabaseService(uid : FirebaseAuth.instance.currentUser!.uid).
                  deletenotesfromuser(widget.notesid, widget.title, widget.detailnotes).whenComplete((){
                    nextScreenReplace(context, NotesPage());
                  });
                  ;

                },

                icon: Icon(Icons.delete,size:30,color: Color(0xff595959))),
          ],
        ),
      ),

    );
  }

}



