// ignore: import_of_legacy_library_into_null_safe
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:payscanner/Model/Vendor.dart';
import 'package:payscanner/aftertransac.dart';

class Pay extends StatefulWidget {
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  final myController = TextEditingController();
  var barcode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MealCard Pay"),
        elevation: 0.0,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Enter Amount"),
                    controller: myController,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera,
                        color: Colors.green,
                        size: 50.0,
                      ),
                      onPressed: () => scan(context),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Scan QR",
                    style: TextStyle(fontSize: 24.0),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        barcode,
                        textAlign: TextAlign.center,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future scan(BuildContext context) async {
    try {
      // HTTP REQUEST TO AUTHORIZE SALE
      var barcode = await BarcodeScanner.scan();
      var code = barcode.rawContent;
      var amount = myController.text;
      String email = "tester1@gmail.com";
      String pw = "tester11234";
      String token = "";

      // Get current date for validity condition
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      // get bearer token
      var gettoken = await http.post(Uri.parse(
          'http://mealcard.rajasaudagar.com/api/login?email=$email&password=$pw'));

      if (gettoken.statusCode == 200) {
        Vendor holder = Vendor.fromJson(jsonDecode(gettoken.body));
        token = holder.token;
      } else {
        token = gettoken.reasonPhrase;
      }

      // authorization of sale
      var headers = {'Authorization': "Bearer " + token};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://mealcard.rajasaudagar.com/api/student?code=$code&amount=$amount&date=$date'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      // CONDITIONAL FOR RESPONSE
      if (response.statusCode == 200) {
        // for success & not enough balance
        var placeholder = await response.stream.bytesToString();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AfterTransac(placeholder),
            ));

        setState(() {
          this.barcode = placeholder;
        });
      } else {
        // other than that (code not exist)
        var placeholder = await response.stream.bytesToString();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AfterTransac(placeholder),
            ));
        setState(() {
          this.barcode = placeholder;
        });
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = "The user did not grant the camera permission";
        });
      } else {
        setState(() {
          this.barcode = "Unknown error: $e";
        });
      }
    } on FormatException {
      setState(() {
        this.barcode =
            "null (User returned using the \"back\"-button before scanning anything. Result)";
      });
    } catch (e) {
      setState(() {
        this.barcode = "Unknown error: $e";
      });
    }
  }
}
