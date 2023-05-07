import 'package:flutter/material.dart';
class dialoge{
  static void snakbar(BuildContext context,String mess){

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),backgroundColor: Colors.cyan,behavior: SnackBarBehavior.floating,));
  }

  static void progress(BuildContext context){
    showDialog(context: context, builder:(_)=>
        Center(child: CircularProgressIndicator())
    );
  }
}