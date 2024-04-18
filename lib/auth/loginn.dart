import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn_firebase2/auth/homepage.dart';
import 'package:learn_firebase2/auth/signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
if(googleUser==null){
  return ;
}
  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
   await FirebaseAuth.instance.signInWithCredential(credential);
   Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
}
   
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  TextEditingController emailController=TextEditingController();
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
   bool isLoading=false;
  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    try {
      isLoading=true;
setState(() {
  
});
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: _email,
    password: _password
  );
isLoading=false;
setState(() {
  
});
  if(credential.user!.emailVerified){
  
   Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));

  }else{
    showErrorDialog(context, 'please go to your Email and click verified link');
  }
  
} on FirebaseAuthException catch (e) {
  isLoading=false;
setState(() {
  
});
  if (e.code == 'user-not-found') {
    print('user not found');
showErrorDialog(context, 'المستخدم غير موحود');
  } else if (e.code == 'wrong-password') {
    print('passwrd not correct');
  showErrorDialog(context, 'كلمة المرور غير صحيحه');
  }
}
      print('Email: $_email, Password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Form'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: isLoading?Center(child: CircularProgressIndicator(),):Column (
              children: [
                TextFormField(
                  controller: emailController,
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
                TextButton(onPressed: ()async{

               try {
  await   FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
     showErrorDialog(context, 'go to your emila and click link to rest password');
} on Exception catch (e) {
print(e);
}
                }, child: Text('Forget Password')),
             
                SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Login'),
                ),
                   SizedBox(height: 20,),
                TextButton(onPressed:(){
            
                }, 
                child: TextButton(child: Text('Login Use Google'),
                onPressed: () {
            signInWithGoogle();
            
             },
                )),
                SizedBox(height: 40,),
                MaterialButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => SignUp(),));
                },
                child: Text('have\'nt account '),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}