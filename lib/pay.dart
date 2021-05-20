import 'package:flutter/material.dart';

class Pay extends StatefulWidget {
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  final myController = TextEditingController();

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
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Scan QR",
                    style: TextStyle(fontSize: 24.0),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
