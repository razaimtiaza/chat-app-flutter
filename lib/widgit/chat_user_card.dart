import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_messg/api/Api.dart';
import 'package:chat_messg/helper/my_date-util.dart';
import 'package:chat_messg/model/messaage.dart';
import 'package:chat_messg/model/user_model.dart';
import 'package:chat_messg/screen/chat_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class usercard extends StatefulWidget {
  final Userchat userchat;
  const usercard({Key? key, required this.userchat}) : super(key: key);

  @override
  State<usercard> createState() => _usercardState();
}

class _usercardState extends State<usercard> {
  AutoGenerate? autoGenerate;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.blue.shade100,
      elevation: 1,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ui_design(
                          userchat: widget.userchat,
                        )));
          },
          child: StreamBuilder(
            stream: Api.getlastmessage(widget.userchat),
            builder: (BuildContext context, snapshot) {
              final data=snapshot.data?.docs;
              final _list=data?.map((e) => AutoGenerate.fromJson(e.data())).toList()??[];
          if(_list.isNotEmpty){
            autoGenerate=_list[0];
          }
              return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      height: 50,
                      width: 50,
                      imageUrl: widget.userchat.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          CircleAvatar(child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  // CircleAvatar(child: Icon(CupertinoIcons.person),

                  title: Text(widget.userchat.name),
                  subtitle: Text( autoGenerate!=null?autoGenerate!.msg:widget.userchat.about),
                  trailing:autoGenerate==null?null:
                  autoGenerate!.read.isEmpty&& autoGenerate!.formid!=Api.user!.uid?
                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(10)),
                  ):
                    Text(Mydate.getlasttime(context: context, time: autoGenerate!.sent)),

                  );
            },
          )),
    );
  }
}
