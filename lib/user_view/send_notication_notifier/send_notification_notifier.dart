

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:notification_on_choice/user_view/send_notication_notifier/'
    'send_notifcation_states.dart';
import 'package:notification_on_choice/user_view/models/user_model.dart';
import '../../utils/firestore.dart';


class SendNotificationNotifier extends StateNotifier<SendNotificationState>{
  SendNotificationNotifier():super(SendNotificationInitialState());

  void sendNotification(UserModel model)async{
    state = SendNotificationLoadingState();
    try{
      bool isSent = await sendNotificationToOne(model);
      if(isSent) {
        state = SendNotificationLoadedState();
      }else{
        state  = SendNotificationErrorState(errorMsg:"MEssage not sent");
      }
    }on FirebaseException catch(e){
      state  = SendNotificationErrorState(errorMsg: e.toString());
    }
    catch(e){
      state  = SendNotificationErrorState(errorMsg: e.toString());
    }
  }
  void getInitialState(){
    state = SendNotificationInitialState();
  }


}