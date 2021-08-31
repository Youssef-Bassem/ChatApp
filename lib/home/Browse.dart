import 'package:ChatApp/model/Room.dart';
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
  _BrowseState(this.roomslist);

  @override
  Widget build(BuildContext context) {
    int count = 0;
    for(int i=0 ; i<roomslist.length ; )
    {
      if ( roomslist[i].type == false)
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
          if(roomslist[index].type == false){
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
