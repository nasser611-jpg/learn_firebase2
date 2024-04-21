import 'package:flutter/material.dart';
import 'package:learn_firebase2/note/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UpdateNote extends StatefulWidget {
   UpdateNote({Key? key, required this.noteId, required this.catId}) : super(key: key);
final String noteId;
final String catId;
  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
TextEditingController noteController=TextEditingController();


  updateNote()async{
try{
        CollectionReference collNote= FirebaseFirestore.instance.collection('categories').doc(widget.catId).collection('note');

await  collNote.doc(widget.noteId) .  update({
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
      updateNote();
      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNote(catId: widget.catId,),));
    } , child: const Text('save'))
    ],),
    );
  }
}