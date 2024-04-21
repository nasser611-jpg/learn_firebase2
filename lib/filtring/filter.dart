import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Filtring extends StatefulWidget {
  const Filtring({Key? key}) : super(key: key);

  @override
  State<Filtring> createState() => FiltringState();
}

class FiltringState extends State<Filtring> {
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
            return Card(
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
            );
          },
        ),
      ),
    );
  }
}
