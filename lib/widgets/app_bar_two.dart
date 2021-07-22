import 'dart:async';
import 'dart:convert';
import 'package:academy_app/screens/courses_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:academy_app/models/app_logo.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class CustomAppBarTwo extends StatefulWidget with PreferredSizeWidget {

  @override
  final Size preferredSize;

  CustomAppBarTwo() : preferredSize = Size.fromHeight(50.0),
        super();

  @override
  _CustomAppBarTwoState createState() => _CustomAppBarTwoState();
}

class _CustomAppBarTwoState extends State<CustomAppBarTwo> {

  bool _isSearching = false;
  final _controller = StreamController<AppLogo>();

  fetchMyLogo() async {
    var url = BASE_URL + '/api/app_logo';
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


  @override
  void initState() {
    super.initState();
    this.fetchMyLogo();
    // Provider.of<Auth>(context).tryAutoLogin().then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.3,
      iconTheme: IconThemeData(
        color: kSecondaryColor, //change your color here
      ),
      title: StreamBuilder<AppLogo>(
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
                imageUrl: snapshot.data.darkLogo,
                fit: BoxFit.contain,
                height: 27,
              );
            }
          }
        },
      ),
      backgroundColor: kBackgroundColor,
    );
  }
}
