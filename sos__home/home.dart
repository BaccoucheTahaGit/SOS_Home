import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soshome/otp_verif.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
        actions: [
          IconButton(onPressed: () async {
            await logout();
          }, icon: const Icon(Icons.power))
        ],
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Phone Number : "+(user?.phoneNumber ?? "")),
            Text("UID: "+(user?.uid ?? "")),


          ],

        ),
      ),


    );
  }
}