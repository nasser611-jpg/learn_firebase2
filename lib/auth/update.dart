import 'package:flutter/material.dart';
import 'package:learn_firebase2/auth/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UpdateCategorey extends StatefulWidget {
  final String  uid;
   UpdateCategorey({Key? key, required this.uid}) : super(key: key);

  @override
  State<UpdateCategorey> createState() => _UpdateCategoreyState();
}

class _UpdateCategoreyState extends State<UpdateCategorey> {
TextEditingController catController=TextEditingController();

      CollectionReference user= FirebaseFirestore.instance.collection('categories');

  updateCategory()async{
try{
await  user.doc(widget.uid).update({
'name':catController.text
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
      updateCategory();
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
    } , child: const Text('save'))
    ],),
    );
  }
}