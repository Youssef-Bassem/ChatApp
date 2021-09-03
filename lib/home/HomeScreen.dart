import 'dart:ffi';

import 'package:ChatApp/addRoom/AddRoom.dart';
import 'package:ChatApp/auth/login/LoginScreen.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/home/MyRoom.dart';
import 'package:ChatApp/home/RoomWidget.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/model/User.dart' as MyUser;


import '../Search.dart';
import 'Browse.dart';

class HomeScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'home';
  late CollectionReference<Room> roomsCollectionRef;

  HomeScreen() {
    roomsCollectionRef = getRoomsCollectionWithConverter();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
late List<Room> myRoomsList;
MyUser.User? currentUser ;

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  late String searchQuery = "";

  bool isMyRoom = true;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  late String userId;

  @override
  Widget build(BuildContext context) {
    userId = firebaseUser!.uid;

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
          appBar: AppBar(
            title: _isSearching ? _buildSearchField() : Text('Chat App',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23)),
            actions: _buildActions(),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context,AddRoom.ROUTE_NAME);
            },
            child: Icon(Icons.add),
          ),

          drawer: Drawer(
            child: SafeArea(
              child: Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false);
                  },
                  child: Text('Sign Out',style: TextStyle(fontSize: 24,color: Colors.white),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)
                  ),
                ),
              ),
            ),
          ),

          body: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          isMyRoom = true;
                        });
                      },
                      child: Text('My Rooms',
                        style: TextStyle(color: Colors.white,fontSize: 18),
                      ),
                      shape: Border(
                          bottom: isMyRoom ?
                          BorderSide(color: Colors.white, width: 3)
                              :
                          BorderSide(color: Colors.transparent, width: 3)
                      ),
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          isMyRoom = false;
                        });
                      },
                      child: Text('Browse',
                        style: TextStyle(color: Colors.white,fontSize: 18),
                      ),
                      shape: Border(
                          bottom: isMyRoom ?
                          BorderSide(color: Colors.transparent, width: 3)
                              :
                          BorderSide(color: Colors.white, width: 3)
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 64, bottom: 12, left: 12, right: 12),
                  child: FutureBuilder<QuerySnapshot<Room>>(
                      future: widget.roomsCollectionRef.get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Room>> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        } else if (snapshot.connectionState == ConnectionState.done) {

                          myRoomsList = snapshot.data!.docs
                              .map((singleDoc) => singleDoc.data())
                              .toList() ??
                              [];
                          for(int i=0 ; i<myRoomsList.length ; i++ )
                          {
                            int counter = 0;
                            for(int j=0 ; j<myRoomsList[i].usersJoined.length ; j++ )
                            {
                              if( myRoomsList[i].usersJoined[j] == userId){
                                counter++;
                                break;
                              }
                            }
                            if(counter == 0){
                              myRoomsList.removeAt(i);
                              i--;
                            }
                          }

                          final List<Room> browseRoomsList = snapshot.data!.docs
                              .map((singleDoc) => singleDoc.data())
                              .toList() ??
                              [];
                          for(int i=0 ; i<browseRoomsList.length ; i++ )
                          {
                            for(int j=0 ; j<browseRoomsList[i].usersJoined.length ; j++ )
                            {
                              if( browseRoomsList[i].usersJoined[j] == userId){
                                browseRoomsList.removeAt(i);
                                i--;
                                break;
                              }
                            }
                          }

                          if(isMyRoom)
                          {
                            if(myRoomsList.isEmpty)
                            {
                              return Center(
                                child: Text('No Joined Rooms Found',style: TextStyle(fontSize: 20),)
                              );
                            }
                            else
                              return MyRoom(myRoomsList);
                          }
                          else
                            return Browse(browseRoomsList);
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //******************************* Search Bar *******************************

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      cursorColor: Colors.white,
      autofocus: true,
      decoration: InputDecoration(
        //hintText: AppLocalizations.of(context)!.search,
        border: InputBorder.none,
        hintText: 'Search Room Name',
        hintStyle: TextStyle(color: Colors.black),
      ),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.done),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Search(searchQuery,widget.roomsCollectionRef)),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);

              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        iconSize: 32,
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

}

bool checkRoomsExistence(String id){
  for(int i = 0 ; i < myRoomsList.length ; i++){
    if(myRoomsList[i].id == id){
      int size = myRoomsList[i].usersJoined.length;
      for(int j = 0 ; j < size ; j++){
        if(myRoomsList[i].usersJoined[j] == currentUser!.id){
          return true;
        }
      }
    }
  }
  return false;
}