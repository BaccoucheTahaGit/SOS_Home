import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Agent_rendez_vous_view extends StatefulWidget {
  const Agent_rendez_vous_view({Key? key}) : super(key: key);

  @override
  State<Agent_rendez_vous_view> createState() => _Agent_rendez_vous_viewState();
}

class _Agent_rendez_vous_viewState extends State<Agent_rendez_vous_view> {
  final agent = FirebaseAuth.instance.currentUser!;
  CollectionReference rv = FirebaseFirestore.instance.collection('rendezvous');

  final List<String> docIDs = [];

  var documentID;
  String id = "";

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    void retrivedata() {
      rv.get().then((value) => {
            value.docs.forEach((element) {
              Map<String, dynamic> data =
                  element.data() as Map<String, dynamic>;
              if (uid == data['agent_id'].toString()) {
                print("date : " + data['date']);
                print("time : " + data['temps']);
              }
            })
          });
    }

    Future getDocIDs() async {
      await FirebaseFirestore.instance.collection('rendezvous').get().then(
            (snapshot) => snapshot.docs.forEach((doc) {
              if (doc.reference.id == uid) {
                docIDs.add(doc.reference.id);
              }
            }),
          );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 70),
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream:
                    rv.where("agent_id", isEqualTo: uid.toString()).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                      color: Colors.grey[200],



                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(

                        children: snapshot.data!.docs.map((document) {
                      return Card(
                        elevation: 1,
                        child: ListTile(
                          title: Text(document['temps'].toString()+" "+document['date'].toString()),
                          subtitle: ListTile(
                            contentPadding: EdgeInsets.all(20),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      minimumSize:
                                          const Size.fromHeight(50), // NEW
                                    ),
                                    onPressed: ()  async{
                                      document.reference.update({'valider' : true});
                                    },
                                    child: const Text(
                                      'valider',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      minimumSize:
                                          const Size.fromHeight(50), // NEW
                                    ),
                                    onPressed: () async {
                                      document.reference.update({'valider' : false});

                                    },
                                    child: const Text(
                                      'refuser',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          //  trailing: Text(document['client_id'].toString()),
                        textColor: Colors.white,
                          tileColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder( //<-- SEE HERE
                            side: BorderSide(width: 2 , color: Colors.orange),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList()),
                  );
                },
              ),

              /*
Expanded(
      child: FutureBuilder(
        future:getDocIDs(),
        builder: (context,snapshot){

          return ListView.builder(
              itemCount:docIDs.length,
              itemBuilder: (context,index){
                return Padding(padding: EdgeInsets.all(8),
                  child:
                  ListTile(
                    contentPadding: EdgeInsets.all(20),

                    tileColor: Colors.orangeAccent,
                    title: getData(documentId: docIDs[index],agentId: uid.toString())!,

                  ),

                );

              return ListTile(
                  contentPadding: EdgeInsets.all(20),
                  title: Row(
                    children: <Widget>[
                      getData(documentId: docIDs[index],agentId: uid.toString()),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            minimumSize: const Size.fromHeight(30), // NEW
                          ),
                          onPressed:() async{
                            await rv
                                .doc(uid.toString())
                                .update({'valider' : true})
                                .then((value) => print("User Updated"))
                                .catchError((error) => print("Failed to update user: $error"));
                          } ,
                          child:const Text(
                            'valider',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      Expanded(
                        child:ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            minimumSize: const Size.fromHeight((30)), // NEW
                          ),

                          onPressed:() async{
                            await rv
                                .doc(uid.toString())
                                .update({'valider' : false})
                                .then((value) => print("User Updated"))
                                .catchError((error) => print("Failed to update user: $error"));
                          } ,
                          child:const Text(
                            'refuser',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                );



              },
              );
        },
      )

    ),*/
            ],
          ),
        ),
      ),
    );
  }
}
