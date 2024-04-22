import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notifation extends StatefulWidget {
  const Notifation({Key? key}) : super(key: key);

  @override
  State<Notifation> createState() => _NotifationState();
}

class _NotifationState extends State<Notifation> {
  getToken() async {
    String? myToken = await FirebaseMessaging.instance.getToken();

    print('==================================');
    print('$myToken');
    print('Failed to retrieve token');
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
