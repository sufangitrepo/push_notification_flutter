import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:notification_on_choice/main.dart';
import 'package:notification_on_choice/user_view/models/user_model.dart';
import 'package:notification_on_choice/user_view/send_notication_notifier/'
    'send_notifcation_states.dart';
import 'package:notification_on_choice/user_view/user_view_notifier/'
    'user_view_notifier.dart';
import 'package:notification_on_choice/user_view/user_view_notifier/'
    'user_view_state.dart';


class UserViewPage extends ConsumerStatefulWidget {
  const UserViewPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserViewState();
  }
}

class _UserViewState extends ConsumerState<UserViewPage>{

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read<UserViewNotifier>(userViewProvider.notifier).fetchUsers();
      ref.read(sendNotificationNotifierProvider.notifier).getInitialState();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("User View"),
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Consumer(
          builder: (context, ref, child) {
            var state = ref.watch(userViewProvider);
            if (state is UserViewInitialState) {
              return SizedBox();
            }
            else if (State is UserViewLoadingState) {
              print("=======================================================");
              return Center(child: CircularProgressIndicator(),);
            }
            else if (state is UserViewLoadedState) {
              var list = state.userModels;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    "No User Exist",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              }
              return Consumer(
                builder: (context, ref , widget) {
                  var state = ref.watch(sendNotificationNotifierProvider);
                  if(state is SendNotificationInitialState){
                    return getUserViewLoadedState(list);
                  }
                  else if(state is SendNotificationLoadingState){
                    return Stack(
                      children: [
                        getUserViewLoadedState(list),
                        Center(child:CircularProgressIndicator(),),
                      ],
                    );
                  }
                  else if(state is SendNotificationLoadedState){
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("send successfully")));
                    });
                   return  getUserViewLoadedState(list);
                  }
                  else if(state is SendNotificationErrorState){
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.errorMsg)));
                    });
                    return getUserViewLoadedState(list);
                  }
                  else {
                    return SizedBox();
                  }
                }
              );
            }
            else if (state is UserViewErrorState) {
              return Center(
                child: Text(
                  "Something went wrong",
                  style: Theme.of(context).textTheme.headline6,
                ),
              );
            }
            else {
              return SizedBox();
            }

          },

        ),
      )
    );


  }

  Widget getUserViewLoadedState(List<UserModel> list){
    return ListView.builder(
      itemBuilder: (context, index) {
        var model = list[index];
        return ListTile(
          title: Text(model.email.toString()),
          trailing: IconButton(
              onPressed: () {

                ref.read(sendNotificationNotifierProvider.notifier)
                    .sendNotification(model);

              }, icon: Icon(Icons.notification_add)),
        );
      },
      itemCount: list.length,
    );
  }

}