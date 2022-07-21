import 'package:chat_application/screens/in_app_browser.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => InAppBrowser())));
        },
        child: Center(child: Text("Google Profile settings")),
      )),
    );
  }
}
