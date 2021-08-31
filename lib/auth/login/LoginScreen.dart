import 'dart:ffi';

import 'package:ChatApp/auth/registeration/RegisterationScreen.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/home/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/model/User.dart' as MyUser;
import 'package:provider/provider.dart';

import '../../Appprovider.dart';

class LoginScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

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
            title: Center(child:
              Text('Login',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),
              )
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
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
                      SizedBox(
                        height: 10,
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password ?'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Login();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                      ),
                TextButton(
                  child: Text('Or Create My Account!'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterationScreen()),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool isLoading = false;
  void Login() {
    if (_loginFormKey.currentState?.validate() == true) {
      signIn();
    }
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        showMessageError(
            'invalid Credentials no user exist' 'with this email and password');
      } else {
        final userRef = getUsersCollectionWithConverter()
            .doc(userCredential.user!.uid)
            .get()
            .then((retrievedUser) {
          provider.updateUser(retrievedUser.data());
          Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
        });
      }
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
