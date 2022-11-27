import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ConnexionView extends StatefulWidget{
  const ConnexionView({Key? key}) : super(key: key);

  @override
  State<ConnexionView> createState() => _ConnexionView();

  }
  class _ConnexionView extends State<ConnexionView>{
    final CollectionReference _user = FirebaseFirestore.instance.collection("Users");
    @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Firebase Firestore')),
          ),
          body: StreamBuilder(
            stream: _user.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(documentSnapshot['phonenumber']),
                        subtitle: Text(documentSnapshot['name'].toString()),
                        trailing: SizedBox(
                          width: 100,
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );

            },
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
      );
    }
}