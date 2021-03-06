import 'package:ChatApp/model/User.dart' as MyUser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'database/DataBaseHelper.dart';
import 'model/Room.dart';

class MythemeData{
  static const primaryColor = Color.fromARGB(255,53,152,219);
  static const white = Color.fromARGB(255,255,255,255);
}

class Appprovider extends ChangeNotifier{
  MyUser.User? currentUser ;

  bool checkLoggedInUser(){
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser!=null)
    {
      getUsersCollectionWithConverter()
          .doc(firebaseUser.uid).get()
          .then((retUser) {
        if(retUser.data()!=null)
        {
          currentUser=retUser.data();
        }
        }
      );
    }
    return firebaseUser != null;
  }

  void updateUser( MyUser.User ? user )
  {
    currentUser = user;
    notifyListeners();
  }

}