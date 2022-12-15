
import 'package:flutter/material.dart';


class NotificationView extends StatelessWidget {
  final String? title;
  final String? message;

  const NotificationView({required this.message, required this.title,Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(child: Center(child: Text("$title \n $message"),),
      ),
    );
  }
}
