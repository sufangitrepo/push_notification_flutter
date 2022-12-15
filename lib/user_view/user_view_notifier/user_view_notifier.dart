

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:notification_on_choice/user_view/user_view_notifier/user_view_state.dart';
import '../../utils/firestore.dart';
import '../models/user_model.dart';



class UserViewNotifier extends StateNotifier<UserViewState>{
  UserViewNotifier():super(const UserViewInitialState());

  void fetchUsers()async{

    try {

      state =  UserViewLoadingState();
      Future.delayed(Duration(seconds: 5));
      List<UserModel> list = await fetchUsersList();
      state = UserViewLoadedState(userModels: list);

    }on FirebaseException catch(e){

      state = UserViewErrorState(errorMsg: e.message.toString());
    }catch(e){
      state = UserViewErrorState(errorMsg: e.toString());
    }

  }
}