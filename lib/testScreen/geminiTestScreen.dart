//default page for the app
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:developer' as developer;

class GeminiTestScreen extends StatefulWidget {
  GeminiTestScreen({Key? key}) : super(key: key);

  @override
  State<GeminiTestScreen> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<GeminiTestScreen> {
  String result = '';
  TextEditingController _controller = TextEditingController();
  final gemini = Gemini.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              processText(result),
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Enter text'),
              ),
              ElevatedButton(
                onPressed: () {
                  gemini
                      .streamGenerateContent(
                    _controller.text,
                  )
                      .listen((value) {
                    print(value.output);
                    setState(() {
                      result += value.output.toString();
                    });
                  }).onError((e) {
                    developer.log('streamGenerateContent exception', error: e);
                  });
                },
                child: Text('Enter text and press me!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget processText(String text) {
    List<String> parts = text.split('*');
    List<Widget> textWidgets = [];

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        textWidgets.add(Text(parts[i], style: TextStyle(fontSize: 16.0)));
      } else {
        textWidgets.add(Text(parts[i],
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)));
      }
    }

    return Column(children: textWidgets);
  }
}
