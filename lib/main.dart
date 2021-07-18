import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poke_trumps/screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PokéTrumps",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      // home: MyHomePage(title: "Title"),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: _incrementCounter,
          child: Text("Increment Counter persistently"),
        ),
      ),
    );
  }

  _incrementCounter() async {
    var prefs = await SharedPreferences.getInstance();
    var counter = (prefs.getInt("counter") ?? 0) + 1;
    print("Pressed counter $counter times.");
    await prefs.setInt("counter", counter);
  }
}
