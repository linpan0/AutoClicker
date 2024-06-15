import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  static const MAX_LENGTH = 3;
  static const MIN_CPS = 0;
  static const MAX_CPS = 100;
  var cps = MIN_CPS;
  var textController = TextEditingController(text: MIN_CPS.toString());

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      var text = int.tryParse(textController.text.trim());
      if (text == null) return;
      if (text < MIN_CPS) {
        text = MIN_CPS;
        textController.value = TextEditingValue(text: MIN_CPS.toString());
      } else if (text > MAX_CPS) {
        text = MAX_CPS;
        textController.value = TextEditingValue(text: MAX_CPS.toString());
      }

      cps = text;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: 200,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(MAX_LENGTH),
              ],
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Clicks Per Second",
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              print("Clicks Per Second: $cps");
            },
            child: const Text("Start"),
          ),
        ],
      ),
    );
  }
}