import 'package:flutter/material.dart';
import 'package:redditech/feed_display_settings.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getFeed(String endpoint) async {
  List<dynamic> stackpost;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("access_token");
  var rep = await http.get(
    Uri.https("oauth.reddit.com", "/" + endpoint),
    headers: {'Authorization': 'bearer $token'},
  );
  stackpost = json.decode(rep.body)["data"]["children"];
  return stackpost;
}

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  int filter = 0;
  List<dynamic> stackpost = [0, 0];

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        await getFeed("best").then(
          (List<dynamic> res) {
            if (mounted == false) {
              return;
            }
            setState(
              () {
                stackpost = res;
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(31.0),
        child: AppBar(
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: const Color.fromARGB(255, 22, 21, 21),
              ),
              onPressed: () {
                if (filter != 0) {
                  getFeed("best").then(
                    (List<dynamic> res) {
                      setState(
                        () {
                          stackpost = res;
                        },
                      );
                    },
                  );
                }
                setState(
                  () {
                    filter = 0;
                  },
                );
              },
              child: const Text("Best"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: const Color.fromARGB(255, 255, 255, 255),
                  backgroundColor: const Color.fromARGB(255, 22, 21, 21),
                ),
                onPressed: () {
                  if (filter != 1) {
                    getFeed("hot").then(
                      (List<dynamic> res) {
                        setState(
                          () {
                            stackpost = res;
                          },
                        );
                      },
                    );
                  }
                  setState(
                    () {
                      filter = 1;
                    },
                  );
                },
                child: const Text('Hot'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 70, 0),
              child: TextButton(
                child: const Text('Rising'),
                style: TextButton.styleFrom(
                  primary: const Color.fromARGB(255, 255, 255, 255),
                  backgroundColor: const Color.fromARGB(255, 22, 21, 21),
                ),
                onPressed: () {
                  if (filter != 2) {
                    getFeed("rising").then(
                      (List<dynamic> res) {
                        setState(
                          () {
                            stackpost = res;
                          },
                        );
                      },
                    );
                  }
                  setState(
                    () {
                      filter = 2;
                    },
                  );
                },
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      body: stackpost.length > 3
          ? Stack(
              children: [
                FeedList(postList: stackpost),
              ],
            )
          : const Scaffold(
              backgroundColor: Color.fromARGB(255, 36, 36, 36),
              body: Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 255, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
