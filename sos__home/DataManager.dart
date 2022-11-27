
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetPhoneNumber  {
  final String documentID;


  GetPhoneNumber({required this.documentID});
  final CollectionReference _user = FirebaseFirestore.instance.collection("Users");
  Future<String?> getphone(String phoneNumber) async{

      DocumentSnapshot variable = await _user.doc(documentID).get();
      phoneNumber = variable["phoneNumber"];
      print("phone number = ${phoneNumber}");
      return phoneNumber;


  }

}
