import 'package:firstvisual/styles/shape.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UnderConstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'We are working on this feature. It will be available soon, please check back later.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: getHeight(context) * 0.7,
                child:
                    Lottie.asset('animations/Animation - 1707939256787.json'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
