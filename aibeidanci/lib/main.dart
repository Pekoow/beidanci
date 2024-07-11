import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_in.dart';
// flutter run -d chrome --web-port=53779
//--web-hostname=127.0.0.1
void main() async{
  runApp(new MyApp());
  SharedPreferences.setMockInitialValues({}); // set initial values here if desired

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '四级单词记忆利器',
      theme: new ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.cyan[300],
      ),
      debugShowCheckedModeBanner: false,
      home: LogininPage(),
    );
  }
}
