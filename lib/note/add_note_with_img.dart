import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_firebase2/note/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:learn_firebase2/Custom_button_upload.dart';





class AddImgWithNote extends StatefulWidget {
   AddImgWithNote({Key? key, required this.docId}) : super(key: key);
final String docId;
  @override
  State<AddImgWithNote> createState() => _AddImgWithNoteState();
}

class _AddImgWithNoteState extends State<AddImgWithNote> {
TextEditingController noteController=TextEditingController();


  AddImgWithNote()async{
try{
        CollectionReference collNote= FirebaseFirestore.instance.collection('categories').doc(widget.docId).collection('note');

DocumentReference response=await  collNote.add({
  'note':noteController.text,
   'url':url
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
   File? file;
  String ?url;
  getImage()async{
    final ImagePicker picker = ImagePicker();

final XFile? photo = await picker.pickImage(source: ImageSource.camera);
if(photo!=null){
   file=File(photo.path);
   var imageName=basename(photo.path);
   var refStoreage=FirebaseStorage.instance.ref('images/$imageName');
   await refStoreage.putFile(file!);
 url=await refStoreage.getDownloadURL();


}
setState(() {
  
});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Add note'),),
    body: Column(children: [
           TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'note',
                    hintText: 'Enter your note',
                  ),
                 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an note';
                    }
              
                    return null;
                  },
            
                ),
    CustomButtonUpload(title: 'uploadImage', isSelected: url==null?false:true,onPress: () async{
     await getImage();
    },),
    TextButton(onPressed:(){
      AddImgWithNote();
      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNote(catId: widget.docId,),));
    } , child: const Text('Add'))
    ],),
    );
  }
}