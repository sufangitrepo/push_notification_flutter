

import 'package:flutter/cupertino.dart';

@immutable
class SendNotificationState{
  const SendNotificationState();
}

class SendNotificationInitialState extends SendNotificationState{

}

class SendNotificationLoadingState extends SendNotificationState{

}
class SendNotificationLoadedState extends SendNotificationState{

}
class SendNotificationErrorState extends SendNotificationState{
  final String errorMsg;
  const SendNotificationErrorState({required this.errorMsg});
}

