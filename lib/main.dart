import 'package:flutter/material.dart';
import 'package:payscanner/pay.dart';
import 'package:payscanner/setting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/pay': (BuildContext context) => Pay(),
        '/setting': (BuildContext context) => Setting(),
        '/home': (BuildContext context) => MyApp(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: Text("MealCard Terminal"),
      ),
      body: Center(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontSize: 40.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pay');
                    },
                    child: CircleAvatar(
                      maxRadius: 80,
                      backgroundColor: Colors.white24,
                      child: Text(
                        "Pay",
                        style: TextStyle(fontSize: 30.0, color: Colors.green),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/setting');
                    },
                    child: CircleAvatar(
                      maxRadius: 80,
                      backgroundColor: Colors.white24,
                      child: Text(
                        "Setting",
                        style: TextStyle(fontSize: 30.0, color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
