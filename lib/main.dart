
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:notification_on_choice/home_page/home_page_riverpod/'
    'home_page_state_listner.dart';
import 'package:notification_on_choice/user_view/send_notication_notifier/'
    'send_notifcation_states.dart';
import 'package:notification_on_choice/user_view/send_notication_notifier/'
    'send_notification_notifier.dart';
import 'package:notification_on_choice/user_view/user_view_notifier/'
    'user_view_notifier.dart';
import 'package:notification_on_choice/user_view/user_view_notifier/'
    'user_view_state.dart';
import 'package:notification_on_choice/user_view/user_view_page.dart';
import 'home_page/home_page.dart';
import 'home_page/home_page_riverpod/home_page_states.dart';


final googleSigninProvider = StateNotifierProvider
<HomePageNotifier, GoogleSigninState>((ref) {
  return HomePageNotifier();
});

final userViewProvider = StateNotifierProvider<UserViewNotifier, UserViewState>
  ((ref) => UserViewNotifier());

final sendNotificationNotifierProvider = StateNotifierProvider<SendNotificationNotifier, SendNotificationState>
  ((ref) => SendNotificationNotifier());


Future<void> handleBackGroundMessage(RemoteMessage message)async{
 await Firebase.initializeApp();

}


AndroidNotificationChannel channel = const AndroidNotificationChannel(
'high_importance_channel', // id
'High Importance Notifications', // title
description: 'This channel is used for important notifications.',
importance: Importance.max,
);

FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();


Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage);

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    sound: true,
    badge: true,
    alert: true
  );

  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),

    );
  }

}
