import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transction extends StatefulWidget {
  const Transction({Key? key}) : super(key: key);

  @override
  State<Transction> createState() => TransctionState();
}

class TransctionState extends State<Transction> {
  List<QueryDocumentSnapshot> data = [];

  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection('users').snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15),
        color: Color.fromARGB(26, 245, 242, 242),
        child: StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
          
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
               DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.docs[index].id);
                    FirebaseFirestore.instance.runTransaction((transaction)async{
                      DocumentSnapshot snapshot =await transaction.get(documentReference) ;
                      if(snapshot.exists){
                        var snapshotData=snapshot.data();
                        if(snapshotData is Map<String,dynamic>){
                          int money=snapshotData['money']+100;
                          transaction.update(documentReference, {"money":money});
                        }
                      }

                    });
            },
            child: Card(child: ListTile(title: Text(snapshot.data?.docs[index]['username'],style: TextStyle(fontSize: 27),),
            subtitle: Text('${snapshot.data?.docs[index]['age']}'),
            trailing: Text('${snapshot.data?.docs[index]['money']}'),
            
            ),),
          );
        },);
  }),
    ));
  }
}

                // DocumentReference documentReference = FirebaseFirestore.instance
                //     .collection('users')
                //     .doc(data[index].id);
                //     FirebaseFirestore.instance.runTransaction((transaction)async{
                //       DocumentSnapshot snapshot =await transaction.get(documentReference) ;
                //       if(snapshot.exists){
                //         var snapshotData=snapshot.data();
                //         if(snapshotData is Map<String,dynamic>){
                //           int money=snapshotData['money']+100;
                //           transaction.update(documentReference, {"money":money});
                //         }
                //       }

                //     }).then((value) => Navigator.push(context, MaterialPageRoute(builder:(context) {
                //       return Transction();
                //     },)));
                   