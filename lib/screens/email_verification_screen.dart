import 'package:academy_app/constants.dart';
import 'package:academy_app/models/common_functions.dart';
import 'package:academy_app/models/update_user_model.dart';
import 'package:academy_app/screens/auth_screen.dart';
import 'package:academy_app/widgets/app_bar_two.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailVerificationScreen extends StatefulWidget {
  static const routeName = '/email_verification';
  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

Future<UpdateUserModel> verifyEmail(String email, String verificationCode) async {
  final String apiUrl = BASE_URL + "/api/verify_email_address";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'email': email,
    'verification_code': verificationCode,
  });

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

Future<UpdateUserModel> resendCode(String email) async {
  final String apiUrl = BASE_URL + "/api/resend_verification_code";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'email': email,
  });

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final verificationController = TextEditingController();
  var isLoading = false;
  var _isLoading = false;

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
      final email = ModalRoute.of(context).settings.arguments as String;
      final UpdateUserModel user = await verifyEmail(email, verificationController.text);

      if(user.status == 200){
        Navigator.of(context).pushNamed(AuthScreen.routeName);
        CommonFunctions.showSuccessToast(user.message);
      } else {
        CommonFunctions.showErrorDialog(user.message, context);
      }

    } catch (error) {
      const errorMsg = 'Could not verify email!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });

  }

  Future<void> _resend() async {
    setState(() {
      isLoading = true;
    });
    try {
      final email = ModalRoute.of(context).settings.arguments as String;
      final UpdateUserModel user = await resendCode(email);

      if(user.status == 200){
        Navigator.of(context).pushNamed(EmailVerificationScreen.routeName, arguments: email);
        CommonFunctions.showSuccessToast(user.message);
      } else {
        CommonFunctions.showErrorDialog(user.message, context);
      }

    } catch (error) {
      const errorMsg = 'Could not send code!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context).settings.arguments as String;
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
                            child: Text("/     Verification code", style: TextStyle(color: kLightBlueColor, fontSize: 18)),
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
                                child: Text("Enter the code from your email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                                child: Text("Let us know that this email address belongs to you Enter the code from the email sent to $email.", style: TextStyle(fontSize: 15, color: kSecondaryColor),),
                              ),
                              Divider(),
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
                                        'Verification code',
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
                                controller: verificationController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Field can not be empty';
                                  }
                                },
                                onSaved: (input) => verificationController.text = input,
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
                                  hintText: "Verification code",
                                  fillColor: Color(0xFFF7F7F7),
                                  contentPadding:
                                  EdgeInsets.only(left: 14, top: 20, right: 14, bottom: 20),
                                ),
                              ),
                              isLoading
                                  ? CircularProgressIndicator()
                                  : InkWell(
                                onTap: _resend,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Resend mail',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kBlueColor),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width * 0.6,
                                child: RaisedButton(
                                  child: Text(
                                    'Verify',
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
