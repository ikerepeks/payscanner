import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payscanner/Model/Vendor.dart';
import 'package:payscanner/services/DatabaseHandler.dart';
import 'package:http/http.dart' as http;

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializaDB().whenComplete(() async {
      await this.addUsers();
      setState(() {});
    });
  }

  Future<int> addUsers() async {
    String email = "tester1@gmail.com";
    String pw = "tester11234";
    String token = "";

    var response = await http.post(Uri.parse(
        'http://mealcard.rajasaudagar.com/api/login?email=$email&password=$pw'));

    if (response.statusCode == 200) {
      Vendor holder = Vendor.fromJson(jsonDecode(response.body));
      token = holder.token;
    } else {
      token = response.reasonPhrase;
    }

    Vendor vendor = Vendor(email: email, token: token);
    return await this.handler.insertVendor(vendor);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: handler.retrieveVendor(),
        builder: (context, AsyncSnapshot<List<Vendor>> snapshot) {
          if (snapshot.hasData) {
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
                        decoration: InputDecoration(
                            hintText: snapshot.data.first.token),
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
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
