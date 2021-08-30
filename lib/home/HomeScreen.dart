import 'package:ChatApp/addRoom/AddRoom.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/home/RoomWidget.dart';
import 'package:ChatApp/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String ROUTE_NAME = 'home';
   late CollectionReference<Room> roomsCollectionRef;

   HomeScreen(){
     roomsCollectionRef = getRoomsCollectionWithConverter();
   }
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
          appBar: AppBar(title: Text('Route Chat App'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,),
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, AddRoom.ROUTE_NAME);
            },
            child: Icon(Icons.add),
          ),
          body: Container(
            margin: EdgeInsets.only( top :64 , bottom: 12 , left: 12 , right: 12),
            child:FutureBuilder< QuerySnapshot<Room> > (
              future: roomsCollectionRef.get(),
              builder: (BuildContext context , AsyncSnapshot<QuerySnapshot<Room>>snapshot  ){
                if( snapshot.hasError ){
                  return Text('Something went wrong');
            }else if(snapshot.connectionState == ConnectionState.done ){
                  final List<Room>roomslist = snapshot.data!.docs.map((singleDoc) => singleDoc.data())
                  .toList()??[];
                  return 
                      GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                       itemBuilder: (buildContext , index){
                        return RoomWidget(roomslist[index]);
                       }, itemCount:roomslist.length,);
            }
                return Center(child : CircularProgressIndicator(),);
            }
            ) ,
          ),
        ),
      ],
    );
  }
}
