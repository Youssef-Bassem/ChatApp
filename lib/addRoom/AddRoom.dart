import 'package:ChatApp/Appprovider.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/home/HomeScreen.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRoom extends StatefulWidget {
  static const String ROUTE_NAME = 'addRoom';

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final _addRoomFormKey = GlobalKey<FormState>();

  String roomName = '';

  String description = '';

  List<String> categories = ['sports', 'movies', 'music'];

  String selectedCategory = 'sports';

  bool isLoading = false;

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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Chat App',
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
                  color: MythemeData.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(4, 8),
                    )
                  ]),
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create New Room',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                      flex: 1,
                      child: Image(image: AssetImage('assets/roomHeader.png'))),
                  Expanded(
                    child: Form(
                      key: _addRoomFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (text) {
                              roomName = text;
                            },
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                labelText: 'Enter Room Name',
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Room Category',
                      ),
                      value: selectedCategory,
                      iconSize: 24,
                      elevation: 16,
                      items: categories.map((name) {
                        return DropdownMenuItem(
                          value: name,
                          child: Row(
                            children: [
                              Image(
                                image: name == 'Select Room Category'? AssetImage('assets/$name.png') : AssetImage('assets/$name.png'),
                                width: 24,
                                height: 24,
                              ),
                              Text(" $name"),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newSelected) {
                        setState(() {
                          selectedCategory = newSelected as String;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      onChanged: (textValue) {
                        description = textValue;
                      },
                      decoration: InputDecoration(
                          labelText: 'Enter Room Description',
                          floatingLabelBehavior: FloatingLabelBehavior.auto),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter room Description';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_addRoomFormKey.currentState!.validate() == true) {
                          addRoom();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200,50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                      ),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Create',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void addRoom() {
    setState(() {
      isLoading = true;
    });
    final docRef = getRoomsCollectionWithConverter().doc();
    Room room = Room(
        name: roomName,
        id: docRef.id,
        description: description,
        cateogry: selectedCategory);
    docRef.set(room).then((value) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: 'Room Added Successfully', toastLength: Toast.LENGTH_LONG);
      Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
    });
  }
}
