import './auth_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 130,
          ),
          Center(
            child: Image.asset(
              'assets/images/do_login.png',
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AuthScreen.routeName);
              },
              child: Text(
                'Sign In',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              color: kBlueColor,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
              splashColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
                side: BorderSide(color: kBlueColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
