import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:http/http.dart' as http;
import 'video_player.dart' as hb;

void sendVote(dynamic response, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("access_token");
  var rep = await http.post(Uri.parse("https://oauth.reddit.com/api/vote"),
      headers: {'Authorization': 'bearer $token'},
      body: {"dir": value.toString(), "id": response["name"], "rank": "2"});
}

class ViewnVote extends StatefulWidget {
  final dynamic redditPost;

  const ViewnVote({Key? key, required this.redditPost}) : super(key: key);

  @override
  _ViewnVoteState createState() => _ViewnVoteState();
}

class _ViewnVoteState extends State<ViewnVote> {
  var postData;
  var iconUrl;
  int upsValue = 0;
  int voteStatus = 0;
  late Widget videoPlayer;
  bool videoMounted = false;
  Color upvoteColor = Colors.grey;
  Color downvoteColor = Colors.grey;

  @override
  void initState() {
    iconUrl =
        "https://styles.redditmedia.com/t5_3j516/styles/communityIcon_n14de2fhscb41.png";
    upsValue = widget.redditPost["ups"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(iconUrl),
            ),
            title: Text(
              widget.redditPost["subreddit_name_prefixed"],
              style: const TextStyle(fontSize: 10),
            ),
            subtitle: Text(
              "u/" + widget.redditPost["author_fullname"],
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Text(
            widget.redditPost["title"],
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),
          if (widget.redditPost["post_hint"] == "image" ||
              (widget.redditPost["post_hint"] == "link" &&
                  widget.redditPost["url"].toString().contains(".gif") == true))
            if (widget.redditPost["url"].toString().contains(".gifv") == true)
              hb.VideoPlayer(redditPost: widget.redditPost)
            else
              Image(
                image: NetworkImage(widget.redditPost["url"]),
              )
          else if (widget.redditPost["post_hint"] == null ||
              widget.redditPost["post_hint"] == "self")
            SizedBox(
              height: 200,
              child: Markdown(
                data: widget.redditPost["selftext"],
                onTapLink: (text, url, title) {
                  if (url != null) launch(url);
                },
              ),
            )
          else if (widget.redditPost["post_hint"] == "hosted:video" ||
              widget.redditPost["post_hint"] == "rich:video")
            hb.VideoPlayer(redditPost: widget.redditPost)
          else if (widget.redditPost["post_hint"] == "link" &&
              widget.redditPost["url"].toString().contains(".gif") == false)
            if (widget.redditPost["crosspost_parent_list"] != null)
              const Text("CROSSPOST")
            else
              SimpleUrlPreview(
                bgColor: const Color.fromARGB(255, 255, 64, 64),
                titleStyle: const TextStyle(
                    color: Color.fromARGB(255, 61, 61, 61),
                    fontWeight: FontWeight.bold),
                descriptionStyle:
                    const TextStyle(color: Color.fromARGB(255, 65, 64, 64)),
                siteNameStyle:
                    const TextStyle(color: Color.fromARGB(255, 75, 75, 75)),
                url: widget.redditPost["url_overridden_by_dest"],
              ),
          if (widget.redditPost["is_gallery"] == true) const Text("Gallery"),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                color: upvoteColor,
                icon: const Icon(Icons.wb_sunny_outlined),
                onPressed: () {
                  if (voteStatus == -1 || voteStatus == 0) {
                    sendVote(widget.redditPost, 1);
                    setState(
                      () {
                        downvoteColor = Colors.grey;
                        upvoteColor = const Color.fromARGB(255, 255, 0, 0);
                        upsValue = upsValue + 1;
                        voteStatus = 1;
                      },
                    );
                  } else if (voteStatus == 1) {
                    sendVote(widget.redditPost, 0);
                    setState(
                      () {
                        upvoteColor = Colors.grey;
                        upsValue = upsValue - 1;
                        voteStatus = 0;
                      },
                    );
                  }
                },
              ),
              const Padding(padding: EdgeInsets.only(right: 15)),
              Text(
                upsValue.toString(),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              IconButton(
                color: downvoteColor,
                icon: const Icon(Icons.wb_cloudy_outlined),
                onPressed: () {
                  if (voteStatus == 1 || voteStatus == 0) {
                    sendVote(widget.redditPost, -1);
                    setState(
                      () {
                        upvoteColor = Colors.grey;
                        downvoteColor = const Color.fromARGB(255, 0, 81, 255);
                        upsValue = upsValue - 1;
                        voteStatus = -1;
                      },
                    );
                  } else if (voteStatus == -1) {
                    sendVote(widget.redditPost, 0);
                    setState(
                      () {
                        downvoteColor = Colors.grey;
                        upsValue = upsValue + 1;
                        voteStatus = 0;
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
