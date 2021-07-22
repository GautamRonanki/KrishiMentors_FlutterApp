import 'dart:async';
import 'dart:convert';

import 'package:academy_app/models/app_logo.dart';
import 'package:academy_app/screens/signup_screen.dart';
import 'package:academy_app/widgets/app_bar_two.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import '../models/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';
import '../constants.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _controller = StreamController<AppLogo>();

  final searchController = TextEditingController();

  fetchMyLogo() async {
    var url = BASE_URL +'/api/app_logo';
    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        var logo = AppLogo.fromJson(jsonDecode(response.body));
        _controller.add(logo);
      }
      // print(extractedData);
    } catch (error) {
      throw (error);
    }
  }

  void initState() {
    super.initState();
    this.fetchMyLogo();
    // Provider.of<Auth>(context).tryAutoLogin().then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      appBar: CustomAppBarTwo(),
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: StreamBuilder<AppLogo>(
                      stream: _controller.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          if (snapshot.error != null) {
                            return Text("Error Occured");
                          } else {
                            // saveImageUrlToSharedPref(snapshot.data.darkLogo);
                            return CachedNetworkImage(
                              imageUrl: snapshot.data.favicon,
                              fit: BoxFit.contain,
                              height: 33,
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 94.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email'],
        _authData['password'],
      );

      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      CommonFunctions.showSuccessToast('Login Successful');
    } on HttpException catch (error) {
      var errorMsg = 'Auth failed';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      print(error);
      const errorMsg = 'Could not authenticate!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: 360,
      constraints: BoxConstraints(minHeight: 260),
      width: deviceSize.width * 0.8,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.grey,
                  ), // myIcon is a 48px-wide widget.
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(
                    Icons.vpn_key,
                    color: Colors.grey,
                  ),
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 4) {
                    return 'Password is too short!';
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ButtonTheme(
                  minWidth: deviceSize.width * 0.8,
                  child: RaisedButton(
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      side: BorderSide(color: kBlueColor),
                    ),
                    splashColor: Colors.blueAccent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
                    color: kBlueColor,
                    textColor: Colors.white,
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                minWidth: deviceSize.width * 0.8,
                child: RaisedButton(
                  child: Text(
                    'Create Account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SignUpScreen.routeName);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    side: BorderSide(color: kGreyColor),
                  ),
                  splashColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
                  color: kGreyColor,
                  textColor: kTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
