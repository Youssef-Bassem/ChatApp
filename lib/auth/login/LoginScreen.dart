import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  String email = '';

  String password = '';

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
            title: Center(child: Text('Login')),
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
                isLoading?
                Center(child: CircularProgressIndicator()) : ElevatedButton(
                    onPressed: () {
                      Login();
                    },
                    child: Text('Create Account'))
              ],
            ),
          ),
        ),
      ],
    );
  }
  bool isLoading = false ;
  void Login() {
    if (_loginFormKey.currentState?.validate() == true) {
      signIn();
    }
  }
  void signIn()async{
    setState(() {
      isLoading=true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
      );
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
