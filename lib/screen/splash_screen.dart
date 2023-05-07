import 'package:chat_messg/screen/auth/lodin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';



class splash_screen extends StatefulWidget {
  const splash_screen ({Key? key}) : super(key: key);

  @override
  State<splash_screen > createState() => _MyHomeState();
}

class _MyHomeState extends State<splash_screen > {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
        const Duration(seconds: 3),(){
          if(FirebaseAuth.instance.currentUser!=null){
            print("User:${FirebaseAuth.instance.currentUser}");

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHome()));
          }
          else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => loginscreen()),
            );
          }
    }


    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(




      body: Stack(
        children: [
          Positioned(
              height: 250,
              width: 250,
              top: 150,
              left: 50,
              //   left: 100,

              child: Image.asset('asset/image/splashicon1.png')),
          Positioned(

            top: 500,
            left: 70,
            child: Text("Made In Pakistan With 💗",style: TextStyle(fontSize: 20),),

          ),

        ],
      ),

    );
  }
}
