import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase2/auth/loginn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String userName='';
    void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطاء'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('حسناً'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
 
  void _submitForm() async{
    if (_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _email,
    password: _password,
  );
 FirebaseAuth.instance.currentUser!.sendEmailVerification();
 showErrorDialog(context, 'move to your emial to verfiey ');
      Navigator.push(context, MaterialPageRoute(builder:(context) => Login(),));


} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    
    showErrorDialog(context,'هذا الحساب مستخدم بالفعل');
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}
      // Here you can handle the SignUp logic with the state values
      print('Email: $_email, Password: $_password , ' 'username: $userName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Form'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'UserName',
                  hintText: 'Enter your username',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an username';
                  }
                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
                onSaved: (value) => userName = value!,
              ),
                     TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
           
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Signup'),
              ),
              SizedBox(height: 30,),
            MaterialButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => Login(),));
              },
              child: Text('alredy have account'),
              )
            ],
          ),
        ),
      ),
    );
  }
}