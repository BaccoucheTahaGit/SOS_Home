import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'otp_verif.dart';

class VerificationOtp extends StatefulWidget {
  const VerificationOtp(
      {Key? key, required this.VerificationId, required this.phoneNumber})
      : super(key: key);
  final String VerificationId;
  final String phoneNumber;

  @override
  State<VerificationOtp> createState() => _VerificationOtpState();
}

class _VerificationOtpState extends State<VerificationOtp> {

  var otp = "";
  bool loading = false;
  bool resend = false;
  int count = 60;
  final _auth = FirebaseAuth.instance;

  late Timer timer;

  void decompte() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (count < 1) {
        timer.cancel();
        count = 60;
        resend = true;
        setState(() {});
        return;
      }
      count--;
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    decompte();
  }

  void onResendSmsCode() {
    authwithphonenumber(widget.phoneNumber, onCodeSend: (verificationId, v) {
      loading = false;
      resend = false;
      decompte();
      setState(() {});
    }, onAuthVerify: (v) async {
      await _auth.signInWithCredential(v);
    }, onFailed: (e) {
      print("wrong code !!");
    }, autoRetrieval: (v) {});
  }

  void onVerifySmsCode() async {
    loading = true;
    setState(() {});
    await validateOTP(otp, widget.VerificationId);
    loading = true;
    setState(() {});
    Navigator.of(context).pop();
    print("verification success !!");
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
            alignment: Alignment.center,

            child: Column(children: <Widget>[

              Container(
                child: Image.asset('assets/Otp3.png',width:MediaQuery.of(context).size.width,),
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                child: Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              Container(
                child: Text('We will send you a one time Password on this'),
              ),
              Container(
                child: Text(
                  'mobile number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                child: Pinput(
                  length: 6,
                  onChanged: (pin)  {
                    otp = pin;
                    print("changed : "+otp.length.toString());
                    setState(() {

                    });

                },
                ),
              ),
              Container(

                child: TextButton(
                  onPressed: !resend ? null : onResendSmsCode,
                  style: TextButton.styleFrom(
                    primary: Colors.orange,
                  ),
                  child: Text(
                    !resend ? "00:${count.toString().padLeft(2, "0")}" : 'Resend OTP ?',

                  ),

                  ),
                ),

              Container(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: otp.length < 6 || loading
                      ? null
                      : onVerifySmsCode,
                  child: loading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(fontSize: 24),
                        ),
                ),
              )
            ])),
      );
    }
}

/**/
