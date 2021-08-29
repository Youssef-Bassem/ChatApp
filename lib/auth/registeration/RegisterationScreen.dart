import 'package:ChatApp/Appprovider.dart';
import 'package:ChatApp/auth/login/LoginScreen.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/home/HomeScreen.dart';
import 'package:ChatApp/model/User.dart' as MyUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RegisterationScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'register';

  @override
  _RegisterationScreenState createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  String userName = '';

  String email = '';

  String password = '';
  late Appprovider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<Appprovider>(context);
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Center(child: Text('Create Account')),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (textValue) {
                          userName = textValue;
                        },
                        decoration: InputDecoration(
                            labelText: 'User Name',
                            floatingLabelBehavior: FloatingLabelBehavior.auto),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter user name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onChanged: (textValue) {
                          email = textValue;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email',
                            floatingLabelBehavior: FloatingLabelBehavior.auto),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onChanged: (textValue) {
                          password = textValue;
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            floatingLabelBehavior: FloatingLabelBehavior.auto),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          } else if (value.length < 6) {
                            return 'password should be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                    onPressed: () {
                      createAccount();
                    },
                    child: Text('Create Account')),
                TextButton(child: Text('Already have Account!'),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  final db = FirebaseFirestore.instance;
  bool isLoading = false;
  void createAccount() {
    if (_registerFormKey.currentState?.validate() == true) {
      registerUser();
    }
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      showMessageError('User registered Successful');

      final userCollectionRef = getUsersCollectionWithConverter();
      final user = MyUser.User(
          email: email, id: userCredential.user!.uid, userName: userName);
      userCollectionRef.doc(user.id).set(user).then((value) {
        provider.updateUser(user);
        Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME);
      });
    } on FirebaseAuthException catch (e) {
      showMessageError(e.message ?? "something went wrong please try again");
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  void showMessageError(String message) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ok'),
              )
            ],
          );
        });
  }
}
