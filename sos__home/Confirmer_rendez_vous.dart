import 'package:flutter/material.dart';

import 'otp_verif.dart';




class confirmer_view extends StatefulWidget {

  const confirmer_view(
  {Key? key,requir, required this.date, required this.temps, required this.user_id})
: super(key: key);
  final String date;
  final String temps;
  final String? user_id;


  @override
  State<confirmer_view> createState() => _confirmer_viewState();
}

class _confirmer_viewState extends State<confirmer_view> {


  @override
  Widget build(BuildContext context) {
  return Scaffold(

        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Home page"),
          actions: [
            IconButton(onPressed: () async {
              await logout();
            }, icon: const Icon(Icons.power))
          ],
        ),
        body:
        Container(

        padding: EdgeInsets.only(top: 180),
    alignment: Alignment.center,

    child: Column(children: <Widget>[
        Text("date = "+widget.date),
      Text("Temps = "+widget.temps),
      Text("uid = "+widget.user_id.toString()),


    ],
      ),
        ),
          );
  }
}
