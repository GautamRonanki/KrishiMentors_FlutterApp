import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/http_exception.dart';
import '../models/user.dart';
import 'dart:async';
import '../constants.dart';
import 'dart:io';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  User _user;

  Auth();

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    if (_userId != null) {
      return _userId;
    }
    return null;
  }

  User get user {
    return _user;
  }

  Future<void> login(String email, String password) async {
    var url = BASE_URL + '/api/login?email=$email&password=$password';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);

      print(responseData['validity']);
      if (responseData['validity'] == 0) {
        throw HttpException('Auth Failed');
      }

      _token = responseData['token'];
      _userId = responseData['user_id'];

      final loadedUser = User(
        userId: responseData['user_id'],
        firstName: responseData['first_name'],
        lastName: responseData['last_name'],
        email: responseData['email'],
        role: responseData['role'],
      );

      _user = loadedUser;
      // print(_user.firstName);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'user_id': _userId,
        'user': jsonEncode(_user),
      });
      prefs.setString('userData', userData);
      print(userData);
    } catch (error) {
      throw (error);
    }
    // return _authenticate(email, password, 'verifyPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _token = extractedUserData['token'];
    _userId = extractedUserData['user_id'];
    // print(jsonDecode(extractedUserData['user']));
    Map userMap = jsonDecode(extractedUserData['user']);
    _user = User.fromJson(userMap);
    notifyListeners();
    // _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    // _user = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    // if (_authTimer != null) {
    //   _authTimer.cancel();
    // }
    // final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    // _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> getUserInfo() async {
    var url = BASE_URL + '/api/userdata?auth_token=$token';
    try {
      if (token == null) {
        throw HttpException('No Auth User');
      }
      final response = await http.get(url);
      final responseData = json.decode(response.body);

      _user.image = responseData['image'];
      _user.facebook = responseData['facebook'];
      _user.twitter = responseData['twitter'];
      _user.linkedIn = responseData['linkedin'];
      _user.biography = responseData['biography'];
      // print(_user.image);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> userImageUpload(File image) async {
    var url = BASE_URL + '/api/upload_user_image';
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    request.fields['auth_token'] = token;

    request.files.add(http.MultipartFile(
        'file', image.readAsBytes().asStream(), image.lengthSync(),
        filename: basename(image.path)));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          final responseData = json.decode(value);
          if (responseData['status'] != 'success') {
            throw HttpException('Upload Failed');
          }
          notifyListeners();
          print(value);
        });
      }

      // final responseData = json.decode(response.body);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateUserData(User user) async {
    final url = BASE_URL + '/api/update_userdata';

    try {
      final response = await http.post(
        url,
        body: {
          'auth_token': token,
          'first_name': user.firstName,
          'last_name': user.lastName,
          'email': user.email,
          'biography': user.biography,
          'twitter_link': user.twitter,
          'facebook_link': user.facebook,
          'linkedin_link': user.linkedIn,
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'failed') {
        throw HttpException('Update Failed');
      }

      _user.firstName = responseData['first_name'];
      _user.lastName = responseData['last_name'];
      _user.email = responseData['email'];
      _user.image = responseData['image'];
      _user.twitter = responseData['twitter'];
      _user.linkedIn = responseData['linkedin'];
      _user.biography = responseData['biography'];
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateUserPassword(
      String currentPassword, String newPassword) async {
    final url = BASE_URL + '/api/update_password';
    try {
      final response = await http.post(
        url,
        body: {
          'auth_token': token,
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': newPassword,
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'failed') {
        throw HttpException('Password update Failed');
      }
    } catch (error) {
      throw (error);
    }
  }
}
