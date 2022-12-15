
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:notification_on_choice/home_page/home_page_riverpod/'
    'home_page_state_listner.dart';
import 'package:notification_on_choice/home_page/home_page_riverpod/'
    'home_page_states.dart';
import 'package:notification_on_choice/main.dart';
import 'package:notification_on_choice/notification_view/notification_view.dart';
import 'package:notification_on_choice/user_view/user_view_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(),
        body:HomeBody()
    );

  }

}

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState()=> _HomeBodyState();

}

class _HomeBodyState extends ConsumerState<HomeBody> {

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((value){
      if(value != null){

          String? title = value.notification!.title;
          String? body = value.notification!.body;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NotificationView(message: body, title: title);
          },));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((value) {

      if(value.notification != null && value.notification!.android != null){
        String? title = value.notification!.title;
        String? body = value.notification!.body;

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NotificationView(message: body, title: title);
        },));
      }
      else{
        ScaffoldMessenger.of(context).
        showSnackBar(SnackBar(content: Text("null")));
      }

    });
    FirebaseMessaging.onMessage.listen((event) {

    });

  }

  @override
  Widget build(BuildContext context) {
   HomePageNotifier homePageNotifier = ref
       .read<HomePageNotifier>(googleSigninProvider.notifier);

   return Container(
      width: double.maxFinite,
      child: Stack(
        children: [
          Center(
            child: TextButton(
              onPressed: (){
                homePageNotifier.signinEvent();
              },
              child: Text("Google signin",style: TextStyle(color: Colors.white),),
            style: ButtonStyle(
              minimumSize:MaterialStateProperty.all(Size(40, 40),),
              backgroundColor: MaterialStateProperty.all(Colors.blue)),
              ),
          ),
          Consumer(builder: (context, ref, child) {
            var state = ref
                .watch(googleSigninProvider);
            if(state is GoogleSigninInitialState){
              return SizedBox();
            }
            else if(state is GoogleSigninLoadingState){
              return Center(child: CircularProgressIndicator(color: Colors.black,),);
            }
            else if(state is GoogleSigninLoadedState){
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UserViewPage();
                },));
              });
              return SizedBox();
            }
            else if(state is GoogleSigninErrorState){
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
               ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(state.errorMsg)));
              });
              return SizedBox();
            }else{
              return SizedBox();
            }
            },)
        ],
      ),
    );
  }
}
