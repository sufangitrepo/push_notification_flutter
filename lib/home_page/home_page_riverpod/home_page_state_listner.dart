


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';


import 'package:notification_on_choice/home_page/home_page_riverpod/home_page_states.dart';
import '../../utils/firestore.dart';

class HomePageNotifier extends StateNotifier<GoogleSigninState>{
  HomePageNotifier():super(GoogleSigninInitialState());
  void signinEvent()async{
    state = GoogleSigninLoadingState();
    try {
      var user = await btnGoogleSignupClick();
      state = GoogleSigninLoadedState(user: user);
    }
    on FirebaseAuthException catch(e){
      state = GoogleSigninErrorState(errorMsg: e.message.toString());
    }
    on FirebaseException catch(e){
      state = GoogleSigninErrorState(errorMsg: e.message.toString());
    }
    catch(e){
      state = GoogleSigninErrorState(errorMsg: e.toString());
    }
  }
}