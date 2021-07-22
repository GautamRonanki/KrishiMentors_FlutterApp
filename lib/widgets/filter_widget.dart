import 'package:academy_app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/misc_provider.dart';
import '../providers/courses.dart';
import '../providers/categories.dart';
import './custom_text.dart';
import './star_display_widget.dart';
import '../screens/courses_screen.dart';
import '../models/common_functions.dart';

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isInit = true;
  var _isLoading = false;
  String _selectedCatagory = 'all';
  String _selectedPrice = 'all';
  String _selectedLevel = 'all';
  String _selectedLanguage = 'all';
  String _selectedRating = 'all';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Languages>(context).fetchLanguages().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _resetForm() {
    setState(() {
      _selectedCatagory = 'all';
      _selectedPrice = 'all';
      _selectedLevel = 'all';
      _selectedLanguage = 'all';
      _selectedRating = 'all';
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Courses>(context, listen: false).filterCourses(
          _selectedCatagory,
          _selectedPrice,
          _selectedLevel,
          _selectedLanguage,
          _selectedRating);
      Navigator.of(context).pushNamed(
        CoursesScreen.routeName,
        arguments: {
          'category_id': null,
          'seacrh_query': null,
          'type': CoursesPageData.Filter,
        },
      );
    } catch (error) {
      const errorMsg = 'Could not process request!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final catData = Provider.of<Categories>(context, listen: false).items;
    catData.insert(0,
        Category(id: 0, title: 'All', thumbnail: null, numberOfCourses: null));
    //print(catData);
    final langData = Provider.of<Languages>(context, listen: false).items;
    langData.insert(0, Language(id: 0, value: 'all', displayedValue: 'All'));
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
                title: Text(
                  'Filter Courses',
                  style: TextStyle(
                    fontSize: 16,
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                  ),
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
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 9,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Customtext(
                                  text: 'Category',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: DropdownButton(
                                value: _selectedCatagory,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCatagory = value;
                                  });
                                },
                                isExpanded: true,
                                items: catData.map((cd) {
                                  return DropdownMenuItem(
                                    value:
                                        cd.id == 0 ? 'all' : cd.id.toString(),
                                    child: Text(cd.title),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 9,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Customtext(
                                  text: 'Price',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: DropdownButton(
                                value: _selectedPrice,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPrice = value;
                                  });
                                },
                                isExpanded: true,
                                items: PriceFilter.getPriceFilter().map((pf) {
                                  return DropdownMenuItem(
                                    value: pf.id,
                                    child: Text(pf.name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 9,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Customtext(
                                  text: 'Level',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: DropdownButton(
                                value: _selectedLevel,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLevel = value;
                                  });
                                },
                                isExpanded: true,
                                items: DifficultyLevel.getDifficultyLevel()
                                    .map((dl) {
                                  return DropdownMenuItem(
                                    value: dl.id,
                                    child: Text(dl.name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 9,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Customtext(
                                  text: 'Language',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: DropdownButton(
                                value: _selectedLanguage,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLanguage = value;
                                  });
                                },
                                isExpanded: true,
                                items: langData.map((ld) {
                                  return DropdownMenuItem(
                                    value: ld.value,
                                    child: Text(ld.displayedValue),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 9,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Customtext(
                                  text: 'Rating',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: DropdownButton(
                                value: _selectedRating,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRating = value;
                                  });
                                },
                                isExpanded: true,
                                items: [0, 1, 2, 3, 4, 5].map((item) {
                                  return DropdownMenuItem(
                                    value: item == 0 ? 'all' : item.toString(),
                                    child: item == 0
                                        ? Text('All')
                                        : StarDisplayWidget(
                                            value: item,
                                            filledStar: Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 15,
                                            ),
                                            unfilledStar: Icon(
                                              Icons.star,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                          ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: RaisedButton(
                                onPressed: _resetForm,
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                color: kDarkButtonBg,
                                textColor: Colors.white,
                                splashColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  side: BorderSide(color: kDarkButtonBg),
                                ),
                              ),
                            ),
                            Expanded(flex: 2, child: Container()),
                            Expanded(
                              flex: 5,
                              child: RaisedButton(
                                onPressed: _submitForm,
                                child: Text(
                                  'Filter',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                color: kDeepBlueColor,
                                textColor: Colors.white,
                                splashColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  side: BorderSide(color: kBlueColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
  }
}
