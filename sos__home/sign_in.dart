
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:soshome/DataManager.dart';
import 'package:soshome/verification_otp.dart';

import 'otp_verif.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool loading = false;
  String phoneNumber = "";



  void SendOtpCode() {
    loading = true;
    setState(() {});
    final _auth = FirebaseAuth.instance;
    if (phoneNumber.isNotEmpty) {
      authwithphonenumber(phoneNumber, onCodeSend: (verificationId, v) {
        loading = false;
        setState(() {});
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => VerificationOtp(
                VerificationId: verificationId, phoneNumber: phoneNumber)));
      }, onAuthVerify: (v) async {
        await _auth.signInWithCredential(v);
      }, onFailed: (e) {
        print("wrong code !!");
      }, autoRetrieval: (v) {});
    }
  }

  List<String> docIDs = [];
  var documentID;
  String id="";

  Future getDocIDs() async {
    await FirebaseFirestore.instance.collection('Users').get().then(
          (snapshot) => snapshot.docs.forEach((doc) {
            print(doc.reference.id);
            docIDs.add(doc.reference.id);
          }),
        );
  }

  Future<String?> getDocID() async{
    try{
    var collection = FirebaseFirestore.instance.collection('Users');
    var querySnapshots = await collection.get();
    for (var snapshot in querySnapshots.docs) {
      var x = snapshot.get("email");
      print(x.toString());
      documentID = snapshot.id;
      print("id1 = " + documentID);
      id = documentID.toString(); //
      return id; // <-- Document ID
    };
    }catch(e){e.toString();      print("id2 = " + id);
    return "id3 = " + id;}
  }

  /*final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const Text(
                "sign in",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              IntlPhoneField(
                initialCountryCode: "TN",
                onChanged: (value) {
                  print(value.completeNumber);
                  phoneNumber = value.completeNumber;
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15)),
                    onPressed: loading ? null : SendOtpCode,
                    child: loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : const Text(
                            "sign in",
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Future<String?> strinf= getDocID();
                      id =(await strinf)!;
                      phoneNumber=GetPhoneNumber(documentID: id)
                          .getphone(phoneNumber) as String;

                      print(GetPhoneNumber(documentID: id)
                          .getphone(phoneNumber));
                    },
                    child: Text("qsdqd"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
