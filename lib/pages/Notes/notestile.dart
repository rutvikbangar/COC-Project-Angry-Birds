import 'package:chatme/pages/Notes/notesdetailpage.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotesTile extends StatefulWidget{
  final String title;
  final String detailnotes;
  final String notesid;

  const NotesTile({Key? key,required this.notesid,
    required this.title,required this.detailnotes})
      : super(key: key);



  @override
  State<NotesTile> createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        nextScreen(context, DetailNotes(
            notesid: widget.notesid,
            title: widget.title,
            detailnotes: widget.detailnotes));

      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8,right: 8,top: 12),
        child: Card(
          elevation: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFFF0F1EC),
              borderRadius: BorderRadius.circular(12),
            ),

            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            child: ListTile(
              title: Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              leading: Icon(Icons.notes,size: 45,),
              trailing:Icon(CupertinoIcons.pencil,size: 30,) ,
            ),
          ),
        ),
      ),
    );
  }
}