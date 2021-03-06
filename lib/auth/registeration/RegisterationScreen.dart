import 'package:ChatApp/Appprovider.dart';
import 'package:ChatApp/auth/login/LoginScreen.dart';
import 'package:ChatApp/database/DataBaseHelper.dart';
import 'package:ChatApp/home/HomeScreen.dart';
import 'package:ChatApp/model/Room.dart';
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

  bool passwordVisibility = true;

  String userName = '';

  String email = '';

  String password = '';

  List<Room> rooms = [];

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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Create Account',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            height: double.infinity,
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
                      SizedBox(
                        height: 10,
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
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (textValue) {
                          password = textValue;
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: passwordVisibility
                                  ? Icon(
                                Icons.remove_red_eye_outlined,
                              )
                                  : Icon(Icons.remove_red_eye),
                              onPressed: () {
                                _togglePasswordVisibility();
                              },
                            ),
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
                        height: 30,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            createAccount();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Create Account',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold,color: Colors.grey),
                                ),
                                Icon(Icons.arrow_forward,color: Colors.grey,)
                              ],
                            ),
                          ),
                        ),
                      ),
                      /*
                      TextButton(
                        child: Text('Already have Account!'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                       */
                    ],
                  ),
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
          email: email, id: userCredential.user!.uid, userName: userName );
      userCollectionRef.doc(user.id).set(user).then((value) {
        provider.updateUser(user);
        Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
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

  void _togglePasswordVisibility() {
    setState(() {
      passwordVisibility = !passwordVisibility;
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
