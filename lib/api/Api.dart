import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chat_messg/model/messaage.dart';
import 'package:chat_messg/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static User? get user => auth.currentUser;
  static late Userchat me;
  //for checking if user exit aur not

  static Future<bool> userexit() async {
    return (await firestore
            .collection('collection')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  //for push notificarion
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;
  static Future<void> pushnotification() async {
    await fmessaging.requestPermission();
    await fmessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        print('push:notification:$t');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> sendnotification(Userchat userchat, String msg) async {
    try {
      final body = {
        "to": userchat.pushToken,
        "notification": {
          "title": userchat.name,
          "body": msg,
          "android_channel_id": "chats",
          "sound": "default"
        },
        "data": {
          "click_action": "User_id:${me.id}",
        },
      };

      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAANxpUZ-E:APA91bGXz7xnnxbRAYq34-MBQ0b3aqUzJ6MPb93AybMnsZ2NZ-aBe7NcMcGZ2Dt0W78PC-1ujZsiHiTSR4_eKPawJ2Vb42WYoY-v6fjVwx_EfvnGT2sZtxZWGWTxIFpTAcQYkZPzrisd'
              },
              body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('error:$e');
    }
  }

  static Future<void> getSelfinfo() async {
    await firestore
        .collection('collection')
        .doc(auth.currentUser!.uid)
        .get()
        .then((usercard) async => {
              if (usercard.exists)
                {
                  me = Userchat.fromJson(usercard.data()!),
                  pushnotification(),
                  Api.updtaestatus(true),
                  log('user:${usercard.data()}' as num)
                }
              else
                {await createexit().then((value) => getSelfinfo())}
            });
  }

  //for creating user
  static Future<void> createexit() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final user = Userchat(
        id: auth.currentUser!.uid,
        name: auth.currentUser!.displayName.toString(),
        email: auth.currentUser!.email.toString(),
        image: auth.currentUser!.photoURL.toString(),
        about: "hi I am using a chat",
        isOnline: false,
        createdAt: time,
        lastActive: time,
        pushToken: "");
    return await firestore
        .collection('collection')
        .doc(user.id)
        .set(user.toJson());
  }

  static Future<void> updateUserinfo() async {
    await firestore
        .collection('collection')
        .doc(user?.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> uolosdprofile(File file) async {
    //getting file extension
    final ext = file.path?.split(".").last;
    //storing ref eith path
    final ref = storage.ref().child('profile_pic/${user!.uid}.$ext');
//uploading image
    ref.putFile(file, SettableMetadata(contentType: 'image$ext'));
//storing image in firedatabase
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('collection')
        .doc(user?.uid)
        .update({'image': me.image});
  }

//**************************Chat Mesge********************
  //for getting all messaging from  firestore

//chat (collection) - - > covesertion(id) - - >message(collection) - - > message(doc)

//for getting conservation ids
//   static String conservationid(String id) => user!.uid.hashCode <= id.hashCode
//       ? '${user.uid}_$id '
//       : '${id}_${user!.uid}';
  static String conservationid(String id) => user!.uid.hashCode <= id.hashCode
      ? '${user?.uid}_$id'
      : '${id}_${user!.uid}';
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllmessage(
      Userchat chat) {
    return firestore
        .collection("chat/${conservationid(chat.id)} /message")
        .snapshots();
  }

//for sending message
  static Future<void> sendmessage(Userchat chat, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final AutoGenerate autoGenerate = AutoGenerate(
        formid: user!.uid,
        msg: msg,
        read: "",
        sent: time,
        told: chat.id,
        type: type);
    final ref1 =
        firestore.collection("chat/${conservationid(chat.id)} /message/");
    ref1.doc(time).set(autoGenerate.toJson()).then(
        (value) => sendnotification(chat, type == Type.text ? msg : "image"));

    // ref1.doc().set();
  }

//read double tick
  static Future<void> updatemessagereadstatus(AutoGenerate autoGenerate) async {
    firestore
        .collection("chat/${conservationid(autoGenerate.formid)} /message/")
        .doc(autoGenerate.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getlastmessage(
      Userchat chat) {
    return firestore
        .collection("chat/${conservationid(chat.id)} /message")
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getuserinfp(
      Userchat chat) {
    return firestore
        .collection('collection')
        .where('id', isEqualTo: chat.id)
        .snapshots();
  }

  static Future<void> updtaestatus(bool isonline) async {
    firestore.collection('collection').doc(user!.uid).update({
      'is_online': isonline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken
    });
  }

  static Future<void> sentimage(Userchat userchat, File file) async {
    final ext = file.path?.split(".").last;
    //storing ref eith path
    final ref = storage.ref().child(
        'image/${conservationid(userchat.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
//uploading image
    ref.putFile(file, SettableMetadata(contentType: 'image$ext'));
//storing image in firedatabase
    final imageurl = await ref.getDownloadURL();
    await sendmessage(userchat, imageurl, Type.image);
  }

  static Future<void> delete(AutoGenerate autoGenerate) async {
    firestore
        .collection("chat/${conservationid(autoGenerate.told)} /message/")
        .doc(autoGenerate.sent)
        .delete();
  }
}
