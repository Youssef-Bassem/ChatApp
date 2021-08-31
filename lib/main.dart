import 'package:ChatApp/Appprovider.dart';
import 'package:ChatApp/home/HomeScreen.dart';
import 'package:ChatApp/room/RoomScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addRoom/AddRoom.dart';
import 'auth/login/LoginScreen.dart';
import 'auth/registeration/RegisterationScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Appprovider(),
      builder: (context,widget)
      {
        final provider  = Provider.of<Appprovider>(context);
        final isLoggedInUser = provider.checkLoggedInUser();

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            LoginScreen.ROUTE_NAME:(buildContext)=>LoginScreen(),
            RegisterationScreen.ROUTE_NAME:(buildContext)=>RegisterationScreen(),
            HomeScreen.ROUTE_NAME:(buildContext)=>HomeScreen(),
            AddRoom.ROUTE_NAME:(buildContext)=>AddRoom(),
            RoomScreen.routeName:(buildContext)=>RoomScreen(),
          },
          initialRoute: isLoggedInUser ? HomeScreen.ROUTE_NAME : LoginScreen.ROUTE_NAME,
        );
      },
    );
  }

}