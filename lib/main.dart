import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
      routes: {
        RegisterationScreen.routeName : (context)=>RegisterationScreen(),
        LoginScreen.routeName : (context)=>LoginScreen(),
      },
      initialRoute: RegisterationScreen.routeName,
    );
  }

}