import 'package:flutter/material.dart';
import 'package:payscanner/main.dart';

class AfterTransac extends StatelessWidget {
  String status = "";

  AfterTransac(var status) {
    this.status = status.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Transaction Status"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Transaction Status",
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(status),
              SizedBox(
                height: 12.0,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyApp(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text("Home")),
            ],
          ),
        ),
      ),
    );
  }
}
