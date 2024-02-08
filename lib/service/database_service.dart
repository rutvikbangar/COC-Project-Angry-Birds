import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //reference of our collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupsCollection = FirebaseFirestore.instance.collection("groups");
  final CollectionReference notesCollection = FirebaseFirestore.instance.collection("notes");


  //update the userdata
Future updateUserData(String fullname,String email) async {
  return await userCollection.doc(uid).set({
    "fullname": fullname,
    "email" : email,
    "groups" : [],
    "profilepic" : "",
    "uid" : uid,
    "notes" : [],
    //LOCATION
    "location" : [],
  });

}

//getting user data
Future gettingUserData(String email) async {
  QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
  return snapshot;
}
// getting the user groups
 getUserGroups() async {
  return userCollection.doc(uid).snapshots();
 }


 // getting user notes
  getUserNotes() async {
    return userCollection.doc(uid).snapshots();
  }
  //update Location
  getUserLocation() async {
    return userCollection.doc(uid).snapshots();
  }

  //update location
  Future updateLocation(String id,String coordinates,String address) async {
  DocumentReference userDocumentReference = userCollection.doc(uid);
  return await userDocumentReference.update({
    "location" : FieldValue.arrayUnion(["${id}_${address}_${coordinates}"])
  });
  }


 //Creating a note
 Future createNotes(String userName,String id, String title,String detailnotes) async {
  DocumentReference notesDocumentReference = await notesCollection.add({
    "title" : title,
    "notesowner" : "${id}_$userName",
    "detailnotes" : detailnotes,
    "notesid" : ""
  });
  await notesDocumentReference.update({
    "notesid" : notesDocumentReference.id,
  });
  //updating notes in user
  DocumentReference userDocumentReference = userCollection.doc(uid);
  return await userDocumentReference.update({
    "notes" : FieldValue.arrayUnion(["${notesDocumentReference.id}_${title}_$detailnotes"])
  });


 }


 // Creating a group
  Future createGroup(String userName,String id, String groupName) async {
  DocumentReference groupDocumentReference = await groupsCollection.add({
    "groupName" : groupName,
    "groupIcon" : "",
    "admin" : "${id}_$userName",
    "members" : [] ,
    "groupId" : "",
    "recentMessage" : "",
    "recentMessageSender" : "",
  });
  //update the members
   await groupDocumentReference.update({
     "members" : FieldValue.arrayUnion(["${uid}_$userName"]),
     "groupId" : groupDocumentReference.id,
   });

   DocumentReference userDocumentReference = userCollection.doc(uid);
   return await userDocumentReference.update({
     "groups" : FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
   });

 }
 getChats(String groupId) async {
  return groupsCollection
      .doc(groupId)
      .collection("messages")
      .orderBy("time")
      .snapshots();
 }
 Future getGroupAdmin(String groupId) async{
  DocumentReference d = groupsCollection.doc(groupId);
  DocumentSnapshot documentSnapshot = await d.get();
  return documentSnapshot['admin'];
 }
getGroupMembers(groupId) async {
  return groupsCollection.doc(groupId).snapshots();
}
//search
searchByName(String groupName){
  return groupsCollection.where("groupName",isEqualTo: groupName).get();
}
//function -> bool
Future<bool> isUserJoined(String groupName,String groupId,String userName) async {
  DocumentReference userDocumentReference = userCollection.doc(uid);
  DocumentSnapshot documentSnapshot = await userDocumentReference.get();

  List<dynamic> groups =  await documentSnapshot['groups'];
  if(groups.contains("${groupId}_$groupName")){
    return true;
  }else{
    return false;
  }
}
//toggling the group join or exit
Future toggleGroupJoin(String groupId,String userName,String groupName) async {
  // doc reference
  DocumentReference userDocumentReference = userCollection.doc(uid);
  DocumentReference groupDocumentReference = groupsCollection.doc(groupId);

  DocumentSnapshot documentSnapshot = await userDocumentReference.get();
  List<dynamic> groups = await documentSnapshot['groups'];

  //if user has our groups --> then remove then or arise in other part re join
  if(groups.contains("${groupId}_$groupName")){
    await userDocumentReference.update({
      "groups" : FieldValue.arrayRemove(["${groupId}_$groupName"])
    });
    await groupDocumentReference.update({
      "members" : FieldValue.arrayRemove(["${uid}_$userName"])
    });
  }else{
    await userDocumentReference.update({
      "groups" : FieldValue.arrayUnion(["${groupId}_$groupName"])
    });
    await groupDocumentReference.update({
      "members" : FieldValue.arrayUnion(["${uid}_$userName"])
    });
  }
}
//send
  sendMessage(String groupId,Map<String, dynamic> chatMessageData) async {
  groupsCollection.doc(groupId).collection("messages").add(chatMessageData);
  groupsCollection.doc(groupId).update({
    "recentMessage": chatMessageData['message'],
    "recentMessageSender": chatMessageData['sender'],
    "recentMessageTime" : chatMessageData['time'].toString()

  });
  }




  // deleting notes


  Future deletenotesfromnotes(String id) async {
  FirebaseFirestore.instance.collection("notes").doc(id).delete();

  }

  Future deletenotesfromuser(String notesid,String title,String detailnotes ) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);



    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> notes = await documentSnapshot['notes'];

    if(notes.contains("${notesid}_${title}_$detailnotes")){
      await userDocumentReference.update({
        "notes" : FieldValue.arrayRemove(["${notesid}_${title}_$detailnotes"])
      });

    }



  }

  Future deletelocationfromuser(String id,String address,String coordinates ) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);



    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> notes = await documentSnapshot['location'];

    if(notes.contains("${id}_${address}_${coordinates}")){
      await userDocumentReference.update({
        "location" : FieldValue.arrayRemove(["${id}_${address}_${coordinates}"])
      });

    }



  }


}

