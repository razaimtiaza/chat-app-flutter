import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mydate{
  static String getformated({required BuildContext context,required String time}){
    final date=DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    

    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getlasttime({required BuildContext context,required String time}){
    final DateTime sent=DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now=DateTime.now();
    if(now.day==sent.day && now.month==sent.month && now.year==sent.year){
      return TimeOfDay.fromDateTime(sent).format(context);
    }
  return '${sent.day} ${sent.month}';
  }

 static String activetime({required BuildContext context, required String lastactive}){
    final int i=int.tryParse(lastactive)??-1;
    if(i==-1) return "last seen not available";
    DateTime time=DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now=DateTime.now();
    String formattime=TimeOfDay.fromDateTime(time).format(context);
    if(time.day==now.day&&time.month==now.month&&time.year==now.year){
      return 'last seen today at$formattime';
    }
    if(now.difference(time).inHours/24.round()==1){
      return 'last seen yesterday$formattime';
    }
     return 'last seen on $formattime';



      }

}