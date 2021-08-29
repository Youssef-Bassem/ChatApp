import 'package:ChatApp/Appprovider.dart';
import 'package:flutter/material.dart';

class AddRoom extends StatelessWidget {
  static const String ROUTE_NAME = 'addRoom';

  final _addroomFormKey = GlobalKey<FormState>();
  String roomName ='';
  String description = '';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: MythemeData.white,
        ),
        Image(image: AssetImage('assets/SIGN IN – 1.png',
        ),
        fit: BoxFit.fitWidth , width: double.infinity,),
        Scaffold(
          appBar: AppBar(title: Text('Route Chat App'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,),
          body: Center(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: MythemeData.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(4,8),
                  )
                ]
              ),
              margin: EdgeInsets.symmetric(vertical: 32 , horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Create New Room',style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                    textAlign: TextAlign.center,
                  ),
                  Image(image: AssetImage('assets/images/add_room_header.png')),
                  Form(
                    key: _addroomFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (text) {
                            roomName = text;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'Room Name',
                              floatingLabelBehavior: FloatingLabelBehavior.auto),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Room Name';
                            }
                            return null;
                          },
                        ),

                        TextFormField(
                          onChanged: (textValue) {
                            description = textValue;
                          },
                          decoration: InputDecoration(
                              labelText: 'description',
                              floatingLabelBehavior: FloatingLabelBehavior.auto),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter room Description';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: (){

                  },style: ButtonStyle(
                  ), child: Text('Create'))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
