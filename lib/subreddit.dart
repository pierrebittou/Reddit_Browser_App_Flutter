import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'vote.dart';

Future<List<dynamic>> getSub(String subName, String endpoint) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var params = {"raw_json": "1"};
  var token = prefs.getString("access_token");
  var rep = await http
      .get(Uri.https("www.reddit.com", "/r/$subName/$endpoint.json", params));
  var _subList = json.decode(rep.body);
  return _subList["data"]["children"];
}

class SubViewer extends StatefulWidget {
  final String subName;

  const SubViewer({Key? key, required this.subName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SubViewerState();
  }
}

class SubViewerState extends State<SubViewer> {
  bool isMounted = false;
  late List<dynamic> _subPosts;

  @override
  void initState() {
    getSub(widget.subName, "best").then((List<dynamic> subPosts) {
      setState(() {
        _subPosts = subPosts;
        isMounted = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        child: const Icon(Icons.clear),
        mini: true,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: (isMounted == true)
          ? Stack(
              children: [
                ListView(
                  children: List.generate(
                    _subPosts.length,
                    (index) {
                      return Padding(
                        child: ViewnVote(redditPost: _subPosts[index]["data"]),
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          left: 4.0,
                          right: 4.0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
