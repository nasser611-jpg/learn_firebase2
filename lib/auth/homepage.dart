import 'package:flutter/material.dart';
import 'package:learn_firebase2/note/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_firebase2/auth/loginn.dart';
import 'package:learn_firebase2/auth/update.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn_firebase2/auth/adminpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_firebase2/auth/add_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data=[];
  bool isLoading=true;
getData()async{
  QuerySnapshot querySnapshot=
 await FirebaseFirestore.instance
    .collection('categories').where('id',isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .get();

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
    return Container(

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(onPressed:(){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>AddCategory(),)
        
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
          title: Text('HomePage'),
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewNote(catId: data[index].id);
                },));
              },
              onLongPress: () {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        headerAnimationLoop: true,
                        title: 'Erorr',
                        btnOkText: 'delete',
                        btnCancelText: 'eidt',
                        desc:
                            'are sure you want to delete Item?',
                        btnOkOnPress: () async{
      
                        await FirebaseFirestore.instance
      .collection('categories').doc(data[index].id).delete();
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                        },
                        btnCancelOnPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateCategorey(uid:data[index].id),));
                         
                        },
                      ).show();
              },
              child: GridTile(
                child: Container(
                  width: 100,height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      
                      Icon(Icons.folder,size: 30,),
                      SizedBox(height: 5,),
                      Text(data[index]['name'].toString()),
                    
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
