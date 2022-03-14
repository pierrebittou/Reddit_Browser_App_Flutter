import 'package:flutter/material.dart';
import 'package:redditech/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getMe() async {
  dynamic _me;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("access_token");
  var rep = await http.get(
    Uri.https("oauth.reddit.com", "/api/v1/me"),
    headers: {'Authorization': 'bearer $token'},
  );
  _me = json.decode(rep.body);
  return _me;
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  dynamic _me = [0, 0];
  bool v1 = false;
  RegExp bannerParse = RegExp(r".*(?=\?)");

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        await getMe().then(
          (dynamic res) {
            if (mounted == false) {
              return;
            }
            setState(
              () {
                _me = res;
                v1 = true;
              },
            );
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (v1 == true) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 30,
              bottom: 10,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                heroTag: 'back',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Settings();
                      },
                    ),
                  );
                },
                child: const Icon(
                  Icons.settings,
                  size: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 30,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                heroTag: 'next',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const MyApp();
                      },
                    ),
                  );
                },
                child: const Icon(
                  Icons.exit_to_app_rounded,
                  size: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.topCenter,
                      image: NetworkImage(
                        bannerParse
                            .stringMatch(_me["subreddit"]["banner_img"])
                            .toString(),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(bottom: 50)),
                    Center(
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: const Color.fromARGB(255, 255, 64, 64),
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 36, 36, 36),
                          radius: 70,
                          backgroundImage: NetworkImage(
                            bannerParse.stringMatch(_me["icon_img"]).toString(),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    Text(
                      _me["name"].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    Text(
                      _me["subreddit"]["display_name_prefixed"].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15),
                    ),
                    Text(
                      _me["total_karma"].toString() + " karma",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15),
                    ),
                    Image.asset('images/Karma_logo.png', height: 20),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                    ),
                    Card(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      child: Text(
                        _me["subreddit"]["public_description"].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 36, 36, 36),
        body: Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 36, 36, 36),
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 244, 3, 3),
              ),
            ),
          ),
        ),
      );
    }
  }
}
