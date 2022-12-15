
import 'package:flutter/cupertino.dart';


import 'package:firebase_auth/firebase_auth.dart';


@immutable
class GoogleSigninState{
  const GoogleSigninState();
}

class GoogleSigninInitialState extends GoogleSigninState{

}

class GoogleSigninLoadingState extends GoogleSigninState{

}

class GoogleSigninLoadedState extends GoogleSigninState{
   final User? user;
   const GoogleSigninLoadedState({required this.user});
}

class GoogleSigninErrorState extends GoogleSigninState{
  final String errorMsg;
  const GoogleSigninErrorState({required this.errorMsg});
}