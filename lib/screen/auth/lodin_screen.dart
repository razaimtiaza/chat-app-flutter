import 'dart:io';
import 'dart:math';

import 'package:chat_messg/helper/dislog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/Api.dart';
import '../home_screen.dart';


class loginscreen extends StatefulWidget {
  const loginscreen({Key? key}) : super(key: key);

  @override
  State<loginscreen> createState() => _MyHomeState();
}

class _MyHomeState extends State<loginscreen> {
  bool _isAnimatio=false;
//   _handlingGooglebtnclick(){
// //for shopwing progress bar
//     dialoge.progress(context);
//     _signInWithGoogle().then((user) {
//       //for hidding progress bar
//       Navigator.pop(context);
//       if(user!=null){
//         print("function called");
//         log('User:${user?.user}'.toString() as num);
//         log('User:${user?.additionalUserInfo}'.toString() as num);
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => const MyHome()),
//         // );
//       }
//
//     }
//     );
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const MyHome()),
//     );
//
//
//   }


  // Future<UserCredential ?> _signInWithGoogle() async {
  //   try {
  //     await InternetAddress.lookup('google.com');
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken ,
  //       idToken: googleAuth?.idToken,
  //     );
  //
  //     // Once signed in, return the UserCredential
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch(e){
  //     print("Error:$e");
  //     dialoge.snakbar(context, "Somthing wrong Interneet");
  //     return null;
  //
  //   }
  //  }
  _handlegooglebtnclick()  {
    //for showing peogress bar
    // dialoge.progress(context);
    _signInWithGoogle().then((user) async {
      //for hiding progressbar
      // Navigator.pop(context);
      if(user!=null){

     print("User:${user.user}");
     print("Useradd:${user.additionalUserInfo}");
  if(await Api.userexit()){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHome()));
  }
  else{
    await Api.createexit().then((value) => {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyHome()))
    });
  }


    } });
  }
  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
   try{
     await InternetAddress.lookup("google.com");
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

     // Obtain the auth details from the request
     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

     // Create a new credential
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth?.accessToken,
       idToken: googleAuth?.idToken,
     );

     // Once signed in, return the UserCredential
     return await FirebaseAuth.instance.signInWithCredential(credential);
   }catch(e){
     print("_signInWithGoogle:${e}");
     dialoge.snakbar(context, "SomeThing Went Wrong Check The Internaet");
     return null;
   }
  }
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 500 ),(){
      setState(() {
        _isAnimatio=true;
      });
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome to Chat",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,


      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              height: 150,
              width: 150,
              top: 90,
              //   left: 100,


              left: _isAnimatio ? 100.0 : 150.0,

              duration: const Duration(seconds: 2),
              child: Image.asset('asset/image/splashicon1.png')),
          Positioned(

            top: 450,
            left: 60,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffead80b),
                  shape: StadiumBorder(),
                  elevation: 1
              ),

              onPressed: (){
                _handlegooglebtnclick();
              }, icon:Container(
                height: 50,
                width: 50,
                child: Image.asset('asset/image/google1.png')),
              label: RichText(text: TextSpan(children: [
                TextSpan(text: "SigIn With ",style: TextStyle(color: Colors.black,fontSize: 18)),
                TextSpan(text: "Google ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20))
              ]),

              ),
            ),
          )
        ],
      ),

    );
  }
}
