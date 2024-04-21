import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learn_firebase2/transaction/transction.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyDejpQM_EedgtqDDHQ5XgACh6f7ouCuh3I',
    appId: '1:710785220796:android:f4144c4ef95b804ba550b9',
    messagingSenderId: 'sendid',
    projectId: 'tareeq-c4fbd',
    storageBucket: 'tareeq-c4fbd.appspot.com',
  )
    );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('====================User is currently signed out!');
    } else {
      print('====================User is signed in!');
    }
  });    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Transction(),
      // home:FirebaseAuth.instance.currentUser!=null&&FirebaseAuth.instance.currentUser!.emailVerified? HomePage():Login()
    );
  }
}




