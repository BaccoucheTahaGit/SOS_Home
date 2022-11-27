import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Confirmer_rendez_vous.dart';


class Rendez_vous_View extends StatefulWidget {
  const Rendez_vous_View({Key? key}) : super(key: key);

  @override
  State<Rendez_vous_View> createState() => _Rendez_vous_ViewState();
}

class _Rendez_vous_ViewState extends State<Rendez_vous_View> {
  TextEditingController _date= TextEditingController();
  TextEditingController _time= TextEditingController();


  late TimeOfDay time ;
  CollectionReference rv = FirebaseFirestore.instance.collection('rendezvous');
String err="veillez choisir un autre temps dans le future";
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur',
            style: TextStyle(
              color: Colors.red,
            ),),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Remplir le date s'il vous plait ! ",
                  style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Remplir le temps s'il vous plait ! ",
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK',
                style: TextStyle(
                  color: Colors.black38, fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    String agent_uid ="vnE6qLnQcaMLCd7AnSSCT8wGXW93";

    return Scaffold(

      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      body:
      Container(

     padding: EdgeInsets.only(top: 180),
        alignment: Alignment.center,

        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(30.0),
        child:  TextField(
          readOnly: true,
          controller: _date,

          decoration: InputDecoration(
            icon: Icon(Icons.calendar_today_rounded,
            color: Colors.orange),
            labelText: "choisir une date",
            labelStyle: TextStyle(color: Colors.orange),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.orange
                ),

            ),


          ),

            style: TextStyle(color: Colors.orange),


          onTap: ()  async {

            DateTime? choisirDate= await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.orange, // <-- SEE HERE
                        onPrimary: Colors.white, // <-- SEE HERE
                        // <-- SEE HERE
                      ),

                    ),
                    child: child!,
                  );
                },
            );

            if(choisirDate != null){
              setState(() {

                _date.text=DateFormat('yyyy-MM-dd').format(choisirDate);
              });
            }
          },
        ),
      ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child:  TextField(
              readOnly: true,
              controller: _time,
              decoration: InputDecoration(
                icon: Icon(Icons.access_time_filled_sharp,
                    color: Colors.orange),
                labelText: "choisir une heure",
                labelStyle: TextStyle(color: Colors.orange),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.orange
                  ),
                ),
              ),
              style: TextStyle(color: Colors.orange),

              onTap: ()  async {

                DateTime? choisirtemps= (await showTimePicker(
                  context: context,
                  initialTime:TimeOfDay.now(),
                    errorInvalidText :err,
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          // change the border color
                          primary: Colors.orange,
                          // change the text color
                          onSurface: Colors.deepOrange,
                        ),

                      ),
                      child: child!,
                    );
                  },


               ).then((value) {
                  setState(() {
                    print("t = "+_time.text+"v = "+value.toString());
                    if((value!.hour<TimeOfDay.now().hour)/*&&(_date.text<DateTime.now().day)*/){_time.text="";}
                    else{
                      print("t = "+_time.text+"v = "+value.toString());

                      _time.text=value.hour.toString().padLeft(2,'0')+":"+value.minute.toString().padLeft(2,'0');
                      print("t = "+_time.text+"v = "+value.toString());

                    }
                  });
                })) as DateTime?;

              /*  if(choisirtemps != null){
                  setState(() {

                    _time.text=TimeOfDayFormat('hh:mm').format(choisirtemps);
                  });
                }*/

              },
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              onPressed:()async{
                print("t = "+_time.text+"  v = ");

                if((_date.text.toString()!="")&&(_time.text.toString()!="")){
    await rv
        .add({
    'date': _date.text.toString(),
    'temps':_time.text.toString(),
    'valider': null,
      'client_id':uid.toString(),
      'agent_id':agent_uid,

    }) .then((value) => print("rv Added"))
        .catchError((error) => print("Failed to add rv: $error"));

    }
                else {
                  _showMyDialog();
                };
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  confirmer_view(date: _date.text.toString(),temps: _time.text.toString(),user_id: uid),
                  ),
                );},
              child:const Text(
                'Submit',
                style: TextStyle(fontSize: 24),
              ),
            ),
          )
      ])),



    );

  }
}
