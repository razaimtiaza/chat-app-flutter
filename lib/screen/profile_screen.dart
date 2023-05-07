import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_messg/api/Api.dart';
import 'package:chat_messg/widgit/chat_user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../helper/dislog.dart';
import '../model/user_model.dart';
import 'auth/lodin_screen.dart';

class profile extends StatefulWidget {
  final Userchat userchat;
  const profile({Key? key, required this.userchat}) : super(key: key);

  @override
  State<profile> createState() => _MyHomeState();
}

class _MyHomeState extends State<profile> {
  final _formkey = GlobalKey<FormFieldState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile Screen",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: FloatingActionButton.extended(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) async =>
                    {await GoogleSignIn().signOut().then((value) => () {})});

                await Api.updtaestatus(false);
                Navigator.pop(context);
                Navigator.pop(context);
                Api.auth=FirebaseAuth.instance;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => loginscreen()),
                );
              },
              backgroundColor: Colors.orange.shade800,
              label: Text("logout"),
              icon: Icon(Icons.logout),
            ),
          ),
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      _image!=null?
                  ClipRRect(
                  borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.file(
                  File(_image!),
                  height: 100,
                  width: 1250,

                ),
              ),
            ):
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: CachedNetworkImage(
                            height: 100,
                            width: 1250,
                            imageUrl: widget.userchat.image,
                            // placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 100,
                        child: MaterialButton(
                          onPressed: () {
                            _showbottomsheet();
                          },
                          elevation: 1,
                          color: Colors.blue.shade700,
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.userchat.email,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                        initialValue: widget.userchat.email,
                        onSaved: (val) => Api.me.name = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : "Required Filled",
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            hintText: "eg Prince Moon",
                            label: Text("Name"))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                        initialValue: widget.userchat.about,
                        onSaved: (val) => Api.me.about= val ?? "",
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : "Required Filled",
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(
                              Icons.info,
                              color: Colors.blue,
                            ),
                            hintText: "eg Happy Mood",
                            label: Text("About"))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        if(_formkey.currentState!.validate()){
                          _formkey.currentState!.save();
                        Api.updateUserinfo();

                        }

                      },
                      icon: Icon(Icons.edit),
                      label: Text("UPDATE"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange.shade900,
                        onPrimary: Colors.white,
                        side: BorderSide(color: Colors.red, width: 5),
                        shape: RoundedRectangleBorder(
                            //to set border radius to button
                            borderRadius: BorderRadius.circular(30)),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
  void _showbottomsheet(){
   showModalBottomSheet(context: context,
       shape:RoundedRectangleBorder(
         borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20))
       ),builder: (_){

      return Container(

        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 120),
              child: Text("Pick Profile Image",style: TextStyle(fontSize: 20),),

            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white38,
                    shape: CircleBorder(),
                    fixedSize: Size(100, 100)
                  ),
                  onPressed: () async {

                    final ImagePicker _picker = ImagePicker();
                    // Pick an image
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if(image!=null){
                      log("image path:${image.path}");
                      setState(() {
                        _image=image.path;
                      });
                      Api.uolosdprofile(File(_image!));
                      Navigator.pop(context);
                    }
                  }, child: Image.asset('asset/image/gallery2.png'),),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white38,
                      shape: CircleBorder(),
                      fixedSize: Size(100, 100)
                  ),
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    // Pick an image
                    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                    if(image!=null){
                      log("image path:${image.path}");
                      setState(() {
                        _image=image.path;
                      });
                      Api.uolosdprofile(File(_image!));
                      Navigator.pop(context);
                    }
                  }, child: Image.asset('asset/image/camer.png'),)
              ],
            )
          ],
        ),
      );
    });
  }
}

