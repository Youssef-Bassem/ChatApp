import 'package:ChatApp/Appprovider.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  Room room;
  RoomWidget( this.room);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: MythemeData.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(4,8),
          )
        ]
      ),
      child: Center(
        child: Column(
          children: [
            Image(image: AssetImage('assets/${room.cateogry}.png'),
            height: 120,
            fit: BoxFit.fill,),
            Text(room.name,style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),)
          ],
        ),
      ),
    );
  }
}
