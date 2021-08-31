import 'package:ChatApp/Appprovider.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/model/Message.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
//import 'MessageWidget.dart';

class RoomScreen extends StatefulWidget {
  static const routeName = 'Room';

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late Room room;
  late Appprovider provider;
  String messageFieldText = '';
  TextEditingController _editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<Appprovider>(context);
    room = (ModalRoute.of(context)?.settings.arguments as RoomScreenArgs).room;
    final Stream<QuerySnapshot<Message>> messagesRef =
        getMessagesCollectionWithConverter(room)
            .orderBy('dateTime')
            .snapshots();

    return Stack(
        children:
        [
          Container(
            color: Colors.white,
          ),
          Image(
            image: AssetImage('assets/SIGN IN – 1.png'),
            fit: BoxFit.fitWidth,
            width: double.infinity,
          ),
          Scaffold(
            appBar: AppBar(
              title: Text(room.name),
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(4, 8), // Shadow position
                    ),
                  ]
              ),
              margin: EdgeInsets.symmetric(vertical: 32,horizontal: 12),
              child: Column(
                children: [
                  Text('Date Time',style: TextStyle(fontSize: 16),),
                  Expanded(
                      child: Container()
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (text) {
                            messageFieldText = text;
                          },
                          controller: _editingController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(4),
                              hintText: 'Type your message',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12)))),
                        ),
                      ),
                      SizedBox(width: 8,),
                      ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          child: Row(
                            children: [
                              Text('send'),
                              SizedBox(width: 8,),
                              Transform(
                                  transform: Matrix4.rotationZ(-45),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.send_outlined)
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
        )
      ]
    );
  }

}

class RoomScreenArgs {
  Room room;
  RoomScreenArgs(this.room);
}
