import 'package:academy_app/constants.dart';
import 'package:academy_app/models/common_functions.dart';
import 'package:academy_app/models/update_user_model.dart';
import 'package:academy_app/screens/auth_screen.dart';
import 'package:academy_app/screens/email_verification_screen.dart';
import 'package:academy_app/widgets/app_bar_two.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

Future<UpdateUserModel> SignUp(String firstName, String lastName, String email, String password) async {
  final String apiUrl = BASE_URL + "/api/signup";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
  });

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool hidePassword = true;
  var _isLoading = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!globalFormKey.currentState.validate()) {
      // Invalid!
      return;
    }
    globalFormKey.currentState.save();

    setState(() {
      _isLoading = true;
    });
    try {
      final UpdateUserModel user = await SignUp(firstNameController.text, lastNameController.text,
          emailController.text, passwordController.text);

      if(user.emailVerification == 'enable') {
        if(user.message == "You have already signed up. Please check your inbox to verify your email address") {
          Navigator.of(context).pushNamed(EmailVerificationScreen.routeName, arguments: emailController.text);
          CommonFunctions.showSuccessToast(user.message);
        } else {
          Navigator.of(context).pushNamed(EmailVerificationScreen.routeName, arguments: emailController.text);
          CommonFunctions.showSuccessToast(user.message);
        }
      } else {
        Navigator.of(context).pushNamed(AuthScreen.routeName);
        CommonFunctions.showSuccessToast('Signup Successful');
      }

    } catch (error) {
      const errorMsg = 'Could not register!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });

  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      border: new OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: const BorderRadius.all(
          const Radius.circular(5.0),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      filled: true,
      hintStyle:
      new TextStyle(color: Colors.black54, fontSize: 14),
      hintText: hintext,
      fillColor: Color(0xFFF7F7F7),
      contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBarTwo(),
      body: SingleChildScrollView(
        child: Form(
          key: globalFormKey,
          child: Column(
            children: [
              Container(
                height: 100,
                color: kDarkButtonBg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.house, color: kIconColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("/     Sign up", style: TextStyle(color: kLightBlueColor, fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text("Registered user", style: TextStyle(color: kLightBlueColor, fontSize: 25),),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                                child: Text("Registration form", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                                child: Text("Sign up and start learning.", style: TextStyle(fontSize: 15, color: kSecondaryColor),),
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Color(0xFFc7c8ca),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'First name',
                                        style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 14),
                                decoration: getInputDecoration(
                                  'First name',
                                  Icons.title,
                                ),
                                controller: firstNameController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'First name cannot be empty';
                                  }
                                },
                                onSaved: (value) {
                                  firstNameController.text = value;
                                },
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Color(0xFFc7c8ca),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Last name',
                                        style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 14),
                                decoration: getInputDecoration(
                                  'Last name',
                                  Icons.title,
                                ),
                                controller: lastNameController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Last name cannot be empty';
                                  }
                                },
                                onSaved: (value) {
                                  lastNameController.text = value;
                                },
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      color: Color(0xFFc7c8ca),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 14),
                                decoration: getInputDecoration(
                                  'Email',
                                  Icons.title,
                                ),
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (input) =>
                                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                    .hasMatch(input)
                                    ? "Email Id should be valid"
                                    : null,
                                onSaved: (value) {
                                  emailController.text = value;
                                },
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      color: Color(0xFFc7c8ca),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Password',
                                        style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                style: TextStyle(color: Colors.black),
                                keyboardType: TextInputType.text,
                                controller: passwordController,
                                onSaved: (input) => passwordController.text = input,
                                validator: (input) => input.length < 3
                                    ? "Password should be more than 3 characters"
                                    : null,
                                obscureText: hidePassword,
                                decoration: new InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.white, width: 2),
                                  ),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(5.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: new TextStyle(color: Colors.black54, fontSize: 14),
                                  hintText: "password",
                                  fillColor: Color(0xFFF7F7F7),
                                  contentPadding:
                                  EdgeInsets.only(left: 14, top: 20, right: 14, bottom: 20),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    color: Colors.black,
                                    icon: Icon(
                                        hidePassword ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width * 0.6,
                                  child: RaisedButton(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: _submit,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      side: BorderSide(color: kRedColor),
                                    ),
                                    splashColor: Colors.blueAccent,
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 50.0, vertical: 15),
                                    color: kRedColor,
                                    textColor: Colors.white,
                                  ),
                                ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(color: Colors.black54, fontSize: 14),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(AuthScreen.routeName);
                                    },
                                    child: Text(
                                      ' Login',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kBlueColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
