import 'package:ChatApp/model/User.dart';
import 'package:flutter/material.dart';

class MythemeData{
  static const primaryColor = Color.fromARGB(255,53,152,219);
  static const white = Color.fromARGB(255,255,255,255);
}

class Appprovider extends ChangeNotifier{
  User? currentUser ;

  void updateUser( User ? user )
  {
    currentUser = user;
    notifyListeners();
  }



}