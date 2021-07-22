import 'package:academy_app/constants.dart';
import 'package:academy_app/screens/courses_screen.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  static const routeName = '/search-item';
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  var _isLoading = false;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            AppBar(
              automaticallyImplyLeading: false,
              title: TextFormField(
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
              iconTheme: IconThemeData(
                color: kSecondaryColor, //change your color here
              ),
              backgroundColor: kBackgroundColor,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: kSecondaryColor,
                    ),
                    onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            SizedBox(height: 150),
            Text("Type In Search Bar..."),
          ],
        ));
  }
}
