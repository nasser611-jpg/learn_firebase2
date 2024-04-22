import 'package:flutter/material.dart';
import 'package:learn_firebase2/note/add.dart';
import 'package:learn_firebase2/note/edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_firebase2/auth/loginn.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn_firebase2/auth/adminpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewNote extends StatefulWidget {
  const ViewNote({Key? key, required this.catId}) : super(key: key);
 final String catId;
  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List<QueryDocumentSnapshot> data=[];
  bool isLoading=true;
getData()async{
  QuerySnapshot querySnapshot=
 await FirebaseFirestore.instance
    .collection('categories').doc(widget.catId).collection('note').get();
    data.addAll(querySnapshot.docs);
    isLoading=false;
setState(() {
  
});
}

  @override
  void initState() {
   getData();
    super.initState();
  }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(floatingActionButton: FloatingActionButton(onPressed:(){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>AddNote(docId: widget.catId,),)
        
        );
        
      },
      child: Icon(Icons.add),
      ),
        appBar: AppBar(
          actions: [
            //try admin page
            IconButton(onPressed:(){
       Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage(),));
            }, icon: Icon(Icons.admin_panel_settings)),
            IconButton(
               onPressed: () async {
        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
        );
        try {
      await FirebaseAuth.instance.signOut();
      
      // Initialize GoogleSignIn
      GoogleSignIn googleSignIn = GoogleSignIn();
      // Disconnect GoogleSignIn
      await googleSignIn.disconnect();
      
        } catch (e) {
      print('error: $e');
        }
      }
      ,
                icon: Icon(Icons.exit_to_app))
          ],
          title: Text('ViewNote'),
        ),
        body:Center(
          child: isLoading?CircularProgressIndicator() :GridView.builder(
          itemCount: data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onLongPress: () {
                   AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        headerAnimationLoop: true,
                        title: 'Erorr',
                        btnOkText: 'delete',
                        btnCancelText: 'cancel',
                        
                        desc:
                            'are sure you want to delete Item?',
                        btnOkOnPress: () async{  
                                          await FirebaseFirestore.instance
     .collection('categories').doc(widget.catId).collection('note').doc(data[index].id).delete();
          if(data[index]['url']!='none'){
            FirebaseStorage.instance.refFromURL(data[index]['url']).delete();
          }
    
      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNote(catId: widget.catId,),));
                        },
                        btnCancelOnPress: () {
                          Navigator.pop(context)  ;
                        },
                      ).show();
             
              },
              onTap:() {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UpdateNote(noteId:data[index].id, catId: widget.catId);
                },));
              },
            
              child: GridTile(
                child: Container(
                  width: 100,height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      
                
                      SizedBox(height: 5,),
                      Text(data[index]['note'].toString()),
                    if(data[index]['url']!="none")
                    Image.network(data[index]['url'],width: 100,height: 100,fit: BoxFit.fill,)
                    ],
                  ),
                ),
              ),
            );
            }),
        )),
    );
  }
}
