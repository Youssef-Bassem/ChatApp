import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addRoom/AddRoom.dart';
import 'auth/login/LoginScreen.dart';
import 'home/RoomWidget.dart';
import 'model/Room.dart';

class Search extends StatefulWidget {
  static const String ROUTE_NAME = 'search';
  late CollectionReference<Room> roomsCollectionRef;
  String searchQuery;
  Search(this.searchQuery, this.roomsCollectionRef);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
            title: Text(widget.searchQuery,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AddRoom.ROUTE_NAME);
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
                    final List<Room> roomslist =
                        snapshot.data!.docs.map( (singleDoc) => singleDoc.data() ).toList() ?? [];

                    int count = 0;
                    for(int i=0 ; i<roomslist.length ; )
                    {
                      int j=i+1;
                      if( j == roomslist.length )
                        break;
                      if ( roomslist[i].name.toUpperCase().contains(widget.searchQuery.toUpperCase() ))
                      {
                        count++;
                        i++;
                      }
                      else{
                        roomslist.removeAt(i);
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemBuilder: (buildContext, index) {
                          print('$index');
                          if ( roomslist[index].name.toUpperCase().contains(widget.searchQuery.toUpperCase() ))
                            //return RoomWidget(roomslist[index],"");
                            return Container(color: Colors.black,);
                          else
                            return Container(color: Colors.black,);
                        },
                        itemCount: count,
                      ),
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
}
