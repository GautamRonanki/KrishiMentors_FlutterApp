import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:academy_app/models/app_logo.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants.dart';

class WebviewScreen extends StatefulWidget {
  static const routeName = '/webview';

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final _controllerTwo = StreamController<AppLogo>();

  fetchMyLogo() async {
    var url = BASE_URL + '/api/app_logo';
    // var url = 'http://192.168.88.239:8888/academy_4.5//api/app_logo';
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
          NavigationControls(_controller.future),
          // FutureBuilder<WebViewController>(
          //   future: _controller.future,
          //   builder: (ctx, AsyncSnapshot<WebViewController> controller) {
          //     if (controller.hasData) {
          //       // print('lalala');
          //       return IconButton(
          //         icon: Icon(Icons.refresh),
          //         onPressed: () async {
          //           controller.data.reload();
          //         },
          //       );
          //     } else {
          //       return Container();
          //     }
          //   },
          // ),
        ],
      ),
      body: WebView(
        initialUrl: selectedUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No back history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("No forward history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
