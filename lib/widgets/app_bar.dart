import 'dart:async';
import 'dart:convert';
import 'package:academy_app/screens/courses_screen.dart';
import 'package:academy_app/widgets/search_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:academy_app/models/app_logo.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {

  @override
  final Size preferredSize;

  CustomAppBar() : preferredSize = Size.fromHeight(50.0),
        super();

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  bool _isSearching = false;
  final _controller = StreamController<AppLogo>();
  final searchController = TextEditingController();

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

  void _handleSubmitted(String value) {
    final searchText = searchController.text;
    if (searchText.isEmpty) {
      return;
    }

    searchController.clear();
    Navigator.of(context).pushNamed(
      CoursesScreen.routeName,
      arguments: {
        'category_id': null,
        'seacrh_query': searchText,
        'type': CoursesPageData.Search,
      },
    );
    // print(searchText);
  }

  void _showSearchModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return SearchWidget();
      },
    );
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
      leading: StreamBuilder<AppLogo>(
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
              return Transform.scale(
                scale: 3.5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: CachedNetworkImage(alignment: Alignment.center,
                    // imageUrl: 'http://192.168.88.239:8888/academy_4.5/uploads/system/logo-dark.png',
                    imageUrl: snapshot.data.darkLogo,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }
          }
        },
      ),
      title: !_isSearching
          ? Container()
          : Card(
        color: Colors.white,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Search Here',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          controller: searchController,
          onFieldSubmitted: _handleSubmitted,
        ),
      ),
      backgroundColor: kBackgroundColor,
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.search,
              color: kSecondaryColor,
            ),
            onPressed: () => _showSearchModal(context),
        ),
      ],
    );
  }
}
