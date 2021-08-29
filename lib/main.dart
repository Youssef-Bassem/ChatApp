import 'package:ChatApp/Appprovider.dart';
import 'package:ChatApp/home/HomeScreen.dart';
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
      builder: (context,widget){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            RegisterationScreen.ROUTE_NAME : (context)=>RegisterationScreen(),
            LoginScreen.ROUTE_NAME : (context)=>LoginScreen(),
            HomeScreen.ROUTE_NAME:(context)=>HomeScreen(),
            AddRoom.ROUTE_NAME:(context)=>AddRoom(),
          },
          initialRoute: AddRoom.ROUTE_NAME,
        );
      },
    );
  }

}