

import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';

@immutable
class UserViewState{
  const UserViewState();
}


class UserViewInitialState extends UserViewState{
  const UserViewInitialState();
}

class UserViewLoadingState extends UserViewState{
  const UserViewLoadingState();
}

class UserViewLoadedState extends UserViewState{
  final List<UserModel> userModels;
  const UserViewLoadedState({required this.userModels});

}


class UserViewErrorState extends UserViewState{

  final String errorMsg;
  const UserViewErrorState({required this.errorMsg});

}
