import 'package:flutter/material.dart';
import './custom_text.dart';
import '../constants.dart';

class TabViewDetails extends StatelessWidget {
  final String titleText;
  final List<String> listText;
  final IconData icon;

  TabViewDetails({
    @required this.titleText,
    @required this.listText,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Customtext(
                text: titleText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                colors: kDarkGreyColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Icon(
                icon,
                color: kSecondaryColor,
                size: 28,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (ctx, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Customtext(
                      text: listText[index],
                      colors: kDarkGreyColor,
                      fontSize: 16,
                    ),
                    Divider(),
                  ],
                ),
              );
            },
            itemCount: listText.length,
          ),
        ),
      ],
    );
  }
}
