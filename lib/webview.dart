import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'homescreen.dart';
import 'main.dart';

class Mywebview extends StatelessWidget {
  Mywebview({Key? key}) : super(key: key);
  final Completer<WebViewController> mywebviewcontroller =
      Completer<WebViewController>();

  var token;
  @override
  Widget build(BuildContext context) {
    var _clientId = "UPuD8WMD-zXpl5U2kbYcPA";
    var callbackUrl = "https://github.com/pierrebittou";
    var callbackScheme = "";

    return Scaffold(
      key: const Key("WebView"),
      body: WebView(
        initialUrl:
            'https://www.reddit.com/api/v1/authorize.compact?client_id=$_clientId&response_type=code&state=RANDOM_STRING&redirect_uri=$callbackUrl$callbackScheme&scope=*',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          mywebviewcontroller.complete(webViewController);
        },
        navigationDelegate: (geturl) async {
          if (geturl.url.startsWith("https://github.com")) {
            final queryStrings =
                Uri.splitQueryString(Uri.parse(geturl.url).query);

            String? code = queryStrings['code'];
            print("code:");
            print(code);

            var response = await http.post(
              Uri.parse('https://www.reddit.com/api/v1/access_token'),
              headers: {
                'Authorization': 'Basic ' +
                    base64Encode(
                      utf8.encode(
                          _clientId + ':bgEsZWKfwu9Xm2KiKGU6RavLYEgQtw'),
                    ),
              },
              body: {
                'grant_type': 'authorization_code',
                'code': code,
                'redirect_uri': "https://github.com/pierrebittou",
              },
              encoding: Encoding.getByName("utf-8"),
            );
            var jsonRep = json.decode(response.body);
            saveKeysLocaly(jsonRep);
            token = ('${jsonDecode(response.body)['access_token']}');
            print(token);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const HomeScreen();
                },
              ),
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
