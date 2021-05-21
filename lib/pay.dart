// ignore: import_of_legacy_library_into_null_safe
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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
      // HTTP REQUEST TO AUTHORIZE SALE
      var barcode = await BarcodeScanner.scan();
      var code = barcode.rawContent;
      var amount = myController.text;

      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      var headers = {
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiN2ZlNTQ5MDcxZTM1ZmU0ZmQ5NzA2YjE4NWM2OGVhMTdhYTkzMWNkMmZiNGMyYmU1YWY0Njg1MmQ5YzFiNmMxMTcyOWU4YzFjZWQ1M2NiYjEiLCJpYXQiOjE2MjE0NzcyNDkuOTg1MjU4MTAyNDE2OTkyMTg3NSwibmJmIjoxNjIxNDc3MjQ5Ljk4NTI2NTAxNjU1NTc4NjEzMjgxMjUsImV4cCI6MTY1MzAxMzI0OS45NzgzOTU5Mzg4NzMyOTEwMTU2MjUsInN1YiI6IjEiLCJzY29wZXMiOltdfQ.Mx24LnSpBCDfmJ4eJ3p0HwBhy6ddl_cC6lQw0_tJW39QUPkhZWh3LdxoJYO85lOGx521D0QpGDMZA2A-jYe-A7tGdljKlpNdIfnIsSSE71U4celyJVInfh40qcwfRoZ6DP4X93ZB6j1WDnK6quVlpX_6Jp391nziNwa45trs7ma9PrPjP5QNDAia-ZOmvA0SZNW3hzCL1SdmABWo44d4Qz3gftNmonYkMi6Nvf9HOVY4b87UyBvA3c93WplSRYCM92hwaQ-sRAQrkXBxPwiLrGtiPLnrXP-q4zujMlNtNc81NH1cnThjtCn2rrShZfxksRCu5AKmTp8F-twsg9c6dZX6RX9hCY70CnltWOf04kErRSeD4Cja6_BN7EYa1GGWie9ViqQytqfalu9d7ZedybpndidDbf6meY-4N8jI5VyeWYKrC1idAuhx_5d0sAi6uChEKEdxgDk2IBq2mx2tgF-WA_bqsGETHREYUBUZ7y2QsaW8v0UCtP5QPyie1wQnNleraohSTdHrid-sHU5-4arQMFa6wn2YwPV8UxgqZDNwc9H-KQXAY0tKSIlUnZY1xMP_z7YqtLVnALv6pnc5W9_I1Zof4rWRceQ3fOqz5VTslpiwXWeKfKMZELjjU-rOqWD7abQkVruLLtrudDsRXmkPNhMYRBGVeIobf3TK9As'
      };
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
        var placeholder = await response.stream.bytesToString() +
            "\nReason: " +
            response.reasonPhrase +
            date.toString();
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
