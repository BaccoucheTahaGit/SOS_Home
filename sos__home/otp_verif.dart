import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;

void authwithphonenumber(String phone,
    {required Function(String value, int? value1) onCodeSend,
    required Function(PhoneAuthCredential value) onAuthVerify,
    required Function(FirebaseAuthException value) onFailed,
    required Function(String value) autoRetrieval}) async {
  _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: onAuthVerify,
      verificationFailed: onFailed,
      codeSent: onCodeSend,
      codeAutoRetrievalTimeout: autoRetrieval);
}

Future<void> validateOTP(String smsCode, String verf_id) async {
  final _credential =
      PhoneAuthProvider.credential(verificationId: verf_id, smsCode: smsCode);
  await _auth.signInWithCredential(_credential);
  return;
}

Future<void>logout() async {
  await _auth.signOut();
  return;
}

User? get user => _auth.currentUser;


