import 'package:ChatApp/Appprovider.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRoom extends StatefulWidget {
  static const String ROUTE_NAME = 'addRoom';

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final _addroomFormKey = GlobalKey<FormState>();

  String roomName = '';

  String description = '';

  List<String> cateogries = ['sports', 'movies', 'music'];

  String selectedCateogry = 'sports';

  bool isLoading =false;

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
          appBar: AppBar(
            title: Text('Route Chat App'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
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
                      offset: Offset(4, 8),
                    )
                  ]),
              margin: EdgeInsets.symmetric(vertical: 32, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create New Room',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Image(image: AssetImage('assets/roomHeader.png')),
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.auto),
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.auto),
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
                  DropdownButton(
                    value: selectedCateogry,
                    iconSize: 24,
                    elevation: 16,
                    items: cateogries.map((name) {
                      return DropdownMenuItem(
                          value: name,
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage('assets/$name.png'),
                                width: 24,
                                height: 24,
                              ),
                              Text(" $name"),
                            ],
                          ));
                    }).toList(),
                    onChanged: (newSelected) {
                      setState(() {
                        selectedCateogry = newSelected as String;
                      });
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if( _addroomFormKey.currentState!.validate() == true ){
                          addroom();
                        }
                      },
                      style: ButtonStyle(),
                      child: isLoading ? Center(child: CircularProgressIndicator(),)
                      :Text('Create'))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  void addroom(){
    setState(() {
      isLoading=true;
    });
    final docRef = getRoomsCollectionWithConverter()
        .doc();
    Room room = Room(name: roomName, id: docRef.id
        , description: description, cateogry: selectedCateogry);
    docRef.set(room).then((value) {
      setState(() {
        isLoading=false;
      });
      Fluttertoast.showToast(msg: 'Room Added Successfully',
      toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context);
    });
  }
}
