import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:ChatApp/room/RoomScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JoinRoom extends StatefulWidget {
  static const String ROUTE_NAME = 'joinRoom';
  late CollectionReference<Room> roomsCollectionRef;

  JoinRoom()
  {
    roomsCollectionRef = getRoomsCollectionWithConverter();
  }

  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  late Room room;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  late String userId;

  @override
  Widget build(BuildContext context) {
    room = (ModalRoute.of(context)?.settings.arguments as JoinRoomArgs).room;
    userId = firebaseUser!.uid;
    //userId = (ModalRoute.of(context)?.settings.arguments as JoinRoomArgs).userId;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Image.asset(
            'assets/SIGN IN – 1.png',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(room.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(4, 8),
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text('Hello, Welcome to our chat room\n' ,
                        style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w500)),
                  ),
                  Center(
                    child: Text('Join The ${room.name} Zone!\n',
                        style: TextStyle(fontSize: 22 , fontWeight: FontWeight.w900)),
                  ),
                  Image(
                      image: AssetImage('assets/${room.cateogry}.png'), width: 200,height: 200,
                  ),
                  Center(
                    child: Text('\n${room.description}',),
                  ),
                  ElevatedButton(
                    onPressed: () async
                    {
                          room.usersJoined.add(userId); // Add In List
                          await widget.roomsCollectionRef.doc(room.id).update({'usersJoined' : room.usersJoined});

                          var collection = FirebaseFirestore.instance.collection('rooms');
                          collection
                              .doc(room.id)
                              .update({'type': true});

                      Navigator.of(context)
                          .pushNamed(RoomScreen.routeName, arguments: RoomScreenArgs(room));
                    },
                    child: Text('Join', style: TextStyle(fontSize: 18),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class JoinRoomArgs {
  Room room;
  late String userId;
  JoinRoomArgs(this.room,this.userId);
}