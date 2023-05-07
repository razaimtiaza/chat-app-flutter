import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_messg/api/Api.dart';
import 'package:chat_messg/helper/dislog.dart';
import 'package:chat_messg/helper/my_date-util.dart';
import 'package:chat_messg/model/messaage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screen/home_screen.dart';

class messagecard extends StatefulWidget {
  final AutoGenerate autoGenerate;
  const messagecard({Key? key, required this.autoGenerate}) : super(key: key);

  @override
  State<messagecard> createState() => _messagecardState();
}

class _messagecardState extends State<messagecard> {

  @override
  Widget build(BuildContext context) {
    bool isme=Api.user!.uid == widget.autoGenerate.formid;
    return InkWell(
      onLongPress: (){
_showbottomsheet(isme);
      },
      child: isme
        ? greenmessage()
        : bluemessage(),);
  }

  //sender aur another user message
  Widget bluemessage() {
    if(widget.autoGenerate.read.isEmpty){
      Api.updatemessagereadstatus(widget.autoGenerate);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 165, 218, 232),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.only(right: 40),
              child:  Text(widget.autoGenerate.msg,style: TextStyle(fontSize: 18),),
            ),
          ),
        ),//Text(Mydate.getformated(context: context, time: widget.autoGenerate.sent),style: TextStyle(fontSize: 18),)
        // Text(widget.autoGenerate.sent,style:TextStyle(fontSize: 15,color:Colors.black54),):
        Padding(
          padding: const EdgeInsets.only(right: 60),
          child: widget.autoGenerate.type==Type.text?
          Text(Mydate.getformated(context: context, time: widget.autoGenerate.sent),style:TextStyle(fontSize: 15,color:Colors.black54),):
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CachedNetworkImage(
                height: 100,
                width: 1250,
                imageUrl: widget.autoGenerate.msg,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                  Icon(Icons.person)),
              ),
            ),
          ),



      ],
    );
  }

//our aur user message
  Widget greenmessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          
          children: [
            SizedBox(width: 30,),
            if(widget.autoGenerate.read.isNotEmpty)
            Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),
            SizedBox(width: 10,),
            Text(Mydate.getformated(context: context, time: widget.autoGenerate.sent),style:TextStyle(fontSize: 15,color:Colors.black54),),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 237, 255, 137),
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Text(widget.autoGenerate.msg,style: const TextStyle(fontSize: 18),),
            ),
          ),
        ),

      ],
    );
  }
  void _showbottomsheet(bool Isme){
    showModalBottomSheet(context: context,
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20))
        ),builder: (_){

          return Container(

            color: Colors.white,
            child: ListView(
              shrinkWrap: true,
              children: [

                ListTile(
                  title: Row(
                    children: const [
                      Icon(Icons.copy_all_rounded,color: Colors.blue,size: 24,),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text("Copy Text"),
          )
                    ],
                  ),
                  onTap: () async {
                  await  Clipboard.setData(ClipboardData(text: widget.autoGenerate.msg)).then((value) {
                    Navigator.pop(context);
                    dialoge.snakbar(context, "Text Copied");
                  });
                  },
                ),
                   Divider(),
if(Isme)
                ListTile(
                  title: Row(
                      children: const [
                        Icon(Icons.edit,color: Colors.blue,size: 24,),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Edit"),
                        )
                      ],),
                  onTap: () {},
                ),
if(Isme)
                ListTile(
                  title:Row(
                    children: const [
                      Icon(Icons.delete,color: Colors.red,size: 24,),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child:  Text("Delete Message"))
                    ],),
                  onTap: () async {
                 Api.delete(widget.autoGenerate).then((value) {
                  Navigator.pop(context);
               });
               //      Navigator.push(
               //          context,
               //          MaterialPageRoute(builder: (context) => MyHome()));
                  },
                ),
if(Isme)
                  Divider(),
                ListTile(
                  title:Row(
                    children:  [
                      Icon(Icons.remove_red_eye,color: Colors.blue,size: 24,),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  child: Text("Seen At: ${Mydate.getformated(context: context, time: widget.autoGenerate.sent)}")
                  ) ],),
                  onTap: () {},
                // ),ListTile(
                //   title:Row(
                //     children:  [
                //       Icon(Icons.remove_red_eye,color: Colors.green,size: 24,),
                //   // Padding(
                //   //   padding: EdgeInsets.only(left: 10),
                //   //    child:    Text("Read At:${Mydate.getlasttime(context: context, time: widget.autoGenerate.read)}")
                //   // )],),
                //   // onTap: () {},
                // ),
                )  ],
            ),
          );
        });
  }
}
