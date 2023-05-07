import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_messg/helper/my_date-util.dart';
import 'package:chat_messg/model/user_model.dart';
import 'package:chat_messg/widgit/message_dart.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/Api.dart';
import '../model/messaage.dart';

class ui_design extends StatefulWidget {
  final Userchat userchat;
  const ui_design({Key? key, required this.userchat}) : super(key: key);

  @override
  State<ui_design> createState() => _ui_designState();
}

class _ui_designState extends State<ui_design> {
  List<AutoGenerate> _list = [];
  final _textediter = TextEditingController();
  bool emoji = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: StreamBuilder(
            stream: Api.getuserinfp(widget.userchat),
            builder: (context, snapshot) {
              final data=snapshot.data?.docs;
              final _list=data?.map((e) => Userchat.fromJson(e.data())).toList()??[];

              return Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 45, left: 20),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        height: 50,
                        width: 50,
                        imageUrl:_list.isNotEmpty?_list[0].image: widget.userchat.image,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            CircleAvatar(child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 45, left: 7),
                        child: Text(
                          _list.isNotEmpty?_list[0].name:   widget.userchat.name,
                          style:
                              TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        _list.isNotEmpty?
                        _list[0].isOnline?"isOnline":
                       Mydate.activetime(context: context, lastactive:  _list[0].lastActive)
                            : Mydate.activetime(context: context, lastactive:  widget.userchat.lastActive),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              );
            }
          ),
        ),
        backgroundColor: Color.fromARGB(255, 122, 199, 208),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: Api.getAllmessage(widget.userchat),
                  builder: (context, snapshor) {
                    switch (snapshor.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      // return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                      // final data = snapshor.data?.docs;
                      // log("data:${jsonEncode(data![0].data())}" as num);
                    }
                    // final _list = ['hi','hello'];

                    final data = snapshor.data?.docs;
                    _list = data
                            ?.map((e) => AutoGenerate.fromJson(e.data()))
                            .toList() ??
                        [];
                    // _list.clear();
                    // _list.add(AutoGenerate(formid: Api.user!.uid, msg: "hi", read: "", sent: "12:00", told: "xyz", type: Type.text));
                    // _list.add(AutoGenerate(formid: "xyz", msg: "hello", read: "", sent: "12:05", told: Api.user!.uid, type: Type.text));
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return messagecard(
                              autoGenerate: _list[index],
                            );
                          });
                    } else {
                      return Center(
                        child: Text(
                          "Say HI!!!",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
                  }),
            ),

            //type mesage
            Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    // child: Container(
                    //
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //   ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          emoji = !emoji;
                        });
                      },
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        if (emoji)
                          setState(() {
                            emoji = !emoji;
                          });
                      },
                      controller: _textediter,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  // IconButton(
                  //     onPressed: () async {final ImagePicker _picker=ImagePicker();
                  //     final List<XFile> image= await _picker.pickMultiImage();
                  //     for(var i in image){
                  //       Api.sentimage(widget.userchat,File(i.path));
                  //     }},
                  //     icon: Icon(
                  //       Icons.image,
                  //       color: Colors.blue,
                  //     )),
                  // IconButton(
                  //     onPressed: () async {
                  //       // final ImagePicker _picker = ImagePicker();
                  //       // // Pick an image
                  //       // final XFile? image =
                  //       //     await _picker.pickImage(source: ImageSource.camera);
                  //       // if (image != null) {
                  //       //   Api.sentimage(widget.userchat,File(image.path));
                  //      // }
                  //       final ImagePicker _picker=ImagePicker();
                  //       final XFile? image= await _picker.pickImage(source: ImageSource.camera);
                  //       if(image!= null){
                  //         Api.sentimage(widget.userchat,File(image.path));
                  //       }
                  //     },
                  //     icon: Icon(
                  //       Icons.camera_alt,
                  //       color: Colors.blue,
                  //     )),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (_textediter.text.isNotEmpty) {
                        Api.sendmessage(
                            widget.userchat, _textediter.text, Type.text);
                        _textediter.text = "";
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
            if (emoji)
              SizedBox(
                height: 250,
                child: EmojiPicker(
                  textEditingController:
                      _textediter, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                  config: Config(
                    columns: 7,
                    emojiSizeMax: 32 *
                        (Platform.isIOS
                            ? 1.30
                            : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
