import 'package:ChatApp/model/Room.dart';
import 'package:flutter/material.dart';

import 'RoomWidget.dart';

class MyRoom extends StatefulWidget {
  late List<Room> roomslist;
  MyRoom(this.roomslist);

  @override
  _MyRoomState createState() => _MyRoomState(this.roomslist);
}

class _MyRoomState extends State<MyRoom> {
  late List<Room> roomslist;
  _MyRoomState(this.roomslist);

  @override
  Widget build(BuildContext context) {
    int count = 0;
    for(int i=0 ; i<roomslist.length ; )
    {
      if ( roomslist[i].type == true)
      {
        count++;
        i++;
      }
      else{
        roomslist.removeAt(i);
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (buildContext, index) {
          if(roomslist[index].type == true){
            return RoomWidget(roomslist[index]);
          }
          else{
            return Center(child: Text('Empty'),);
          }
        },
        itemCount: count,
      ),
    );
  }
}
