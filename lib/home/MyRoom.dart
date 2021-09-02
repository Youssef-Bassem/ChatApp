import 'package:ChatApp/model/Room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'RoomWidget.dart';

class MyRoom extends StatefulWidget {
  late List<Room> roomslist;
  MyRoom(this.roomslist);

  @override
  _MyRoomState createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  late String userId;

  @override
  Widget build(BuildContext context) {
    userId = firebaseUser!.uid;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (buildContext, index) {
            return RoomWidget(widget.roomslist[index],userId);
        },
        itemCount: widget.roomslist.length,
      ),
    );
  }
}
