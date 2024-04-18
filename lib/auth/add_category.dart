import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learn_firebase2/auth/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddCategory extends StatelessWidget {
   AddCategory({Key? key}) : super(key: key);
TextEditingController catController=TextEditingController();
      CollectionReference user= FirebaseFirestore.instance.collection('categories');

  addCategory()async{
try{
DocumentReference response=await  user.add({
  'name':catController.text,
  'id':FirebaseAuth.instance.currentUser!.uid
});

}catch(e){
  print('Erorr $e');
}
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Add Category'),),
    body: Column(children: [
           TextFormField(
                  controller: catController,
                  decoration: InputDecoration(
                    labelText: 'catagory',
                    hintText: 'Enter your catagory',
                  ),
                 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an catgory';
                    }
              
                    return null;
                  },
            
                ),
    
    TextButton(onPressed:(){
      addCategory();
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
    } , child: const Text('Add'))
    ],),
    );
  }
}