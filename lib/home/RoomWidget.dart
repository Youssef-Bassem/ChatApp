import 'package:ChatApp/home/HomeScreen.dart';
import 'package:ChatApp/joinRoom/JoinRoom.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:ChatApp/room/RoomScreen.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  Room room;
  late String userId;
  RoomWidget(this.room,this.userId);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(checkRoomsExistence(room.id, userId)){
          Navigator.of(context)
              .pushNamed(RoomScreen.routeName, arguments: RoomScreenArgs(room));
        }
        else {
          Navigator.of(context)
              .pushNamed(JoinRoom.ROUTE_NAME, arguments: JoinRoomArgs(room,this.userId));
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(4, 8), // Shadow position
              ),
            ]),
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Image(
                  image: AssetImage('assets/${room.cateogry}.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: Text(
                  room.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text('${(room.usersJoined.length)-1} Members'),
            ],
          ),
        ),
      ),
    );
  }
}
