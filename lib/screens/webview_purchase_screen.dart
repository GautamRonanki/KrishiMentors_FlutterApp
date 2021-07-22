import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:academy_app/models/app_logo.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../constants.dart';

class WebviewPurchaseScreen extends StatefulWidget {
  static const routeName = '/webview-test';

  @override
  _WebviewPurchaseScreenState createState() => _WebviewPurchaseScreenState();
}

class _WebviewPurchaseScreenState extends State<WebviewPurchaseScreen> {

  final _controllerTwo = StreamController<AppLogo>();

  fetchMyLogo() async {
    var url = BASE_URL + '/api/app_logo';
    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        var logo = AppLogo.fromJson(jsonDecode(response.body));
        _controllerTwo.add(logo);
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
    final flutterWebViewPlugin = FlutterWebviewPlugin();
    final selectedUrl = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        iconTheme: IconThemeData(
          color: kSecondaryColor, //change your color here
        ),
        title: StreamBuilder<AppLogo>(
          stream: _controllerTwo.stream,
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              flutterWebViewPlugin.goBack();
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              flutterWebViewPlugin.goForward();
            },
          ),
          IconButton(
            icon: const Icon(Icons.autorenew),
            onPressed: () {
              flutterWebViewPlugin.reload();
            },
          ),
        ],
      ),
      body: WebviewScaffold(
        url: selectedUrl,
        withLocalStorage: true,
        initialChild: Container(
          color: Colors.redAccent,
          child: const Center(
            child: Text('Waiting.....'),
          ),
        ),
      ),
    );
  }
}
