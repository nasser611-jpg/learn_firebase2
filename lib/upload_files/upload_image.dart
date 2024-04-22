import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';





class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);
// Pick an image.
// final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
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
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker'),),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
        IconButton(onPressed:()async{
         await getImage();
        }, icon:Icon(Icons.camera_alt_outlined)),
      if(url!=null) Image.network(url!,width: 100,height: 100,fit: BoxFit.fill,)
      
      ],),),
    );
  }
}