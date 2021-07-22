import 'package:academy_app/widgets/app_bar.dart';
import 'package:academy_app/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './home_screen.dart';
import './login_screen.dart';
import '../constants.dart';
import '../screens/courses_screen.dart';
import '../screens/my_courses_screen.dart';
import '../screens/my_wishlist_screen.dart';
import '../screens/account_screen.dart';
import '../widgets/filter_widget.dart';
import '../providers/auth.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Widget> _pages = [
    HomeScreen(),
    LoginScreen(),
    LoginScreen(),
    LoginScreen(),
  ];
  var _isInit = true;
  var _isLoading = false;

  int _selectedPageIndex = 0;
  bool _isSearching = false;
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Provider.of<Auth>(context).tryAutoLogin().then((_) {});
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      final _isAuth = Provider.of<Auth>(context, listen: false).isAuth;

      if (_isAuth) {
        _pages = [
          HomeScreen(),
          MyCoursesScreen(),
          MyWishlistScreen(),
          AccountScreen(),
        ];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showFilterModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return FilterWidget();
      },
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _pages[_selectedPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterModal(context),
        child: Icon(Icons.filter_list),
        backgroundColor: kDarkButtonBg,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.school),
            title: Text('Course'),
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.shopping_basket),
            title: Text('My Course'),
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.favorite_border),
            title: Text('Wishlist'),
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.account_circle),
            title: Text('Account'),
          ),
        ],
        backgroundColor: kBackgroundColor,
        unselectedItemColor: kSecondaryColor,
        selectedItemColor: kSelectItemColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
