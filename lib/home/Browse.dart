import 'package:ChatApp/model/Room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'RoomWidget.dart';

class Browse extends StatefulWidget {
  late List<Room> roomslist;
  Browse(this.roomslist);

  @override
  _BrowseState createState() => _BrowseState(this.roomslist);
}

class _BrowseState extends State<Browse> {
  late List<Room> roomslist;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  late String userId;

  _BrowseState(this.roomslist);

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
            return RoomWidget(roomslist[index],userId);
        },
        itemCount: roomslist.length,
      ),
    );
  }
}
