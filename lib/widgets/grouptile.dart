import 'package:chatme/widgets/widget.dart';
import 'package:flutter/material.dart';
import '../pages/finding_people/chatpage.dart';

class GroupTile extends StatefulWidget{
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile({Key? key,
    required this.groupName,
    required this.userName,
    required this.groupId})
  : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(
            userName: widget.userName,
            groupName: widget.groupName,
            groupId: widget.groupId)
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),

        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,fontWeight: FontWeight.w500
            ),),
          ),
          title: Text(widget.groupName,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.userName}",style: TextStyle(fontSize: 13),),
        ),
      ),
    );

  }
}