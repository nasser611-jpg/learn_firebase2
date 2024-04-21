import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transction extends StatefulWidget {
  const Transction({Key? key}) : super(key: key);

  @override
  State<Transction> createState() => TransctionState();
}

class TransctionState extends State<Transction> {
  List<QueryDocumentSnapshot> data = [];
  initialData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot usersdata = await users.get();
    usersdata.docs.forEach((element) {
      data.add(element);
    });
    setState(() {});
  }

  @override
  void initState() {
    initialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15),
        color: Color.fromARGB(26, 245, 242, 242),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection('users')
                    .doc(data[index].id);
                    FirebaseFirestore.instance.runTransaction((transaction)async{
                      DocumentSnapshot snapshot =await transaction.get(documentReference) ;
                      if(snapshot.exists){
                        var snapshotData=snapshot.data();
                        if(snapshotData is Map<String,dynamic>){
                          int money=snapshotData['money']+100;
                          transaction.update(documentReference, {"money":money});
                        }
                      }

                    }).then((value) => Navigator.push(context, MaterialPageRoute(builder:(context) {
                      return Transction();
                    },)));
                   
              },
              child: Card(
                child: ListTile(
                  trailing: Text(
                    '${data[index]['money'].toString()} \$',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  title: Text(
                    ' ${data[index]['username']}',
                    style: TextStyle(fontSize: 27),
                  ),
                  subtitle: Text('age ${data[index]['age']}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
