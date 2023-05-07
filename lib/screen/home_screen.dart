import 'dart:convert';
import 'dart:developer';

import 'package:chat_messg/api/Api.dart';
import 'package:chat_messg/screen/profile_screen.dart';
import 'package:chat_messg/widgit/chat_user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';
import 'auth/lodin_screen.dart';








class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
 List<Userchat> list=[];
 //for storing item
 List<Userchat> search=[];
//for storing status
 bool _isSearching=false;
@override
  void initState() {
    // TODO: implement initState
    Api.getSelfinfo();


      SystemChannels.lifecycle.setMessageHandler((message) {
        if(Api.auth.currentUser!=null){
        if (message.toString().contains('resume'))Api.updtaestatus(true);

        if (message.toString().contains('pause'))Api.updtaestatus(false);
    }


   return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context)

  {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title:_isSearching? TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,hintText: "Name,Email.....",

              ),
              autofocus: true,
              style: TextStyle(fontSize: 15,letterSpacing: 1),
              onChanged: (val){
                //search logic
                search.clear();
                for(var i in list){
                  if(i.name.toLowerCase().contains(val.toLowerCase())||
                      i.email.toLowerCase().contains(val.toLowerCase())
                  ){
                    search.add(i);
                  }
                  setState(() {
                    search;
                  });
                }

              },

            ):
            Text(
              "We chat",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: Icon(CupertinoIcons.home, color: Colors.black),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching=!_isSearching;
                    });
                  }, icon: Icon(_isSearching?CupertinoIcons.clear_circled_solid:Icons.search, color: Colors.black)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => profile(userchat: Api.me)));
                  },
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: Colors.black,
                  )),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: FloatingActionButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => loginscreen()),
                );
              },
              child: Icon(Icons.add_comment_rounded),
            ),
          ),
          // body: StreamBuilder<QuerySnapshot>(
          //   stream: firestore.collection('collection').snapshots(),
          //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (snapshot.hasError) {
          //       return Text('Error: ${snapshot.error}');
          //     }
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Text('Loading...');
          //     }
          //     return ListView(
          //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
          //         return ListTile(
          //           title: Text(document['class']),
          //
          //         );
          //       }).toList(),
          //     );
          //   },
          // ),
          body: StreamBuilder(
            stream: Api.firestore.collection('collection').snapshots(),
            builder: (context, snapshot){

              if(snapshot.hasData){
                final data=snapshot.data?.docs;
                list=data?.map((e) => Userchat.fromJson(e.data())).toList()??[];
              }
            return  ListView.builder(

                  itemCount:_isSearching?search.length: list.length,
                  itemBuilder: (context,index){

                // return usercard();
                return
                 usercard(userchat:_isSearching?search[index]: list[index]);



              },

              );}
              ),



        ),
      ),
    );
  }
}
