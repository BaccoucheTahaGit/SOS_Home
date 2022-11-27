import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soshome/rendez_vous.dart';
import 'package:soshome/rendez_vous_agent.dart';
import 'package:soshome/signIn.dart';
import 'package:soshome/sign_in.dart';
import 'package:soshome/verification_otp.dart';
import 'connexion.dart';
import 'home.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: "sos HOME",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.orange),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.data == null ? const SignInScreen() : const Home();
        },
      ),
    );
  }
}
/*Scaffold(
     appBar: AppBar(
       title: Text("soshome"),
     ),
     body: Center(
       child: VerificationOtp(VerificationId: '2xFvsQsVS6M1JjONHKa4HaTldsE2',phoneNumber: '+21698664063'),
     )
   ),


StreamBuilder<User?>(
stream: _auth.authStateChanges(),
builder: ((context, snapshot) {
return snapshot.data == null ? const SignInView() : MyApp();
}),

 */
