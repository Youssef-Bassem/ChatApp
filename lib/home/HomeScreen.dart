import 'package:ChatApp/addRoom/AddRoom.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/home/RoomWidget.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Search.dart';

class HomeScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'home';
  late CollectionReference<Room> roomsCollectionRef;


  HomeScreen() {
    roomsCollectionRef = getRoomsCollectionWithConverter();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchQueryController = TextEditingController();

  bool _isSearching = false;

  late String searchQuery = "";

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
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            title: _isSearching ? _buildSearchField() : Text('Chat App',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23)),
            actions: _buildActions(),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRoom()),
              );
            },
            child: Icon(Icons.add),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 64, bottom: 12, left: 12, right: 12),
            child: FutureBuilder<QuerySnapshot<Room>>(
                future: widget.roomsCollectionRef.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Room>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    final List<Room> roomslist = snapshot.data!.docs
                            .map((singleDoc) => singleDoc.data())
                            .toList() ??
                        [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (buildContext, index) {
                        return RoomWidget(roomslist[index]);
                      },
                      itemCount: roomslist.length,
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
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
              MaterialPageRoute(builder: (context) => Search()),
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
