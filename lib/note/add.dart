import 'package:flutter/material.dart';
import 'package:learn_firebase2/note/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddNote extends StatefulWidget {
   AddNote({Key? key, required this.docId}) : super(key: key);
final String docId;
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
TextEditingController noteController=TextEditingController();


  addNote()async{
try{
        CollectionReference collNote= FirebaseFirestore.instance.collection('categories').doc(widget.docId).collection('note');

DocumentReference response=await  collNote.add({
  'note':noteController.text,

});

}catch(e){
  print('Erorr $e');
}
  }
@override
  void dispose() {
 noteController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Add Category'),),
    body: Column(children: [
           TextFormField(
                  controller: noteController,
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
      addNote();
      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNote(catId: widget.docId,),));
    } , child: const Text('Add'))
    ],),
    );
  }
}