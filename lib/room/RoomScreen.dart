import 'package:ChatApp/Appprovider.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/home/HomeScreen.dart';
import 'package:ChatApp/home/MyRoom.dart';
import 'package:ChatApp/model/Message.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'MessageWidget.dart';
import 'package:intl/intl.dart';

class RoomScreen extends StatefulWidget {
  static const routeName = 'Room';
  late CollectionReference<Room> roomsCollectionRef;

  RoomScreen()
  {
    roomsCollectionRef = getRoomsCollectionWithConverter();
  }

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late Room room;
  late Appprovider provider;
  String messageFieldText = '';
  TextEditingController _editingController = TextEditingController();
  final firebaseUser = FirebaseAuth.instance.currentUser;
  late String userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userId = firebaseUser!.uid;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM').format(now);
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
              actions: <Widget> [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: Text('Leave Room'),
                        height: 20,
                      )
                    ],
                    onCanceled: () async
                    {
                      room.usersJoined.remove(userId); // Add In List
                      await widget.roomsCollectionRef.doc(room.id).update({'usersJoined' : room.usersJoined});

                      Navigator.of(context)
                          .pushNamed(HomeScreen.ROUTE_NAME, arguments: HomeScreen() );
                    },
                  ),
                ),

    ],
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
                  Text('$formattedDate',style: TextStyle(fontSize: 16),),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot<Message>>(
                        stream: messagesRef,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Message>> snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString() ?? "");
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                                itemBuilder: (buildContext, index) {
                                  return MessageWidget(
                                      snapshot.data?.docs[index].data());
                                },
                                itemCount: snapshot.data?.size ?? 0);
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
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
                        onPressed: () {
                          insertMessage(messageFieldText);
                        },
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

  void insertMessage(String messageText) {
    if (messageText.trim().isEmpty) return;
    CollectionReference<Message> messages =
    getMessagesCollectionWithConverter(room);
    DocumentReference<Message> doc = messages.doc();
    Message message = Message(
        id: doc.id,
        messageContent: messageText,
        senderName: provider.currentUser?.userName ?? "",
        senderId: provider.currentUser?.id ?? "",
        dateTime: DateTime.now());
    doc.set(message).then((addedMessage) {
      print('in then');
      setState(() {
        print('set  state');
        messageFieldText = '';
        _editingController.text = '';
      });
    }).onError((error, stackTrace) {
      print('on error');
      Fluttertoast.showToast(
          msg: error.toString(), toastLength: Toast.LENGTH_LONG);
    });
  }
}

class RoomScreenArgs {
  Room room;
  RoomScreenArgs(this.room);
}
