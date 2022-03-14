import 'package:flutter/material.dart';
import 'package:redditech/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoggedIn = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: const Body(),
    );
  }
}

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/reddit_logo.png',
        ),
        const RoundedButton(),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFB71C1C),
                      Color.fromARGB(255, 244, 108, 54),
                      Color.fromARGB(255, 224, 116, 15),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(15.0),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Mywebview();
                    },
                  ),
                );
              },
              child: const Align(
                alignment: Alignment.center,
                child: Text('LOGIN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void saveKeysLocaly(dynamic response) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("access_token", response["access_token"]);
}
