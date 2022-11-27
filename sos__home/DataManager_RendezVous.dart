import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class add_rv extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final String date_rv ;

  add_rv(this.date_rv);


  @override
  Widget build(BuildContext context) {
    CollectionReference rv = FirebaseFirestore.instance.collection('rendezvous');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    Future<void> addrv() {
      return rv
          .add({
        'date': date_rv,
        'valider': false,
        'id_client':uid,

      })
          .then((value) => print("rv Added"))
          .catchError((error) => print("Failed to add rv: $error"));
    }

    return TextButton(
        onPressed: (){
          addrv;

          },
        child: Text(
        "Add rv",
    ),
    );
  }
}
