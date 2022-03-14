import 'package:flutter/material.dart';
import 'package:redditech/subreddit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void subredditStatus(dynamic subInfo, int status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("access_token");
  http.Response rep;

  if (status == 1) {
    rep = await http.post(Uri.parse("https://oauth.reddit.com/api/subscribe"),
        headers: {'Authorization': 'bearer $token'},
        body: {"action": "sub", "sr_name": subInfo["display_name"]});
  } else {
    rep = await http.post(Uri.parse("https://oauth.reddit.com/api/subscribe"),
        headers: {'Authorization': 'bearer $token'},
        body: {"action": "unsub", "sr_name": subInfo["display_name"]});
  }
}

class Subreddit extends StatefulWidget {
  final dynamic subInfo;

  const Subreddit({Key? key, required this.subInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SubredditState();
  }
}

class SubredditState extends State<Subreddit> {
  String hexColor = "";
  int colorBanner = 0;
  bool subscribed = false;

  @override
  void initState() {
    setState(
      () {
        hexColor =
            widget.subInfo["primary_color"].toUpperCase().replaceAll("#", "");
        hexColor = "FF" + hexColor;
        colorBanner = int.parse(hexColor, radix: 16);
      },
    );

    if (widget.subInfo["user_is_subscriber"] == true) {
      setState(
        () {
          subscribed = true;
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => (SubViewer(
              subName: widget.subInfo["display_name_prefixed"]
                  .toString()
                  .substring(2),
            )),
          ),
        );
      },
      child: Card(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(colorBanner),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
              ),
              height: 40,
              width: MediaQuery.of(context).size.width - 8,
            ),
            ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
              ),
              trailing: (subscribed == true)
                  ? TextButton(
                      onPressed: () {
                        subredditStatus(widget.subInfo, -1);
                        setState(
                          () {
                            subscribed = false;
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
                        subredditStatus(widget.subInfo, 1);
                        setState(
                          () {
                            subscribed = true;
                          },
                        );
                      },
                      child: const Text("Subscribe"),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                        primary: Colors.white,
                        side: const BorderSide(
                          color: Color.fromARGB(255, 255, 0, 0),
                        ),
                      ),
                    ),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  (widget.subInfo["icon_img"]) == null
                      ? widget.subInfo["community_icon"]
                      : widget.subInfo["icon_img"],
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  widget.subInfo["title"].toString(),
                ),
              ),
              subtitle: Text(
                widget.subInfo["display_name_prefixed"],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
