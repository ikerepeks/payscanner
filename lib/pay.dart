// ignore: import_of_legacy_library_into_null_safe
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                      onPressed: scan,
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

  Future scan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode.rawContent);
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
