
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import 'package:notification_on_choice/user_view/models/user_model.dart';

Future<User?> btnGoogleSignupClick()async{

  GoogleSignInAccount? account = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? authentication = await account?.authentication;

  String? token = authentication?.accessToken;
  String? idToken = authentication?.idToken;
  OAuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: token,
      idToken:idToken
  );

  UserCredential userCredential = await FirebaseAuth.instance
      .signInWithCredential(authCredential);

  if(userCredential.user != null){
    var snapShot = await FirebaseFirestore.instance.collection("user")
        .where("email",isEqualTo: userCredential.user!.email).get();
    if(snapShot.docs.isEmpty){
      String? token = await FirebaseMessaging.instance.getToken();
      print("========Notification Token in GoogleSingin Controller+++++++++++++++++++++++++++++++++++++++");
      print(token);
      await FirebaseFirestore.instance.collection("user").doc().set({
        "email":userCredential.user!.email,
        "notification_token":token,
        "id":userCredential.user!.uid,
      });
    }
    return userCredential.user;
  }
  return null;
}





Future<List<UserModel>> fetchUsersList()async{
  QuerySnapshot<Map<String,dynamic>> snapshot = await
  FirebaseFirestore.instance.collection("user").get();
  List<UserModel> list = [];
  for(var doc in snapshot.docs){
    list.add(UserModel.fromMap(doc.data()));
  }
  return list;
}


Future<bool> sendNotificationToOne(UserModel model)async{

  const String serverKey = "key=AAAAYiloDCU:APA91bH4YnrSVkxDJYhe4vTC9T4AKeq3o_jPETBLrHkXrZnv35IhbNg4JlCqvU6Omlytpf6VwUj98LU0Ruu6QYUWtEf25yfv7oh8EN9hgwEp4rb19LuHmZKdL2X_i70L2HmIvv0Sh5Ox";

  const notificationUrl = "https://fcm.googleapis.com/fcm/send";
  var response = await post(
    Uri.parse(notificationUrl),
    headers: {
      "Authorization": serverKey,
      "Content-Type" : "application/json"
    },
    body: jsonEncode(
        {
          "to" : model.token,
          "collapse_key" : "New Message",
          "priority": "high",
          "notification" : {
            "title": "Title of Your Notification",
            "body" : "Body of Your Notification"
          }
        }
    ),
  );
  if(response.statusCode == 200){
    return true;
  }
  return false;
}