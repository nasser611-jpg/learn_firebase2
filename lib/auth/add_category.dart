import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatelessWidget {
   AddCategory({Key? key}) : super(key: key);
TextEditingController catController=TextEditingController();
      CollectionReference users = FirebaseFirestore.instance.collection('categories');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'name': catController.text, // John Doe
            // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
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
    
    TextButton(onPressed: addUser, child: const Text('Add'))
    ],),
    );
  }
}