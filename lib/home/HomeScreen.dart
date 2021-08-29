import 'package:ChatApp/addRoom/AddRoom.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String ROUTE_NAME = 'home';
  @override
  Widget build(BuildContext context) {
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
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, AddRoom.ROUTE_NAME);
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
