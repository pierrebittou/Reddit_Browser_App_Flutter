import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'subreddit.dart';

void changeSubStatus(dynamic subInfo, int status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("access_token");
  http.Response rep;

  if (status == 1) {
    rep = await http.post(
      Uri.parse("https://oauth.reddit.com/api/subscribe"),
      headers: {'Authorization': 'bearer $token'},
      body: {
        "action": "sub",
        "sr_name": subInfo["name"],
      },
    );
  } else {
    rep = await http.post(
      Uri.parse("https://oauth.reddit.com/api/subscribe"),
      headers: {'Authorization': 'bearer $token'},
      body: {
        "action": "unsub",
        "sr_name": subInfo["name"],
      },
    );
  }
}

Future<bool> userIsSubscribed(String subName) async {
  bool res = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("access_token");
  http.Response rep;

  rep = await http.get(
    Uri.parse("https://oauth.reddit.com/r/$subName/about"),
    headers: {'Authorization': 'bearer $token'},
  );
  res = json.decode(rep.body)["data"]["user_is_subscriber"];
  return res;
}

class MiniSubredditContainer extends StatefulWidget {
  final dynamic subInfo;

  const MiniSubredditContainer({Key? key, required this.subInfo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MiniSubredditContainerState();
  }
}

class MiniSubredditContainerState extends State<MiniSubredditContainer> {
  String hexColor = "";
  int bannerColor = 0;
  bool isMounted = false;
  bool isSubscribed = false;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        await userIsSubscribed(widget.subInfo["name"]).then(
          (bool res) {
            setState(
              () {
                isMounted = true;
                isSubscribed = res;
                if (widget.subInfo["key_color"] != "") {
                  hexColor = widget.subInfo["key_color"]
                      .toUpperCase()
                      .replaceAll("#", "");
                  hexColor = "FF" + hexColor;
                  bannerColor = int.parse(hexColor, radix: 16);
                } else {
                  bannerColor = int.parse("FFFFFFFF", radix: 16);
                }
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
    return (isMounted == true)
        ? InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => (SubViewer(
                    subName: widget.subInfo["name"].toString(),
                  )),
                ),
              );
            },
            child: Card(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(bannerColor),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                    height: 25,
                    width: MediaQuery.of(context).size.width - 8,
                  ),
                  Column(
                    children: [
                      ListTile(
                        trailing: (isSubscribed == true)
                            ? TextButton(
                                onPressed: () {
                                  changeSubStatus(widget.subInfo, -1);
                                  setState(
                                    () {
                                      isSubscribed = false;
                                    },
                                  );
                                },
                                child: const Text("Unsubscribe"),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  primary: const Color.fromARGB(255, 255, 0, 0),
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 255, 0, 0),
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  changeSubStatus(widget.subInfo, 1);
                                  setState(
                                    () {
                                      isSubscribed = true;
                                    },
                                  );
                                },
                                child: const Text("Subscribe"),
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 77, 77),
                                  primary:
                                      const Color.fromARGB(255, 36, 36, 36),
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 255, 0, 0)),
                                ),
                              ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: Text(
                            "r/" + widget.subInfo["name"],
                          ),
                        ),
                        subtitle: Text(
                            widget.subInfo["subscriber_count"].toString() +
                                " subscribers"),
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 36, 36, 36),
                          radius: 20,
                          backgroundImage: NetworkImage(widget
                                      .subInfo["icon_img"] !=
                                  ""
                              ? widget.subInfo["icon_img"]
                              : "https://styles.redditmedia.com/t5_3j516/styles/communityIcon_n14de2fhscb41.png"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        : const Card(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 36, 36, 36),
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            ),
          );
  }
}
