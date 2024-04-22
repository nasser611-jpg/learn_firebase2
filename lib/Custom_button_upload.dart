import 'package:flutter/material.dart';

class CustomButtonUpload extends StatelessWidget {
  final String title;
  final void Function ()? onPress ;
  final bool isSelected;
  const CustomButtonUpload({Key? key, required this.title, this.onPress, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      minWidth: 200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color:isSelected?Colors.green: Colors.white70,
      onPressed: onPress,
    
    child: Text(title),
    );
  }
}