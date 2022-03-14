import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mini_subreddit_container.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> getSearch(String query) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("access_token");
  http.Response rep;

  rep = await http.post(
    Uri.parse("https://oauth.reddit.com/api/search-subreddits"),
    headers: {'Authorization': 'bearer $token'},
    body: {"query": query, "exact": "false"},
  );
  return json.decode(rep.body)["subreddits"];
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  bool searchMade = false;
  FocusNode _formFocus = FocusNode();
  List<dynamic> _subList = [0];

  @override
  void initState() {
    _formFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _formFocus.dispose();
    super.dispose();
  }

  void _requestFocus() {
    setState(
      () {
        FocusScope.of(context).requestFocus(_formFocus);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextFormField(
                onFieldSubmitted: (String rep) async {
                  await getSearch(rep).then(
                    (subList) {
                      setState(
                        () {
                          _subList = subList;
                          searchMade = false;
                          searchMade = true;
                        },
                      );
                    },
                  );
                },
                onTap: _requestFocus,
                focusNode: _formFocus,
                cursorColor: const Color.fromARGB(255, 255, 0, 0),
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: (_formFocus.hasFocus == true)
                          ? const Color.fromARGB(255, 255, 0, 0)
                          : const Color.fromARGB(255, 255, 255, 255),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Search for a Sub'),
              ),
            ),
          ),
          if (searchMade == true && _subList.length > 1)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.68,
              child: ListView(
                children: List.generate(
                  _subList.length,
                  (index) {
                    return Padding(
                      child: MiniSubredditContainer(
                        subInfo: _subList[index],
                      ),
                      padding: const EdgeInsets.only(
                        bottom: 1.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
