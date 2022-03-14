import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

bool NightMode = false;
bool Accept_PM = false;
bool Enable_followers = false;
bool NSFW = false;
bool Save_search = false;
bool Video_autoplay = false;

Future<dynamic> getSettings() async {
  dynamic settings;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("access_token");
  var rep = await http.get(
    Uri.https("oauth.reddit.com", "/api/v1/me/prefs"),
    headers: {'Authorization': 'bearer $token'},
  );
  settings = json.decode(rep.body);
  return settings;
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  late dynamic prefs;

  @override
  void initState() {
    getSettings().then((dynamic rep) {
      setState(() {
        if (mounted == false) {
          return;
        }
        prefs = rep;
        NightMode = rep["nightmode"];
        Accept_PM = rep["accept_pms"];
        Enable_followers = rep["enable_followers"];
        NSFW = rep["over_18"];
        Save_search = rep["search_include_over_18"];
        Video_autoplay = rep["video_autoplay"];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: SettingsScreenSwitch(),
      ),
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        child: const Icon(Icons.clear),
        mini: true,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class SettingsScreenSwitch extends StatefulWidget {
  const SettingsScreenSwitch({Key? key}) : super(key: key);

  @override
  State<SettingsScreenSwitch> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreenSwitch> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Settings"),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(bottom: 50)),
            //
            SwitchListTile(
              activeColor: Colors.red,
              title: const Text(
                'NightMode',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              value: NightMode,
              onChanged: (bool value) {
                setState(
                  () {
                    NightMode = value;
                  },
                );
              },
            ),
            //
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            SwitchListTile(
              activeColor: Colors.red,
              title: const Text(
                'Accept PM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              value: Accept_PM,
              onChanged: (bool value) {
                setState(
                  () {
                    Accept_PM = value;
                  },
                );
              },
            ),
            //
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            SwitchListTile(
              activeColor: Colors.red,
              title: const Text(
                'Enable followers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              value: Enable_followers,
              onChanged: (bool value) {
                setState(
                  () {
                    Enable_followers = value;
                  },
                );
              },
            ),
            //
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            SwitchListTile(
              activeColor: Colors.red,
              title: const Text(
                'NSFW',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              value: NSFW,
              onChanged: (bool value) {
                setState(
                  () {
                    NSFW = value;
                  },
                );
              },
            ),
            //
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            SwitchListTile(
              activeColor: Colors.red,
              title: const Text(
                'Save search',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              value: Save_search,
              onChanged: (bool value) {
                setState(
                  () {
                    Save_search = value;
                  },
                );
              },
            ),
            //
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            SwitchListTile(
              activeColor: Colors.red,
              title: const Text(
                'Video auto-play',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              value: Video_autoplay,
              onChanged: (bool value) {
                setState(
                  () {
                    Video_autoplay = value;
                  },
                );
              },
            ),
            const Padding(padding: EdgeInsets.only(bottom: 20)),

            TextButton(
                style: TextButton.styleFrom(
                  primary: const Color.fromARGB(255, 255, 0, 0),
                  backgroundColor: const Color.fromARGB(255, 26, 26, 26),
                ),
                child: const Text(
                  'Save',
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  const SnackBar(
                    content: Text("Save"),
                  );
                }),
          ],
        ),
      ),
    ));
  }
}
