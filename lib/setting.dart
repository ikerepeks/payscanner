import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Terminal Setting"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                readOnly: true,
                decoration: InputDecoration(hintText: "Bearer Token"),
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: () {},
                child: Text("Get New Token"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
