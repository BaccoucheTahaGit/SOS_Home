import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class getData extends StatelessWidget {
  final String documentId;
  final String agentId;
  getData({required this.documentId,required this.agentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference rv = FirebaseFirestore.instance.collection("rendezvous");
    CollectionReference users = FirebaseFirestore.instance.collection("rendezvous");

    return FutureBuilder<DocumentSnapshot>(
        future: rv.doc(documentId).get(),
builder: ((context,snapshot){
        if (snapshot.connectionState == ConnectionState.done) {

      Map<String,dynamic> data =
    snapshot.data!.data() as Map<String, dynamic>;
      if(agentId==data['agent_id']){
        return Text('date = ${data['date']} \n'+
        'time = ${data['temps']} \n');
      }

        }
        return Text("d");
  }),
    );
    return Container();
}
}
