import 'package:academy_app/models/common_functions.dart';
import 'package:academy_app/providers/courses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

buildPopupDialog(BuildContext context, items) {
  return new AlertDialog(
    title: const Text('Notifying'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Do you wish to remove this course?'),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('No', style: TextStyle(color: Colors.red),),
      ),
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
          Provider.of<Courses>(context, listen: false)
              .toggleWishlist(items, true)
              .then((_) => CommonFunctions.showSuccessToast(
              'Removed from wishlist.'));
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Yes', style: TextStyle(color: Colors.green),),
      ),
    ],
  );
}

buildPopupDialogWishList(BuildContext context, courses, isWishlisted, id, msg) {
  return new AlertDialog(
    title: const Text('Notifying'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        msg ? Text('Do you want remove it?') : Text('Do you want to add it?'),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('No', style: TextStyle(color: Colors.red),),
      ),
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
          var msg = isWishlisted
              ? 'Remove from Wishlist'
              : 'Added to Wishlist';
          CommonFunctions.showSuccessToast(msg);
          courses.toggleWishlist(
              id, false);
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Yes', style: TextStyle(color: Colors.green),),
      ),
    ],
  );
}